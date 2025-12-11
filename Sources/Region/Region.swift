// Region.swift
// Namespace for finite spatial partitions.

/// Namespace for finite spatial partition types.
///
/// Region defines types that decompose N-dimensional space into discrete, labeled regions. These are combinatorial structures representing spatial organization—compass directions, plane quadrants, 3D octants, and rectangle edges/corners. Use these types when you need precise spatial semantics with algebraic properties like rotation and reflection.
///
/// ## Example
///
/// ```swift
/// let direction: Region.Cardinal = .north
/// let rotated = direction.clockwise  // .east
/// let opposite = !direction  // .south
///
/// let quadrant: Region.Quadrant = .I
/// let next = quadrant.next  // .II (90° counterclockwise)
/// ```
///
/// ## Types
///
/// - ``Region/Cardinal``: Four compass directions (Z₄ group)
/// - ``Region/Quadrant``: Four regions of the 2D plane (Z₄ group)
/// - ``Region/Octant``: Eight regions of 3D space (Z₂³ group)
/// - ``Region/Clock``: Twelve clock positions (Z₁₂ group)
/// - ``Region/Sextant``: Six 60° sectors (Z₆ group)
/// - ``Region/Edge``: Four edges of a rectangle
/// - ``Region/Corner``: Four corners of a rectangle
public enum Region {
    // Types are defined in separate files and extended onto this enum
}
