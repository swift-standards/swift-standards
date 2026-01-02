//
//  Parsing.OneOf.Builder.swift
//  swift-standards
//
//  Result builder for alternative parsers.
//

extension Parsing.OneOf {
    /// A result builder for alternative parsers.
    ///
    /// `Builder` combines parsers as alternatives - the first one that
    /// succeeds wins.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// Parsing.OneOf.Sequence {
    ///     "true".map { true }
    ///     "false".map { false }
    /// }
    /// ```
    @resultBuilder
    public struct Builder<Input, Output> {}
}

extension Parsing.OneOf.Builder {
    /// Builds a single alternative.
    @inlinable
    public static func buildBlock<P: Parsing.Parser>(
        _ parser: P
    ) -> P where P.Input == Input, P.Output == Output {
        parser
    }

    /// Combines two alternatives.
    @inlinable
    public static func buildBlock<P0: Parsing.Parser, P1: Parsing.Parser>(
        _ p0: P0,
        _ p1: P1
    ) -> Parsing.OneOf.Two<P0, P1>
    where P0.Input == Input, P1.Input == Input,
          P0.Output == Output, P1.Output == Output {
        Parsing.OneOf.Two(p0, p1)
    }

    /// Combines three alternatives.
    @inlinable
    public static func buildBlock<P0: Parsing.Parser, P1: Parsing.Parser, P2: Parsing.Parser>(
        _ p0: P0,
        _ p1: P1,
        _ p2: P2
    ) -> Parsing.OneOf.Three<P0, P1, P2>
    where P0.Input == Input, P1.Input == Input, P2.Input == Input,
          P0.Output == Output, P1.Output == Output, P2.Output == Output {
        Parsing.OneOf.Three(p0, p1, p2)
    }

    /// Starts partial block.
    @inlinable
    public static func buildPartialBlock<P: Parsing.Parser>(
        first: P
    ) -> P where P.Input == Input, P.Output == Output {
        first
    }

    /// Accumulates alternatives.
    @inlinable
    public static func buildPartialBlock<Accumulated: Parsing.Parser, Next: Parsing.Parser>(
        accumulated: Accumulated,
        next: Next
    ) -> Parsing.OneOf.Two<Accumulated, Next>
    where Accumulated.Input == Input, Next.Input == Input,
          Accumulated.Output == Output, Next.Output == Output {
        Parsing.OneOf.Two(accumulated, next)
    }
}
