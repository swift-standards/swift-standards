// Parity.swift
public import Dimension

/// Classification of integers as even or odd.
///
/// Partitions integers into two equivalence classes under modulo 2. Forms a Z₂
/// group under addition (even + even = even, odd + odd = even). Use when tracking
/// divisibility by 2 or implementing parity-based algorithms.
///
/// ## Example
///
/// ```swift
/// let p = Parity(42)
/// print(p)                       // even
/// print(p.adding(.odd))          // odd
/// print(p.multiplying(.odd))     // even
/// ```
public enum Parity: Sendable, Hashable, Codable, CaseIterable {
    /// Divisible by 2 (remainder 0).
    case even

    /// Not divisible by 2 (remainder 1).
    case odd
}

// MARK: - Opposite

extension Parity {
    /// Opposite parity (even↔odd).
    @inlinable
    public var opposite: Parity {
        switch self {
        case .even: return .odd
        case .odd: return .even
        }
    }

    /// Returns the opposite parity.
    @inlinable
    public static prefix func ! (value: Parity) -> Parity {
        value.opposite
    }
}

// MARK: - Arithmetic Properties

extension Parity {
    /// Parity of adding two values with these parities (e+e=e, o+o=e, e+o=o).
    @inlinable
    public func adding(_ other: Parity) -> Parity {
        switch (self, other) {
        case (.even, .even), (.odd, .odd): return .even
        case (.even, .odd), (.odd, .even): return .odd
        }
    }

    /// Parity of multiplying two values with these parities (o×o=o, else e).
    @inlinable
    public func multiplying(_ other: Parity) -> Parity {
        switch (self, other) {
        case (.odd, .odd): return .odd
        default: return .even
        }
    }
}

// MARK: - Integer Detection

extension Parity {
    /// Determines the parity of an integer.
    @inlinable
    public init<T: BinaryInteger>(_ value: T) {
        self = value.isMultiple(of: 2) ? .even : .odd
    }
}

// MARK: - Tagged Value

extension Parity {
    /// A value paired with its parity.
    public typealias Value<Payload> = Pair<Parity, Payload>
}
