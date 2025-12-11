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
// - `X`, `Y`, `Z`: Type-safe coordinate components
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

/// The Linear namespace for vector space primitives.
///
/// Parameterized by the scalar type (field) used for coordinates.
/// Supports both copyable and non-copyable scalar types.
public enum Linear<Scalar: ~Copyable>: ~Copyable {}

extension Linear: Copyable where Scalar: Copyable {}
extension Linear: Sendable where Scalar: Sendable {}

// MARK: - Coordinate Type Aliases

extension Linear {
    /// A type-safe horizontal displacement component.
    ///
    /// Uses `Tagged` with `Algebra.X` phantom type for compile-time
    /// distinction from Y, Z, and W components.
    public typealias X = Tagged<Algebra.X, Scalar>

    /// A type-safe vertical displacement component.
    ///
    /// Uses `Tagged` with `Algebra.Y` phantom type for compile-time
    /// distinction from X, Z, and W components.
    public typealias Y = Tagged<Algebra.Y, Scalar>

    /// A type-safe depth displacement component.
    ///
    /// Uses `Tagged` with `Algebra.Z` phantom type for compile-time
    /// distinction from X, Y, and W components.
    public typealias Z = Tagged<Algebra.Z, Scalar>

    /// A type-safe homogeneous displacement component.
    ///
    /// Uses `Tagged` with `Algebra.W` phantom type for compile-time
    /// distinction from X, Y, and Z components.
    public typealias W = Tagged<Algebra.W, Scalar>
}
