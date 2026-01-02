//
//  Parsing.Map.Throwing.swift
//  swift-standards
//
//  Throwing output transformation.
//

extension Parsing.Map {
    /// A parser that transforms output using a throwing function.
    ///
    /// If the transformation throws, parsing fails with that error.
    /// The resulting failure type is `Either<Upstream.Failure, E>`.
    ///
    /// Created via `parser.tryMap(_:)`.
    public struct Throwing<Upstream: Parsing.Parser, Output, E: Swift.Error & Sendable>: Sendable
    where Upstream: Sendable {
        @usableFromInline
        let upstream: Upstream

        @usableFromInline
        let transform: @Sendable (Upstream.Output) throws(E) -> Output

        @inlinable
        public init(
            upstream: Upstream,
            transform: @escaping @Sendable (Upstream.Output) throws(E) -> Output
        ) {
            self.upstream = upstream
            self.transform = transform
        }
    }
}

extension Parsing.Map.Throwing: Parsing.Parser {
    public typealias Input = Upstream.Input
    public typealias Failure = Parsing.Either<Upstream.Failure, E>

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) -> Output {
        let upstreamOutput: Upstream.Output
        do {
            upstreamOutput = try upstream.parse(&input)
        } catch {
            throw .left(error)
        }
        do {
            return try transform(upstreamOutput)
        } catch {
            throw .right(error)
        }
    }
}
