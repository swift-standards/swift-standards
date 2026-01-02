//
//  Parsing.Optional.swift
//  swift-standards
//
//  Compile-time optional parser (for result builders).
//

extension Parsing {
    /// A parser that optionally parses if its wrapped parser is present.
    ///
    /// Used by `Take.Builder` for `if` statements without `else`.
    public struct Optional<Wrapped: Parsing.Parser>: Sendable
    where Wrapped: Sendable {
        @usableFromInline
        let wrapped: Wrapped?

        @inlinable
        public init(_ wrapped: Wrapped?) {
            self.wrapped = wrapped
        }
    }
}

extension Parsing.Optional: Parsing.Parser {
    public typealias Input = Wrapped.Input
    public typealias Output = Wrapped.Output?
    public typealias Failure = Wrapped.Failure

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) -> Output {
        guard let wrapped = wrapped else {
            return nil
        }
        return try wrapped.parse(&input)
    }
}

// MARK: - Printer Conformance

extension Parsing.Optional: Parsing.Printer
where Wrapped: Parsing.Printer {
    @inlinable
    public func print(_ output: Wrapped.Output?, into input: inout Input) throws(Failure) {
        guard let wrapped = wrapped, let output = output else { return }
        try wrapped.print(output, into: &input)
    }
}
