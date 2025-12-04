// Height.swift
// A type-safe vertical measurement.

extension Geometry {
    /// A vertical measurement (height) parameterized by unit type.
    ///
    /// Use `Height` when you need type safety to distinguish vertical
    /// measurements from horizontal ones.
    ///
    /// ## Example
    ///
    /// ```swift
    /// func setDimensions(width: Geometry<Points>.Width, height: Geometry<Points>.Height) {
    ///     // Compiler prevents accidentally swapping width and height
    /// }
    /// ```
    public struct Height {
        /// The height value
        public var value: Scalar

        /// Create a height with the given value
        @inlinable
        public init(_ value: consuming Scalar) {
            self.value = value
        }
    }
}

extension Geometry.Height: Sendable where Scalar: Sendable {}
extension Geometry.Height: Equatable where Scalar: Equatable {}
extension Geometry.Height: Hashable where Scalar: Hashable {}

// MARK: - Codable

extension Geometry.Height: Codable where Scalar: Codable {}

// MARK: - AdditiveArithmetic

extension Geometry.Height: AdditiveArithmetic where Scalar: AdditiveArithmetic {
    @inlinable
    public static var zero: Self {
        Self(.zero)
    }

    @inlinable
    public static func + (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        Self(lhs.value + rhs.value)
    }

    @inlinable
    public static func - (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        Self(lhs.value - rhs.value)
    }

    /// Add a raw scalar to Height
    @inlinable
    public static func + (lhs: borrowing Self, rhs: Scalar) -> Self {
        Self(lhs.value + rhs)
    }

    /// Add Height to a raw scalar
    @inlinable
    public static func + (lhs: Scalar, rhs: borrowing Self) -> Self {
        Self(lhs + rhs.value)
    }

    /// Subtract a raw scalar from Height
    @inlinable
    public static func - (lhs: borrowing Self, rhs: Scalar) -> Self {
        Self(lhs.value - rhs)
    }

    /// Subtract Height from a raw scalar
    @inlinable
    public static func - (lhs: Scalar, rhs: borrowing Self) -> Self {
        Self(lhs - rhs.value)
    }
}

// MARK: - Comparable

extension Geometry.Height: Comparable where Scalar: Comparable {
    @inlinable
    public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.value < rhs.value
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Geometry.Height: ExpressibleByIntegerLiteral where Scalar: ExpressibleByIntegerLiteral {
    @inlinable
    public init(integerLiteral value: Scalar.IntegerLiteralType) {
        self.value = Scalar(integerLiteral: value)
    }
}

// MARK: - ExpressibleByFloatLiteral

extension Geometry.Height: ExpressibleByFloatLiteral where Scalar: ExpressibleByFloatLiteral {
    @inlinable
    public init(floatLiteral value: Scalar.FloatLiteralType) {
        self.value = Scalar(floatLiteral: value)
    }
}

// MARK: - Negation

extension Geometry.Height where Scalar: SignedNumeric {
    /// Negate
    @inlinable
    public static prefix func - (value: borrowing Self) -> Self {
        Self(-value.value)
    }
}

// MARK: - Multiplication/Division

extension Geometry.Height where Scalar: FloatingPoint {
    /// Multiply by a scalar
    @inlinable
    public static func * (lhs: borrowing Self, rhs: Scalar) -> Self {
        Self(lhs.value * rhs)
    }

    /// Multiply scalar by value
    @inlinable
    public static func * (lhs: Scalar, rhs: borrowing Self) -> Self {
        Self(lhs * rhs.value)
    }

    /// Divide by a scalar
    @inlinable
    public static func / (lhs: borrowing Self, rhs: Scalar) -> Self {
        Self(lhs.value / rhs)
    }
}

// MARK: - Functorial Map

extension Geometry.Height {
    /// Create a Height by transforming the value of another Height
    @inlinable
    public init<U>(_ other: borrowing Geometry<U>.Height, _ transform: (U) -> Scalar) {
        self.init(transform(other.value))
    }

    /// Transform the value using the given closure
    @inlinable
    public func map<E: Error, Result>(
        _ transform: (Scalar) throws(E) -> Result
    ) throws(E) -> Geometry<Result>.Height {
        Geometry<Result>.Height(try transform(value))
    }
}
