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

    @inlinable
    public func parse(_ input: inout Input) throws(Parsing.Error) -> Output {
        guard !input.isEmpty else {
            throw Parsing.Error.unexpectedEnd(expected: "any element")
        }
        return input.removeFirst()
    }
}
