// Linear.swift
// Linear algebra namespace for vector spaces and linear maps.
//
// This module provides type-safe linear algebra primitives.
// Types are parameterized by their scalar type and coordinate space.
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
// typealias Vec3 = Linear<Double, Void>.Vector<3>
// typealias Mat4 = Linear<Double, Void>.Matrix4x4
//
// let v: Vec3 = .init(dx: 1, dy: 2, dz: 3)
// let m: Mat4 = .identity
// ```

import Algebra
public import Dimension

/// A namespace for type-safe vector spaces and linear transformations.
///
/// `Linear` provides compile-time dimension checking for vectors and matrices,
/// parameterized by scalar type and coordinate space. The `Space` parameter is a phantom
/// type that distinguishes vectors in different coordinate systems (e.g., user space vs device space).
///
/// ## Example
///
/// ```swift
/// // Define coordinate spaces
/// enum UserSpace {}
/// enum DeviceSpace {}
///
/// typealias UserVec2 = Linear<Double, UserSpace>.Vector<2>
/// typealias DeviceVec2 = Linear<Double, DeviceSpace>.Vector<2>
///
/// // Vectors in different spaces are type-incompatible
/// let userV = UserVec2(dx: 3, dy: 4)
/// let deviceV = DeviceVec2(dx: 6, dy: 8)
/// // userV + deviceV  // Compile error: different spaces
/// ```
public enum Linear<Scalar: ~Copyable, Space>: ~Copyable {}

extension Linear: Copyable where Scalar: Copyable {}
extension Linear: Sendable where Scalar: Sendable {}

// MARK: - Displacement Type Aliases

extension Linear {
    /// A horizontal displacement (vector X-component), parameterized by coordinate space.
    ///
    /// Use for widths, horizontal changes, or vector X-axis values. Distinct from coordinates.
    public typealias Dx = Displacement.X<Space>.Value<Scalar>

    /// A vertical displacement (vector Y-component), parameterized by coordinate space.
    ///
    /// Use for heights, vertical changes, or vector Y-axis values. Distinct from coordinates.
    public typealias Dy = Displacement.Y<Space>.Value<Scalar>

    /// A depth displacement (vector Z-component), parameterized by coordinate space.
    ///
    /// Use for depths, Z-axis changes, or vector Z-axis values. Distinct from coordinates.
    public typealias Dz = Displacement.Z<Space>.Value<Scalar>

    /// A homogeneous displacement (vector W-component), parameterized by coordinate space.
    ///
    /// Use for 4D vector W-axis values in homogeneous coordinates. Distinct from coordinates.
    public typealias Dw = Displacement.W<Space>.Value<Scalar>

    /// A non-directional scalar magnitude, parameterized by coordinate space.
    ///
    /// Use for lengths, distances, radii, or any scalar size measurement without direction.
    /// Unlike displacements which have axis identity, magnitudes represent pure scalar quantities.
    public typealias Magnitude = Dimension.Magnitude<Space>.Value<Scalar>

    /// Width (unsigned horizontal extent), parameterized by coordinate space.
    ///
    /// Use for non-negative horizontal size measurements. Distinct from Dx which is signed.
    public typealias Width = Extent.X<Space>.Value<Scalar>

    /// Height (unsigned vertical extent), parameterized by coordinate space.
    ///
    /// Use for non-negative vertical size measurements. Distinct from Dy which is signed.
    public typealias Height = Extent.Y<Space>.Value<Scalar>

    /// Depth (unsigned Z extent), parameterized by coordinate space.
    ///
    /// Use for non-negative depth measurements. Distinct from Dz which is signed.
    public typealias Depth = Extent.Z<Space>.Value<Scalar>
}

extension Linear {
    /// See ``Linear/Magnitude``
    public typealias Length = Dimension.Length<Space, Scalar>

    /// See ``Linear/Magnitude``
    public typealias Radius = Dimension.Radius<Space, Scalar>

    /// See ``Linear/Magnitude``
    public typealias Diameter = Dimension.Diameter<Space, Scalar>

    /// See ``Linear/Magnitude``
    public typealias Distance = Dimension.Distance<Space, Scalar>

    /// See ``Linear/Magnitude``
    public typealias Circumference = Dimension.Circumference<Space, Scalar>

    /// See ``Linear/Magnitude``
    public typealias Perimeter = Dimension.Perimeter<Space, Scalar>

    /// See ``Linear/Magnitude``
    public typealias ArcLength = Dimension.ArcLength<Space, Scalar>

    /// Area (2D measure) in this coordinate space.
    ///
    /// See ``Dimension/Area``
    public typealias Area = Dimension.Area<Space>.Value<Scalar>
}
