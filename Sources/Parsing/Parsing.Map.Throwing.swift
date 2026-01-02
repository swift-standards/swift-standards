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
    ///
    /// Created via `parser.tryMap(_:)`.
    public struct Throwing<Upstream: Parsing.Parser, Output>: Sendable
    where Upstream: Sendable {
        @usableFromInline
        let upstream: Upstream

        @usableFromInline
        let transform: @Sendable (Upstream.Output) throws(Parsing.Error) -> Output

        @inlinable
        public init(
            upstream: Upstream,
            transform: @escaping @Sendable (Upstream.Output) throws(Parsing.Error) -> Output
        ) {
            self.upstream = upstream
            self.transform = transform
        }
    }
}

extension Parsing.Map.Throwing: Parsing.Parser {
    public typealias Input = Upstream.Input

    @inlinable
    public func parse(_ input: inout Input) throws(Parsing.Error) -> Output {
        try transform(try upstream.parse(&input))
    }
}
