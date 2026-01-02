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
    public typealias Failure = Parsing.Constraint.Error

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) -> Output {
        let endIndex = input.index(input.startIndex, offsetBy: count, limitedBy: input.endIndex)
            ?? input.endIndex

        let actualCount = input.distance(from: input.startIndex, to: endIndex)
        guard actualCount == count else {
            throw .countTooLow(expected: count, got: actualCount)
        }

        let result = input[input.startIndex..<endIndex]
        input = input[endIndex...]
        return result
    }
}

// MARK: - Printer Conformance

extension Parsing.Consume.Exactly: Parsing.Printer
where Input: RangeReplaceableCollection {
    @inlinable
    public func print(_ output: Input, into input: inout Input) throws(Failure) {
        let outputCount = output.count
        guard outputCount == count else {
            if outputCount < count {
                throw .countTooLow(expected: count, got: outputCount)
            } else {
                throw .countTooHigh(expected: count, got: outputCount)
            }
        }
        input.insert(contentsOf: output, at: input.startIndex)
    }
}
