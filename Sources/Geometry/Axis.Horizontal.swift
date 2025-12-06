// Axis.Horizontal.swift
// Horizontal (X) axis direction.

public import Dimension

extension Axis {
    /// Horizontal (X) axis direction.
    ///
    /// Determines how "leading" and "trailing" map to x-coordinates:
    /// - `.rightward`: X increases rightward (standard convention)
    /// - `.leftward`: X increases leftward
    public enum Horizontal: Sendable, Hashable {
        /// X axis increases rightward (standard convention).
        case rightward

        /// X axis increases leftward.
        case leftward
    }
}
