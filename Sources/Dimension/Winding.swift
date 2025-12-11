// Winding.swift
// Rotational direction around an axis.

/// Rotational winding direction: clockwise or counterclockwise.
///
/// `Winding` specifies the direction of rotation around an axis. Use it for polygon vertex ordering, angular velocities, or any clockwise/counterclockwise distinction.
///
/// ## Example
///
/// ```swift
/// let rotation: Winding = .counterclockwise  // Positive angular direction
/// let reversed = !rotation                   // .clockwise
/// let angle: Winding.Value<Double> = Pair(.ccw, 45.0)
/// ```
public enum Winding: Sendable, Hashable, Codable, CaseIterable {
    /// Rotation in the direction of clock hands.
    case clockwise

    /// Rotation opposite to clock hands.
    case counterclockwise
}

// MARK: - Opposite

extension Winding {
    /// Returns the opposite winding direction.
    @inlinable
    public var opposite: Winding {
        switch self {
        case .clockwise: return .counterclockwise
        case .counterclockwise: return .clockwise
        }
    }

    /// Returns the opposite winding direction (prefix negation).
    @inlinable
    public static prefix func ! (value: Winding) -> Winding {
        value.opposite
    }
}

// MARK: - Aliases

extension Winding {
    /// Clockwise (CW) abbreviation.
    public static var cw: Winding { .clockwise }

    /// Counterclockwise (CCW) abbreviation.
    public static var ccw: Winding { .counterclockwise }
}

// MARK: - Paired Value

extension Winding {
    /// Value paired with winding direction.
    public typealias Value<Payload> = Pair<Winding, Payload>
}
