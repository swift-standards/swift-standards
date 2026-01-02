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
    public typealias Failure = Parsing.Either<Upstream.Failure, Parsing.Constraint.Error>

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) -> Output {
        let output: Upstream.Output
        do {
            output = try upstream.parse(&input)
        } catch {
            throw .left(error)
        }
        guard predicate(output) else {
            throw .right(.validationFailed(value: "\(output)", reason: "filter predicate"))
        }
        return output
    }
}
