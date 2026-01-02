//
//  Parsing.Error.swift
//  swift-standards
//
//  Error transformation namespace and combinators.
//

extension Parsing {
    /// Namespace for error transformation types.
    public enum Error {}
}

// MARK: - Transform Wrapper

extension Parsing.Error {
    /// Wrapper providing error transformation methods.
    ///
    /// Access via the `.error` property on any parser:
    /// ```swift
    /// let parser = myParser.error.map { error in
    ///     MyCustomError(from: error)
    /// }
    /// ```
    public struct Transform<Upstream: Parsing.Parser>: Sendable
    where Upstream: Sendable {
        @usableFromInline
        let upstream: Upstream

        @inlinable
        init(_ upstream: Upstream) {
            self.upstream = upstream
        }
    }
}

// MARK: - Parser.error Property

extension Parsing.Parser where Self: Sendable {
    /// Access error transformation methods.
    ///
    /// ## Transform Error Type
    /// ```swift
    /// let parser = intParser.error.map { _ in
    ///     MyError.invalidNumber
    /// }
    /// ```
    ///
    /// ## Replace Error with Default
    /// ```swift
    /// let parser = intParser.error.replace(with: 0)
    /// // Now infallible - returns 0 on parse failure
    /// ```
    @inlinable
    public var error: Parsing.Error.Transform<Self> {
        Parsing.Error.Transform(self)
    }
}

// MARK: - Map

extension Parsing.Error {
    /// A parser that transforms the failure type of an upstream parser.
    public struct Map<Upstream: Parsing.Parser, NewFailure: Swift.Error & Sendable>: Sendable
    where Upstream: Sendable {
        @usableFromInline
        let upstream: Upstream

        @usableFromInline
        let transform: @Sendable (Upstream.Failure) -> NewFailure

        @inlinable
        init(
            _ upstream: Upstream,
            transform: @escaping @Sendable (Upstream.Failure) -> NewFailure
        ) {
            self.upstream = upstream
            self.transform = transform
        }
    }
}

extension Parsing.Error.Map: Parsing.Parser {
    public typealias Input = Upstream.Input
    public typealias Output = Upstream.Output
    public typealias Failure = NewFailure

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) -> Output {
        do {
            return try upstream.parse(&input)
        } catch {
            throw transform(error)
        }
    }
}

extension Parsing.Error.Transform {
    /// Transforms errors from the upstream parser.
    ///
    /// - Parameter transform: Closure converting upstream errors to new type.
    /// - Returns: A parser with the transformed failure type.
    ///
    /// ## Example
    /// ```swift
    /// enum MyError: Error { case invalid }
    ///
    /// let parser = intParser.error.map { _ in MyError.invalid }
    /// ```
    @inlinable
    public func map<NewFailure: Swift.Error & Sendable>(
        _ transform: @escaping @Sendable (Upstream.Failure) -> NewFailure
    ) -> Parsing.Error.Map<Upstream, NewFailure> {
        Parsing.Error.Map(upstream, transform: transform)
    }
}

// MARK: - Replace

extension Parsing.Error {
    /// A parser that replaces failures with a default output value.
    ///
    /// This makes the parser infallible (`Failure == Never`).
    public struct Replace<Upstream: Parsing.Parser>: Sendable
    where Upstream: Sendable, Upstream.Output: Sendable {
        @usableFromInline
        let upstream: Upstream

        @usableFromInline
        let output: Upstream.Output

        @inlinable
        init(_ upstream: Upstream, output: Upstream.Output) {
            self.upstream = upstream
            self.output = output
        }
    }
}

extension Parsing.Error.Replace: Parsing.Parser {
    public typealias Input = Upstream.Input
    public typealias Output = Upstream.Output
    public typealias Failure = Never

    @inlinable
    public func parse(_ input: inout Input) -> Output {
        do {
            return try upstream.parse(&input)
        } catch {
            return output
        }
    }
}

extension Parsing.Error.Transform where Upstream.Output: Sendable {
    /// Replaces any parse failure with a default output value.
    ///
    /// - Parameter output: The value to return when parsing fails.
    /// - Returns: An infallible parser that never throws.
    ///
    /// ## Example
    /// ```swift
    /// let parser = intParser.error.replace(with: 0)
    /// // Returns 0 if parsing fails
    /// ```
    @inlinable
    public func replace(with output: Upstream.Output) -> Parsing.Error.Replace<Upstream> {
        Parsing.Error.Replace(upstream, output: output)
    }
}
