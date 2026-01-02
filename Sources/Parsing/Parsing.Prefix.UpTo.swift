//
//  Parsing.Prefix.UpTo.swift
//  swift-standards
//
//  Prefix parser that consumes up to (not including) delimiter.
//

extension Parsing.Prefix {
    /// A parser that consumes up to (but not including) a delimiter sequence.
    ///
    /// Unlike `While`, this looks for a specific delimiter sequence rather
    /// than testing each element.
    public struct UpTo<Input: Collection>: Sendable
    where Input: Sendable, Input.Element: Equatable & Sendable, Input.SubSequence == Input {
        @usableFromInline
        let delimiter: [Input.Element]

        @inlinable
        public init(_ delimiter: [Input.Element]) {
            self.delimiter = delimiter
        }
    }
}

extension Parsing.Prefix.UpTo: Parsing.Parser {
    public typealias Output = Input

    @inlinable
    public func parse(_ input: inout Input) throws(Parsing.Error) -> Output {
        var endIndex = input.startIndex

        outer: while endIndex < input.endIndex {
            // Check if delimiter starts here
            var checkIndex = endIndex
            for element in delimiter {
                guard checkIndex < input.endIndex else {
                    break outer
                }
                guard input[checkIndex] == element else {
                    // No match, advance and continue
                    input.formIndex(after: &endIndex)
                    continue outer
                }
                input.formIndex(after: &checkIndex)
            }
            // Found delimiter
            break
        }

        let result = input[input.startIndex..<endIndex]
        input = input[endIndex...]
        return result
    }
}
