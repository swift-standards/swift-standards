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
    public struct Height: ~Copyable {
        /// The height value
        public var value: Unit

        /// Create a height with the given value
        @inlinable
        public init(_ value: consuming Unit) {
            self.value = value
        }
    }
}

extension Geometry.Height: Copyable where Unit: Copyable {}
extension Geometry.Height: Sendable where Unit: Sendable {}
extension Geometry.Height: Equatable where Unit: Equatable & Copyable {}
extension Geometry.Height: Hashable where Unit: Hashable & Copyable {}

// MARK: - Codable

extension Geometry.Height: Codable where Unit: Codable & Copyable {}

// MARK: - AdditiveArithmetic

extension Geometry.Height: AdditiveArithmetic where Unit: AdditiveArithmetic & Copyable {
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
}

// MARK: - Comparable

extension Geometry.Height: Comparable where Unit: Comparable & Copyable {
    @inlinable
    public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.value < rhs.value
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Geometry.Height: ExpressibleByIntegerLiteral where Unit: ExpressibleByIntegerLiteral & Copyable {
    @inlinable
    public init(integerLiteral value: Unit.IntegerLiteralType) {
        self.value = Unit(integerLiteral: value)
    }
}

// MARK: - ExpressibleByFloatLiteral

extension Geometry.Height: ExpressibleByFloatLiteral where Unit: ExpressibleByFloatLiteral & Copyable {
    @inlinable
    public init(floatLiteral value: Unit.FloatLiteralType) {
        self.value = Unit(floatLiteral: value)
    }
}

// MARK: - Negation

extension Geometry.Height where Unit: SignedNumeric {
    /// Negate
    @inlinable
    public static prefix func - (value: borrowing Self) -> Self {
        Self(-value.value)
    }
}

// MARK: - Multiplication/Division

extension Geometry.Height where Unit: FloatingPoint {
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

// MARK: - Functorial Map

extension Geometry.Height {
    /// Create a Height by transforming the value of another Height
    @inlinable
    public init<U>(_ other: borrowing Geometry<U>.Height, _ transform: (U) -> Unit) {
        self.init(transform(other.value))
    }

    /// Transform the value using the given closure
    @inlinable
    public func map<E: Error, Result: ~Copyable>(
        _ transform: (Unit) throws(E) -> Result
    ) throws(E) -> Geometry<Result>.Height {
        Geometry<Result>.Height(try transform(value))
    }
}
