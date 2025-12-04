// Geometry
//
// Affine geometry primitives parameterized by scalar type.
//
// This module provides type-safe geometry primitives for affine spaces.
// Types are parameterized by their scalar type (the coordinate unit).
//
// ## Structure
//
// The module separates:
// - **Dimensionless types** (global): `Radian`, `Degree`, `Scale`, `Rotation`, `Linear`, `Shear`
// - **Spatial types** (parameterized): `Point`, `Vector`, `Size`, `Rectangle`, `Translation`, `AffineTransform`
//
// This reflects the mathematical reality that linear transformations (rotation,
// scale, shear) are independent of coordinate system, while positions and
// displacements are not.
//
// ## Spatial Types (Geometry<Scalar>)
//
// - `Point<N>`: An N-dimensional position
// - `Vector<N>`: An N-dimensional displacement
// - `Size<N>`: N-dimensional dimensions
// - `Rectangle`: A 2D bounding box
// - `Translation`: A 2D displacement (typed x, y)
// - `AffineTransform`: Linear transformation + translation
// - `X`, `Y`: Type-safe coordinate wrappers
// - `Width`, `Height`: Type-safe dimension wrappers
//
// ## Usage
//
// Specialize with your scalar type:
//
// ```swift
// struct Points: AdditiveArithmetic { ... }
//
// typealias Coordinate = Geometry<Points>.Point<2>
// typealias PageSize = Geometry<Points>.Size<2>
// typealias Transform = Geometry<Points>.AffineTransform
// ```

/// The Geometry namespace for affine geometry primitives.
///
/// Parameterized by the scalar type used for coordinates and measurements.
/// Supports both copyable and non-copyable scalar types.
public enum Geometry<Scalar: ~Copyable>: ~Copyable {}

extension Geometry: Copyable where Scalar: Copyable {}
extension Geometry: Sendable where Scalar: Sendable {}
