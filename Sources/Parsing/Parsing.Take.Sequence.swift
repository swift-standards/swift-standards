//
//  Parsing.Take.Sequence.swift
//  swift-standards
//
//  Entry point for building sequential parsers.
//

extension Parsing.Take {
    /// Entry point for building parsers with result builder syntax.
    ///
    /// `Sequence` provides a convenient way to compose parsers using Swift's
    /// result builder syntax. The resulting parser type is inferred from
    /// the builder contents.
    ///
    /// ## Basic Usage
    ///
    /// ```swift
    /// let keyValue = Parsing.Take.Sequence {
    ///     Parsing.Prefix.While { $0 != UInt8(ascii: "=") }  // key
    ///     "="                                                // delimiter (discarded)
    ///     Parsing.Rest()                                     // value
    /// }
    /// // Type: Parser with Output = (Substring, Substring) or similar
    /// ```
    public struct Sequence<Input, Output, Body: Parsing.Parser>: Sendable
    where Body: Sendable, Body.Input == Input, Body.Output == Output {
        @usableFromInline
        let body: Body

        @inlinable
        public init(
            @Parsing.Take.Builder<Input> _ build: () -> Body
        ) {
            self.body = build()
        }
    }
}

extension Parsing.Take.Sequence: Parsing.Parser {
    @inlinable
    public func parse(_ input: inout Input) throws(Parsing.Error) -> Output {
        try body.parse(&input)
    }
}
