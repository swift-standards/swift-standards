// Vertical.swift
// Vertical axis namespace.

public import Dimension

// MARK: - Baseline

extension Vertical {
    /// Text baseline position for typography-aware alignment.
    ///
    /// Use this for aligning text elements by their baseline rather than
    /// their bounding box, creating visually consistent typography layouts.
    public enum Baseline: Sendable, Hashable, Codable, CaseIterable {
        /// First line's baseline (top baseline for multi-line text)
        case first

        /// Last line's baseline (bottom baseline for multi-line text)
        case last
    }
}

// MARK: - Alignment

extension Vertical {
    /// Vertical alignment for content positioning.
    ///
    /// Aligns content along the vertical axis, with special support for
    /// typography-aware baseline alignment. Use baseline alignment when
    /// horizontally arranging text labels to maintain consistent visual rhythm.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Top-aligned header
    /// let header: Vertical.Alignment = .top
    ///
    /// // Vertically centered button
    /// let button: Vertical.Alignment = .center
    ///
    /// // Text labels aligned by first baseline
    /// let labels: Vertical.Alignment = .firstBaseline
    /// // Creates clean typography alignment despite different font sizes
    /// ```
    public enum Alignment: Sendable, Hashable, Codable {
        /// Align to the top edge
        case top

        /// Align to the vertical center
        case center

        /// Align to the bottom edge
        case bottom

        /// Align to a text baseline (first or last line)
        case baseline(Vertical.Baseline)
    }
}

// MARK: - Alignment Convenience

extension Vertical.Alignment {
    /// Aligns to the first text baseline (top baseline for multi-line text)
    @inlinable
    public static var firstBaseline: Self { .baseline(.first) }

    /// Aligns to the last text baseline (bottom baseline for multi-line text)
    @inlinable
    public static var lastBaseline: Self { .baseline(.last) }
}

// MARK: - Alignment CaseIterable

extension Vertical.Alignment: CaseIterable {
    public static var allCases: [Vertical.Alignment] {
        [.top, .center, .bottom, .baseline(.first), .baseline(.last)]
    }
}
