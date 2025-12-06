// Horizontal.swift
// Horizontal (X) axis orientation convention.

/// Horizontal (X) axis orientation convention.
///
/// Determines how "leading" and "trailing" map to x-coordinates:
/// - `.rightward`: X increases rightward (standard convention)
/// - `.leftward`: X increases leftward
///
/// This is a coordinate system convention, independent of dimension count.
/// Like `Direction`, this type exists at the module level since it describes
/// a general orientation choice, not a property of a specific axis.
///
/// ## Usage
///
/// ```swift
/// let orientation: Horizontal = .rightward
///
/// // Also accessible via Axis<N>.Horizontal (where N >= 2):
/// let xOrientation: Axis<2>.Horizontal = .rightward
/// ```
public enum Horizontal: Sendable, Hashable, Codable, CaseIterable {
    /// X axis increases rightward (standard convention).
    case rightward

    /// X axis increases leftward.
    case leftward
}

extension Horizontal {
    /// The opposite orientation.
    @inlinable
    public var opposite: Horizontal {
        switch self {
        case .rightward: return .leftward
        case .leftward: return .rightward
        }
    }
}
