//
//  Parsing.Take.Two.swift
//  swift-standards
//
//  Two-parser sequential combinator.
//

extension Parsing.Take {
    /// A parser that runs two parsers in sequence and collects both outputs.
    ///
    /// The outputs are combined into a tuple `(P0.Output, P1.Output)`.
    /// Created by `Take.Builder` when combining two non-Void parsers.
    public struct Two<P0: Parsing.Parser, P1: Parsing.Parser>: Sendable
    where P0: Sendable, P1: Sendable, P0.Input == P1.Input {
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

extension Parsing.Take.Two: Parsing.Parser {
    public typealias Input = P0.Input
    public typealias Output = (P0.Output, P1.Output)

    @inlinable
    public func parse(_ input: inout Input) throws(Parsing.Error) -> Output {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        return (o0, o1)
    }
}

extension Parsing.Take.Two {
    /// Maps the output of this parser using the given transform.
    @inlinable
    public func map<NewOutput>(
        _ transform: @escaping @Sendable (P0.Output, P1.Output) -> NewOutput
    ) -> Parsing.Take.Two<P0, P1>.Map<NewOutput> {
        Map(upstream: self, transform: transform)
    }
}
