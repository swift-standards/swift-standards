// Ternary.swift
public import Dimension

/// Balanced ternary digit: -1, 0, or +1.
///
/// Used in balanced ternary numeral systems where digits are -1, 0, +1 (also
/// known as a "trit"). More symmetric than binary with simple negation and no
/// separate sign bit. Use for balanced ternary arithmetic or three-state logic.
///
/// ## Example
///
/// ```swift
/// let t: Ternary = .positive
/// print(t.intValue)              // 1
/// print(t.negated)               // negative
/// print(t.multiplying(.negative)) // negative
/// ```
public enum Ternary: Int, Sendable, Hashable, CaseIterable {
    /// Negative one (-1).
    case negative = -1

    /// Zero (0).
    case zero = 0

    /// Positive one (+1).
    case positive = 1
}

// MARK: - Negation

extension Ternary {
    /// Negated ternary value (swaps positive↔negative, preserves zero).
    @inlinable
    public static func negated(_ ternary: Ternary) -> Ternary {
        switch ternary {
        case .negative: return .positive
        case .zero: return .zero
        case .positive: return .negative
        }
    }

    /// Negated ternary value (swaps positive↔negative, preserves zero).
    @inlinable
    public var negated: Ternary {
        Ternary.negated(self)
    }

    /// Returns the negated value.
    @inlinable
    public static prefix func - (value: Ternary) -> Ternary {
        value.negated
    }
}

// MARK: - Arithmetic

extension Ternary {
    /// Integer value (-1, 0, or +1).
    @inlinable
    public var intValue: Int { rawValue }

    /// Multiplies two ternary values (standard integer multiplication).
    @inlinable
    public static func multiplying(_ lhs: Ternary, _ rhs: Ternary) -> Ternary {
        Ternary(rawValue: lhs.rawValue * rhs.rawValue) ?? .zero
    }

    /// Multiplies two ternary values (standard integer multiplication).
    @inlinable
    public func multiplying(_ other: Ternary) -> Ternary {
        Ternary.multiplying(self, other)
    }
}

// MARK: - From Sign

extension Ternary {
    /// Creates a ternary value from a sign.
    @inlinable
    public init(_ sign: Sign) {
        switch sign {
        case .positive: self = .positive
        case .negative: self = .negative
        case .zero: self = .zero
        }
    }
}

// MARK: - Tagged Value

extension Ternary {
    /// A value paired with a ternary digit.
    public typealias Value<Payload> = Pair<Ternary, Payload>
}

// MARK: - Codable

#if !hasFeature(Embedded)
    extension Ternary: Codable {}
#endif
