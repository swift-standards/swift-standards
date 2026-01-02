//
//  Parsing.Always.swift
//  swift-standards
//
//  Always-succeeding parser.
//

extension Parsing {
    /// A parser that always succeeds without consuming input.
    ///
    /// `Always` is useful as an identity element and for injecting values.
    public struct Always<Input, Output>: Sendable where Output: Sendable {
        public let output: Output

        @inlinable
        public init(_ output: Output) {
            self.output = output
        }
    }
}

extension Parsing.Always: Parsing.Parser {
    public typealias Failure = Never

    @inlinable
    public func parse(_ input: inout Input) -> Output {
        output
    }
}

// MARK: - Printer Conformance (Void only)

extension Parsing.Always: Parsing.Printer where Output == Void {
    @inlinable
    public func print(_ output: Void, into input: inout Input) {
        // Always produces value without consuming/producing input
    }
}
