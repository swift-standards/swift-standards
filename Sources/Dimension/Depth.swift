// Depth.swift
// Depth (Z) axis orientation and oriented values.

/// Z-axis orientation: forward or backward.
///
/// `Depth` specifies which direction along the Z-axis is considered positive. Forward is left-handed (DirectX, Metal) with Z into the screen, while backward is right-handed (OpenGL, math) with Z out of the screen.
///
/// ## Example
///
/// ```swift
/// let leftHanded: Depth = .forward    // DirectX, Metal: Z into screen
/// let rightHanded: Depth = .backward  // OpenGL, math: Z out of screen
///
/// // Oriented value with direction
/// let offset = Depth.Value(.forward, 10.0)
/// ```
public enum Depth: Sendable, Hashable, Codable {
    /// Z-axis increases away from viewer (left-handed systems).
    case forward

    /// Z-axis increases toward viewer (right-handed systems).
    case backward
}

// MARK: - Orientation Conformance (Static Implementation)

extension Depth {
    /// Returns the opposite of a depth orientation.
    @inlinable
    public static func opposite(of orientation: Depth) -> Depth {
        switch orientation {
        case .forward: return .backward
        case .backward: return .forward
        }
    }
}

// MARK: - Orientation Conformance (Instance Convenience)

extension Depth: Orientation {
    /// Returns the canonical direction representation.
    @inlinable
    public var direction: Direction {
        switch self {
        case .forward: return .positive
        case .backward: return .negative
        }
    }

    /// Creates a depth orientation from a canonical direction.
    @inlinable
    public init(direction: Direction) {
        switch direction {
        case .positive: self = .forward
        case .negative: self = .backward
        }
    }

    /// Returns the opposite orientation.
    @inlinable
    public var opposite: Depth {
        Depth.opposite(of: self)
    }

    /// All depth orientations.
    public static let allCases: [Depth] = [.forward, .backward]
}

// MARK: - Pattern Matching Support

extension Depth {
    /// Whether orientation is forward.
    @inlinable
    public var isForward: Bool { self == .forward }

    /// Whether orientation is backward.
    @inlinable
    public var isBackward: Bool { self == .backward }
}

// MARK: - CustomStringConvertible

extension Depth: CustomStringConvertible {
    public var description: String {
        switch self {
        case .forward: return "forward"
        case .backward: return "backward"
        }
    }
}
