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

public import Affine
public import Algebra
public import Algebra_Linear
import Angle
public import Dimension
import Region

/// Namespace for affine geometry primitives.
///
/// All geometry types are parameterized by scalar type for coordinates and measurements.
/// Supports both copyable and non-copyable scalar types.
///
/// ## Example
///
/// ```swift
/// typealias Points = Double
/// let rect = Geometry<Points>.Rectangle(x: 0, y: 0, width: 100, height: 200)
/// let circle = Geometry<Points>.Circle(center: .init(x: 50, y: 50), radius: 25)
/// ```
public enum Geometry<Scalar: ~Copyable>: ~Copyable {}

extension Geometry: Copyable where Scalar: Copyable {}
extension Geometry: Sendable where Scalar: Sendable {}

// MARK: - Type Aliases (Canonical types from Affine/Linear)

extension Geometry {
    /// See ``Affine/X``
    public typealias X = Affine<Scalar>.X

    /// See ``Affine/Y``
    public typealias Y = Affine<Scalar>.Y

    /// See ``Linear/Dx``
    public typealias Width = Linear<Scalar>.Dx

    /// See ``Linear/Dy``
    public typealias Height = Linear<Scalar>.Dy

    /// See ``Linear/Magnitude``
    public typealias Length = Linear<Scalar>.Magnitude

    /// See ``Affine/Translation``
    public typealias Translation = Affine<Scalar>.Translation

    /// See ``Affine/Transform``
    public typealias AffineTransform = Affine<Scalar>.Transform

    /// See ``Affine/Point``
    public typealias Point<let N: Int> = Affine<Scalar>.Point<N>

    /// See ``Linear/Vector``
    public typealias Vector<let N: Int> = Linear<Scalar>.Vector<N>
}
