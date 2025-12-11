// Comparison.swift
public import Dimension

/// Result of three-way comparison: less, equal, or greater.
///
/// Represents the outcome of comparing two ordered values. Corresponds to the
/// signum of (a - b). Use when you need to capture all three ordering outcomes
/// in a single value, such as implementing custom comparison logic.
///
/// ## Example
///
/// ```swift
/// let result = Comparison(5, 10)
/// print(result)              // less
/// print(result.reversed)     // greater
/// print(result.isLess)       // true
/// ```
public enum Comparison: Sendable, Hashable, Codable, CaseIterable {
    /// First value is less than second.
    case less

    /// Values are equal.
    case equal

    /// First value is greater than second.
    case greater
}

// MARK: - Reversal

extension Comparison {
    /// Reversed comparison (swaps less↔greater, preserves equal).
    @inlinable
    public var reversed: Comparison {
        switch self {
        case .less: return .greater
        case .equal: return .equal
        case .greater: return .less
        }
    }

    /// Returns the reversed comparison.
    @inlinable
    public static prefix func ! (value: Comparison) -> Comparison {
        value.reversed
    }
}

// MARK: - From Comparable

extension Comparison {
    /// Creates a comparison from two comparable values.
    @inlinable
    public init<T: Comparable>(_ lhs: T, _ rhs: T) {
        if lhs < rhs {
            self = .less
        } else if lhs > rhs {
            self = .greater
        } else {
            self = .equal
        }
    }
}

// MARK: - Boolean Properties

extension Comparison {
    /// Whether the comparison is `.less`.
    @inlinable
    public var isLess: Bool { self == .less }

    /// Whether the comparison is `.equal`.
    @inlinable
    public var isEqual: Bool { self == .equal }

    /// Whether the comparison is `.greater`.
    @inlinable
    public var isGreater: Bool { self == .greater }

    /// Whether the comparison is `.less` or `.equal`.
    @inlinable
    public var isLessOrEqual: Bool { self != .greater }

    /// Whether the comparison is `.greater` or `.equal`.
    @inlinable
    public var isGreaterOrEqual: Bool { self != .less }
}

// MARK: - Tagged Value

extension Comparison {
    /// A value paired with a comparison result.
    public typealias Value<Payload> = Pair<Comparison, Payload>
}
