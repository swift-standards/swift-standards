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

// MARK: - Square from Area

extension Geometry.Hypercube where N == 2, Scalar: FloatingPoint {
    /// Create a square with the given area (centered at origin).
    ///
    /// The square's side length is √A where A is the area.
    @inlinable
    public init(area: Geometry.Area) {
        let side = area.rawValue.squareRoot()
        self.init(
            center: .zero,
            halfSide: Linear<Scalar, Space>.Magnitude(side / 2)
        )
    }
}

// MARK: - Circle from Area

extension Geometry.Ball where N == 2, Scalar: FloatingPoint {
    /// Create a circle with the given area (centered at origin).
    ///
    /// The circle's radius is √(A/π) where A is the area.
    @inlinable
    public init(area: Geometry.Area) {
        let radius = (area.rawValue / Scalar.pi).squareRoot()
        self.init(
            center: .zero,
            radius: Geometry.Radius(radius)
        )
    }
}

// MARK: - Shape Projections

extension Geometry.Area where Scalar: FloatingPoint {
    /// Square with this area (centered at origin).
    ///
    /// The square's side length is √A where A is the area.
    @inlinable
    public var square: Geometry.Square { .init(area: self) }

    /// Circle with this area (centered at origin).
    ///
    /// The circle's radius is √(A/π) where A is the area.
    @inlinable
    public var circle: Geometry.Circle { .init(area: self) }
}

// MARK: - Absolute Value

/// Returns the absolute value of an area.
@inlinable
public func abs<Scalar: SignedNumeric & Comparable, Space>(
    _ area: Geometry<Scalar, Space>.Area
) -> Geometry<Scalar, Space>.Area where Scalar.Magnitude == Scalar {
    Geometry<Scalar, Space>.Area(Swift.abs(area.rawValue))
}
