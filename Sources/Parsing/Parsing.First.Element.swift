//
//  Parsing.First.Element.swift
//  swift-standards
//
//  Parse first element unconditionally.
//

extension Parsing.First {
    /// A parser that consumes and returns the first element.
    ///
    /// Fails if the input is empty.
    public struct Element<Input: Parsing.Input>: Sendable
    where Input: Sendable {
        @inlinable
        public init() {}
    }
}

extension Parsing.First.Element: Parsing.Parser {
    public typealias Output = Input.Element
    public typealias Failure = Parsing.EndOfInput.Error

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) -> Output {
        guard !input.isEmpty else {
            throw .unexpected(expected: "any element")
        }
        return input.removeFirst()
    }
}

// MARK: - Printer Conformance

extension Parsing.First.Element: Parsing.Printer
where Input: RangeReplaceableCollection {
    @inlinable
    public func print(_ output: Input.Element, into input: inout Input) {
        input.insert(output, at: input.startIndex)
    }
}
