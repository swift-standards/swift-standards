//
//  Parsing.OneOf.Sequence.swift
//  swift-standards
//
//  Entry point for building alternative parsers.
//

extension Parsing.OneOf {
    /// Entry point for building alternative parsers.
    ///
    /// `Sequence` tries each parser in order until one succeeds.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let boolean = Parsing.OneOf.Sequence {
    ///     "true".map { true }
    ///     "false".map { false }
    /// }
    /// ```
    public struct Sequence<Input, Output, Body: Parsing.Parser>: Sendable
    where Body: Sendable, Body.Input == Input, Body.Output == Output {
        @usableFromInline
        let body: Body

        @inlinable
        public init(
            @Parsing.OneOf.Builder<Input, Output> _ build: () -> Body
        ) {
            self.body = build()
        }
    }
}

extension Parsing.OneOf.Sequence: Parsing.Parser {
    @inlinable
    public func parse(_ input: inout Input) throws(Parsing.Error) -> Output {
        try body.parse(&input)
    }
}
