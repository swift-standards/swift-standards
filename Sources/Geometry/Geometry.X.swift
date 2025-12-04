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
    /// func setPosition(x: Geometry.X<Points>, y: Geometry.Y<Points>) {
    ///     // Compiler prevents accidentally swapping x and y
    /// }
    /// ```
    public struct X {
        /// The x coordinate value
        public let value: Unit

        /// Create an x coordinate with the given value
        public init(_ value: consuming Unit) {
            self.value = value
        }
    }
}

extension Geometry.X: Sendable where Unit: Sendable {}
extension Geometry.X: Equatable where Unit: Equatable {}
extension Geometry.X: Hashable where Unit: Hashable {}

// MARK: - Codable

extension Geometry.X: Codable where Unit: Codable {}

// MARK: - AdditiveArithmetic

extension Geometry.X: AdditiveArithmetic where Unit: AdditiveArithmetic {
    @inlinable
    public static var zero: Self {
        Self(.zero)
    }

    public static func + (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        Self(lhs.value + rhs.value)
    }

    public static func - (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        Self(lhs.value - rhs.value)
    }
}

// MARK: - Comparable

extension Geometry.X: Comparable where Unit: Comparable {
    public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.value < rhs.value
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Geometry.X: ExpressibleByIntegerLiteral where Unit: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Unit.IntegerLiteralType) {
        self.value = Unit(integerLiteral: value)
    }
}

// MARK: - ExpressibleByFloatLiteral

extension Geometry.X: ExpressibleByFloatLiteral where Unit: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Unit.FloatLiteralType) {
        self.value = Unit(floatLiteral: value)
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
    public func map<E: Error, Result>(
        _ transform: (Unit) throws(E) -> Result
    ) throws(E) -> Geometry<Result>.X {
        Geometry<Result>.X(try transform(value))
    }
}
