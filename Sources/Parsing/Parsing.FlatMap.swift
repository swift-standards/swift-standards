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
    public typealias Failure = Parsing.Either<Upstream.Failure, Downstream.Failure>

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) -> Output {
        let upstreamOutput: Upstream.Output
        do {
            upstreamOutput = try upstream.parse(&input)
        } catch {
            throw .left(error)
        }
        let downstream = transform(upstreamOutput)
        do {
            return try downstream.parse(&input)
        } catch {
            throw .right(error)
        }
    }
}
