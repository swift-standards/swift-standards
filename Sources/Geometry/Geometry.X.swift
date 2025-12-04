// X.swift
// A type-safe horizontal coordinate.

extension Geometry {
    /// A horizontal coordinate (x-position) parameterized by unit type.
    ///
    /// Use `X` when you need type safety to distinguish horizontal
    /// coordinates from vertical ones.
    ///
    /// ## Example
    ///
    /// ```swift
    /// func setPosition(x: Geometry<Points>.X, y: Geometry<Points>.Y) {
    ///     // Compiler prevents accidentally swapping x and y
    /// }
    /// ```
    public struct X: ~Copyable {
        /// The x coordinate value
        public var value: Unit

        /// Create an x coordinate with the given value
        @inlinable
        public init(_ value: consuming Unit) {
            self.value = value
        }
    }
}

extension Geometry.X: Copyable where Unit: Copyable {}
extension Geometry.X: Sendable where Unit: Sendable {}
extension Geometry.X: Equatable where Unit: Equatable & Copyable {}
extension Geometry.X: Hashable where Unit: Hashable & Copyable {}

// MARK: - Codable

extension Geometry.X: Codable where Unit: Codable & Copyable {}

// MARK: - AdditiveArithmetic

extension Geometry.X: AdditiveArithmetic where Unit: AdditiveArithmetic & Copyable {
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

extension Geometry.X: Comparable where Unit: Comparable & Copyable {
    @inlinable
    public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.value < rhs.value
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Geometry.X: ExpressibleByIntegerLiteral where Unit: ExpressibleByIntegerLiteral & Copyable {
    @inlinable
    public init(integerLiteral value: Unit.IntegerLiteralType) {
        self.value = Unit(integerLiteral: value)
    }
}

// MARK: - ExpressibleByFloatLiteral

extension Geometry.X: ExpressibleByFloatLiteral where Unit: ExpressibleByFloatLiteral & Copyable {
    @inlinable
    public init(floatLiteral value: Unit.FloatLiteralType) {
        self.value = Unit(floatLiteral: value)
    }
}

// MARK: - Negation

extension Geometry.X where Unit: SignedNumeric {
    /// Negate
    @inlinable
    public static prefix func - (value: borrowing Self) -> Self {
        Self(-value.value)
    }
}

// MARK: - Multiplication/Division

extension Geometry.X where Unit: FloatingPoint {
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

extension Geometry.X {
    /// Create an X coordinate by transforming the value of another X coordinate
    @inlinable
    public init<U>(_ other: borrowing Geometry<U>.X, _ transform: (U) -> Unit) {
        self.init(transform(other.value))
    }

    /// Transform the value using the given closure
    @inlinable
    public func map<E: Error, Result: ~Copyable>(
        _ transform: (Unit) throws(E) -> Result
    ) throws(E) -> Geometry<Result>.X {
        Geometry<Result>.X(try transform(value))
    }
}
