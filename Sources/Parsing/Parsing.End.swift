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

    @inlinable
    public func parse(_ input: inout Input) throws(Parsing.Error) -> Void {
        guard input.isEmpty else {
            throw Parsing.Error("Expected end of input", at: input)
        }
    }
}
