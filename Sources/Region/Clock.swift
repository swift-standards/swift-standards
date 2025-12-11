// Clock.swift
// Twelve angular regions (30-degree sectors, like clock positions).

public import Algebra

extension Region {
    /// Clock position (30-degree angular sector).
    ///
    /// The twelve regions dividing a circle into equal 30° sectors,
    /// numbered like clock positions starting from 12 o'clock.
    ///
    /// ## Convention
    ///
    /// Uses clock notation where 12 is at the top (positive y-axis in screen
    /// coordinates, or the direction one would call "up").
    ///
    /// - twelve: 345° to 15° (centered on positive y in screen coords)
    /// - one: 15° to 45°
    /// - two: 45° to 75°
    /// - ...continuing clockwise...
    /// - eleven: 315° to 345°
    ///
    /// ## Mathematical Properties
    ///
    /// - Forms Z12 group under 30 degree rotation
    /// - Useful for compass directions, clock faces, and fine angular division
    /// - Each position spans 30°
    ///
    /// ## Tagged Values
    ///
    /// Use `Clock.Value<T>` to pair a value with its clock position:
    ///
    /// ```swift
    /// let direction: Region.Clock.Value<Velocity> = .init(.three, v)
    /// ```
    public enum Clock: Int, Sendable, Hashable, Codable, CaseIterable {
        /// 12 o'clock position (top center).
        case twelve = 12

        /// 1 o'clock position.
        case one = 1

        /// 2 o'clock position.
        case two = 2

        /// 3 o'clock position (right center).
        case three = 3

        /// 4 o'clock position.
        case four = 4

        /// 5 o'clock position.
        case five = 5

        /// 6 o'clock position (bottom center).
        case six = 6

        /// 7 o'clock position.
        case seven = 7

        /// 8 o'clock position.
        case eight = 8

        /// 9 o'clock position (left center).
        case nine = 9

        /// 10 o'clock position.
        case ten = 10

        /// 11 o'clock position.
        case eleven = 11

        /// All cases in clockwise order starting from twelve.
        public static let allCases: [Clock] = [
            .twelve, .one, .two, .three, .four, .five,
            .six, .seven, .eight, .nine, .ten, .eleven
        ]
    }
}

// MARK: - Rotation

extension Region.Clock {
    /// The next clock position (30 degrees clockwise).
    @inlinable
    public var clockwise: Region.Clock {
        let next = rawValue % 12 + 1
        return Region.Clock(rawValue: next == 0 ? 12 : next)!
    }

    /// The previous clock position (30 degrees counterclockwise).
    @inlinable
    public var counterclockwise: Region.Clock {
        let prev = rawValue - 1
        return Region.Clock(rawValue: prev == 0 ? 12 : prev)!
    }

    /// The opposite clock position (180 degree rotation).
    @inlinable
    public var opposite: Region.Clock {
        let opp = (rawValue + 5) % 12 + 1
        return Region.Clock(rawValue: opp == 0 ? 12 : opp)!
    }

    /// Returns the opposite clock position.
    @inlinable
    public static prefix func ! (value: Region.Clock) -> Region.Clock {
        value.opposite
    }

    /// Advance by n positions clockwise.
    @inlinable
    public func advanced(by n: Int) -> Region.Clock {
        let result = ((rawValue - 1 + n) % 12 + 12) % 12 + 1
        return Region.Clock(rawValue: result == 0 ? 12 : result)!
    }
}

// MARK: - Quadrant

extension Region.Clock {
    /// The quadrant containing this clock position.
    ///
    /// Note: Uses screen coordinates where y increases downward.
    @inlinable
    public var quadrant: Region.Quadrant {
        switch self {
        case .twelve, .one, .two: return .I
        case .three, .four, .five: return .IV
        case .six, .seven, .eight: return .III
        case .nine, .ten, .eleven: return .II
        }
    }

    /// The cardinal direction closest to this clock position.
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
    /// True if this is a cardinal position (12, 3, 6, or 9 o'clock).
    @inlinable
    public var isCardinal: Bool {
        switch self {
        case .twelve, .three, .six, .nine: return true
        default: return false
        }
    }

    /// True if this is an ordinal position (diagonal: 1:30, 4:30, 7:30, 10:30).
    @inlinable
    public var isOrdinal: Bool {
        switch self {
        case .one, .two, .four, .five, .seven, .eight, .ten, .eleven: return true
        default: return false
        }
    }

    /// True if this position is in the upper half (10, 11, 12, 1, 2).
    @inlinable
    public var isUpperHalf: Bool {
        switch self {
        case .ten, .eleven, .twelve, .one, .two: return true
        default: return false
        }
    }

    /// True if this position is in the right half (1, 2, 3, 4, 5).
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
