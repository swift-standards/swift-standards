//
//  Parsing.Either.swift
//  swift-standards
//
//  Binary sum type for composing heterogeneous errors.
//

extension Parsing {
    /// Binary sum type for composing heterogeneous errors.
    ///
    /// Used by combinators like `OneOf` and `FlatMap` to compose errors from
    /// parsers with different failure types without requiring existentials.
    ///
    /// ## Error Composition
    ///
    /// When `OneOf` combines parsers with different error types:
    /// ```swift
    /// let parser = OneOf.Two(parserA, parserB)
    /// // Failure = Parsing.Either<ParserA.Failure, ParserB.Failure>
    /// ```
    ///
    /// For more than two parsers, Either chains nest:
    /// ```swift
    /// // Either<A.Failure, Either<B.Failure, C.Failure>>
    /// ```
    ///
    /// ## Never Elimination
    ///
    /// When one side is `Never` (infallible), the error simplifies:
    /// - `Either<Never, R>` → effectively just `R`
    /// - `Either<L, Never>` → effectively just `L`
    public enum Either<Left: Swift.Error & Sendable, Right: Swift.Error & Sendable>:
        Swift.Error, Sendable {
        case left(Left)
        case right(Right)
    }
}

// MARK: - Equatable

extension Parsing.Either: Equatable where Left: Equatable, Right: Equatable {}

// MARK: - Accessors

extension Parsing.Either {
    /// Extract left error if present.
    @inlinable
    public var left: Left? {
        if case .left(let e) = self { return e }
        return nil
    }

    /// Extract right error if present.
    @inlinable
    public var right: Right? {
        if case .right(let e) = self { return e }
        return nil
    }
}

// MARK: - Never Elimination

extension Parsing.Either where Left == Never {
    /// When left is `Never`, extract the right error unconditionally.
    @inlinable
    public var error: Right {
        switch self {
        case .right(let e): return e
        }
    }
}

extension Parsing.Either where Right == Never {
    /// When right is `Never`, extract the left error unconditionally.
    @inlinable
    public var error: Left {
        switch self {
        case .left(let e): return e
        }
    }
}
