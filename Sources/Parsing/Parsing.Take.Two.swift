//
//  Parsing.Take.Two.swift
//  swift-standards
//
//  Two-parser sequential combinator.
//

extension Parsing.Take {
    /// A parser that runs two parsers in sequence and collects both outputs.
    ///
    /// The outputs are combined into a tuple `(P0.Output, P1.Output)`.
    /// Created by `Take.Builder` when combining two non-Void parsers.
    public struct Two<P0: Parsing.Parser, P1: Parsing.Parser>: Sendable
    where P0: Sendable, P1: Sendable, P0.Input == P1.Input {
        @usableFromInline
        let p0: P0

        @usableFromInline
        let p1: P1

        @inlinable
        public init(_ p0: P0, _ p1: P1) {
            self.p0 = p0
            self.p1 = p1
        }
    }
}

extension Parsing.Take.Two: Parsing.Parser {
    public typealias Input = P0.Input
    public typealias Output = (P0.Output, P1.Output)
    public typealias Failure = Parsing.Either<P0.Failure, P1.Failure>

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) -> Output {
        let o0: P0.Output
        do {
            o0 = try p0.parse(&input)
        } catch {
            throw .left(error)
        }
        let o1: P1.Output
        do {
            o1 = try p1.parse(&input)
        } catch {
            throw .right(error)
        }
        return (o0, o1)
    }
}

extension Parsing.Take.Two {
    /// Maps the output of this parser using the given transform.
    @inlinable
    public func map<NewOutput>(
        _ transform: @escaping @Sendable (P0.Output, P1.Output) -> NewOutput
    ) -> Parsing.Take.Two<P0, P1>.Map<NewOutput> {
        Map(upstream: self, transform: transform)
    }
}

// MARK: - Printer Conformance

extension Parsing.Take.Two: Parsing.Printer
where P0: Parsing.Printer, P1: Parsing.Printer {
    @inlinable
    public func print(
        _ output: (P0.Output, P1.Output),
        into input: inout Input
    ) throws(Failure) {
        // Print in reverse order to build input correctly
        do {
            try p1.print(output.1, into: &input)
        } catch {
            throw .right(error)
        }
        do {
            try p0.print(output.0, into: &input)
        } catch {
            throw .left(error)
        }
    }
}
