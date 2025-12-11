// Affine.X.swift
// A type-safe horizontal coordinate (x-projection) in affine space.

extension Affine {
    /// A horizontal coordinate (x-position) parameterized by scalar type.
    ///
    /// In category theory terms, this is a coordinate function (projection)
    /// from affine space to the scalar field.
    ///
    /// Use `X` when you need type safety to distinguish horizontal
    /// coordinates from vertical ones.
    ///
    /// ## Example
    ///
    /// ```swift
    /// func setPosition(x: Affine<Double>.X, y: Affine<Double>.Y) {
    ///     // Compiler prevents accidentally swapping x and y
    /// }
    /// ```
    public struct X {
        /// The x coordinate value
        public var value: Scalar

        /// Create an x coordinate with the given value
        @inlinable
        public init(_ value: consuming Scalar) {
            self.value = value
        }
    }
}

extension Affine.X: Sendable where Scalar: Sendable {}
extension Affine.X: Equatable where Scalar: Equatable {}
extension Affine.X: Hashable where Scalar: Hashable {}

// MARK: - Codable

extension Affine.X: Codable where Scalar: Codable {}

// MARK: - AdditiveArithmetic

extension Affine.X: AdditiveArithmetic where Scalar: AdditiveArithmetic {
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

    /// Add a raw scalar to X
    @inlinable
    @_disfavoredOverload
    public static func + (lhs: borrowing Self, rhs: Scalar) -> Self {
        Self(lhs.value + rhs)
    }

    /// Add X to a raw scalar
    @inlinable
    @_disfavoredOverload
    public static func + (lhs: Scalar, rhs: borrowing Self) -> Self {
        Self(lhs + rhs.value)
    }

    /// Subtract a raw scalar from X
    @inlinable
    @_disfavoredOverload
    public static func - (lhs: borrowing Self, rhs: Scalar) -> Self {
        Self(lhs.value - rhs)
    }

    /// Subtract X from a raw scalar
    @inlinable
    @_disfavoredOverload
    public static func - (lhs: Scalar, rhs: borrowing Self) -> Self {
        Self(lhs - rhs.value)
    }
}

// MARK: - Comparable

extension Affine.X: Comparable where Scalar: Comparable {
    @inlinable
    public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.value < rhs.value
    }
}

// MARK: - Negation

extension Affine.X where Scalar: SignedNumeric {
    /// Negate
    @inlinable
    public static prefix func - (value: borrowing Self) -> Self {
        Self(-value.value)
    }
}

// MARK: - Multiplication/Division

extension Affine.X where Scalar: FloatingPoint {
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

extension Affine.X where Scalar: Numeric {
    /// Multiply X by X to get squared length (for distance calculations)
    ///
    /// Dimensionally: [X] * [X] = [L^2] (squared length, same as Y*Y)
    /// This allows `dx*dx + dy*dy` to work for distance squared calculations.
    @inlinable
    public static func * (lhs: borrowing Self, rhs: borrowing Self) -> Scalar {
        lhs.value * rhs.value
    }

    /// Multiply X by Y to get a scalar (for cross product calculations)
    ///
    /// Dimensionally: [X] * [Y] = [L^2] (area/cross product)
    /// This allows 2D cross product: `a.dx * b.dy - a.dy * b.dx`
    @inlinable
    public static func * (lhs: borrowing Self, rhs: borrowing Affine.Y) -> Scalar {
        lhs.value * rhs.value
    }
}

// MARK: - Functorial Map

extension Affine.X {
    /// Create an X coordinate by transforming the value of another X coordinate
    @inlinable
    public init<U, E: Error>(
        _ other: borrowing Affine<U>.X,
        _ transform: (U) throws(E) -> Scalar
    ) throws(E) {
        self.init(try transform(other.value))
    }

    /// Transform the value using the given closure
    @inlinable
    public func map<Result, E: Error>(
        _ transform: (Scalar) throws(E) -> Result
    ) throws(E) -> Affine<Result>.X {
        Affine<Result>.X(try transform(value))
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Affine.X: ExpressibleByIntegerLiteral where Scalar: ExpressibleByIntegerLiteral {
    @_disfavoredOverload
    @inlinable
    public init(integerLiteral value: Scalar.IntegerLiteralType) {
        self.init(Scalar(integerLiteral: value))
    }
}

// MARK: - ExpressibleByFloatLiteral

extension Affine.X: ExpressibleByFloatLiteral where Scalar: ExpressibleByFloatLiteral {
    @_disfavoredOverload
    @inlinable
    public init(floatLiteral value: Scalar.FloatLiteralType) {
        self.init(Scalar(floatLiteral: value))
    }
}

// MARK: - Strideable

extension Affine.X: Strideable where Scalar: Strideable {
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
