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
        let parsers: [@Sendable (inout Input) throws(Error) -> Output]

        @inlinable
        public init(_ parsers: [@Sendable (inout Input) throws(Error) -> Output]) {
            self.parsers = parsers
        }
    }
}

// MARK: - Error Type

extension Parsing.OneOf.`Any` {
    /// Type-erased error for `OneOf.Any`.
    ///
    /// Since `Any` uses type-erased closures, it needs a common error type
    /// to aggregate failures from heterogeneous parsers.
    public struct Error: Swift.Error, Sendable, Equatable {
        /// Description of the failure.
        public let message: String

        /// Errors from each attempted alternative.
        public let underlying: [Error]

        @inlinable
        public init(_ message: String, underlying: [Error] = []) {
            self.message = message
            self.underlying = underlying
        }

        /// Creates an error for no matching alternative.
        @inlinable
        public static func noMatch(tried errors: [Error]) -> Self {
            Self("No matching alternative", underlying: errors)
        }
    }
}

// MARK: - Parser Conformance

extension Parsing.OneOf.`Any`: Parsing.Parser {
    public typealias Failure = Error

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) -> Output {
        var errors: [Error] = []
        let saved = input

        for parser in parsers {
            do {
                return try parser(&input)
            } catch {
                errors.append(error)
                input = saved
            }
        }

        throw .noMatch(tried: errors)
    }
}
