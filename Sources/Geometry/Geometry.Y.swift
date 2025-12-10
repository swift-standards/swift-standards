// Y.swift
// A type-safe vertical coordinate.

extension Geometry {
    /// A vertical coordinate (y-position) parameterized by unit type.
    ///
    /// Use `Y` when you need type safety to distinguish vertical
    /// coordinates from horizontal ones.
    ///
    /// ## Example
    ///
    /// ```swift
    /// func setPosition(x: Geometry<Points>.X, y: Geometry<Points>.Y) {
    ///     // Compiler prevents accidentally swapping x and y
    /// }
    /// ```
    public struct Y: ~Copyable {
        /// The y coordinate value
        public var value: Unit

        /// Create a y coordinate with the given value
        @inlinable
        public init(_ value: consuming Unit) {
            self.value = value
        }
    }
}

extension Geometry.Y: Copyable where Unit: Copyable {}
extension Geometry.Y: Sendable where Unit: Sendable {}
extension Geometry.Y: Equatable where Unit: Equatable & Copyable {}
extension Geometry.Y: Hashable where Unit: Hashable & Copyable {}

// MARK: - Codable

extension Geometry.Y: Codable where Unit: Codable & Copyable {}

// MARK: - AdditiveArithmetic

extension Geometry.Y: AdditiveArithmetic where Unit: AdditiveArithmetic & Copyable {
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

extension Geometry.Y: Comparable where Unit: Comparable & Copyable {
    @inlinable
    public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.value < rhs.value
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Geometry.Y: ExpressibleByIntegerLiteral
where Unit: ExpressibleByIntegerLiteral & Copyable {
    @inlinable
    public init(integerLiteral value: Unit.IntegerLiteralType) {
        self.value = Unit(integerLiteral: value)
    }
}

// MARK: - ExpressibleByFloatLiteral

extension Geometry.Y: ExpressibleByFloatLiteral where Unit: ExpressibleByFloatLiteral & Copyable {
    @inlinable
    public init(floatLiteral value: Unit.FloatLiteralType) {
        self.value = Unit(floatLiteral: value)
    }
}

// MARK: - Negation

extension Geometry.Y where Unit: SignedNumeric {
    /// Negate
    @inlinable
    public static prefix func - (value: borrowing Self) -> Self {
        Self(-value.value)
    }
}

// MARK: - Multiplication/Division

extension Geometry.Y where Unit: FloatingPoint {
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

extension Geometry.Y {
    /// Create a Y coordinate by transforming the value of another Y coordinate
    @inlinable
    public init<U>(_ other: borrowing Geometry<U>.Y, _ transform: (U) -> Unit) {
        self.init(transform(other.value))
    }

    /// Transform the value using the given closure
    @inlinable
    public func map<E: Error, Result: ~Copyable>(
        _ transform: (Unit) throws(E) -> Result
    ) throws(E) -> Geometry<Result>.Y {
        Geometry<Result>.Y(try transform(value))
    }
}
