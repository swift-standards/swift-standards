// Geometry
//
// Affine geometry primitives parameterized by scalar type and coordinate space.
//
// This module provides type-safe geometry primitives for affine spaces.
// Types are parameterized by their scalar type and coordinate space.
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
// ## Spatial Types (Geometry<Scalar, Space>)
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
// Specialize with your scalar type and coordinate space:
//
// ```swift
// struct Points: AdditiveArithmetic { ... }
// enum PageSpace {}
//
// typealias Coordinate = Geometry<Points, PageSpace>.Point<2>
// typealias PageSize = Geometry<Points, PageSpace>.Size<2>
// typealias Transform = Geometry<Points, PageSpace>.AffineTransform
// ```

public import Affine
public import Algebra
public import Algebra_Linear
import Angle
public import Dimension

/// Namespace for affine geometry primitives.
///
/// All geometry types are parameterized by scalar type and coordinate space.
/// The `Space` parameter is a phantom type that ensures type safety across coordinate systems.
/// Use `Void` for applications that don't need space separation.
///
/// ## Example
///
/// ```swift
/// // Simple usage with Void space
/// let rect = Geometry<Double, Void>.Rectangle(x: 0, y: 0, width: 100, height: 200)
/// let circle = Geometry<Double, Void>.Circle(center: .init(x: 50, y: 50), radius: 25)
///
/// // Type-safe coordinate spaces
/// enum UserSpace {}
/// enum DeviceSpace {}
/// let userPoint: Geometry<Double, UserSpace>.Point<2> = .init(x: 10, y: 20)
/// let devicePoint: Geometry<Double, DeviceSpace>.Point<2> = .init(x: 100, y: 200)
/// // userPoint + devicePoint  // Compile error: different spaces
/// ```
public enum Geometry<Scalar: ~Copyable, Space>: ~Copyable {}

extension Geometry: Copyable where Scalar: Copyable {}
extension Geometry: Sendable where Scalar: Sendable {}

// MARK: - Type Aliases (Canonical types from Affine/Linear)

extension Geometry {
    /// See ``Affine/X``
    public typealias X = Affine<Scalar, Space>.X

    /// See ``Affine/Y``
    public typealias Y = Affine<Scalar, Space>.Y

    /// See ``Linear/Width``
    public typealias Width = Linear<Scalar, Space>.Width

    /// See ``Linear/Height``
    public typealias Height = Linear<Scalar, Space>.Height

    /// See ``Linear/Dx``
    public typealias Dx = Linear<Scalar, Space>.Dx

    /// See ``Linear/Dy``
    public typealias Dy = Linear<Scalar, Space>.Dy

    /// See ``Linear/Magnitude``
    public typealias Length = Linear<Scalar, Space>.Magnitude

    /// Radius of a circle or arc (non-directional magnitude).
    ///
    /// Semantically identical to `Length` but provides clearer intent for circular geometry.
    public typealias Radius = Linear<Scalar, Space>.Magnitude

    /// Diameter of a circle (non-directional magnitude).
    ///
    /// Semantically identical to `Length` but provides clearer intent for circular geometry.
    public typealias Diameter = Linear<Scalar, Space>.Magnitude

    /// Distance between two points (non-directional magnitude).
    ///
    /// Semantically identical to `Length` but provides clearer intent for point-to-point measurements.
    public typealias Distance = Linear<Scalar, Space>.Magnitude

    /// Circumference of a circle (non-directional magnitude).
    ///
    /// Semantically identical to `Length` but provides clearer intent for circular perimeter.
    public typealias Circumference = Linear<Scalar, Space>.Magnitude

    /// Perimeter of a closed shape (non-directional magnitude).
    ///
    /// Semantically identical to `Length` but provides clearer intent for boundary length.
    public typealias Perimeter = Linear<Scalar, Space>.Magnitude

    /// Arc length along a curve (non-directional magnitude).
    ///
    /// Semantically identical to `Length` but provides clearer intent for curved paths.
    public typealias ArcLength = Linear<Scalar, Space>.Magnitude

    /// See ``Affine/Translation``
    public typealias Translation = Affine<Scalar, Space>.Translation

    /// See ``Affine/Transform``
    public typealias AffineTransform = Affine<Scalar, Space>.Transform

    /// See ``Affine/Point``
    public typealias Point<let N: Int> = Affine<Scalar, Space>.Point<N>

    /// See ``Linear/Vector``
    public typealias Vector<let N: Int> = Linear<Scalar, Space>.Vector<N>
}

// MARK: - Magnitude with Projections

extension Geometry {
    /// A non-directional scalar magnitude with projections to Width and Height.
    ///
    /// Use for diameter, radius, or other scalar quantities that may need to be
    /// projected as directional displacements.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let circle = Geometry<Double, Void>.Circle(center: .zero, radius: 10)
    /// let markerWidth: Geometry<Double, Void>.Width = circle.diameter.width
    /// ```
    public struct Magnitude {
        /// Underlying raw magnitude value.
        public var rawValue: Linear<Scalar, Space>.Magnitude

        /// Creates a magnitude from a raw value.
        @inlinable
        public init(_ rawValue: Linear<Scalar, Space>.Magnitude) {
            self.rawValue = rawValue
        }
    }
}

extension Geometry.Magnitude: Sendable where Scalar: Sendable {}
extension Geometry.Magnitude: Equatable where Scalar: Equatable {}
extension Geometry.Magnitude: Hashable where Scalar: Hashable {}

extension Geometry.Magnitude: Comparable where Scalar: Comparable {
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension Geometry.Magnitude: ExpressibleByIntegerLiteral where Scalar: ExpressibleByIntegerLiteral {
    @inlinable
    public init(integerLiteral value: Scalar.IntegerLiteralType) {
        self.rawValue = Linear<Scalar, Space>.Magnitude(integerLiteral: value)
    }
}

extension Geometry.Magnitude: ExpressibleByFloatLiteral where Scalar: ExpressibleByFloatLiteral {
    @inlinable
    public init(floatLiteral value: Scalar.FloatLiteralType) {
        self.rawValue = Linear<Scalar, Space>.Magnitude(floatLiteral: value)
    }
}

extension Geometry.Magnitude {
    /// Project magnitude as horizontal displacement (width).
    @inlinable
    public var width: Geometry.Width {
        Geometry.Width(rawValue._rawValue)
    }

    /// Project magnitude as vertical displacement (height).
    @inlinable
    public var height: Geometry.Height {
        Geometry.Height(rawValue._rawValue)
    }

    /// Underlying scalar value.
    @inlinable
    public var value: Scalar {
        rawValue._rawValue
    }
}

// MARK: - Geometry.Magnitude Arithmetic

extension Geometry.Magnitude where Scalar: AdditiveArithmetic {
    /// Zero magnitude.
    @inlinable
    public static var zero: Self {
        Self(Linear<Scalar, Space>.Magnitude(.zero))
    }
}
//
//extension Geometry.Magnitude where Scalar: FloatingPoint {
//    /// Multiplies magnitude by a scalar.
//    @inlinable
//    public static func * (lhs: Self, rhs: Scalar) -> Self {
//        Self(lhs.rawValue * rhs)
//    }
//
//    /// Multiplies scalar by magnitude.
//    @inlinable
//    public static func * (lhs: Scalar, rhs: Self) -> Self {
//        Self(lhs * rhs.rawValue)
//    }
//
//    /// Divides magnitude by a scalar.
//    @inlinable
//    public static func / (lhs: Self, rhs: Scalar) -> Self {
//        Self(lhs.rawValue / rhs)
//    }
//
//    /// Ratio of two magnitudes (dimensionless).
//    @inlinable
//    public static func / (lhs: Self, rhs: Self) -> Scalar {
//        lhs.rawValue / rhs.rawValue
//    }
//}
