// Quadrant.swift
// Cartesian plane quadrants.

public import Algebra
public import Dimension

extension Region {
    /// Four regions of the 2D Cartesian plane separated by coordinate axes.
    ///
    /// Quadrant divides the plane into four regions defined by axis signs, numbered counterclockwise from the upper-right in standard mathematical convention. Use it for spatial partitioning, sign analysis, or coordinate-based logic. Forms a cyclic group (Z₄) under 90° rotation.
    ///
    /// ## Example
    ///
    /// ```swift
    /// //      II (+y) | I
    /// //    -----------+----------- (+x)
    /// //     III       | IV (-y)
    ///
    /// let q: Region.Quadrant = .I        // x > 0, y > 0
    /// let rotated = q.next               // .II (90° CCW)
    /// let opposite = !q                  // .III (180°)
    ///
    /// // Check axis signs
    /// q.hasPositiveX  // true
    /// q.hasPositiveY  // true
    /// ```
    public enum Quadrant: Int, Sendable, Hashable, Codable, CaseIterable {
        /// First quadrant (x > 0, y > 0, upper right).
        case I = 1

        /// Second quadrant (x < 0, y > 0, upper left).
        case II = 2

        /// Third quadrant (x < 0, y < 0, lower left).
        case III = 3

        /// Fourth quadrant (x > 0, y < 0, lower right).
        case IV = 4
    }
}

// MARK: - Rotation

extension Region.Quadrant {
    /// Next quadrant (90° counterclockwise rotation).
    @inlinable
    public var next: Region.Quadrant {
        Region.Quadrant(rawValue: (rawValue % 4) + 1)!
    }

    /// Previous quadrant (90° clockwise rotation).
    @inlinable
    public var previous: Region.Quadrant {
        Region.Quadrant(rawValue: ((rawValue + 2) % 4) + 1)!
    }

    /// Opposite quadrant (180° rotation).
    @inlinable
    public var opposite: Region.Quadrant {
        Region.Quadrant(rawValue: ((rawValue + 1) % 4) + 1)!
    }

    /// Returns the opposite quadrant (180° rotation).
    @inlinable
    public static prefix func ! (value: Region.Quadrant) -> Region.Quadrant {
        value.opposite
    }
}

// MARK: - Sign Properties

extension Region.Quadrant {
    /// Whether x is positive in this quadrant.
    @inlinable
    public var hasPositiveX: Bool {
        self == .I || self == .IV
    }

    /// Whether y is positive in this quadrant.
    @inlinable
    public var hasPositiveY: Bool {
        self == .I || self == .II
    }
}

// MARK: - Paired Value

extension Region.Quadrant {
    /// A value paired with its quadrant.
    public typealias Value<Payload> = Pair<Region.Quadrant, Payload>
}
