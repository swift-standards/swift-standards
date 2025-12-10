// Dimension.swift
// Type-safe dimensional measurements.

extension Geometry {
    /// A generic linear measurement parameterized by unit type.
    ///
    /// This is the base type for specific dimensional types like `Width`, `Height`, and `Length`.
    public struct Dimension: ~Copyable {
        /// The measurement value
        public var value: Unit

        /// Create a dimension with the given value
        @inlinable
        public init(_ value: consuming Unit) {
            self.value = value
        }
    }
}

extension Geometry.Dimension: Copyable where Unit: Copyable {}
extension Geometry.Dimension: Sendable where Unit: Sendable {}
extension Geometry.Dimension: Equatable where Unit: Equatable & Copyable {}
extension Geometry.Dimension: Hashable where Unit: Hashable & Copyable {}

// MARK: - Codable

extension Geometry.Dimension: Codable where Unit: Codable & Copyable {}

// MARK: - AdditiveArithmetic

extension Geometry.Dimension: AdditiveArithmetic where Unit: AdditiveArithmetic & Copyable {
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

extension Geometry.Dimension: Comparable where Unit: Comparable & Copyable {
    @inlinable
    public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.value < rhs.value
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Geometry.Dimension: ExpressibleByIntegerLiteral
where Unit: ExpressibleByIntegerLiteral & Copyable {
    @inlinable
    public init(integerLiteral value: Unit.IntegerLiteralType) {
        self.value = Unit(integerLiteral: value)
    }
}

// MARK: - ExpressibleByFloatLiteral

extension Geometry.Dimension: ExpressibleByFloatLiteral
where Unit: ExpressibleByFloatLiteral & Copyable {
    @inlinable
    public init(floatLiteral value: Unit.FloatLiteralType) {
        self.value = Unit(floatLiteral: value)
    }
}

// MARK: - Negation

extension Geometry.Dimension where Unit: SignedNumeric {
    /// Negate
    @inlinable
    public static prefix func - (value: borrowing Self) -> Self {
        Self(-value.value)
    }
}

// MARK: - Multiplication/Division

extension Geometry.Dimension where Unit: FloatingPoint {
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

extension Geometry.Dimension {
    /// Create a Dimension by transforming the value of another Dimension
    @inlinable
    public init<U>(_ other: borrowing Geometry<U>.Dimension, _ transform: (U) -> Unit) {
        self.init(transform(other.value))
    }

    /// Transform the value using the given closure
    @inlinable
    public func map<E: Error, Result: ~Copyable>(
        _ transform: (Unit) throws(E) -> Result
    ) throws(E) -> Geometry<Result>.Dimension {
        Geometry<Result>.Dimension(try transform(value))
    }
}
