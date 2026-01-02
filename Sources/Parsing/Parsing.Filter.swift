//
//  Parsing.Filter.swift
//  swift-standards
//
//  Output validation combinator.
//

extension Parsing {
    /// A parser that filters output using a predicate.
    ///
    /// If the upstream parser succeeds but the predicate returns false,
    /// parsing fails.
    ///
    /// Created via `parser.filter(_:)`.
    public struct Filter<Upstream: Parsing.Parser>: Sendable
    where Upstream: Sendable {
        @usableFromInline
        let upstream: Upstream

        @usableFromInline
        let predicate: @Sendable (Upstream.Output) -> Bool

        @inlinable
        public init(
            upstream: Upstream,
            predicate: @escaping @Sendable (Upstream.Output) -> Bool
        ) {
            self.upstream = upstream
            self.predicate = predicate
        }
    }
}

extension Parsing.Filter: Parsing.Parser {
    public typealias Input = Upstream.Input
    public typealias Output = Upstream.Output

    @inlinable
    public func parse(_ input: inout Input) throws(Parsing.Error) -> Output {
        let output = try upstream.parse(&input)
        guard predicate(output) else {
            throw Parsing.Error("Filter predicate failed for: \(output)")
        }
        return output
    }
}
