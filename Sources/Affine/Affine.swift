// Affine.swift
// Affine geometry namespace for affine spaces and transformations.
//
// This module provides type-safe affine geometry primitives.
// Types are parameterized by their scalar type (the field).
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
// typealias Point2D = Affine<Double>.Point<2>
//
// let p: Point2D = .init(x: 1, y: 2)
// let q: Point2D = .init(x: 4, y: 6)
// let v = q - p  // Linear<Double>.Vector<2>
// ```

public import Algebra
public import Dimension

/// Namespace for affine space primitives parameterized by scalar type.
///
/// Affine spaces represent geometry where points have position but no canonical origin.
/// This differs from vector spaces which have a distinguished zero point.
///
/// ## Example
///
/// ```swift
/// typealias Point2D = Affine<Double>.Point<2>
/// let p = Point2D(x: 1, y: 2)
/// let q = Point2D(x: 4, y: 6)
/// let displacement = q - p  // Vector, not another Point
/// ```
public enum Affine<Scalar: ~Copyable>: ~Copyable {}

extension Affine: Copyable where Scalar: Copyable {}
extension Affine: Sendable where Scalar: Sendable {}

// MARK: - Coordinate Type Aliases

extension Affine {
    /// Type-safe horizontal coordinate representing absolute position on the x-axis.
    ///
    /// Distinguishes position coordinates from displacement vectors for type safety.
    public typealias X = Tagged<Index.X.Coordinate, Scalar>

    /// Type-safe vertical coordinate representing absolute position on the y-axis.
    ///
    /// Distinguishes position coordinates from displacement vectors for type safety.
    public typealias Y = Tagged<Index.Y.Coordinate, Scalar>

    /// Type-safe depth coordinate representing absolute position on the z-axis.
    ///
    /// Distinguishes position coordinates from displacement vectors for type safety.
    public typealias Z = Tagged<Index.Z.Coordinate, Scalar>

    /// Type-safe homogeneous coordinate for projective transformations.
    ///
    /// Used in 4D homogeneous coordinates where `w=1` represents standard 3D points.
    public typealias W = Tagged<Index.W.Coordinate, Scalar>
}
