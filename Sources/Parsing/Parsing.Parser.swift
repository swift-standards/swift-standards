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
    /// Parsers use typed throws (`throws(Error)`) for precise error propagation.
    /// The `Error` associated type allows domain-specific error information.
    ///
    /// ## Example
    ///
    /// ```swift
    /// struct IntParser: Parsing.Parser {
    ///     typealias Input = Span<UInt8>
    ///     typealias Output = Int
    ///
    ///     func parse(_ input: inout Input) throws(Parsing.Error) -> Int {
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
    ///             throw Parsing.Error("Expected digit")
    ///         }
    ///         return value
    ///     }
    /// }
    /// ```
    public protocol Parser<Input, Output> {
        /// The input type this parser consumes.
        associatedtype Input

        /// The output type this parser produces.
        associatedtype Output

        /// Parses a value from the input.
        ///
        /// On success, consumes the parsed portion from input and returns the result.
        /// On failure, throws an error. The input state after failure is undefined.
        ///
        /// - Parameter input: The input to parse from. Modified to reflect consumption.
        /// - Returns: The parsed value.
        /// - Throws: `Parsing.Error` if parsing fails.
        func parse(_ input: inout Input) throws(Parsing.Error) -> Output
    }
}

// MARK: - Convenience Extensions

extension Parsing.Parser {
    /// Parses a complete input, requiring all bytes to be consumed.
    ///
    /// Use this for top-level parsing where trailing input is an error.
    ///
    /// - Parameter input: The complete input to parse.
    /// - Returns: The parsed value.
    /// - Throws: If parsing fails or input remains.
    @inlinable
    public func parse(_ input: Input) throws(Parsing.Error) -> Output
    where Input: Collection {
        var input = input
        let output = try parse(&input)
        guard input.isEmpty else {
            throw Parsing.Error(
                "Unexpected trailing input",
                at: input
            )
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
    /// If the transform throws, parsing fails with that error.
    ///
    /// - Parameter transform: A throwing function to apply to successful output.
    /// - Returns: A parser that transforms its output, potentially failing.
    @inlinable
    public func tryMap<NewOutput>(
        _ transform: @escaping @Sendable (Output) throws(Parsing.Error) -> NewOutput
    ) -> Parsing.Map.Throwing<Self, NewOutput> {
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
