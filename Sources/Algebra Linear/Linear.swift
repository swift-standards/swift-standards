// Linear.swift
// Linear algebra namespace for vector spaces and linear maps.
//
// This module provides type-safe linear algebra primitives.
// Types are parameterized by their scalar type (the field).
//
// ## Category Theory Perspective
//
// This module represents the category **Vect** of vector spaces:
// - Objects: Vector spaces (represented by `Vector<N>`)
// - Morphisms: Linear maps (represented by `Matrix<M, N>`)
//
// ## Types
//
// - `Vector<N>`: An N-dimensional vector (element of vector space)
// - `Matrix<M, N>`: An M×N matrix (linear map from N-dim to M-dim space)
// - `Dx`, `Dy`, `Dz`: Type-safe displacement components
//
// ## Usage
//
// ```swift
// typealias Vec3 = Linear<Double>.Vector<3>
// typealias Mat4 = Linear<Double>.Matrix4x4
//
// let v: Vec3 = .init(dx: 1, dy: 2, dz: 3)
// let m: Mat4 = .identity
// ```

public import Algebra
public import Dimension

/// A namespace for type-safe vector spaces and linear transformations.
///
/// `Linear` provides compile-time dimension checking for vectors and matrices, parameterized by scalar type. Use it to build collision-free 2D/3D math with strong guarantees about dimensions and units.
///
/// ## Example
///
/// ```swift
/// typealias Vec2 = Linear<Double>.Vector<2>
/// typealias Mat2 = Linear<Double>.Matrix2x2
///
/// let v = Vec2(dx: .init(3), dy: .init(4))
/// let length = v.length  // 5.0
/// let rotated = v.rotated(by: .degrees(90))
/// ```
public enum Linear<Scalar: ~Copyable>: ~Copyable {}

extension Linear: Copyable where Scalar: Copyable {}
extension Linear: Sendable where Scalar: Sendable {}

// MARK: - Displacement Type Aliases

extension Linear {
    /// A horizontal displacement (vector X-component).
    ///
    /// Use for widths, horizontal changes, or vector X-axis values. Distinct from coordinates.
    public typealias Dx = Tagged<Index.X.Displacement, Scalar>

    /// A vertical displacement (vector Y-component).
    ///
    /// Use for heights, vertical changes, or vector Y-axis values. Distinct from coordinates.
    public typealias Dy = Tagged<Index.Y.Displacement, Scalar>

    /// A depth displacement (vector Z-component).
    ///
    /// Use for depths, Z-axis changes, or vector Z-axis values. Distinct from coordinates.
    public typealias Dz = Tagged<Index.Z.Displacement, Scalar>

    /// A homogeneous displacement (vector W-component).
    ///
    /// Use for 4D vector W-axis values in homogeneous coordinates. Distinct from coordinates.
    public typealias Dw = Tagged<Index.W.Displacement, Scalar>

    /// A non-directional scalar magnitude.
    ///
    /// Use for lengths, distances, radii, or any scalar size measurement without direction. Unlike displacements which have axis identity, magnitudes represent pure scalar quantities.
    public typealias Magnitude = Tagged<Index.Magnitude, Scalar>
}
