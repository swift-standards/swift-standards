//
//  Parsing.OneOf.Three.swift
//  swift-standards
//
//  Three-parser alternative combinator.
//

extension Parsing.OneOf {
    /// A parser that tries three alternatives.
    public struct Three<P0: Parsing.Parser, P1: Parsing.Parser, P2: Parsing.Parser>: Sendable
    where P0: Sendable, P1: Sendable, P2: Sendable,
          P0.Input == P1.Input, P1.Input == P2.Input,
          P0.Output == P1.Output, P1.Output == P2.Output {
        @usableFromInline
        let p0: P0

        @usableFromInline
        let p1: P1

        @usableFromInline
        let p2: P2

        @inlinable
        public init(_ p0: P0, _ p1: P1, _ p2: P2) {
            self.p0 = p0
            self.p1 = p1
            self.p2 = p2
        }
    }
}

extension Parsing.OneOf.Three: Parsing.Parser {
    public typealias Input = P0.Input
    public typealias Output = P0.Output

    @inlinable
    public func parse(_ input: inout Input) throws(Parsing.Error) -> Output {
        let saved = input
        var errors: [Parsing.Error] = []

        do { return try p0.parse(&input) }
        catch { errors.append(error); input = saved }

        do { return try p1.parse(&input) }
        catch { errors.append(error); input = saved }

        do { return try p2.parse(&input) }
        catch { errors.append(error) }

        throw Parsing.Error.noMatch(tried: errors)
    }
}
