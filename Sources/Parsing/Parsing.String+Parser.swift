//
//  Parsing.String+Parser.swift
//  swift-standards
//
//  String conformance to Parser and Printer for literal usage.
//

extension String: Parsing.Parser {
    public typealias Input = Substring
    public typealias Output = Void
    public typealias Failure = Parsing.Match.Error

    @inlinable
    public func parse(_ input: inout Substring) throws(Failure) {
        guard input.hasPrefix(self) else {
            throw .literalMismatch(expected: self, found: String(input.prefix(self.count)))
        }
        input = input.dropFirst(self.count)
    }
}

extension String: Parsing.Printer {
    @inlinable
    public func print(_ output: Void, into input: inout Substring) {
        input.insert(contentsOf: self, at: input.startIndex)
    }
}
