//
//  Parsing.Byte.swift
//  swift-standards
//
//  Single byte literal matching.
//

extension Parsing {
    /// A parser that matches a single byte.
    ///
    /// More efficient than `Literal` for single bytes.
    public struct Byte<Input: Parsing.Input>: Sendable
    where Input: Sendable, Input.Element == UInt8 {
        @usableFromInline
        let expected: UInt8

        @inlinable
        public init(_ expected: UInt8) {
            self.expected = expected
        }
    }
}

extension Parsing.Byte: Parsing.Parser {
    public typealias Output = Void
    public typealias Failure = Parsing.Either<Parsing.EndOfInput.Error, Parsing.Match.Error>

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) {
        guard let actual = input.first else {
            throw .left(.unexpected(expected: "byte \(expected)"))
        }
        guard actual == expected else {
            throw .right(.byteMismatch(expected: [expected], found: [actual]))
        }
        _ = input.removeFirst()
    }
}

// MARK: - Printer Conformance

extension Parsing.Byte: Parsing.Printer
where Input: RangeReplaceableCollection {
    @inlinable
    public func print(_ output: Void, into input: inout Input) {
        input.insert(expected, at: input.startIndex)
    }
}
