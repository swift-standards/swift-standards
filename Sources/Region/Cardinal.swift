// Cardinal.swift
// Cardinal directions (compass points).

public import Algebra
public import Dimension

extension Region {
    /// Four primary compass directions with rotation operations.
    ///
    /// Cardinal represents the four principal compass points (north, east, south, west) as a discrete spatial type. Use it for directional movement, grid navigation, or any system requiring four-way orientation with 90° rotation semantics. Forms a cyclic group (Z₄) under rotation.
    ///
    /// ## Example
    ///
    /// ```swift
    /// var facing: Region.Cardinal = .north
    /// facing = facing.clockwise  // .east
    /// facing = facing.clockwise  // .south
    /// let behind = !facing  // .north (opposite of south)
    ///
    /// // Pair with distance
    /// let travel: Region.Cardinal.Value<Int> = .init(.west, 100)
    /// ```
    ///
    /// ## Note
    ///
    /// In screen coordinates (y-down): north is up, east is right.
    /// In mathematical coordinates (y-up): depends on convention.
    public enum Cardinal: Sendable, Hashable, Codable, CaseIterable {
        /// Upward (toward top in screen coordinates).
        case north

        /// Rightward (toward right side).
        case east

        /// Downward (toward bottom in screen coordinates).
        case south

        /// Leftward (toward left side).
        case west
    }
}

// MARK: - Rotation

extension Region.Cardinal {
    /// Next cardinal direction (90° clockwise rotation).
    @inlinable
    public var clockwise: Region.Cardinal {
        switch self {
        case .north: return .east
        case .east: return .south
        case .south: return .west
        case .west: return .north
        }
    }

    /// Previous cardinal direction (90° counterclockwise rotation).
    @inlinable
    public var counterclockwise: Region.Cardinal {
        switch self {
        case .north: return .west
        case .east: return .north
        case .south: return .east
        case .west: return .south
        }
    }

    /// Opposite cardinal direction (180° rotation).
    @inlinable
    public var opposite: Region.Cardinal {
        switch self {
        case .north: return .south
        case .east: return .west
        case .south: return .north
        case .west: return .east
        }
    }

    /// Returns the opposite cardinal direction.
    @inlinable
    public static prefix func ! (value: Region.Cardinal) -> Region.Cardinal {
        value.opposite
    }
}

// MARK: - Axis

extension Region.Cardinal {
    /// Whether this is a horizontal direction (east or west).
    @inlinable
    public var isHorizontal: Bool {
        self == .east || self == .west
    }

    /// Whether this is a vertical direction (north or south).
    @inlinable
    public var isVertical: Bool {
        self == .north || self == .south
    }
}

// MARK: - Paired Value

extension Region.Cardinal {
    /// A value paired with its cardinal direction.
    public typealias Value<Payload> = Pair<Region.Cardinal, Payload>
}
