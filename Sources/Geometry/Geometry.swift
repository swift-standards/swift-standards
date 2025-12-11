// Geometry
//
// Affine geometry primitives parameterized by scalar type.
//
// This module provides type-safe geometry primitives for affine spaces.
// Types are parameterized by their scalar type (the coordinate unit).
//
// ## Structure
//
// Geometry depends on and re-exports:
// - **Angle**: Angular measurements (`Radian`, `Degree`)
// - **Region**: Discrete spatial partitions (`Cardinal`, `Quadrant`, `Octant`, `Edge`, `Corner`)
//
// Related modules (import separately):
// - **Symmetry**: Lie group transformations (`Rotation`, `Scale`, `Shear`)
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

public import Algebra
public import Affine
public import Algebra_Linear
import Angle
import Dimension
import Region

/// The Geometry namespace for affine geometry primitives.
///
/// Parameterized by the scalar type used for coordinates and measurements.
/// Supports both copyable and non-copyable scalar types.
public enum Geometry<Scalar: ~Copyable>: ~Copyable {}

extension Geometry: Copyable where Scalar: Copyable {}
extension Geometry: Sendable where Scalar: Sendable {}

// MARK: - Type Aliases (Canonical types from Affine/Linear)

extension Geometry {
    /// Type-safe X coordinate - typealias to `Affine<Scalar>.X`
    public typealias X = Affine<Scalar>.X

    /// Type-safe Y coordinate - typealias to `Affine<Scalar>.Y`
    public typealias Y = Affine<Scalar>.Y

    /// A 2D translation - typealias to `Affine<Scalar>.Translation`
    public typealias Translation = Affine<Scalar>.Translation

    /// A 2D affine transformation - typealias to `Affine<Scalar>.Transform`
    public typealias AffineTransform = Affine<Scalar>.Transform

    /// An N-dimensional point - typealias to `Affine<Scalar>.Point<N>`
    public typealias Point<let N: Int> = Affine<Scalar>.Point<N>

    /// An N-dimensional vector - typealias to `Linear<Scalar>.Vector<N>`
    public typealias Vector<let N: Int> = Linear<Scalar>.Vector<N>
}

