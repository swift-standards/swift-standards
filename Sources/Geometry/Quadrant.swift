// Quadrant.swift
// Cartesian plane quadrants.

/// Quadrant of the Cartesian plane.
///
/// The four regions defined by the x and y axes, numbered counterclockwise
/// starting from the positive x, positive y region.
///
/// ## Convention
///
/// - I: x > 0, y > 0 (upper right)
/// - II: x < 0, y > 0 (upper left)
/// - III: x < 0, y < 0 (lower left)
/// - IV: x > 0, y < 0 (lower right)
///
/// ## Mathematical Properties
///
/// - Forms Z₄ group under 90° rotation
/// - Reflection swaps horizontally (I↔II, III↔IV) or vertically (I↔IV, II↔III)
///
/// ## Tagged Values
///
/// Use `Quadrant.Value<T>` to pair a point with its quadrant:
///
/// ```swift
/// let point: Quadrant.Value<Point> = .init(tag: .I, value: p)
/// ```
public enum Quadrant: Int, Sendable, Hashable, Codable, CaseIterable {
    /// First quadrant: x > 0, y > 0.
    case I = 1

    /// Second quadrant: x < 0, y > 0.
    case II = 2

    /// Third quadrant: x < 0, y < 0.
    case III = 3

    /// Fourth quadrant: x > 0, y < 0.
    case IV = 4
}

// MARK: - Rotation

extension Quadrant {
    /// The next quadrant (90° counterclockwise).
    @inlinable
    public var next: Quadrant {
        Quadrant(rawValue: (rawValue % 4) + 1)!
    }

    /// The previous quadrant (90° clockwise).
    @inlinable
    public var previous: Quadrant {
        Quadrant(rawValue: ((rawValue + 2) % 4) + 1)!
    }

    /// The opposite quadrant (180° rotation).
    @inlinable
    public var opposite: Quadrant {
        Quadrant(rawValue: ((rawValue + 1) % 4) + 1)!
    }

    /// Returns the opposite quadrant.
    @inlinable
    public static prefix func ! (value: Quadrant) -> Quadrant {
        value.opposite
    }
}

// MARK: - Sign Properties

extension Quadrant {
    /// True if x is positive in this quadrant.
    @inlinable
    public var hasPositiveX: Bool {
        self == .I || self == .IV
    }

    /// True if y is positive in this quadrant.
    @inlinable
    public var hasPositiveY: Bool {
        self == .I || self == .II
    }
}

// MARK: - Tagged Value

public import Algebra

extension Quadrant {
    /// A value paired with its quadrant.
    public typealias Value<Payload> = Tagged<Quadrant, Payload>
}
