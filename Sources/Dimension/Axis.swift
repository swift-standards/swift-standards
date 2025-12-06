// Axis.swift
// A coordinate axis in N-dimensional space.

/// A coordinate axis in N-dimensional space.
///
/// An axis identifies a dimension of a coordinate system, independent of
/// its orientation or direction. This separation allows layout logic to
/// operate generically while geometry handles directional conventions
/// separately through `Axis.Vertical` and `Axis.Horizontal`.
///
/// ## Mathematical Background
///
/// In linear algebra, an axis is simply a basis vector direction in a
/// coordinate system. The "primary" axis is typically horizontal (X),
/// "secondary" is vertical (Y), and "tertiary" is depth (Z).
///
/// ## Structure
///
/// - `Axis`: The axis identity (`.primary`, `.secondary`, `.tertiary`)
/// - `Axis.Direction`: Direction along any axis (`.positive`, `.negative`)
/// - `Axis.Vertical`: Y-axis orientation convention (`.upward`, `.downward`)
/// - `Axis.Horizontal`: X-axis orientation convention (`.rightward`, `.leftward`)
///
/// ## Usage
///
/// ```swift
/// let stack = Layout<Double>.Stack(axis: .secondary, spacing: 10, ...)
/// let perpendicular = Axis.primary.perpendicular  // .secondary
/// ```
public enum Axis: Int, Sendable, Hashable, Codable, CaseIterable {
    /// The first axis (traditionally X, horizontal).
    case primary = 0

    /// The second axis (traditionally Y, vertical).
    case secondary = 1

    /// The third axis (traditionally Z, depth).
    case tertiary = 2
}

// MARK: - Perpendicular

extension Axis {
    /// The axis perpendicular to this one in 2D.
    ///
    /// - `.primary.perpendicular` returns `.secondary`
    /// - `.secondary.perpendicular` returns `.primary`
    /// - `.tertiary.perpendicular` returns `.primary` (undefined in 2D)
    @inlinable
    public var perpendicular: Axis {
        switch self {
        case .primary: return .secondary
        case .secondary: return .primary
        case .tertiary: return .primary
        }
    }
}
