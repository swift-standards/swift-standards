//
//  Parsing.FlatMap.swift
//  swift-standards
//
//  Dependent parser chaining.
//

extension Parsing {
    /// A parser that chains two parsers where the second depends on the first's output.
    ///
    /// This is the monad `flatMap` (or `bind`) operation for parsers.
    ///
    /// Created via `parser.flatMap(_:)`.
    public struct FlatMap<Upstream: Parsing.Parser, Downstream: Parsing.Parser>: Sendable
    where Upstream: Sendable, Downstream: Sendable, Upstream.Input == Downstream.Input {
        @usableFromInline
        let upstream: Upstream

        @usableFromInline
        let transform: @Sendable (Upstream.Output) -> Downstream

        @inlinable
        public init(
            upstream: Upstream,
            transform: @escaping @Sendable (Upstream.Output) -> Downstream
        ) {
            self.upstream = upstream
            self.transform = transform
        }
    }
}

extension Parsing.FlatMap: Parsing.Parser {
    public typealias Input = Upstream.Input
    public typealias Output = Downstream.Output

    @inlinable
    public func parse(_ input: inout Input) throws(Parsing.Error) -> Output {
        let upstreamOutput = try upstream.parse(&input)
        let downstream = transform(upstreamOutput)
        return try downstream.parse(&input)
    }
}
