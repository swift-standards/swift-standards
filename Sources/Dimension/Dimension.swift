// Dimension.swift
// Phantom types for coordinate dimensions and their semantic roles.
// Role-first namespace structure for type-safe affine geometry.

// MARK: - Spatial Protocol

/// A phantom type tag that belongs to a coordinate space.
///
/// All dimension tags (coordinates, displacements, magnitudes) conform to this protocol,
/// exposing their `Space` parameter for compile-time dispatch and quantization support.
public protocol Spatial {
    associatedtype Space
}

// MARK: - Coordinate Namespace

/// Phantom type tags for absolute positions in affine space.
///
/// Coordinates represent positions, not displacements. You cannot add two coordinates,
/// but you can compute the displacement between them or translate a coordinate by a displacement.
///
/// ## Affine Arithmetic
/// - `Coordinate - Coordinate = Displacement` (vector between positions)
/// - `Coordinate + Displacement = Coordinate` (translate position)
/// - `Coordinate - Displacement = Coordinate` (translate position)
///
/// ## Example
///
/// ```swift
/// typealias X = Tagged<Coordinate.X<MySpace>, Double>
/// let x: X = 10.0
/// let dx: Tagged<Displacement.X<MySpace>, Double> = 5.0
/// let newX = x + dx  // OK: Coordinate + Displacement = Coordinate
/// ```
public enum Coordinate {
    /// Horizontal position (1D), parameterized by coordinate system.
    public enum X<Space> {}

    /// Vertical position (1D), parameterized by coordinate system.
    public enum Y<Space> {}

    /// Depth position (1D), parameterized by coordinate system.
    public enum Z<Space> {}

    /// Homogeneous coordinate (1D), parameterized by coordinate system.
    public enum W<Space> {}

    /// N-dimensional position, parameterized by dimensionality and coordinate system.
    public enum Vector<let N: Int, Space> {}
}

// MARK: - Displacement Namespace

/// Phantom type tags for directed offsets in affine space.
///
/// Displacements represent directed quantities: offsets, velocities, extents.
/// Unlike coordinates, displacements form a vector space and can be added together.
///
/// ## Displacement Arithmetic
/// - `Displacement + Displacement = Displacement`
/// - `Displacement - Displacement = Displacement`
/// - `Displacement + Coordinate = Coordinate` (commutative translation)
///
/// ## Example
///
/// ```swift
/// typealias Dx = Tagged<Displacement.X<MySpace>, Double>
/// let dx1: Dx = 5.0
/// let dx2: Dx = 3.0
/// let sum = dx1 + dx2  // OK: Displacement + Displacement = Displacement
/// ```
public enum Displacement {
    /// Horizontal offset dx (1D), parameterized by coordinate system.
    public enum X<Space> {}

    /// Vertical offset dy (1D), parameterized by coordinate system.
    public enum Y<Space> {}

    /// Depth offset dz (1D), parameterized by coordinate system.
    public enum Z<Space> {}

    /// W offset dw (1D), parameterized by coordinate system.
    public enum W<Space> {}

    /// N-dimensional displacement, parameterized by dimensionality and coordinate system.
    public enum Vector<let N: Int, Space> {}
}

// MARK: - Extent Namespace

/// Phantom type tags for unsigned size dimensions.
///
/// Extents represent non-directional size dimensions: width, height, depth.
/// Semantically distinct from signed displacements.
///
/// ## Example
///
/// ```swift
/// typealias Width = Tagged<Extent.X<MySpace>, Double>
/// typealias Height = Tagged<Extent.Y<MySpace>, Double>
/// let size = width * height  // Raw scalar (area)
/// ```
public enum Extent {
    /// Width (1D), parameterized by coordinate system.
    public enum X<Space> {}

    /// Height (1D), parameterized by coordinate system.
    public enum Y<Space> {}

    /// Depth (1D), parameterized by coordinate system.
    public enum Z<Space> {}

    /// N-dimensional extent, parameterized by dimensionality and coordinate system.
    public enum Vector<let N: Int, Space> {}
}

// MARK: - Measure

/// Phantom type tag for N-dimensional scalar measures.
///
/// Measures are non-directional quantities parameterized by their dimension:
/// - `Measure<1, Space>` = Length (distance, radius, norm)
/// - `Measure<2, Space>` = Area
/// - `Measure<3, Space>` = Volume
///
/// ## Dimensional Arithmetic
/// - `Measure<1> × Measure<1> → Measure<2>` (Length × Length = Area)
/// - `Measure<1> × Measure<2> → Measure<3>` (Length × Area = Volume)
/// - `√Measure<2> → Measure<1>` (√Area = Length)
///
/// ## Example
///
/// ```swift
/// typealias Radius = Tagged<Measure<1, MySpace>, Double>
/// typealias Area = Tagged<Measure<2, MySpace>, Double>
/// let r: Radius = 5.0
/// let area: Area = r * r  // Length × Length = Area
/// ```
public enum Measure<let N: Int, Space> {}

// MARK: - Measure Typealiases

/// Non-directional length (1D measure): distances, radii, norms.
///
/// Magnitudes can be added to coordinates along any axis.
///
/// ## Example
///
/// ```swift
/// typealias Radius = Tagged<Magnitude<MySpace>, Double>
/// let center: Tagged<Coordinate.X<MySpace>, Double> = 10.0
/// let radius: Radius = 5.0
/// let edge = center + radius  // OK: Coordinate + Magnitude = Coordinate
/// ```
public typealias Magnitude<Space> = Measure<1, Space>

/// 2-dimensional measure (area).
///
/// Result of multiplying two lengths or displacement components.
public typealias Area<Space> = Measure<2, Space>

/// 3-dimensional measure (volume).
///
/// Result of multiplying length by area, or three lengths.
public typealias Volume<Space> = Measure<3, Space>

// MARK: - Spatial Conformances (1D)

extension Coordinate.X: Spatial {}
extension Coordinate.Y: Spatial {}
extension Coordinate.Z: Spatial {}
extension Coordinate.W: Spatial {}

extension Displacement.X: Spatial {}
extension Displacement.Y: Spatial {}
extension Displacement.Z: Spatial {}
extension Displacement.W: Spatial {}

extension Extent.X: Spatial {}
extension Extent.Y: Spatial {}
extension Extent.Z: Spatial {}

extension Measure: Spatial {}

// MARK: - Spatial Conformances (N-dimensional)

extension Coordinate.Vector: Spatial {}
extension Displacement.Vector: Spatial {}
extension Extent.Vector: Spatial {}

// MARK: - Value Typealiases

// These typealiases provide convenient access to Tagged-wrapped values.
// Usage: Coordinate.X<Space>.Value<Scalar> instead of Tagged<Coordinate.X<Space>, Scalar>

extension Coordinate.X {
    /// A tagged X coordinate value in the given space.
    public typealias Value<Scalar> = Tagged<Coordinate.X<Space>, Scalar>
}

extension Coordinate.Y {
    /// A tagged Y coordinate value in the given space.
    public typealias Value<Scalar> = Tagged<Coordinate.Y<Space>, Scalar>
}

extension Coordinate.Z {
    /// A tagged Z coordinate value in the given space.
    public typealias Value<Scalar> = Tagged<Coordinate.Z<Space>, Scalar>
}

extension Coordinate.W {
    /// A tagged W coordinate value in the given space.
    public typealias Value<Scalar> = Tagged<Coordinate.W<Space>, Scalar>
}

extension Displacement.X {
    /// A tagged X displacement value in the given space.
    public typealias Value<Scalar> = Tagged<Displacement.X<Space>, Scalar>
}

extension Displacement.Y {
    /// A tagged Y displacement value in the given space.
    public typealias Value<Scalar> = Tagged<Displacement.Y<Space>, Scalar>
}

extension Displacement.Z {
    /// A tagged Z displacement value in the given space.
    public typealias Value<Scalar> = Tagged<Displacement.Z<Space>, Scalar>
}

extension Displacement.W {
    /// A tagged W displacement value in the given space.
    public typealias Value<Scalar> = Tagged<Displacement.W<Space>, Scalar>
}

extension Extent.X {
    /// A tagged X extent (width) value in the given space.
    public typealias Value<Scalar> = Tagged<Extent.X<Space>, Scalar>
}

extension Extent.Y {
    /// A tagged Y extent (height) value in the given space.
    public typealias Value<Scalar> = Tagged<Extent.Y<Space>, Scalar>
}

extension Extent.Z {
    /// A tagged Z extent (depth) value in the given space.
    public typealias Value<Scalar> = Tagged<Extent.Z<Space>, Scalar>
}

extension Measure {
    /// A tagged measure value of dimension N in the given space.
    public typealias Value<Scalar> = Tagged<Measure<N, Space>, Scalar>
}
