// Width.swift
// A type-safe horizontal measurement.

extension Geometry {
    /// A horizontal measurement (width) parameterized by unit type.
    ///
    /// Use `Width` when you need type safety to distinguish horizontal
    /// measurements from vertical ones.
    ///
    /// ## Example
    ///
    /// ```swift
    /// func setDimensions(width: Geometry<Points>.Width, height: Geometry<Points>.Height) {
    ///     // Compiler prevents accidentally swapping width and height
    /// }
    /// ```
    public struct Width: ~Copyable {
        /// The width value
        public var value: Unit

        /// Create a width with the given value
        @inlinable
        public init(_ value: consuming Unit) {
            self.value = value
        }
    }
}

extension Geometry.Width: Copyable where Unit: Copyable {}
extension Geometry.Width: Sendable where Unit: Sendable {}
extension Geometry.Width: Equatable where Unit: Equatable & Copyable {}
extension Geometry.Width: Hashable where Unit: Hashable & Copyable {}

// MARK: - Codable

extension Geometry.Width: Codable where Unit: Codable & Copyable {}

// MARK: - AdditiveArithmetic

extension Geometry.Width: AdditiveArithmetic where Unit: AdditiveArithmetic & Copyable {
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

extension Geometry.Width: Comparable where Unit: Comparable & Copyable {
    @inlinable
    public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.value < rhs.value
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Geometry.Width: ExpressibleByIntegerLiteral
where Unit: ExpressibleByIntegerLiteral & Copyable {
    @inlinable
    public init(integerLiteral value: Unit.IntegerLiteralType) {
        self.value = Unit(integerLiteral: value)
    }
}

// MARK: - ExpressibleByFloatLiteral

extension Geometry.Width: ExpressibleByFloatLiteral
where Unit: ExpressibleByFloatLiteral & Copyable {
    @inlinable
    public init(floatLiteral value: Unit.FloatLiteralType) {
        self.value = Unit(floatLiteral: value)
    }
}

// MARK: - Negation

extension Geometry.Width where Unit: SignedNumeric {
    /// Negate
    @inlinable
    public static prefix func - (value: borrowing Self) -> Self {
        Self(-value.value)
    }
}

// MARK: - Multiplication/Division

extension Geometry.Width where Unit: FloatingPoint {
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

extension Geometry.Width {
    /// Create a Width by transforming the value of another Width
    @inlinable
    public init<U>(_ other: borrowing Geometry<U>.Width, _ transform: (U) -> Unit) {
        self.init(transform(other.value))
    }

    /// Transform the value using the given closure
    @inlinable
    public func map<E: Error, Result: ~Copyable>(
        _ transform: (Unit) throws(E) -> Result
    ) throws(E) -> Geometry<Result>.Width {
        Geometry<Result>.Width(try transform(value))
    }
}
