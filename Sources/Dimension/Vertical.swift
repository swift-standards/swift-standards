// Vertical.swift
// Vertical (Y) axis orientation and oriented values.

/// Y-axis orientation: upward or downward.
///
/// `Vertical` specifies which direction along the Y-axis is considered positive. Upward is standard Cartesian (math, PDF), while downward is common for screen coordinates (CSS, many graphics APIs).
///
/// ## Example
///
/// ```swift
/// let cartesian: Vertical = .upward    // Math: Y increases up
/// let screen: Vertical = .downward     // CSS: Y increases down
///
/// // Oriented value with direction
/// let offset = Vertical.Value(.upward, 10.0)
/// ```
public enum Vertical: Sendable, Hashable, Codable {
    /// Y-axis increases upward (standard Cartesian, PDF).
    case upward

    /// Y-axis increases downward (screen coordinates, CSS).
    case downward
}

// MARK: - Orientation Conformance

extension Vertical: Orientation {
    /// Returns the canonical direction representation.
    @inlinable
    public var direction: Direction {
        switch self {
        case .upward: return .positive
        case .downward: return .negative
        }
    }

    /// Creates a vertical orientation from a canonical direction.
    @inlinable
    public init(direction: Direction) {
        switch direction {
        case .positive: self = .upward
        case .negative: self = .downward
        }
    }

    /// Returns the opposite orientation.
    @inlinable
    public var opposite: Vertical {
        switch self {
        case .upward: return .downward
        case .downward: return .upward
        }
    }

    /// All vertical orientations.
    public static let allCases: [Vertical] = [.upward, .downward]
}

// MARK: - Pattern Matching Support

extension Vertical {
    /// Whether orientation is upward.
    @inlinable
    public var isUpward: Bool { self == .upward }

    /// Whether orientation is downward.
    @inlinable
    public var isDownward: Bool { self == .downward }
}

// MARK: - CustomStringConvertible

extension Vertical: CustomStringConvertible {
    public var description: String {
        switch self {
        case .upward: return "upward"
        case .downward: return "downward"
        }
    }
}
