// Scalar.swift
// A generic scalar value.

extension Geometry {
    /// Generic scalar value wrapper.
    ///
    /// Wraps a value of the geometry's scalar type for type safety across different coordinate systems.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let value = Geometry<Double>.Scalar(72.0)
    /// // value.value == 72.0
    /// ```
    public struct Scalar {
        /// Underlying scalar value.
        public var value: Scalar

        /// Creates a scalar with the given value.
        @inlinable
        public init(_ value: consuming Scalar) {
            self.value = value
        }
    }
}

extension Geometry.Scalar: Sendable where Scalar: Sendable {}
extension Geometry.Scalar: Equatable where Scalar: Equatable {}
extension Geometry.Scalar: Hashable where Scalar: Hashable {}

// MARK: - Codable
#if Codable
    extension Geometry.Scalar: Codable where Scalar: Codable {}
#endif
// MARK: - Zero

extension Geometry.Scalar where Scalar: AdditiveArithmetic {
    /// Zero scalar value.
    @inlinable
    public static var zero: Self { Self(.zero) }
}

// MARK: - AdditiveArithmetic

extension Geometry.Scalar: AdditiveArithmetic where Scalar: AdditiveArithmetic {
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
}

// MARK: - Comparable

extension Geometry.Scalar: Comparable where Scalar: Comparable {
    @inlinable
    @_disfavoredOverload
    public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.value < rhs.value
    }
}

// MARK: - ExpressibleByFloatLiteral

extension Geometry.Scalar: ExpressibleByFloatLiteral where Scalar: ExpressibleByFloatLiteral {
    @inlinable
    public init(floatLiteral value: Scalar.FloatLiteralType) {
        self.value = Scalar(floatLiteral: value)
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Geometry.Scalar: ExpressibleByIntegerLiteral where Scalar: ExpressibleByIntegerLiteral {
    @inlinable
    public init(integerLiteral value: Scalar.IntegerLiteralType) {
        self.value = Scalar(integerLiteral: value)
    }
}

// MARK: - Negation (SignedNumeric)

extension Geometry.Scalar where Scalar: SignedNumeric {
    /// Negates the scalar value.
    @inlinable
    public static prefix func - (value: borrowing Self) -> Self {
        Self(-value.value)
    }
}

// MARK: - Functorial Map

extension Geometry.Scalar {
    /// Creates a scalar by transforming another scalar's value.
    @inlinable
    public init<U, E: Error>(
        _ other: borrowing Geometry<U>.Scalar,
        _ transform: (U) throws(E) -> Scalar
    ) throws(E) {
        self.init(try transform(other.value))
    }

    /// Transforms the value using the given closure.
    @inlinable
    public func map<Result, E: Error>(
        _ transform: (Scalar) throws(E) -> Result
    ) throws(E) -> Geometry<Result>.Scalar {
        Geometry<Result>.Scalar(try transform(value))
    }
}

// MARK: - Multiplication/Division (FloatingPoint)

extension Geometry.Scalar where Scalar: FloatingPoint {
    /// Multiplies by a scalar.
    @inlinable
    @_disfavoredOverload
    public static func * (lhs: borrowing Self, rhs: Scalar) -> Self {
        Self(lhs.value * rhs)
    }

    /// Multiplies scalar by value.
    @inlinable
    @_disfavoredOverload
    public static func * (lhs: Scalar, rhs: borrowing Self) -> Self {
        Self(lhs * rhs.value)
    }

    /// Divides by a scalar.
    @inlinable
    @_disfavoredOverload
    public static func / (lhs: borrowing Self, rhs: Scalar) -> Self {
        Self(lhs.value / rhs)
    }
}
