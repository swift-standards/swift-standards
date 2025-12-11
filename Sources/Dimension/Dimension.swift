// Dimension.swift
// Phantom types for coordinate dimensions and their semantic roles.

/// Phantom type tags for coordinate dimensions and their semantic roles.
///
/// `Index` provides zero-cost phantom type tags that distinguish coordinate positions from displacement vectors in affine geometry. Use these tags with `Tagged` to create type-safe scalar values that prevent mixing incompatible quantities.
///
/// In affine geometry, coordinates (points in affine space) and displacements (vectors) are fundamentally different: you can add displacements, but adding two coordinates is mathematically meaningless. These phantom types enforce this distinction at compile time with zero runtime overhead.
///
/// ## Example
///
/// ```swift
/// typealias XCoordinate = Tagged<Index.X.Coordinate, Double>
/// typealias Width = Tagged<Index.X.Displacement, Double>
///
/// let x: XCoordinate = 10.0
/// let width: Width = 5.0
/// let newX = x + width  // OK: Coordinate + Displacement = Coordinate
/// // let sum = x + x    // Error: cannot add two coordinates
/// ```
public enum Index {

    /// Phantom type tags for the X (horizontal) dimension.
    public enum X {
        /// Horizontal position in affine space.
        public enum Coordinate {}
        /// Horizontal extent or displacement.
        public enum Displacement {}
    }

    /// Phantom type tags for the Y (vertical) dimension.
    public enum Y {
        /// Vertical position in affine space.
        public enum Coordinate {}
        /// Vertical extent or displacement.
        public enum Displacement {}
    }

    /// Phantom type tags for the Z (depth) dimension.
    public enum Z {
        /// Depth position in affine space.
        public enum Coordinate {}
        /// Depth extent or displacement.
        public enum Displacement {}
    }

    /// Phantom type tags for the W (homogeneous/temporal) dimension.
    public enum W {
        /// Fourth-dimension position.
        public enum Coordinate {}
        /// Fourth-dimension displacement.
        public enum Displacement {}
    }

    /// Phantom type tag for scalar magnitudes.
    ///
    /// Unlike coordinates (positions) and displacements (directed extents), magnitudes are non-directional scalar quantities: vector norms, distances, radii, and lengths.
    public enum Magnitude {}
}
