//
//  Parsing.Rest.swift
//  swift-standards
//
//  Consume all remaining input.
//

extension Parsing {
    /// A parser that consumes and returns all remaining input.
    ///
    /// Always succeeds, possibly with empty output.
    public struct Rest<Input: Collection>: Sendable
    where Input: Sendable, Input.SubSequence == Input {
        @inlinable
        public init() {}
    }
}

extension Parsing.Rest: Parsing.Parser {
    public typealias Output = Input

    @inlinable
    public func parse(_ input: inout Input) throws(Parsing.Error) -> Output {
        let result = input
        input = input[input.endIndex...]
        return result
    }
}
