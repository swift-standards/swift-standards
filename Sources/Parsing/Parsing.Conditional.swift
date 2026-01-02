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

    @inlinable
    public func parse(_ input: inout Input) throws(Parsing.Error) -> Output {
        switch self {
        case .first(let parser):
            return try parser.parse(&input)
        case .second(let parser):
            return try parser.parse(&input)
        }
    }
}
