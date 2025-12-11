// Pair.swift
// The binary cartesian product type.

/// A pair of two values (binary cartesian product).
///
/// `Pair` represents the product `First × Second`, pairing two values together. Use it for classifier-value pairs (orientation + magnitude), coordinate pairs, or any typed two-tuple.
///
/// ## Example
///
/// ```swift
/// let point = Pair(3, 4)
/// print(point.first)   // 3
/// print(point.second)  // 4
///
/// let scaled = point.mapSecond { $0 * 2 }  // Pair(3, 8)
///
/// // Classifier-value pattern
/// let velocity: Pair<Vertical, Double> = Pair(.upward, 9.8)
/// ```
public struct Pair<First, Second> {
    /// First component.
    public var first: First

    /// Second component.
    public var second: Second

    /// Creates a pair from two values.
    @inlinable
    public init(_ first: First, _ second: Second) {
        self.first = first
        self.second = second
    }
}

// MARK: - Conditional Conformances

extension Pair: Sendable where First: Sendable, Second: Sendable {}
extension Pair: Equatable where First: Equatable, Second: Equatable {}
extension Pair: Hashable where First: Hashable, Second: Hashable {}
#if Codable
    extension Pair: Codable where First: Codable, Second: Codable {}
#endif

// MARK: - Functor

extension Pair {
    /// Transforms the second component while preserving the first.
    @inlinable
    public func map<NewSecond>(
        _ transform: (Second) throws -> NewSecond
    ) rethrows -> Pair<First, NewSecond> {
        Pair<First, NewSecond>(first, try transform(second))
    }

    /// Transforms the second component while preserving the first.
    @inlinable
    public func mapSecond<NewSecond>(
        _ transform: (Second) throws -> NewSecond
    ) rethrows -> Pair<First, NewSecond> {
        try map(transform)
    }

    /// Transforms the first component while preserving the second.
    @inlinable
    public func mapFirst<NewFirst>(
        _ transform: (First) throws -> NewFirst
    ) rethrows -> Pair<NewFirst, Second> {
        Pair<NewFirst, Second>(try transform(first), second)
    }

    /// Transforms both components.
    @inlinable
    public func bimap<NewFirst, NewSecond>(
        first firstTransform: (First) throws -> NewFirst,
        second secondTransform: (Second) throws -> NewSecond
    ) rethrows -> Pair<NewFirst, NewSecond> {
        Pair<NewFirst, NewSecond>(
            try firstTransform(first),
            try secondTransform(second)
        )
    }
}

// MARK: - Swap

extension Pair {
    /// Returns the pair with components swapped.
    @inlinable
    public var swapped: Pair<Second, First> {
        Pair<Second, First>(second, first)
    }
}

// MARK: - Tuple Conversion

extension Pair {
    /// Creates a pair from a tuple.
    @inlinable
    public init(_ tuple: (First, Second)) {
        self.first = tuple.0
        self.second = tuple.1
    }

    /// Returns the pair as a tuple.
    @inlinable
    public var tuple: (First, Second) {
        (first, second)
    }
}

// MARK: - Enumerable First Components

extension Pair where First: CaseIterable {
    /// All possible first components.
    @inlinable
    public static var allFirsts: First.AllCases {
        First.allCases
    }
}
