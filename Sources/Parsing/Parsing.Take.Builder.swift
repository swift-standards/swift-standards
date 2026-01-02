//
//  Parsing.Take.Builder.swift
//  swift-standards
//
//  Result builder for sequential parser composition.
//

extension Parsing.Take {
    /// A result builder for composing parsers sequentially.
    ///
    /// `Builder` enables declarative parser composition using Swift's
    /// result builder syntax. Parsers are combined sequentially, with their
    /// outputs collected into tuples.
    ///
    /// ## Sequential Composition
    ///
    /// Multiple parsers run in sequence. Outputs are combined into tuples:
    ///
    /// ```swift
    /// Parsing.Take.Sequence {
    ///     IntParser()      // Output: Int
    ///     ","              // Output: Void (discarded)
    ///     IntParser()      // Output: Int
    /// }
    /// // Result: (Int, Int)
    /// ```
    ///
    /// ## Void Skipping
    ///
    /// Parsers with `Void` output are automatically skipped in the result tuple.
    @resultBuilder
    public struct Builder<Input> {}
}

// MARK: - Empty and Single Block

extension Parsing.Take.Builder {
    /// Builds an empty parser that consumes nothing and returns Void.
    @inlinable
    public static func buildBlock() -> Parsing.Always<Input, Void> {
        Parsing.Always(())
    }

    /// Builds a single parser unchanged.
    @inlinable
    public static func buildBlock<P: Parsing.Parser>(
        _ parser: P
    ) -> P where P.Input == Input {
        parser
    }
}

// MARK: - Two Parsers

extension Parsing.Take.Builder {
    /// Combines two parsers sequentially.
    @inlinable
    public static func buildBlock<P0: Parsing.Parser, P1: Parsing.Parser>(
        _ p0: P0,
        _ p1: P1
    ) -> Parsing.Take.Two<P0, P1>
    where P0.Input == Input, P1.Input == Input {
        Parsing.Take.Two(p0, p1)
    }

    /// Combines parsers, skipping Void output from first.
    @inlinable
    public static func buildBlock<P0: Parsing.Parser, P1: Parsing.Parser>(
        _ p0: P0,
        _ p1: P1
    ) -> Parsing.Skip.First<P0, P1>
    where P0.Input == Input, P1.Input == Input, P0.Output == Void {
        Parsing.Skip.First(p0, p1)
    }

    /// Combines parsers, skipping Void output from second.
    @inlinable
    public static func buildBlock<P0: Parsing.Parser, P1: Parsing.Parser>(
        _ p0: P0,
        _ p1: P1
    ) -> Parsing.Skip.Second<P0, P1>
    where P0.Input == Input, P1.Input == Input, P1.Output == Void {
        Parsing.Skip.Second(p0, p1)
    }
}

// MARK: - Partial Block Building

extension Parsing.Take.Builder {
    /// Starts building a partial block.
    @inlinable
    public static func buildPartialBlock<P: Parsing.Parser>(
        first: P
    ) -> P where P.Input == Input {
        first
    }

    /// Accumulates into partial block (general case - two elements).
    @inlinable
    public static func buildPartialBlock<Accumulated: Parsing.Parser, Next: Parsing.Parser>(
        accumulated: Accumulated,
        next: Next
    ) -> Parsing.Take.Two<Accumulated, Next>
    where Accumulated.Input == Input, Next.Input == Input {
        Parsing.Take.Two(accumulated, next)
    }

    /// Accumulates with tuple flattening using parameter packs.
    ///
    /// This enables unlimited parser composition by flattening nested tuples:
    /// `((A, B), C)` becomes `(A, B, C)`.
    @inlinable
    public static func buildPartialBlock<
        Accumulated: Parsing.Parser,
        Next: Parsing.Parser,
        each O1,
        O2
    >(
        accumulated: Accumulated,
        next: Next
    ) -> Parsing.Take.Two<Accumulated, Next>.Map<(repeat each O1, O2)>
    where
        Accumulated.Input == Input,
        Next.Input == Input,
        Accumulated.Output == (repeat each O1),
        Next.Output == O2
    {
        Parsing.Take.Two(accumulated, next)
            .map { tuple, next in
                (repeat each tuple, next)
            }
    }

    /// Accumulates with Void skipping (accumulated is Void).
    @inlinable
    public static func buildPartialBlock<Accumulated: Parsing.Parser, Next: Parsing.Parser>(
        accumulated: Accumulated,
        next: Next
    ) -> Parsing.Skip.First<Accumulated, Next>
    where Accumulated.Input == Input, Next.Input == Input, Accumulated.Output == Void {
        Parsing.Skip.First(accumulated, next)
    }

    /// Accumulates with Void skipping (next is Void).
    @inlinable
    public static func buildPartialBlock<Accumulated: Parsing.Parser, Next: Parsing.Parser>(
        accumulated: Accumulated,
        next: Next
    ) -> Parsing.Skip.Second<Accumulated, Next>
    where Accumulated.Input == Input, Next.Input == Input, Next.Output == Void {
        Parsing.Skip.Second(accumulated, next)
    }
}

// MARK: - Conditionals

extension Parsing.Take.Builder {
    /// Builds an optional parser from an `if` statement.
    @inlinable
    public static func buildIf<P: Parsing.Parser>(
        _ parser: P?
    ) -> Parsing.Optional<P> where P.Input == Input {
        .init(parser)
    }

    /// Builds the first branch of if-else.
    @inlinable
    public static func buildEither<First: Parsing.Parser, Second: Parsing.Parser>(
        first: First
    ) -> Parsing.Conditional<First, Second>
    where First.Input == Input, Second.Input == Input, First.Output == Second.Output {
        Parsing.Conditional.first(first)
    }

    /// Builds the second branch of if-else.
    @inlinable
    public static func buildEither<First: Parsing.Parser, Second: Parsing.Parser>(
        second: Second
    ) -> Parsing.Conditional<First, Second>
    where First.Input == Input, Second.Input == Input, First.Output == Second.Output {
        Parsing.Conditional.second(second)
    }
}

// MARK: - Expressions

extension Parsing.Take.Builder {
    /// Wraps an expression in the builder context.
    @inlinable
    public static func buildExpression<P: Parsing.Parser>(
        _ parser: P
    ) -> P where P.Input == Input {
        parser
    }
}
