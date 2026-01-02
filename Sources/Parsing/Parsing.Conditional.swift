//
//  Parsing.Conditional.swift
//  swift-standards
//
//  Conditional branch parser (for result builders).
//

extension Parsing {
    /// A parser that represents a conditional branch.
    ///
    /// Used by `Take.Builder` for `if-else` statements.
    public enum Conditional<First: Parsing.Parser, Second: Parsing.Parser>: Sendable
    where First: Sendable, Second: Sendable,
          First.Input == Second.Input, First.Output == Second.Output {
        case first(First)
        case second(Second)
    }
}

extension Parsing.Conditional: Parsing.Parser {
    public typealias Input = First.Input
    public typealias Output = First.Output
    public typealias Failure = Parsing.Either<First.Failure, Second.Failure>

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) -> Output {
        switch self {
        case .first(let parser):
            do {
                return try parser.parse(&input)
            } catch {
                throw .left(error)
            }
        case .second(let parser):
            do {
                return try parser.parse(&input)
            } catch {
                throw .right(error)
            }
        }
    }
}

// MARK: - Printer Conformance

extension Parsing.Conditional: Parsing.Printer
where First: Parsing.Printer, Second: Parsing.Printer {
    @inlinable
    public func print(_ output: Output, into input: inout Input) throws(Failure) {
        switch self {
        case .first(let printer):
            do {
                try printer.print(output, into: &input)
            } catch {
                throw .left(error)
            }
        case .second(let printer):
            do {
                try printer.print(output, into: &input)
            } catch {
                throw .right(error)
            }
        }
    }
}
