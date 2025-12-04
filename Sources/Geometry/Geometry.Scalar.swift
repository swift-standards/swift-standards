// Scalar.swift
// A generic scalar value.

extension Geometry {
    /// A generic scalar value.
    ///
    /// `Scalar` wraps a value of the geometry's unit type,
    /// providing type safety for measurements in different coordinate systems.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let value: Geometry<Double>.Scalar = .init(72.0)
    /// ```
    public struct Scalar {
        /// The underlying value
        public var value: Unit

        /// Create a scalar with the given value
        @inlinable
        public init(_ value: consuming Unit) {
            self.value = value
        }
    }
}

extension Geometry.Scalar: Sendable where Unit: Sendable {}
extension Geometry.Scalar: Equatable where Unit: Equatable {}
extension Geometry.Scalar: Hashable where Unit: Hashable {}

// MARK: - Codable

extension Geometry.Scalar: Codable where Unit: Codable {}

// MARK: - Zero

extension Geometry.Scalar where Unit: AdditiveArithmetic {
    /// Zero scalar
    @inlinable
    public static var zero: Self { Self(.zero) }
}

// MARK: - AdditiveArithmetic

extension Geometry.Scalar: AdditiveArithmetic where Unit: AdditiveArithmetic {
    @inlinable
    public static func + (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        Self(lhs.value + rhs.value)
    }

    @inlinable
    public static func - (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        Self(lhs.value - rhs.value)
    }
}

// MARK: - Comparable

extension Geometry.Scalar: Comparable where Unit: Comparable {
    @inlinable
    public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.value < rhs.value
    }
}

// MARK: - ExpressibleByFloatLiteral

extension Geometry.Scalar: ExpressibleByFloatLiteral where Unit: ExpressibleByFloatLiteral {
    @inlinable
    public init(floatLiteral value: Unit.FloatLiteralType) {
        self.value = Unit(floatLiteral: value)
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Geometry.Scalar: ExpressibleByIntegerLiteral where Unit: ExpressibleByIntegerLiteral {
    @inlinable
    public init(integerLiteral value: Unit.IntegerLiteralType) {
        self.value = Unit(integerLiteral: value)
    }
}

// MARK: - Negation (SignedNumeric)

extension Geometry.Scalar where Unit: SignedNumeric {
    /// Negate
    @inlinable
    public static prefix func - (value: borrowing Self) -> Self {
        Self(-value.value)
    }
}

// MARK: - Functorial Map

extension Geometry.Scalar {
    /// Create a scalar by transforming the value of another scalar
    @inlinable
    public init<U>(_ other: borrowing Geometry<U>.Scalar, _ transform: (U) -> Unit) {
        self.init(transform(other.value))
    }

    /// Transform the value using the given closure
    @inlinable
    public func map<E: Error, Result>(
        _ transform: (Unit) throws(E) -> Result
    ) throws(E) -> Geometry<Result>.Scalar {
        Geometry<Result>.Scalar(try transform(value))
    }
}

// MARK: - Multiplication/Division (FloatingPoint)

extension Geometry.Scalar where Unit: FloatingPoint {
    /// Multiply by a scalar
    @inlinable
    public static func * (lhs: borrowing Self, rhs: Unit) -> Self {
        Self(lhs.value * rhs)
    }

    /// Multiply scalar by value
    @inlinable
    public static func * (lhs: Unit, rhs: borrowing Self) -> Self {
        Self(lhs * rhs.value)
    }

    /// Divide by a scalar
    @inlinable
    public static func / (lhs: borrowing Self, rhs: Unit) -> Self {
        Self(lhs.value / rhs)
    }
}
