// Horizontal.swift
// Horizontal (X) axis orientation and oriented values.

/// X-axis orientation: rightward or leftward.
///
/// `Horizontal` specifies which direction along the X-axis is considered positive. Use it to express coordinate system conventions (rightward is standard) or to pair scalar values with explicit horizontal direction via `Horizontal.Value<T>`.
///
/// ## Example
///
/// ```swift
/// let system: Horizontal = .rightward  // Standard: X increases right
///
/// // Oriented value with direction
/// let offset = Horizontal.Value(.rightward, 10.0)
/// ```
public enum Horizontal: Sendable, Hashable, Codable {
    /// X-axis increases rightward (standard convention).
    case rightward

    /// X-axis increases leftward.
    case leftward
}

// MARK: - Orientation Conformance (Static Implementation)

extension Horizontal {
    /// Returns the opposite of a horizontal orientation.
    @inlinable
    public static func opposite(of orientation: Horizontal) -> Horizontal {
        switch orientation {
        case .rightward: return .leftward
        case .leftward: return .rightward
        }
    }
}

// MARK: - Orientation Conformance (Instance Convenience)

extension Horizontal: Orientation {
    /// Returns the canonical direction representation.
    @inlinable
    public var direction: Direction {
        switch self {
        case .rightward: return .positive
        case .leftward: return .negative
        }
    }

    /// Creates a horizontal orientation from a canonical direction.
    @inlinable
    public init(direction: Direction) {
        switch direction {
        case .positive: self = .rightward
        case .negative: self = .leftward
        }
    }

    /// Returns the opposite orientation.
    @inlinable
    public var opposite: Horizontal {
        Horizontal.opposite(of: self)
    }

    /// All horizontal orientations.
    public static let allCases: [Horizontal] = [.rightward, .leftward]
}

// MARK: - Pattern Matching Support

extension Horizontal {
    /// Whether orientation is rightward.
    @inlinable
    public var isRightward: Bool { self == .rightward }

    /// Whether orientation is leftward.
    @inlinable
    public var isLeftward: Bool { self == .leftward }
}

// MARK: - CustomStringConvertible

extension Horizontal: CustomStringConvertible {
    public var description: String {
        switch self {
        case .rightward: return "rightward"
        case .leftward: return "leftward"
        }
    }
}
