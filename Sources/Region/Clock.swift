// Clock.swift
// Twelve angular regions (30-degree sectors, like clock positions).

public import Algebra
public import Dimension

extension Region {
    /// Twelve angular sectors dividing a circle like clock positions.
    ///
    /// Clock represents twelve equal 30° sectors numbered like a clock face, starting at 12 o'clock at the top. Use it for fine-grained directional logic, analog time visualization, or 30° angular partitioning. Forms a cyclic group (Z₁₂) under rotation.
    ///
    /// ## Example
    ///
    /// ```swift
    ///         12
    ///      11  |  1
    ///   10     |     2
    ///  9 ------+------ 3
    ///   8      |     4
    ///      7   |  5
    ///          6
    ///
    /// let pos: Region.Clock = .three       // East (right)
    /// let next = pos.clockwise             // .four
    /// let opposite = !pos                  // .nine (West)
    /// let cardinal = pos.nearestCardinal   // .east
    /// ```
    public enum Clock: Int, Sendable, Hashable, Codable, CaseIterable {
        /// 12 o'clock (top, north).
        case twelve = 12

        /// 1 o'clock (upper right).
        case one = 1

        /// 2 o'clock (right of north).
        case two = 2

        /// 3 o'clock (right, east).
        case three = 3

        /// 4 o'clock (lower right of east).
        case four = 4

        /// 5 o'clock (right of south).
        case five = 5

        /// 6 o'clock (bottom, south).
        case six = 6

        /// 7 o'clock (lower left).
        case seven = 7

        /// 8 o'clock (left of south).
        case eight = 8

        /// 9 o'clock (left, west).
        case nine = 9

        /// 10 o'clock (upper left of west).
        case ten = 10

        /// 11 o'clock (left of north).
        case eleven = 11

        /// All clock positions in clockwise order starting from twelve.
        public static let allCases: [Clock] = [
            .twelve, .one, .two, .three, .four, .five,
            .six, .seven, .eight, .nine, .ten, .eleven,
        ]
    }
}

// MARK: - Rotation

extension Region.Clock {
    /// Next clock position (30° clockwise rotation).
    @inlinable
    public var clockwise: Region.Clock {
        let next = rawValue % 12 + 1
        return Region.Clock(rawValue: next == 0 ? 12 : next)!
    }

    /// Previous clock position (30° counterclockwise rotation).
    @inlinable
    public var counterclockwise: Region.Clock {
        let prev = rawValue - 1
        return Region.Clock(rawValue: prev == 0 ? 12 : prev)!
    }

    /// Opposite clock position (180° rotation).
    @inlinable
    public var opposite: Region.Clock {
        let opp = (rawValue + 5) % 12 + 1
        return Region.Clock(rawValue: opp == 0 ? 12 : opp)!
    }

    /// Returns the opposite clock position (180° rotation).
    @inlinable
    public static prefix func ! (value: Region.Clock) -> Region.Clock {
        value.opposite
    }

    /// Advances by `n` positions clockwise (or counterclockwise if negative).
    @inlinable
    public func advanced(by n: Int) -> Region.Clock {
        let result = ((rawValue - 1 + n) % 12 + 12) % 12 + 1
        return Region.Clock(rawValue: result == 0 ? 12 : result)!
    }
}

// MARK: - Quadrant

extension Region.Clock {
    /// Quadrant containing this clock position (screen coordinates, y-down).
    @inlinable
    public var quadrant: Region.Quadrant {
        switch self {
        case .twelve, .one, .two: return .I
        case .three, .four, .five: return .IV
        case .six, .seven, .eight: return .III
        case .nine, .ten, .eleven: return .II
        }
    }

    /// Cardinal direction closest to this clock position.
    @inlinable
    public var nearestCardinal: Region.Cardinal {
        switch self {
        case .twelve, .one, .eleven: return .north
        case .two, .three, .four: return .east
        case .five, .six, .seven: return .south
        case .eight, .nine, .ten: return .west
        }
    }
}

// MARK: - Properties

extension Region.Clock {
    /// Whether this is a cardinal position (12, 3, 6, or 9 o'clock).
    @inlinable
    public var isCardinal: Bool {
        switch self {
        case .twelve, .three, .six, .nine: return true
        default: return false
        }
    }

    /// Whether this is a non-cardinal position (all except 12, 3, 6, 9).
    @inlinable
    public var isOrdinal: Bool {
        switch self {
        case .one, .two, .four, .five, .seven, .eight, .ten, .eleven: return true
        default: return false
        }
    }

    /// Whether this position is in the upper half (10, 11, 12, 1, 2).
    @inlinable
    public var isUpperHalf: Bool {
        switch self {
        case .ten, .eleven, .twelve, .one, .two: return true
        default: return false
        }
    }

    /// Whether this position is in the right half (1, 2, 3, 4, 5).
    @inlinable
    public var isRightHalf: Bool {
        switch self {
        case .one, .two, .three, .four, .five: return true
        default: return false
        }
    }
}

// MARK: - Paired Value

extension Region.Clock {
    /// A value paired with its clock position.
    public typealias Value<Payload> = Pair<Region.Clock, Payload>
}
