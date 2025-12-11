// Horizontal.swift
// Horizontal axis namespace.

/// Namespace for horizontal axis layout concepts.
///
/// Provides types for horizontal alignment and positioning that adapt to
/// text direction (LTR/RTL). Use `Horizontal.Alignment` for layout-relative
/// positioning that mirrors correctly in right-to-left locales.
public import Dimension

// MARK: - Alignment

extension Horizontal {
    /// Horizontal alignment for content positioning.
    ///
    /// Aligns content along the horizontal axis using layout-relative terms
    /// that automatically adapt to text direction. Use this for UI elements
    /// that should mirror in RTL languages.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Menu button aligned to leading edge
    /// let menuAlignment: Horizontal.Alignment = .leading
    /// // Left in LTR (English), right in RTL (Arabic)
    ///
    /// // Title centered
    /// let titleAlignment: Horizontal.Alignment = .center
    ///
    /// // User profile aligned to trailing edge
    /// let profileAlignment: Horizontal.Alignment = .trailing
    /// // Right in LTR (English), left in RTL (Arabic)
    /// ```
    public enum Alignment: Sendable, Hashable, Codable, CaseIterable {
        /// Align to the leading edge (left in LTR, right in RTL)
        case leading

        /// Align to the horizontal center
        case center

        /// Align to the trailing edge (right in LTR, left in RTL)
        case trailing
    }
}
