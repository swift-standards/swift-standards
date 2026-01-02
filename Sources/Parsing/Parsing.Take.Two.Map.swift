//
//  Parsing.Take.Two.Map.swift
//  swift-standards
//
//  Map transformation for Take.Two output.
//

extension Parsing.Take.Two {
    /// A parser that transforms the output of a `Take.Two` parser.
    ///
    /// Used internally for tuple flattening with parameter packs.
    public struct Map<NewOutput>: Sendable
    where P0: Sendable, P1: Sendable {
        @usableFromInline
        let upstream: Parsing.Take.Two<P0, P1>

        @usableFromInline
        let transform: @Sendable (P0.Output, P1.Output) -> NewOutput

        @inlinable
        init(
            upstream: Parsing.Take.Two<P0, P1>,
            transform: @escaping @Sendable (P0.Output, P1.Output) -> NewOutput
        ) {
            self.upstream = upstream
            self.transform = transform
        }
    }
}

extension Parsing.Take.Two.Map: Parsing.Parser {
    public typealias Input = P0.Input
    public typealias Output = NewOutput
    public typealias Failure = Parsing.Take.Two<P0, P1>.Failure

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) -> Output {
        let (o0, o1) = try upstream.parse(&input)
        return transform(o0, o1)
    }
}
