// Geometry.Area.swift
// 2-dimensional area measure with projections to equivalent shapes.

public import Algebra_Linear
public import Dimension

extension Geometry {
    /// 2-dimensional area measure with projections to equivalent shapes.
    ///
    /// An area can be projected onto different shapes to find the characteristic
    /// dimension of a shape with equivalent area.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let rect = Geometry<Double, Void>.Rectangle(x: 0, y: 0, width: 100, height: 200)
    /// let area = rect.area
    ///
    /// // Get the side of a square with the same area
    /// let squareSide = area.square.side  // √(100 × 200) ≈ 141.4
    ///
    /// // Get the radius of a circle with the same area
    /// let circleRadius = area.circle.radius  // √(20000/π) ≈ 79.8
    /// ```
    public struct Area {
        /// Typed area value using dimensional type system.
        public var _value: Linear<Scalar, Space>.Area

        /// Raw area value in square units.
        @inlinable
        public var rawValue: Scalar { _value._rawValue }

        /// Creates an area from a raw value.
        @inlinable
        public init(_ rawValue: Scalar) {
            self._value = Tagged(rawValue)
        }

        /// Creates an area from a typed area value.
        @inlinable
        public init(_ value: Linear<Scalar, Space>.Area) {
            self._value = value
        }
    }
}

// MARK: - Conformances

extension Geometry.Area: Sendable where Scalar: Sendable {}
extension Geometry.Area: Equatable where Scalar: Equatable {}
extension Geometry.Area: Hashable where Scalar: Hashable {}

#if Codable
extension Geometry.Area: Codable where Scalar: Codable {}
#endif

extension Geometry.Area: ExpressibleByIntegerLiteral where Scalar: ExpressibleByIntegerLiteral {
    @inlinable
    public init(integerLiteral value: Scalar.IntegerLiteralType) {
        self._value = Tagged(Scalar(integerLiteral: value))
    }
}

extension Geometry.Area: ExpressibleByFloatLiteral where Scalar: ExpressibleByFloatLiteral {
    @inlinable
    public init(floatLiteral value: Scalar.FloatLiteralType) {
        self._value = Tagged(Scalar(floatLiteral: value))
    }
}

// MARK: - Value Access

extension Geometry.Area {
    /// Underlying scalar value.
    @inlinable
    public var value: Scalar { rawValue }
}

// MARK: - Shape Projections

extension Geometry.Area where Scalar: FloatingPoint {
    /// Square with this area (centered at origin).
    ///
    /// The square's side length is √A where A is the area.
    @inlinable
    public var square: Geometry.Square {
        let side = rawValue.squareRoot()
        return Geometry.Square(
            center: .zero,
            halfSide: Linear<Scalar, Space>.Magnitude(side / 2)
        )
    }

    /// Circle with this area (centered at origin).
    ///
    /// The circle's radius is √(A/π) where A is the area.
    @inlinable
    public var circle: Geometry.Circle {
        let radius = (rawValue / Scalar.pi).squareRoot()
        return Geometry.Circle(
            center: .zero,
            radius: Geometry.Radius(radius)
        )
    }
}

// MARK: - Arithmetic

extension Geometry.Area where Scalar: AdditiveArithmetic {
    /// Zero area.
    @inlinable
    public static var zero: Self {
        Self(Scalar.zero)
    }

    /// Adds two areas.
    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(lhs.rawValue + rhs.rawValue)
    }

    /// Subtracts two areas.
    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(lhs.rawValue - rhs.rawValue)
    }
}

extension Geometry.Area where Scalar: FloatingPoint {
    /// Multiplies area by a scalar.
    @inlinable
    public static func * (lhs: Self, rhs: Scalar) -> Self {
        Self(lhs.rawValue * rhs)
    }

    /// Multiplies a scalar by area.
    @inlinable
    public static func * (lhs: Scalar, rhs: Self) -> Self {
        Self(lhs * rhs.rawValue)
    }

    /// Divides area by a scalar.
    @inlinable
    public static func / (lhs: Self, rhs: Scalar) -> Self {
        Self(lhs.rawValue / rhs)
    }

    /// Ratio of two areas (dimensionless).
    @inlinable
    public static func / (lhs: Self, rhs: Self) -> Scalar {
        lhs.rawValue / rhs.rawValue
    }
}

extension Geometry.Area where Scalar: BinaryFloatingPoint {
    /// Multiplies area by an integer.
    @inlinable
    public static func * <I: BinaryInteger>(lhs: Self, rhs: I) -> Self {
        Self(lhs.rawValue * Scalar(rhs))
    }

    /// Multiplies an integer by area.
    @inlinable
    public static func * <I: BinaryInteger>(lhs: I, rhs: Self) -> Self {
        Self(Scalar(lhs) * rhs.rawValue)
    }

    /// Divides area by an integer.
    @inlinable
    public static func / <I: BinaryInteger>(lhs: Self, rhs: I) -> Self {
        Self(lhs.rawValue / Scalar(rhs))
    }
}

// MARK: - Comparison

extension Geometry.Area: Comparable where Scalar: Comparable {
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

// MARK: - Absolute Value

/// Returns the absolute value of an area.
@inlinable
public func abs<Scalar: SignedNumeric & Comparable, Space>(
    _ area: Geometry<Scalar, Space>.Area
) -> Geometry<Scalar, Space>.Area where Scalar.Magnitude == Scalar {
    Geometry<Scalar, Space>.Area(Swift.abs(area.rawValue))
}
