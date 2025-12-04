// Degree.swift
// An angle measured in degrees.

extension Geometry {
    /// An angle measured in degrees.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let rightAngle: Geometry<Double>.Degree = .init(90)
    /// ```
    public struct Degree {
        /// The value in degrees
        public var value: Unit

        /// Create a degree value
        @inlinable
        public init(_ value: consuming Unit) {
            self.value = value
        }
    }
}

extension Geometry.Degree: Sendable where Unit: Sendable {}
extension Geometry.Degree: Equatable where Unit: Equatable {}
extension Geometry.Degree: Hashable where Unit: Hashable {}

// MARK: - Codable

extension Geometry.Degree: Codable where Unit: Codable {}

// MARK: - Zero

extension Geometry.Degree where Unit: AdditiveArithmetic {
    /// Zero angle
    @inlinable
    public static var zero: Self { Self(.zero) }
}

// MARK: - AdditiveArithmetic

extension Geometry.Degree: AdditiveArithmetic where Unit: AdditiveArithmetic {
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

extension Geometry.Degree: Comparable where Unit: Comparable {
    @inlinable
    public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.value < rhs.value
    }
}

// MARK: - ExpressibleByFloatLiteral

extension Geometry.Degree: ExpressibleByFloatLiteral where Unit: ExpressibleByFloatLiteral {
    @inlinable
    public init(floatLiteral value: Unit.FloatLiteralType) {
        self.value = Unit(floatLiteral: value)
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Geometry.Degree: ExpressibleByIntegerLiteral where Unit: ExpressibleByIntegerLiteral {
    @inlinable
    public init(integerLiteral value: Unit.IntegerLiteralType) {
        self.value = Unit(integerLiteral: value)
    }
}

// MARK: - Functorial Map

extension Geometry.Degree {
    /// Create a Degree by transforming the value of another Degree
    @inlinable
    public init<U>(_ other: borrowing Geometry<U>.Degree, _ transform: (U) -> Unit) {
        self.init(transform(other.value))
    }

    /// Transform the value using the given closure
    @inlinable
    public func map<E: Error, Result>(
        _ transform: (Unit) throws(E) -> Result
    ) throws(E) -> Geometry<Result>.Degree {
        Geometry<Result>.Degree(try transform(value))
    }
}
