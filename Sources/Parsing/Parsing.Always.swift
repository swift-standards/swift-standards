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
    @inlinable
    public func parse(_ input: inout Input) throws(Parsing.Error) -> Output {
        output
    }
}
