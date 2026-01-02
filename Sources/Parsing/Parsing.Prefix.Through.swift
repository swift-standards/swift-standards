//
//  Parsing.Prefix.Through.swift
//  swift-standards
//
//  Prefix parser that consumes through (including) delimiter.
//

extension Parsing.Prefix {
    /// A parser that consumes through (including) a delimiter sequence.
    ///
    /// Like `UpTo` but includes the delimiter in the consumed portion.
    public struct Through<Input: Collection>: Sendable
    where Input: Sendable, Input.Element: Equatable & Sendable, Input.SubSequence == Input {
        @usableFromInline
        let delimiter: [Input.Element]

        @inlinable
        public init(_ delimiter: [Input.Element]) {
            self.delimiter = delimiter
        }
    }
}

extension Parsing.Prefix.Through: Parsing.Parser {
    public typealias Output = Input

    @inlinable
    public func parse(_ input: inout Input) throws(Parsing.Error) -> Output {
        var endIndex = input.startIndex

        outer: while endIndex < input.endIndex {
            var checkIndex = endIndex
            for element in delimiter {
                guard checkIndex < input.endIndex else {
                    break outer
                }
                guard input[checkIndex] == element else {
                    input.formIndex(after: &endIndex)
                    continue outer
                }
                input.formIndex(after: &checkIndex)
            }
            // Found delimiter - include it in result
            let result = input[input.startIndex..<checkIndex]
            input = input[checkIndex...]
            return result
        }

        throw Parsing.Error("Delimiter not found")
    }
}
