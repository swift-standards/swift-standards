//
//  Parsing.Fail.swift
//  swift-standards
//
//  Always-failing parser.
//

extension Parsing {
    /// A parser that always fails.
    ///
    /// `Fail` is useful as a fallback in error handling scenarios.
    public struct Fail<Input, Output>: Sendable {
        @usableFromInline
        let error: Parsing.Error

        @inlinable
        public init(_ message: String) {
            self.error = Parsing.Error(message)
        }

        @inlinable
        public init(error: Parsing.Error) {
            self.error = error
        }
    }
}

extension Parsing.Fail: Parsing.Parser {
    @inlinable
    public func parse(_ input: inout Input) throws(Parsing.Error) -> Output {
        throw error
    }
}
