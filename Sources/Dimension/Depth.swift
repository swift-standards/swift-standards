// Depth.swift
// Depth (Z) axis orientation convention.

/// Depth (Z) axis orientation convention.
///
/// Determines how "near" and "far" map to z-coordinates:
/// - `.forward`: Z increases away from viewer (into the screen)
/// - `.backward`: Z increases toward viewer (out of the screen)
///
/// This is a coordinate system convention for 3D+ spaces.
/// Like `Direction`, this type exists at the module level since it describes
/// a general orientation choice, not a property of a specific axis.
///
/// ## Mathematical Background
///
/// In right-handed coordinate systems (OpenGL, mathematics), Z typically
/// points toward the viewer. In left-handed systems (DirectX, Metal), Z
/// points away. This affects depth buffer interpretation and culling.
///
/// ## Usage
///
/// ```swift
/// let orientation: Depth = .forward
///
/// // Also accessible via Axis<N>.Depth (where N >= 3):
/// let zOrientation: Axis<3>.Depth = .forward
/// ```
public enum Depth: Sendable, Hashable, Codable, CaseIterable {
    /// Z axis increases away from viewer (into the screen).
    ///
    /// Common in left-handed coordinate systems (DirectX, Metal).
    case forward

    /// Z axis increases toward viewer (out of the screen).
    ///
    /// Common in right-handed coordinate systems (OpenGL, mathematics).
    case backward
}

extension Depth {
    /// The opposite orientation.
    @inlinable
    public var opposite: Depth {
        switch self {
        case .forward: return .backward
        case .backward: return .forward
        }
    }

    /// Returns the opposite orientation.
    ///
    /// - `!.forward == .backward`
    /// - `!.backward == .forward`
    @inlinable
    public static prefix func ! (value: Self) -> Self {
        value.opposite
    }
}
