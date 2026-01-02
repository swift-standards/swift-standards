//
//  Parsing.First.Where.swift
//  swift-standards
//
//  Parse first element matching predicate.
//

extension Parsing.First {
    /// A parser that consumes the first element if it matches a predicate.
    public struct Where<Input: Parsing.Input>: Sendable
    where Input: Sendable {
        @usableFromInline
        let predicate: @Sendable (Input.Element) -> Bool

        @usableFromInline
        let expected: String

        @inlinable
        public init(
            expected: String = "matching element",
            _ predicate: @escaping @Sendable (Input.Element) -> Bool
        ) {
            self.predicate = predicate
            self.expected = expected
        }
    }
}

extension Parsing.First.Where: Parsing.Parser {
    public typealias Output = Input.Element
    public typealias Failure = Parsing.Either<Parsing.EndOfInput.Error, Parsing.Match.Error>

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) -> Output {
        guard let element = input.first else {
            throw .left(.unexpected(expected: expected))
        }
        guard predicate(element) else {
            throw .right(.predicateFailed(description: expected))
        }
        return input.removeFirst()
    }
}
