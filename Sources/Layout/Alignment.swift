// Alignment.swift
// Combined horizontal and vertical alignment.

public import Dimension

/// A combined horizontal and vertical alignment for positioning content.
///
/// Combines horizontal (leading/center/trailing) and vertical (top/center/bottom)
/// alignment into a single value. Use this for grid cell alignment, overlay positioning,
/// or any scenario requiring precise 2D content placement.
///
/// ## Example
///
/// ```swift
/// // Position a badge at the top-trailing corner
/// let badge = Alignment(horizontal: .trailing, vertical: .top)
/// // Equivalent to: Alignment.topTrailing
///
/// // Center an image in its container
/// let centered = Alignment.center
/// ```
public struct Alignment: Sendable, Hashable, Codable {
    /// Horizontal alignment component
    public var horizontal: Horizontal.Alignment

    /// Vertical alignment component
    public var vertical: Vertical.Alignment

    /// Creates an alignment from horizontal and vertical components.
    @inlinable
    public init(horizontal: Horizontal.Alignment, vertical: Vertical.Alignment) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
}

// MARK: - Presets

extension Alignment {
    /// Top-leading corner (top-left in LTR, top-right in RTL)
    public static let topLeading = Self(horizontal: .leading, vertical: .top)

    /// Top center edge
    public static let top = Self(horizontal: .center, vertical: .top)

    /// Top-trailing corner (top-right in LTR, top-left in RTL)
    public static let topTrailing = Self(horizontal: .trailing, vertical: .top)

    /// Center-leading edge (left edge in LTR, right edge in RTL)
    public static let leading = Self(horizontal: .leading, vertical: .center)

    /// Exact center point
    public static let center = Self(horizontal: .center, vertical: .center)

    /// Center-trailing edge (right edge in LTR, left edge in RTL)
    public static let trailing = Self(horizontal: .trailing, vertical: .center)

    /// Bottom-leading corner (bottom-left in LTR, bottom-right in RTL)
    public static let bottomLeading = Self(horizontal: .leading, vertical: .bottom)

    /// Bottom center edge
    public static let bottom = Self(horizontal: .center, vertical: .bottom)

    /// Bottom-trailing corner (bottom-right in LTR, bottom-left in RTL)
    public static let bottomTrailing = Self(horizontal: .trailing, vertical: .bottom)
}
