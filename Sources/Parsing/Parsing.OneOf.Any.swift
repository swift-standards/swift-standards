//
//  Parsing.OneOf.Any.swift
//  swift-standards
//
//  Type-erased alternative parser.
//

extension Parsing.OneOf {
    /// A parser that tries multiple alternatives in order.
    ///
    /// `Any` attempts each parser in sequence. The first parser that succeeds
    /// determines the result. If all parsers fail, it fails with an error
    /// aggregating all the individual failures.
    ///
    /// ## Backtracking
    ///
    /// By default, saves and restores input state between attempts.
    /// This enables clean backtracking when an alternative fails partway through.
    public struct `Any`<Input, Output>: Sendable {
        @usableFromInline
        let parsers: [@Sendable (inout Input) throws(Parsing.Error) -> Output]

        @inlinable
        public init(_ parsers: [@Sendable (inout Input) throws(Parsing.Error) -> Output]) {
            self.parsers = parsers
        }
    }
}

extension Parsing.OneOf.`Any`: Parsing.Parser {
    @inlinable
    public func parse(_ input: inout Input) throws(Parsing.Error) -> Output {
        var errors: [Parsing.Error] = []
        let saved = input

        for parser in parsers {
            do {
                return try parser(&input)
            } catch {
                errors.append(error)
                input = saved
            }
        }

        throw Parsing.Error.noMatch(tried: errors)
    }
}
