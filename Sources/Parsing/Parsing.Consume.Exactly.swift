//
//  Parsing.Consume.Exactly.swift
//  swift-standards
//
//  Consume exactly N elements.
//

extension Parsing.Consume {
    /// A parser that consumes exactly N elements.
    public struct Exactly<Input: Collection>: Sendable
    where Input: Sendable, Input.SubSequence == Input {
        @usableFromInline
        let count: Int

        @inlinable
        public init(_ count: Int) {
            self.count = count
        }
    }
}

extension Parsing.Consume.Exactly: Parsing.Parser {
    public typealias Output = Input

    @inlinable
    public func parse(_ input: inout Input) throws(Parsing.Error) -> Output {
        let endIndex = input.index(input.startIndex, offsetBy: count, limitedBy: input.endIndex)
            ?? input.endIndex

        let actualCount = input.distance(from: input.startIndex, to: endIndex)
        guard actualCount == count else {
            throw Parsing.Error("Expected \(count) elements, got \(actualCount)")
        }

        let result = input[input.startIndex..<endIndex]
        input = input[endIndex...]
        return result
    }
}
