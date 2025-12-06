// Cardinal.swift
// Cardinal directions (compass points).

/// Cardinal direction (primary compass point).
///
/// The four principal compass directions.
///
/// ## Convention
///
/// In screen coordinates (y-down): north is up, east is right.
/// In mathematical coordinates (y-up): depends on convention.
///
/// ## Mathematical Properties
///
/// - Forms Z₄ group under 90° rotation
/// - `opposite` gives 180° rotation
///
/// ## Tagged Values
///
/// Use `Cardinal.Value<T>` to pair a distance with its direction:
///
/// ```swift
/// let travel: Cardinal.Value<Distance> = .init(tag: .north, value: 100)
/// ```
public enum Cardinal: Sendable, Hashable, Codable, CaseIterable {
    /// Upward / toward top.
    case north

    /// Rightward / toward east.
    case east

    /// Downward / toward bottom.
    case south

    /// Leftward / toward west.
    case west
}

// MARK: - Rotation

extension Cardinal {
    /// The next cardinal (90° clockwise).
    @inlinable
    public var clockwise: Cardinal {
        switch self {
        case .north: return .east
        case .east: return .south
        case .south: return .west
        case .west: return .north
        }
    }

    /// The previous cardinal (90° counterclockwise).
    @inlinable
    public var counterclockwise: Cardinal {
        switch self {
        case .north: return .west
        case .east: return .north
        case .south: return .east
        case .west: return .south
        }
    }

    /// The opposite cardinal (180° rotation).
    @inlinable
    public var opposite: Cardinal {
        switch self {
        case .north: return .south
        case .east: return .west
        case .south: return .north
        case .west: return .east
        }
    }

    /// Returns the opposite cardinal.
    @inlinable
    public static prefix func ! (value: Cardinal) -> Cardinal {
        value.opposite
    }
}

// MARK: - Axis

extension Cardinal {
    /// True if this is a horizontal direction (east/west).
    @inlinable
    public var isHorizontal: Bool {
        self == .east || self == .west
    }

    /// True if this is a vertical direction (north/south).
    @inlinable
    public var isVertical: Bool {
        self == .north || self == .south
    }
}

// MARK: - Tagged Value

public import Algebra

extension Cardinal {
    /// A value paired with its cardinal direction.
    public typealias Value<Payload> = Tagged<Cardinal, Payload>
}
