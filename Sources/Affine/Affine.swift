// Affine.swift
// Affine geometry namespace for affine spaces and transformations.
//
// This module provides type-safe affine geometry primitives.
// Types are parameterized by their scalar type and coordinate space.
//
// ## Category Theory Perspective
//
// This module represents the category **Aff** of affine spaces:
// - Objects: Affine spaces (vector space + forgotten origin)
// - Morphisms: Affine maps (linear map + translation)
//
// Key distinction from Vect:
// - Vector spaces have a distinguished origin
// - Affine spaces have no canonical origin
// - Points in affine space can be translated by vectors
// - The difference of two points is a vector
//
// ## Types
//
// - `Point<N>`: A position in N-dimensional affine space
// - `X`, `Y`, `Z`: Type-safe coordinate functions (projections)
// - `Translation`: A displacement in affine space
// - `Transform`: An affine transformation (linear + translation)
//
// ## Usage
//
// ```swift
// typealias Point2D = Affine<Double, Void>.Point<2>
//
// let p: Point2D = .init(x: 1, y: 2)
// let q: Point2D = .init(x: 4, y: 6)
// let v = q - p  // Linear<Double, Void>.Vector<2>
// ```

public import Algebra
public import Dimension

/// Namespace for affine space primitives parameterized by scalar type and coordinate space.
///
/// Affine spaces represent geometry where points have position but no canonical origin.
/// This differs from vector spaces which have a distinguished zero point.
/// The `Space` parameter is a phantom type that distinguishes points in different coordinate systems.
///
/// ## Example
///
/// ```swift
/// // Points in different coordinate spaces are type-incompatible
/// typealias UserPoint = Affine<Double, UserSpace>.Point<2>
/// typealias DevicePoint = Affine<Double, DeviceSpace>.Point<2>
///
/// let p = UserPoint(x: 1, y: 2)
/// let q = UserPoint(x: 4, y: 6)
/// let displacement = q - p  // Linear<Double, UserSpace>.Vector<2>
/// ```
public enum Affine<Scalar: ~Copyable, Space>: ~Copyable {}

extension Affine: Copyable where Scalar: Copyable {}
extension Affine: Sendable where Scalar: Sendable {}

// MARK: - Coordinate Type Aliases

extension Affine {
    /// Type-safe horizontal coordinate representing absolute position on the x-axis,
    /// parameterized by coordinate space.
    ///
    /// Distinguishes position coordinates from displacement vectors for type safety.
    public typealias X = Tagged<Coordinate.X<Space>, Scalar>

    /// Type-safe vertical coordinate representing absolute position on the y-axis,
    /// parameterized by coordinate space.
    ///
    /// Distinguishes position coordinates from displacement vectors for type safety.
    public typealias Y = Tagged<Coordinate.Y<Space>, Scalar>

    /// Type-safe depth coordinate representing absolute position on the z-axis,
    /// parameterized by coordinate space.
    ///
    /// Distinguishes position coordinates from displacement vectors for type safety.
    public typealias Z = Tagged<Coordinate.Z<Space>, Scalar>

    /// Type-safe homogeneous coordinate for projective transformations,
    /// parameterized by coordinate space.
    ///
    /// Used in 4D homogeneous coordinates where `w=1` represents standard 3D points.
    public typealias W = Tagged<Coordinate.W<Space>, Scalar>
}

// MARK: - Displacement Type Aliases

extension Affine {
    /// Horizontal displacement component.
    ///
    /// See ``Linear/Dx``
    public typealias Dx = Linear<Scalar, Space>.Dx

    /// Vertical displacement component.
    ///
    /// See ``Linear/Dy``
    public typealias Dy = Linear<Scalar, Space>.Dy

    /// Depth displacement component.
    ///
    /// See ``Linear/Dz``
    public typealias Dz = Linear<Scalar, Space>.Dz
}

// MARK: - Magnitude Type Aliases

extension Affine {
    /// Distance between two points (non-directional magnitude).
    ///
    /// See ``Linear/Magnitude``
    public typealias Distance = Linear<Scalar, Space>.Magnitude
}
