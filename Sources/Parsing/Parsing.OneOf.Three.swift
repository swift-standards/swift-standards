//
//  Parsing.OneOf.Three.swift
//  swift-standards
//
//  Three-parser alternative combinator.
//

extension Parsing.OneOf {
    /// A parser that tries three alternatives.
    public struct Three<P0: Parsing.Parser, P1: Parsing.Parser, P2: Parsing.Parser>: Sendable
    where P0: Sendable, P1: Sendable, P2: Sendable,
          P0.Input == P1.Input, P1.Input == P2.Input,
          P0.Output == P1.Output, P1.Output == P2.Output {
        @usableFromInline
        let p0: P0

        @usableFromInline
        let p1: P1

        @usableFromInline
        let p2: P2

        @inlinable
        public init(_ p0: P0, _ p1: P1, _ p2: P2) {
            self.p0 = p0
            self.p1 = p1
            self.p2 = p2
        }
    }
}

extension Parsing.OneOf.Three: Parsing.Parser {
    public typealias Input = P0.Input
    public typealias Output = P0.Output
    public typealias Failure = Parsing.OneOf.Errors<P0.Failure, P1.Failure, P2.Failure>

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) -> Output {
        let saved = input

        do { return try p0.parse(&input) } catch let error0 {
            input = saved
            do { return try p1.parse(&input) } catch let error1 {
                input = saved
                do { return try p2.parse(&input) } catch let error2 {
                    throw Failure(error0, error1, error2)
                }
            }
        }
    }
}

// MARK: - Printer Conformance

extension Parsing.OneOf.Three: Parsing.Printer
where P0: Parsing.Printer, P1: Parsing.Printer, P2: Parsing.Printer {
    @inlinable
    public func print(_ output: Output, into input: inout Input) throws(Failure) {
        // Try each printer in order, use first that succeeds
        let saved = input

        do {
            try p0.print(output, into: &input)
            return
        } catch let error0 {
            input = saved
            do {
                try p1.print(output, into: &input)
                return
            } catch let error1 {
                input = saved
                do {
                    try p2.print(output, into: &input)
                } catch let error2 {
                    throw Failure(error0, error1, error2)
                }
            }
        }
    }
}
