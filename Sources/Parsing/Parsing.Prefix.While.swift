//
//  Parsing.Prefix.While.swift
//  swift-standards
//
//  Prefix parser that consumes while predicate holds.
//

extension Parsing.Prefix {
    /// A parser that consumes elements while a predicate holds.
    ///
    /// `While` is fundamental for tokenization. It greedily consumes elements
    /// until the predicate returns false or input is exhausted.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // Parse digits
    /// let digits = Parsing.Prefix.While { $0 >= 0x30 && $0 <= 0x39 }
    ///
    /// // Parse until delimiter
    /// let field = Parsing.Prefix.While { $0 != UInt8(ascii: ",") }
    /// ```
    public struct While<Input: Collection>: Sendable
    where Input: Sendable, Input.SubSequence == Input {
        @usableFromInline
        let minLength: Int

        @usableFromInline
        let maxLength: Int?

        @usableFromInline
        let predicate: @Sendable (Input.Element) -> Bool

        @inlinable
        public init(
            minLength: Int = 0,
            maxLength: Int? = nil,
            _ predicate: @escaping @Sendable (Input.Element) -> Bool
        ) {
            self.minLength = minLength
            self.maxLength = maxLength
            self.predicate = predicate
        }
    }
}

extension Parsing.Prefix.While: Parsing.Parser {
    public typealias Output = Input

    @inlinable
    public func parse(_ input: inout Input) throws(Parsing.Error) -> Output {
        var count = 0
        var endIndex = input.startIndex

        while endIndex < input.endIndex {
            if let max = maxLength, count >= max {
                break
            }
            guard predicate(input[endIndex]) else {
                break
            }
            input.formIndex(after: &endIndex)
            count += 1
        }

        guard count >= minLength else {
            throw Parsing.Error("Expected at least \(minLength) elements, got \(count)")
        }

        let result = input[input.startIndex..<endIndex]
        input = input[endIndex...]
        return result
    }
}
