//
//  Parsing.Skip.First.swift
//  swift-standards
//
//  Skip first parser's Void output.
//

extension Parsing.Skip {
    /// A parser that runs two parsers but discards the first's output.
    ///
    /// Used when the first parser has `Void` output (like a delimiter).
    public struct First<P0: Parsing.Parser, P1: Parsing.Parser>: Sendable
    where P0: Sendable, P1: Sendable, P0.Input == P1.Input, P0.Output == Void {
        @usableFromInline
        let p0: P0

        @usableFromInline
        let p1: P1

        @inlinable
        public init(_ p0: P0, _ p1: P1) {
            self.p0 = p0
            self.p1 = p1
        }
    }
}

extension Parsing.Skip.First: Parsing.Parser {
    public typealias Input = P0.Input
    public typealias Output = P1.Output

    @inlinable
    public func parse(_ input: inout Input) throws(Parsing.Error) -> Output {
        _ = try p0.parse(&input)
        return try p1.parse(&input)
    }
}
