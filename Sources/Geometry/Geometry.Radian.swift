// Radian.swift
// An angle measured in radians.

extension Geometry {
    /// An angle measured in radians.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let rightAngle: Geometry<Double>.Radian = .init(1.5707963267948966)
    /// ```
    public struct Radian {
        /// The value in radians
        public var value: Unit

        /// Create a radian value
        @inlinable
        public init(_ value: consuming Unit) {
            self.value = value
        }
    }
}

extension Geometry.Radian: Sendable where Unit: Sendable {}
extension Geometry.Radian: Equatable where Unit: Equatable {}
extension Geometry.Radian: Hashable where Unit: Hashable {}

// MARK: - Codable

extension Geometry.Radian: Codable where Unit: Codable {}

// MARK: - Zero

extension Geometry.Radian where Unit: AdditiveArithmetic {
    /// Zero angle
    @inlinable
    public static var zero: Self { Self(.zero) }
}

// MARK: - AdditiveArithmetic

extension Geometry.Radian: AdditiveArithmetic where Unit: AdditiveArithmetic {
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

extension Geometry.Radian: Comparable where Unit: Comparable {
    @inlinable
    public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.value < rhs.value
    }
}

// MARK: - ExpressibleByFloatLiteral

extension Geometry.Radian: ExpressibleByFloatLiteral where Unit: ExpressibleByFloatLiteral {
    @inlinable
    public init(floatLiteral value: Unit.FloatLiteralType) {
        self.value = Unit(floatLiteral: value)
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Geometry.Radian: ExpressibleByIntegerLiteral where Unit: ExpressibleByIntegerLiteral {
    @inlinable
    public init(integerLiteral value: Unit.IntegerLiteralType) {
        self.value = Unit(integerLiteral: value)
    }
}

// MARK: - Functorial Map

extension Geometry.Radian {
    /// Create a Radian by transforming the value of another Radian
    @inlinable
    public init<U>(_ other: borrowing Geometry<U>.Radian, _ transform: (U) -> Unit) {
        self.init(transform(other.value))
    }

    /// Transform the value using the given closure
    @inlinable
    public func map<E: Error, Result>(
        _ transform: (Unit) throws(E) -> Result
    ) throws(E) -> Geometry<Result>.Radian {
        Geometry<Result>.Radian(try transform(value))
    }
}
