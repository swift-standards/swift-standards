// Bound.swift
public import Dimension

/// Position of an interval endpoint: lower or upper.
///
/// Identifies which end of an interval or range a value represents. Forms a
/// Z₂ group under swap. Use when distinguishing minimum/maximum positions.
///
/// ## Example
///
/// ```swift
/// let limit: Bound = .lower
/// print(limit.opposite)     // upper
/// print(!limit)             // upper
/// ```
public enum Bound: Sendable, Hashable, CaseIterable {
    /// Lower bound (minimum, left endpoint).
    case lower

    /// Upper bound (maximum, right endpoint).
    case upper
}

// MARK: - Opposite

extension Bound {
    /// Opposite bound (lower↔upper).
    @inlinable
    public static func opposite(of bound: Bound) -> Bound {
        switch bound {
        case .lower: return .upper
        case .upper: return .lower
        }
    }

    /// Opposite bound (lower↔upper).
    @inlinable
    public var opposite: Bound {
        Bound.opposite(of: self)
    }

    /// Returns the opposite bound.
    @inlinable
    public static prefix func ! (value: Bound) -> Bound {
        value.opposite
    }
}

// MARK: - Aliases

extension Bound {
    /// Alias for lower bound.
    public static var min: Bound { .lower }

    /// Alias for upper bound.
    public static var max: Bound { .upper }

    /// Alias for lower (left endpoint).
    public static var left: Bound { .lower }

    /// Alias for upper (right endpoint).
    public static var right: Bound { .upper }
}

// MARK: - Tagged Value

extension Bound {
    /// A value paired with its bound position.
    public typealias Value<Payload> = Pair<Bound, Payload>
}

// MARK: - Codable

#if !hasFeature(Embedded)
    extension Bound: Codable {}
#endif
