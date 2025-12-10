// Length.swift
// A type-safe general linear measurement.

extension Geometry {
    /// A general linear measurement (length) parameterized by unit type.
    ///
    /// Use `Length` for measurements that aren't specifically horizontal or vertical,
    /// such as distances, radii, or line thicknesses.
    ///
    /// ## Example
    ///
    /// ```swift
    /// func drawCircle(center: Geometry<Points>.Point<2>, radius: Geometry<Points>.Length) {
    ///     // ...
    /// }
    /// ```
    public struct Length: ~Copyable {
        /// The length value
        public var value: Unit

        /// Create a length with the given value
        @inlinable
        public init(_ value: consuming Unit) {
            self.value = value
        }
    }
}

extension Geometry.Length: Copyable where Unit: Copyable {}
extension Geometry.Length: Sendable where Unit: Sendable {}
extension Geometry.Length: Equatable where Unit: Equatable & Copyable {}
extension Geometry.Length: Hashable where Unit: Hashable & Copyable {}

// MARK: - Codable

extension Geometry.Length: Codable where Unit: Codable & Copyable {}

// MARK: - AdditiveArithmetic

extension Geometry.Length: AdditiveArithmetic where Unit: AdditiveArithmetic & Copyable {
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

extension Geometry.Length: Comparable where Unit: Comparable & Copyable {
    @inlinable
    public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.value < rhs.value
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Geometry.Length: ExpressibleByIntegerLiteral
where Unit: ExpressibleByIntegerLiteral & Copyable {
    @inlinable
    public init(integerLiteral value: Unit.IntegerLiteralType) {
        self.value = Unit(integerLiteral: value)
    }
}

// MARK: - ExpressibleByFloatLiteral

extension Geometry.Length: ExpressibleByFloatLiteral
where Unit: ExpressibleByFloatLiteral & Copyable {
    @inlinable
    public init(floatLiteral value: Unit.FloatLiteralType) {
        self.value = Unit(floatLiteral: value)
    }
}

// MARK: - Negation

extension Geometry.Length where Unit: SignedNumeric {
    /// Negate
    @inlinable
    public static prefix func - (value: borrowing Self) -> Self {
        Self(-value.value)
    }
}

// MARK: - Multiplication/Division

extension Geometry.Length where Unit: FloatingPoint {
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

extension Geometry.Length {
    /// Create a Length by transforming the value of another Length
    @inlinable
    public init<U>(_ other: borrowing Geometry<U>.Length, _ transform: (U) -> Unit) {
        self.init(transform(other.value))
    }

    /// Transform the value using the given closure
    @inlinable
    public func map<E: Error, Result: ~Copyable>(
        _ transform: (Unit) throws(E) -> Result
    ) throws(E) -> Geometry<Result>.Length {
        Geometry<Result>.Length(try transform(value))
    }
}
