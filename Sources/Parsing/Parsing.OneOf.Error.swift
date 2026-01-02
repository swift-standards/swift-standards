//
//  Parsing.OneOf.Error.swift
//  swift-standards
//
//  Error type for OneOf alternative failures using parameter packs.
//

extension Parsing.OneOf {
    /// Error containing all failures from a OneOf alternative.
    ///
    /// Uses parameter packs to support unlimited arity while maintaining
    /// type safety and avoiding existentials (Swift Embedded compatible).
    ///
    /// ## Example
    ///
    /// ```swift
    /// // For OneOf<P0, P1, P2>:
    /// // Failure = OneOf.Errors<P0.Failure, P1.Failure, P2.Failure>
    /// ```
    public struct Errors<each E: Swift.Error & Sendable>: Swift.Error, Sendable {
        /// The failures from each alternative, in order.
        public let failures: (repeat each E)

        @inlinable
        public init(_ failures: repeat each E) {
            self.failures = (repeat each failures)
        }
    }
}

// MARK: - Convenience Aliases

extension Parsing.OneOf {
    /// Two-alternative error type alias.
    public typealias Error2<E0: Swift.Error & Sendable, E1: Swift.Error & Sendable> =
        Errors<E0, E1>

    /// Three-alternative error type alias.
    public typealias Error3<
        E0: Swift.Error & Sendable,
        E1: Swift.Error & Sendable,
        E2: Swift.Error & Sendable
    > = Errors<E0, E1, E2>
}

// MARK: - Equatable

extension Parsing.OneOf.Errors: Equatable
where repeat each E: Equatable {
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        func compare<T: Equatable>(_ l: T, _ r: T) -> Bool { l == r }
        var result = true
        repeat result = result && compare(each lhs.failures, each rhs.failures)
        return result
    }
}
