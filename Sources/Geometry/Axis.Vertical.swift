// Axis.Vertical.swift
// Vertical (Y) axis direction.

public import Dimension

extension Axis {
    /// Vertical (Y) axis direction.
    ///
    /// Determines how "top" and "bottom" map to y-coordinates:
    /// - `.upward`: Y increases upward (standard Cartesian, PDF)
    /// - `.downward`: Y increases downward (screen coordinates, CSS/HTML)
    ///
    /// ## Mathematical Background
    ///
    /// In the standard Cartesian coordinate system, the y-axis points upward.
    /// Many screen-based systems invert this, with y increasing downward.
    /// This affects how directional terms ("top", "bottom") map to coordinates.
    public enum Vertical: Sendable, Hashable {
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
}
