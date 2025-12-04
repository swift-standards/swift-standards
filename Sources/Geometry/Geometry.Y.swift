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
    /// func setPosition(x: Geometry.X<Points>, y: Geometry.Y<Points>) {
    ///     // Compiler prevents accidentally swapping x and y
    /// }
    /// ```
    public struct Y {
        /// The y coordinate value
        public let value: Unit

        /// Create a y coordinate with the given value
        public init(_ value: consuming Unit) {
            self.value = value
        }
    }
}

extension Geometry.Y: Sendable where Unit: Sendable {}
extension Geometry.Y: Equatable where Unit: Equatable {}
extension Geometry.Y: Hashable where Unit: Hashable {}

// MARK: - Codable

extension Geometry.Y: Codable where Unit: Codable {}

// MARK: - AdditiveArithmetic

extension Geometry.Y: AdditiveArithmetic where Unit: AdditiveArithmetic {
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

extension Geometry.Y: Comparable where Unit: Comparable {
    public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.value < rhs.value
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Geometry.Y: ExpressibleByIntegerLiteral where Unit: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Unit.IntegerLiteralType) {
        self.value = Unit(integerLiteral: value)
    }
}

// MARK: - ExpressibleByFloatLiteral

extension Geometry.Y: ExpressibleByFloatLiteral where Unit: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Unit.FloatLiteralType) {
        self.value = Unit(floatLiteral: value)
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
    public func map<E: Error, Result>(
        _ transform: (Unit) throws(E) -> Result
    ) throws(E) -> Geometry<Result>.Y {
        Geometry<Result>.Y(try transform(value))
    }
}
