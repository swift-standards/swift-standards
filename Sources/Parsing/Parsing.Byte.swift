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

    @inlinable
    public func parse(_ input: inout Input) throws(Parsing.Error) -> Void {
        guard let actual = input.first else {
            throw Parsing.Error.unexpectedEnd(expected: "byte \(expected)")
        }
        guard actual == expected else {
            throw Parsing.Error.unexpected(actual, expected: "byte \(expected)")
        }
        _ = input.removeFirst()
    }
}
