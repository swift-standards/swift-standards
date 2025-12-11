// Affine.Y.swift
// A type-safe vertical coordinate (y-projection) in affine space.

extension Affine {
    /// A vertical coordinate (y-position) parameterized by scalar type.
    ///
    /// In category theory terms, this is a coordinate function (projection)
    /// from affine space to the scalar field.
    ///
    /// Use `Y` when you need type safety to distinguish vertical
    /// coordinates from horizontal ones.
    ///
    /// ## Example
    ///
    /// ```swift
    /// func setPosition(x: Affine<Double>.X, y: Affine<Double>.Y) {
    ///     // Compiler prevents accidentally swapping x and y
    /// }
    /// ```
    public struct Y {
        /// The y coordinate value
        public var value: Scalar

        /// Create a y coordinate with the given value
        @inlinable
        public init(_ value: consuming Scalar) {
            self.value = value
        }
    }
}

extension Affine.Y: Sendable where Scalar: Sendable {}
extension Affine.Y: Equatable where Scalar: Equatable {}
extension Affine.Y: Hashable where Scalar: Hashable {}

// MARK: - Codable

extension Affine.Y: Codable where Scalar: Codable {}

// MARK: - AdditiveArithmetic

extension Affine.Y: AdditiveArithmetic where Scalar: AdditiveArithmetic {
    @inlinable
    public static var zero: Self {
        Self(.zero)
    }

    @inlinable
    @_disfavoredOverload
    public static func + (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        Self(lhs.value + rhs.value)
    }

    @inlinable
    @_disfavoredOverload
    public static func - (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        Self(lhs.value - rhs.value)
    }

    /// Add a raw scalar to Y
    @inlinable
    @_disfavoredOverload
    public static func + (lhs: borrowing Self, rhs: Scalar) -> Self {
        Self(lhs.value + rhs)
    }

    /// Add Y to a raw scalar
    @inlinable
    @_disfavoredOverload
    public static func + (lhs: Scalar, rhs: borrowing Self) -> Self {
        Self(lhs + rhs.value)
    }

    /// Subtract a raw scalar from Y
    @inlinable
    @_disfavoredOverload
    public static func - (lhs: borrowing Self, rhs: Scalar) -> Self {
        Self(lhs.value - rhs)
    }

    /// Subtract Y from a raw scalar
    @inlinable
    @_disfavoredOverload
    public static func - (lhs: Scalar, rhs: borrowing Self) -> Self {
        Self(lhs - rhs.value)
    }
}

// MARK: - Comparable

extension Affine.Y: Comparable where Scalar: Comparable {
    @inlinable
    public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.value < rhs.value
    }
}

// MARK: - Negation

extension Affine.Y where Scalar: SignedNumeric {
    /// Negate
    @inlinable
    public static prefix func - (value: borrowing Self) -> Self {
        Self(-value.value)
    }
}

// MARK: - Multiplication/Division

extension Affine.Y where Scalar: FloatingPoint {
    /// Multiply by a scalar
    @inlinable
    public static func * (lhs: borrowing Self, rhs: Scalar) -> Self {
        Self(lhs.value * rhs)
    }

    /// Multiply scalar by value
    @inlinable
    @_disfavoredOverload
    public static func * (lhs: Scalar, rhs: borrowing Self) -> Self {
        Self(lhs * rhs.value)
    }

    /// Divide by a scalar
    @inlinable
    public static func / (lhs: borrowing Self, rhs: Scalar) -> Self {
        Self(lhs.value / rhs)
    }
}

// MARK: - Squared (for distance calculations)

extension Affine.Y where Scalar: Numeric {
    /// Multiply Y by Y to get squared length (for distance calculations)
    ///
    /// Dimensionally: [Y] * [Y] = [L^2] (squared length, same as X*X)
    /// This allows `dx*dx + dy*dy` to work for distance squared calculations.
    @inlinable
    public static func * (lhs: borrowing Self, rhs: borrowing Self) -> Scalar {
        lhs.value * rhs.value
    }

    /// Multiply Y by X to get a scalar (for cross product calculations)
    ///
    /// Dimensionally: [Y] * [X] = [L^2] (area/cross product)
    /// This allows 2D cross product: `a.dx * b.dy - a.dy * b.dx`
    @inlinable
    public static func * (lhs: borrowing Self, rhs: borrowing Affine.X) -> Scalar {
        lhs.value * rhs.value
    }
}

// MARK: - Functorial Map

extension Affine.Y {
    /// Create a Y coordinate by transforming the value of another Y coordinate
    @inlinable
    public init<U, E: Error>(
        _ other: borrowing Affine<U>.Y,
        _ transform: (U) throws(E) -> Scalar
    ) throws(E) {
        self.init(try transform(other.value))
    }

    /// Transform the value using the given closure
    @inlinable
    public func map<Result, E: Error>(
        _ transform: (Scalar) throws(E) -> Result
    ) throws(E) -> Affine<Result>.Y {
        Affine<Result>.Y(try transform(value))
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Affine.Y: ExpressibleByIntegerLiteral where Scalar: ExpressibleByIntegerLiteral {
    @_disfavoredOverload
    @inlinable
    public init(integerLiteral value: Scalar.IntegerLiteralType) {
        self.init(Scalar(integerLiteral: value))
    }
}

// MARK: - ExpressibleByFloatLiteral

extension Affine.Y: ExpressibleByFloatLiteral where Scalar: ExpressibleByFloatLiteral {
    @_disfavoredOverload
    @inlinable
    public init(floatLiteral value: Scalar.FloatLiteralType) {
        self.init(Scalar(floatLiteral: value))
    }
}

// MARK: - Strideable

extension Affine.Y: Strideable where Scalar: Strideable {
    public typealias Stride = Scalar.Stride

    @inlinable
    public func distance(to other: Self) -> Stride {
        value.distance(to: other.value)
    }

    @inlinable
    public func advanced(by n: Stride) -> Self {
        Self(value.advanced(by: n))
    }
}
