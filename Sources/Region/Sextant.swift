// Sextant.swift
// Six angular regions (60-degree sectors).

public import Algebra

extension Region {
    /// Sextant of the plane (60-degree angular sector).
    ///
    /// The six regions dividing a circle into equal 60° sectors, starting
    /// from the positive x-axis and proceeding counterclockwise.
    ///
    /// ## Convention
    ///
    /// - I: 0° to 60° (including positive x-axis)
    /// - II: 60° to 120°
    /// - III: 120° to 180° (including negative x-axis upper half)
    /// - IV: 180° to 240°
    /// - V: 240° to 300°
    /// - VI: 300° to 360°
    ///
    /// ## Mathematical Properties
    ///
    /// - Forms Z6 group under 60 degree rotation
    /// - Useful for hexagonal grids and triangular tessellations
    /// - Each sextant corresponds to one "slice" of a regular hexagon
    ///
    /// ## Tagged Values
    ///
    /// Use `Sextant.Value<T>` to pair a point with its sextant:
    ///
    /// ```swift
    /// let point: Region.Sextant.Value<Point> = .init(.I, p)
    /// ```
    public enum Sextant: Int, Sendable, Hashable, Codable, CaseIterable {
        /// First sextant: 0° to 60°.
        case I = 1

        /// Second sextant: 60° to 120°.
        case II = 2

        /// Third sextant: 120° to 180°.
        case III = 3

        /// Fourth sextant: 180° to 240°.
        case IV = 4

        /// Fifth sextant: 240° to 300°.
        case V = 5

        /// Sixth sextant: 300° to 360°.
        case VI = 6
    }
}

// MARK: - Rotation

extension Region.Sextant {
    /// The next sextant (60 degrees counterclockwise).
    @inlinable
    public var next: Region.Sextant {
        Region.Sextant(rawValue: (rawValue % 6) + 1)!
    }

    /// The previous sextant (60 degrees clockwise).
    @inlinable
    public var previous: Region.Sextant {
        Region.Sextant(rawValue: ((rawValue + 4) % 6) + 1)!
    }

    /// The opposite sextant (180 degree rotation).
    @inlinable
    public var opposite: Region.Sextant {
        Region.Sextant(rawValue: ((rawValue + 2) % 6) + 1)!
    }

    /// Returns the opposite sextant.
    @inlinable
    public static prefix func ! (value: Region.Sextant) -> Region.Sextant {
        value.opposite
    }
}

// MARK: - Quadrant

extension Region.Sextant {
    /// The quadrant containing this sextant.
    @inlinable
    public var quadrant: Region.Quadrant {
        switch self {
        case .I: return .I
        case .II: return .I
        case .III: return .II
        case .IV: return .III
        case .V: return .IV
        case .VI: return .IV
        }
    }
}

// MARK: - Sign Properties

extension Region.Sextant {
    /// True if the sextant is in the upper half-plane (y > 0).
    @inlinable
    public var isUpperHalf: Bool {
        switch self {
        case .I, .II, .III: return true
        case .IV, .V, .VI: return false
        }
    }

    /// True if the sextant is in the right half-plane (x > 0).
    @inlinable
    public var isRightHalf: Bool {
        switch self {
        case .I, .II, .VI: return true
        case .III, .IV, .V: return false
        }
    }
}

// MARK: - Paired Value

extension Region.Sextant {
    /// A value paired with its sextant.
    public typealias Value<Payload> = Pair<Region.Sextant, Payload>
}
