// Dimension.swift
// Phantom types for coordinate dimensions and their semantic roles.

/// Phantom type tags for coordinate dimensions and their semantic roles.
///
/// `Index` provides zero-cost phantom type tags that distinguish coordinate positions
/// from displacement vectors in affine geometry. Tags are parameterized by `Space` to
/// prevent mixing coordinates from different coordinate systems (e.g., UserSpace vs DeviceSpace).
///
/// In affine geometry, coordinates (points in affine space) and displacements (vectors)
/// are fundamentally different: you can add displacements, but adding two coordinates
/// is mathematically meaningless. These phantom types enforce this distinction at compile
/// time with zero runtime overhead.
///
/// ## Example
///
/// ```swift
/// enum MySpace {}
/// typealias X = Tagged<Index.X.Coordinate<MySpace>, Double>
/// typealias Width = Tagged<Index.X.Displacement<MySpace>, Double>
///
/// let x: X = 10.0
/// let width: Width = 5.0
/// let newX = x + width  // OK: Coordinate + Displacement = Coordinate (same Space)
/// // let sum = x + x    // Error: cannot add two coordinates
/// ```
///
/// ## Space Parameter
///
/// The `Space` parameter distinguishes coordinate systems:
/// - Use `Void` for generic/abstract geometry
/// - Use a specific type (e.g., `ISO_32000.UserSpace`) for concrete coordinate systems
/// - Arithmetic only works between types with the same `Space`
public enum Index {
    
    /// Phantom type tags for the X (horizontal) dimension.
    public enum X {
        /// Horizontal position in affine space, parameterized by coordinate system.
        public enum Coordinate<Space> {}
        /// Horizontal extent or displacement, parameterized by coordinate system.
        public enum Displacement<Space> {}
    }
    
    /// Phantom type tags for the Y (vertical) dimension.
    public enum Y {
        /// Vertical position in affine space, parameterized by coordinate system.
        public enum Coordinate<Space> {}
        /// Vertical extent or displacement, parameterized by coordinate system.
        public enum Displacement<Space> {}
    }
    
    /// Phantom type tags for the Z (depth) dimension.
    public enum Z {
        /// Depth position in affine space, parameterized by coordinate system.
        public enum Coordinate<Space> {}
        /// Depth extent or displacement, parameterized by coordinate system.
        public enum Displacement<Space> {}
    }
    
    /// Phantom type tags for the W (homogeneous/temporal) dimension.
    public enum W {
        /// Fourth-dimension position, parameterized by coordinate system.
        public enum Coordinate<Space> {}
        /// Fourth-dimension displacement, parameterized by coordinate system.
        public enum Displacement<Space> {}
    }
}

extension Index {
    /// Phantom type tag for scalar magnitudes, parameterized by coordinate system.
    ///
    /// Unlike coordinates (positions) and displacements (directed extents),
    /// magnitudes are non-directional scalar quantities: vector norms, distances,
    /// radii, and lengths.
    public enum Magnitude<Space> {}
}

// MARK: - Quantized Displacement Conformances

extension Index.X.Displacement: QuantizedDisplacementTag where Space: Quantized {}
extension Index.Y.Displacement: QuantizedDisplacementTag where Space: Quantized {}
extension Index.Z.Displacement: QuantizedDisplacementTag where Space: Quantized {}
extension Index.W.Displacement: QuantizedDisplacementTag where Space: Quantized {}
