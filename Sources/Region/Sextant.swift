// Sextant.swift
// Six angular regions (60-degree sectors).

public import Algebra
public import Dimension

extension Region {
    /// Six angular sectors dividing a circle into 60° slices.
    ///
    /// Sextant represents six equal 60° sectors of a circle, numbered counterclockwise from the positive x-axis. Use it for hexagonal grid logic, triangular tessellations, or 60° angular partitioning. Forms a cyclic group (Z₆) under rotation.
    ///
    /// ## Example
    ///
    /// ```swift
    ///       III    II
    ///         \  /
    ///    IV----+----I   (I starts at 0°, positive x-axis)
    ///         /  \
    ///        V    VI
    ///
    /// let sect: Region.Sextant = .I    // 0° to 60°
    /// let next = sect.next             // .II (60° CCW)
    /// let opposite = !sect             // .IV (180°)
    /// let quad = sect.quadrant         // .I
    /// ```
    public enum Sextant: Int, Sendable, Hashable, Codable, CaseIterable {
        /// First sextant (0° to 60°, positive x-axis).
        case I = 1

        /// Second sextant (60° to 120°).
        case II = 2

        /// Third sextant (120° to 180°, positive y-axis).
        case III = 3

        /// Fourth sextant (180° to 240°, negative x-axis).
        case IV = 4

        /// Fifth sextant (240° to 300°).
        case V = 5

        /// Sixth sextant (300° to 360°, negative y-axis).
        case VI = 6
    }
}

// MARK: - Rotation

extension Region.Sextant {
    /// Next sextant (60° counterclockwise rotation).
    @inlinable
    public var next: Region.Sextant {
        Region.Sextant(rawValue: (rawValue % 6) + 1)!
    }

    /// Previous sextant (60° clockwise rotation).
    @inlinable
    public var previous: Region.Sextant {
        Region.Sextant(rawValue: ((rawValue + 4) % 6) + 1)!
    }

    /// Opposite sextant (180° rotation).
    @inlinable
    public var opposite: Region.Sextant {
        Region.Sextant(rawValue: ((rawValue + 2) % 6) + 1)!
    }

    /// Returns the opposite sextant (180° rotation).
    @inlinable
    public static prefix func ! (value: Region.Sextant) -> Region.Sextant {
        value.opposite
    }
}

// MARK: - Quadrant

extension Region.Sextant {
    /// Quadrant containing this sextant.
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
    /// Whether the sextant is in the upper half-plane (y > 0).
    @inlinable
    public var isUpperHalf: Bool {
        switch self {
        case .I, .II, .III: return true
        case .IV, .V, .VI: return false
        }
    }

    /// Whether the sextant is in the right half-plane (x > 0).
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
