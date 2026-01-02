//
//  Parsing.Literal.swift
//  swift-standards
//
//  Literal byte sequence matching.
//

extension Parsing {
    /// A parser that matches a specific byte sequence.
    ///
    /// `Literal` consumes exact bytes from the input. It succeeds with `Void`
    /// output, making it ideal for delimiters and keywords.
    public struct Literal<Input: Parsing.Input>: Sendable
    where Input: Sendable, Input.Element == UInt8 {
        @usableFromInline
        let bytes: [UInt8]

        @inlinable
        public init(_ bytes: [UInt8]) {
            self.bytes = bytes
        }

        @inlinable
        public init(_ string: StaticString) {
            self.bytes = Array(string.utf8Start.withMemoryRebound(to: UInt8.self, capacity: string.utf8CodeUnitCount) {
                UnsafeBufferPointer(start: $0, count: string.utf8CodeUnitCount)
            })
        }
    }
}

extension Parsing.Literal: Parsing.Parser {
    public typealias Output = Void
    public typealias Failure = Parsing.Either<Parsing.EndOfInput.Error, Parsing.Match.Error>

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) {
        for expected in bytes {
            guard let actual = input.first else {
                throw .left(.unexpected(expected: "byte \(expected)"))
            }
            guard actual == expected else {
                throw .right(.byteMismatch(expected: [expected], found: [actual]))
            }
            _ = input.removeFirst()
        }
    }
}

extension Parsing.Literal: ExpressibleByStringLiteral {
    @inlinable
    public init(stringLiteral value: String) {
        self.bytes = Array(value.utf8)
    }
}

extension Parsing.Literal: ExpressibleByUnicodeScalarLiteral {
    @inlinable
    public init(unicodeScalarLiteral value: Unicode.Scalar) {
        self.bytes = Array(String(value).utf8)
    }
}

extension Parsing.Literal: ExpressibleByExtendedGraphemeClusterLiteral {
    @inlinable
    public init(extendedGraphemeClusterLiteral value: Character) {
        self.bytes = Array(String(value).utf8)
    }
}

// MARK: - Printer Conformance

extension Parsing.Literal: Parsing.Printer
where Input: RangeReplaceableCollection {
    @inlinable
    public func print(_ output: Void, into input: inout Input) {
        input.insert(contentsOf: bytes, at: input.startIndex)
    }
}
