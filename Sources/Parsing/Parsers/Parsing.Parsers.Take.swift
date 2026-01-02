//
//  Parsing.Parsers.Take.swift
//  swift-standards
//
//  Sequential composition parsers that collect outputs.
//

extension Parsing.Parsers {
    /// Namespace for sequential "take" parsers that collect multiple outputs.
    public enum Take {}

    /// Namespace for sequential "skip" parsers that discard Void outputs.
    public enum Skip {}
}

// MARK: - Take.Builder

extension Parsing.Parsers.Take {
    /// A result builder for composing parsers sequentially.
    ///
    /// `Take.Builder` enables declarative parser composition using Swift's
    /// result builder syntax. Parsers are combined sequentially, with their
    /// outputs collected into tuples.
    ///
    /// ## Sequential Composition
    ///
    /// Multiple parsers run in sequence. Outputs are combined into tuples:
    ///
    /// ```swift
    /// Parse.Sequence {
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
    /// This is useful for delimiters and whitespace.
    ///
    /// ## Conditionals
    ///
    /// Use `if` statements for optional parsing:
    ///
    /// ```swift
    /// Parse.Sequence {
    ///     Header()
    ///     if hasBody {
    ///         Body()
    ///     }
    /// }
    /// ```
    @resultBuilder
    public struct Builder<Input> {
        // MARK: - Empty Block

        /// Builds an empty parser that consumes nothing and returns Void.
        @inlinable
        public static func buildBlock() -> Parsing.Parsers.Always<Input, Void> {
            Parsing.Parsers.Always(())
        }

        // MARK: - Single Parser

        /// Builds a single parser unchanged.
        @inlinable
        public static func buildBlock<P: Parsing.Parser>(
            _ parser: P
        ) -> P where P.Input == Input {
            parser
        }

        // MARK: - Two Parsers

        /// Combines two parsers sequentially.
        @inlinable
        public static func buildBlock<P0: Parsing.Parser, P1: Parsing.Parser>(
            _ p0: P0,
            _ p1: P1
        ) -> Parsing.Parsers.Take.Two<P0, P1>
        where P0.Input == Input, P1.Input == Input {
            Parsing.Parsers.Take.Two(p0, p1)
        }

        // MARK: - Skip First (P0 output is Void)

        /// Combines parsers, skipping Void output from first.
        @inlinable
        public static func buildBlock<P0: Parsing.Parser, P1: Parsing.Parser>(
            _ p0: P0,
            _ p1: P1
        ) -> Parsing.Parsers.Skip.First<P0, P1>
        where P0.Input == Input, P1.Input == Input, P0.Output == Void {
            Parsing.Parsers.Skip.First(p0, p1)
        }

        // MARK: - Skip Second (P1 output is Void)

        /// Combines parsers, skipping Void output from second.
        @inlinable
        public static func buildBlock<P0: Parsing.Parser, P1: Parsing.Parser>(
            _ p0: P0,
            _ p1: P1
        ) -> Parsing.Parsers.Skip.Second<P0, P1>
        where P0.Input == Input, P1.Input == Input, P1.Output == Void {
            Parsing.Parsers.Skip.Second(p0, p1)
        }

        // MARK: - Partial Block Building (For Longer Chains)

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
        ) -> Parsing.Parsers.Take.Two<Accumulated, Next>
        where Accumulated.Input == Input, Next.Input == Input {
            Parsing.Parsers.Take.Two(accumulated, next)
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
        ) -> Parsing.Parsers.Take.Two<Accumulated, Next>.Map<(repeat each O1, O2)>
        where
            Accumulated.Input == Input,
            Next.Input == Input,
            Accumulated.Output == (repeat each O1),
            Next.Output == O2
        {
            Parsing.Parsers.Take.Two(accumulated, next)
                .map { tuple, next in
                    (repeat each tuple, next)
                }
        }

        /// Accumulates with Void skipping (accumulated is Void).
        @inlinable
        public static func buildPartialBlock<Accumulated: Parsing.Parser, Next: Parsing.Parser>(
            accumulated: Accumulated,
            next: Next
        ) -> Parsing.Parsers.Skip.First<Accumulated, Next>
        where Accumulated.Input == Input, Next.Input == Input, Accumulated.Output == Void {
            Parsing.Parsers.Skip.First(accumulated, next)
        }

        /// Accumulates with Void skipping (next is Void).
        @inlinable
        public static func buildPartialBlock<Accumulated: Parsing.Parser, Next: Parsing.Parser>(
            accumulated: Accumulated,
            next: Next
        ) -> Parsing.Parsers.Skip.Second<Accumulated, Next>
        where Accumulated.Input == Input, Next.Input == Input, Next.Output == Void {
            Parsing.Parsers.Skip.Second(accumulated, next)
        }

        // MARK: - Conditionals

        /// Builds an optional parser from an `if` statement.
        @inlinable
        public static func buildIf<P: Parsing.Parser>(
            _ parser: P?
        ) -> Parsing.Parsers.Optional<P> where P.Input == Input {
            .init(parser)
        }

        /// Builds the first branch of if-else.
        @inlinable
        public static func buildEither<First: Parsing.Parser, Second: Parsing.Parser>(
            first: First
        ) -> Parsing.Parsers.Conditional<First, Second>
        where First.Input == Input, Second.Input == Input, First.Output == Second.Output {
            Parsing.Parsers.Conditional.first(first)
        }

        /// Builds the second branch of if-else.
        @inlinable
        public static func buildEither<First: Parsing.Parser, Second: Parsing.Parser>(
            second: Second
        ) -> Parsing.Parsers.Conditional<First, Second>
        where First.Input == Input, Second.Input == Input, First.Output == Second.Output {
            Parsing.Parsers.Conditional.second(second)
        }

        // MARK: - Expressions

        /// Wraps an expression in the builder context.
        @inlinable
        public static func buildExpression<P: Parsing.Parser>(
            _ parser: P
        ) -> P where P.Input == Input {
            parser
        }
    }
}

// MARK: - Take.Two

extension Parsing.Parsers.Take {
    /// A parser that runs two parsers in sequence and collects both outputs.
    ///
    /// The outputs are combined into a tuple `(P0.Output, P1.Output)`.
    /// Created by `Take.Builder` when combining two non-Void parsers.
    public struct Two<P0: Parsing.Parser, P1: Parsing.Parser>: Parsing.Parser, Sendable
    where P0: Sendable, P1: Sendable, P0.Input == P1.Input {
        public typealias Input = P0.Input
        public typealias Output = (P0.Output, P1.Output)

        @usableFromInline
        let p0: P0

        @usableFromInline
        let p1: P1

        @inlinable
        public init(_ p0: P0, _ p1: P1) {
            self.p0 = p0
            self.p1 = p1
        }

        @inlinable
        public func parse(_ input: inout Input) throws(Parsing.Error) -> Output {
            let o0 = try p0.parse(&input)
            let o1 = try p1.parse(&input)
            return (o0, o1)
        }

        /// Maps the output of this parser using the given transform.
        @inlinable
        public func map<NewOutput>(
            _ transform: @escaping @Sendable (P0.Output, P1.Output) -> NewOutput
        ) -> Map<NewOutput> {
            Map(upstream: self, transform: transform)
        }
    }
}

// MARK: - Take.Two.Map

extension Parsing.Parsers.Take.Two {
    /// A parser that transforms the output of a `Take.Two` parser.
    ///
    /// Used internally for tuple flattening with parameter packs.
    public struct Map<NewOutput>: Parsing.Parser, Sendable
    where P0: Sendable, P1: Sendable {
        public typealias Input = P0.Input
        public typealias Output = NewOutput

        @usableFromInline
        let upstream: Parsing.Parsers.Take.Two<P0, P1>

        @usableFromInline
        let transform: @Sendable (P0.Output, P1.Output) -> NewOutput

        @inlinable
        init(
            upstream: Parsing.Parsers.Take.Two<P0, P1>,
            transform: @escaping @Sendable (P0.Output, P1.Output) -> NewOutput
        ) {
            self.upstream = upstream
            self.transform = transform
        }

        @inlinable
        public func parse(_ input: inout Input) throws(Parsing.Error) -> Output {
            let (o0, o1) = try upstream.parse(&input)
            return transform(o0, o1)
        }
    }
}

// MARK: - Skip.First

extension Parsing.Parsers.Skip {
    /// A parser that runs two parsers but discards the first's output.
    ///
    /// Used when the first parser has `Void` output (like a delimiter).
    public struct First<P0: Parsing.Parser, P1: Parsing.Parser>: Parsing.Parser, Sendable
    where P0: Sendable, P1: Sendable, P0.Input == P1.Input, P0.Output == Void {
        public typealias Input = P0.Input
        public typealias Output = P1.Output

        @usableFromInline
        let p0: P0

        @usableFromInline
        let p1: P1

        @inlinable
        public init(_ p0: P0, _ p1: P1) {
            self.p0 = p0
            self.p1 = p1
        }

        @inlinable
        public func parse(_ input: inout Input) throws(Parsing.Error) -> Output {
            _ = try p0.parse(&input)
            return try p1.parse(&input)
        }
    }
}

// MARK: - Skip.Second

extension Parsing.Parsers.Skip {
    /// A parser that runs two parsers but discards the second's output.
    ///
    /// Used when the second parser has `Void` output (like a delimiter).
    public struct Second<P0: Parsing.Parser, P1: Parsing.Parser>: Parsing.Parser, Sendable
    where P0: Sendable, P1: Sendable, P0.Input == P1.Input, P1.Output == Void {
        public typealias Input = P0.Input
        public typealias Output = P0.Output

        @usableFromInline
        let p0: P0

        @usableFromInline
        let p1: P1

        @inlinable
        public init(_ p0: P0, _ p1: P1) {
            self.p0 = p0
            self.p1 = p1
        }

        @inlinable
        public func parse(_ input: inout Input) throws(Parsing.Error) -> Output {
            let o0 = try p0.parse(&input)
            _ = try p1.parse(&input)
            return o0
        }
    }
}
