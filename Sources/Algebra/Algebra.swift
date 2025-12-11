// Algebra.swift
// Algebraic structures and protocols.

/// Namespace for algebraic structures.
public enum Algebra {}

// MARK: - Coordinate Axis Tags

extension Algebra {
    /// Phantom type tag for horizontal (x-axis) components.
    public enum X {}

    /// Phantom type tag for vertical (y-axis) components.
    public enum Y {}

    /// Phantom type tag for depth (z-axis) components.
    public enum Z {}

    /// Phantom type tag for homogeneous (w-axis) components.
    public enum W {}
}
