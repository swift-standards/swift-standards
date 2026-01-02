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
    public typealias Failure = Never

    @inlinable
    public func parse(_ input: inout Input) -> Output {
        let result = input
        input = input[input.endIndex...]
        return result
    }
}

// MARK: - Printer Conformance

extension Parsing.Rest: Parsing.Printer
where Input: RangeReplaceableCollection {
    @inlinable
    public func print(_ output: Input, into input: inout Input) {
        input.insert(contentsOf: output, at: input.startIndex)
    }
}
