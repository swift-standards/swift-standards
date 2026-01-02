//
//  Parsing.End.swift
//  swift-standards
//
//  End-of-input parser.
//

extension Parsing {
    /// A parser that succeeds only at end of input.
    ///
    /// Consumes nothing and produces Void. Fails if input remains.
    public struct End<Input: Collection>: Sendable
    where Input: Sendable {
        @inlinable
        public init() {}
    }
}

extension Parsing.End: Parsing.Parser {
    public typealias Output = Void
    public typealias Failure = Parsing.Match.Error

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) {
        guard input.isEmpty else {
            throw .expectedEnd(remaining: input.count)
        }
    }
}

// MARK: - Printer Conformance

extension Parsing.End: Parsing.Printer {
    @inlinable
    public func print(_ output: Void, into input: inout Input) {
        // End produces nothing - it's a marker
    }
}
