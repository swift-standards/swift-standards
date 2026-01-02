//
//  Parsing.Take.Transform.swift
//  swift-standards
//
//  Entry point for building transforming parsers.
//

extension Parsing.Take {
    /// A parser that transforms its body's output.
    ///
    /// Enables constructing domain types from parsed tuples:
    ///
    /// ```swift
    /// let point = Parsing.Take.Transform(Point.init) {
    ///     IntParser()
    ///     ","
    ///     IntParser()
    /// }
    /// ```
    public struct Transform<Input, BodyOutput, Output, Body: Parsing.Parser>: Sendable
    where Body: Sendable, Body.Input == Input, Body.Output == BodyOutput {
        @usableFromInline
        let body: Body

        @usableFromInline
        let transform: @Sendable (BodyOutput) -> Output

        @inlinable
        public init(
            _ transform: @escaping @Sendable (BodyOutput) -> Output,
            @Parsing.Take.Builder<Input> _ build: () -> Body
        ) {
            self.body = build()
            self.transform = transform
        }
    }
}

extension Parsing.Take.Transform: Parsing.Parser {
    public typealias Failure = Body.Failure

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) -> Output {
        transform(try body.parse(&input))
    }
}
