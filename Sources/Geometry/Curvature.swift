// Curvature.swift
// Curve bending direction.

public import Algebra

/// Direction a curve bends: convex or concave.
///
/// Use this to describe which way a curve bends relative to a reference direction.
/// Forms a Z₂ group under reflection (opposite direction).
///
/// ## Example
///
/// ```swift
/// let direction: Curvature = .convex
/// let opposite = !direction  // .concave
/// ```
public enum Curvature: Sendable, Hashable, Codable, CaseIterable {
    /// Curves outward, like the outside of a circle.
    case convex

    /// Curves inward, like the inside of a bowl.
    case concave
}

// MARK: - Opposite

extension Curvature {
    /// Opposite curvature direction.
    @inlinable
    public var opposite: Curvature {
        switch self {
        case .convex: return .concave
        case .concave: return .convex
        }
    }

    /// Returns opposite curvature direction.
    @inlinable
    public static prefix func ! (value: Curvature) -> Curvature {
        value.opposite
    }
}

// MARK: - Paired Value

extension Curvature {
    /// Value paired with its curvature direction.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let curve: Curvature.Value<Double> = .init(.convex, 0.5)
    /// ```
    public typealias Value<Payload> = Pair<Curvature, Payload>
}
