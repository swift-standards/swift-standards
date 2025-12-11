// Cross.swift
// Cross-axis namespace.

/// Namespace for cross-axis layout concepts.
///
/// The cross axis is perpendicular to a container's main axis. In a horizontal
/// stack, the cross axis is vertical; in a vertical stack, it's horizontal.
/// Use cross-axis alignment to control how items are positioned perpendicular
/// to the flow direction.
public enum Cross {}

// MARK: - Alignment

extension Cross {
    /// Alignment perpendicular to a stack's main axis.
    ///
    /// Controls how items align across the perpendicular dimension: in a horizontal
    /// stack (flowing left-to-right), this controls vertical alignment; in a vertical
    /// stack (flowing top-to-bottom), this controls horizontal alignment.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Horizontal stack with items aligned to top
    /// let hstack = Layout<Double>.Stack<[View]>.horizontal(
    ///     spacing: 8,
    ///     alignment: .leading,  // Top edge in horizontal layout
    ///     content: views
    /// )
    ///
    /// // Vertical stack with items aligned to left
    /// let vstack = Layout<Double>.Stack<[View]>.vertical(
    ///     spacing: 8,
    ///     alignment: .leading,  // Left edge in vertical layout
    ///     content: views
    /// )
    /// ```
    public enum Alignment: Sendable, Hashable, Codable, CaseIterable {
        /// Align to the start of the cross axis (top for horizontal, left for vertical)
        case leading

        /// Align to the center of the cross axis
        case center

        /// Align to the end of the cross axis (bottom for horizontal, right for vertical)
        case trailing

        /// Stretch to fill the entire cross axis
        case fill
    }
}
