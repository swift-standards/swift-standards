//
//  Parsing.Parser.swift
//  swift-standards
//
//  Core Parser protocol definition.
//

extension Parsing {
    /// A type that can parse a value from an input.
    ///
    /// Parsers are composable: complex parsers are built from simpler ones using
    /// combinators like `map`, `flatMap`, `oneOf`, and result builders.
    ///
    /// ## Input Mutation
    ///
    /// The `parse` method takes `inout Input` and consumes from the front.
    /// On success, the input is advanced past the consumed portion.
    /// On failure, the input state is undefined (callers should save/restore if needed).
    ///
    /// ## Performance
    ///
    /// The protocol is designed for zero-copy, non-allocating parsing:
    /// - Input types like `Span<UInt8>` provide O(1) slicing
    /// - Index-based consumption avoids copying data
    /// - Result builders inline parser composition
    ///
    /// ## Error Handling
    ///
    /// Parsers use typed throws with a `Failure` associated type for precise,
    /// domain-specific error propagation. Combinators compose error types:
    /// - `Map` preserves the upstream `Failure`
    /// - `FlatMap` produces `Either<Upstream.Failure, Downstream.Failure>`
    /// - `OneOf` produces `Either<P0.Failure, P1.Failure>`
    /// - Infallible parsers use `Failure == Never`
    ///
    /// ## Example
    ///
    /// ```swift
    /// struct IntParser: Parsing.Parser {
    ///     typealias Input = Span<UInt8>
    ///     typealias Output = Int
    ///     typealias Failure = Parsing.Match.Error
    ///
    ///     func parse(_ input: inout Input) throws(Failure) -> Int {
    ///         var value = 0
    ///         var consumed = false
    ///
    ///         while let byte = input.first, byte >= 0x30, byte <= 0x39 {
    ///             value = value * 10 + Int(byte - 0x30)
    ///             input = input.dropFirst()
    ///             consumed = true
    ///         }
    ///
    ///         guard consumed else {
    ///             throw .predicateFailed(description: "digit")
    ///         }
    ///         return value
    ///     }
    /// }
    /// ```
    public protocol Parser<Input, Output, Failure> {
        /// The input type this parser consumes.
        associatedtype Input

        /// The output type this parser produces.
        associatedtype Output

        /// The error type this parser can throw.
        ///
        /// Use `Never` for infallible parsers.
        associatedtype Failure: Swift.Error & Sendable

        /// Parses a value from the input.
        ///
        /// On success, consumes the parsed portion from input and returns the result.
        /// On failure, throws an error. The input state after failure is undefined.
        ///
        /// - Parameter input: The input to parse from. Modified to reflect consumption.
        /// - Returns: The parsed value.
        /// - Throws: `Failure` if parsing fails.
        func parse(_ input: inout Input) throws(Failure) -> Output
    }
}

// MARK: - Convenience Extensions

extension Parsing.Parser {
    /// Parses a complete input, requiring all bytes to be consumed.
    ///
    /// Use this for top-level parsing where trailing input is an error.
    ///
    /// The return type is `Either<Failure, Match.Error>` because parsing can fail
    /// either from the parser itself (`Failure`) or from trailing input (`Match.Error`).
    ///
    /// - Parameter input: The complete input to parse.
    /// - Returns: The parsed value.
    /// - Throws: `Either<Failure, Match.Error>` if parsing fails or input remains.
    @inlinable
    public func parse(_ input: Input) throws(Parsing.Either<Failure, Parsing.Match.Error>) -> Output
    where Input: Collection {
        var input = input
        let output: Output
        do {
            output = try parse(&input)
        } catch {
            throw .left(error)
        }
        guard input.isEmpty else {
            throw .right(.expectedEnd(remaining: input.count))
        }
        return output
    }
}

extension Parsing.Parser where Failure == Parsing.Match.Error {
    /// Parses a complete input, requiring all bytes to be consumed.
    ///
    /// Specialized for parsers with `Match.Error` failure - returns unified error type.
    ///
    /// - Parameter input: The complete input to parse.
    /// - Returns: The parsed value.
    /// - Throws: `Match.Error` if parsing fails or input remains.
    @inlinable
    public func parse(_ input: Input) throws(Parsing.Match.Error) -> Output
    where Input: Collection {
        var input = input
        let output = try parse(&input)
        guard input.isEmpty else {
            throw .expectedEnd(remaining: input.count)
        }
        return output
    }
}

// MARK: - Parser Composition via Methods

extension Parsing.Parser {
    /// Transforms the parser's output using the given function.
    ///
    /// This is the functor `map` operation for parsers.
    ///
    /// - Parameter transform: A function to apply to successful output.
    /// - Returns: A parser that transforms its output.
    @inlinable
    public func map<NewOutput>(
        _ transform: @escaping @Sendable (Output) -> NewOutput
    ) -> Parsing.Map.Transform<Self, NewOutput> {
        .init(upstream: self, transform: transform)
    }

    /// Transforms the parser's output using a throwing function.
    ///
    /// If the transform throws, parsing fails with that error. The resulting
    /// parser's failure type composes both upstream and transform errors.
    ///
    /// - Parameter transform: A throwing function to apply to successful output.
    /// - Returns: A parser that transforms its output, potentially failing.
    @inlinable
    public func tryMap<NewOutput, E: Swift.Error & Sendable>(
        _ transform: @escaping @Sendable (Output) throws(E) -> NewOutput
    ) -> Parsing.Map.Throwing<Self, NewOutput, E> {
        .init(upstream: self, transform: transform)
    }

    /// Chains this parser with another that depends on its output.
    ///
    /// This is the monad `flatMap` operation for parsers.
    ///
    /// - Parameter transform: A function that produces a parser from this parser's output.
    /// - Returns: A parser that runs both parsers in sequence.
    @inlinable
    public func flatMap<P: Parsing.Parser>(
        _ transform: @escaping @Sendable (Output) -> P
    ) -> Parsing.FlatMap<Self, P>
    where P.Input == Input {
        .init(upstream: self, transform: transform)
    }

    /// Filters the parser's output using a predicate.
    ///
    /// If the predicate returns false, parsing fails.
    ///
    /// - Parameter predicate: A function that validates the output.
    /// - Returns: A parser that fails if the predicate is false.
    @inlinable
    public func filter(
        _ predicate: @escaping @Sendable (Output) -> Bool
    ) -> Parsing.Filter<Self> where Self: Sendable {
        .init(upstream: self, predicate: predicate)
    }
}
