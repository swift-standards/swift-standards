// Vertical.swift
// Vertical (Y) axis orientation convention.

/// Vertical (Y) axis orientation convention.
///
/// Determines how "top" and "bottom" map to y-coordinates:
/// - `.upward`: Y increases upward (standard Cartesian, PDF)
/// - `.downward`: Y increases downward (screen coordinates, CSS/HTML)
///
/// This is a coordinate system convention, independent of dimension count.
/// Like `Direction`, this type exists at the module level since it describes
/// a general orientation choice, not a property of a specific axis.
///
/// ## Mathematical Background
///
/// In the standard Cartesian coordinate system, the y-axis points upward.
/// Many screen-based systems invert this, with y increasing downward.
/// This affects how directional terms ("top", "bottom") map to coordinates.
///
/// ## Usage
///
/// ```swift
/// let orientation: Vertical = .upward
///
/// // Also accessible via Axis<N>.Vertical (where N >= 2):
/// let yOrientation: Axis<2>.Vertical = .downward
/// ```
public enum Vertical: Sendable, Hashable, Codable, CaseIterable {
    /// Y axis increases upward (standard Cartesian convention).
    ///
    /// In this system:
    /// - Lower y values are at the bottom visually
    /// - `lly` corresponds to the bottom edge
    /// - `ury` corresponds to the top edge
    /// - "Top inset" shrinks from `ury`
    case upward

    /// Y axis increases downward (screen coordinate convention).
    ///
    /// In this system:
    /// - Lower y values are at the top visually
    /// - `lly` corresponds to the top edge
    /// - `ury` corresponds to the bottom edge
    /// - "Top inset" shrinks from `lly`
    case downward
}

extension Vertical {
    /// The opposite orientation.
    @inlinable
    public var opposite: Vertical {
        switch self {
        case .upward: return .downward
        case .downward: return .upward
        }
    }

    /// Returns the opposite orientation.
    ///
    /// - `!.upward == .downward`
    /// - `!.downward == .upward`
    @inlinable
    public static prefix func ! (value: Self) -> Self {
        value.opposite
    }
}
