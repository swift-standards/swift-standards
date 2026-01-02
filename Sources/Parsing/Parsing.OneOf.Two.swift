//
//  Parsing.OneOf.Two.swift
//  swift-standards
//
//  Two-parser alternative combinator.
//

extension Parsing.OneOf {
    /// A parser that tries two alternatives.
    ///
    /// Type-safe variant for exactly two parsers. Used by result builders.
    public struct Two<P0: Parsing.Parser, P1: Parsing.Parser>: Sendable
    where P0: Sendable, P1: Sendable, P0.Input == P1.Input, P0.Output == P1.Output {
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

extension Parsing.OneOf.Two: Parsing.Parser {
    public typealias Input = P0.Input
    public typealias Output = P0.Output

    @inlinable
    public func parse(_ input: inout Input) throws(Parsing.Error) -> Output {
        let saved = input

        do {
            return try p0.parse(&input)
        } catch let error0 {
            input = saved
            do {
                return try p1.parse(&input)
            } catch let error1 {
                throw Parsing.Error.noMatch(tried: [error0, error1])
            }
        }
    }
}
