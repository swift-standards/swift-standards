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
    /// func setDimensions(width: Geometry.Width<Points>, height: Geometry.Height<Points>) {
    ///     // Compiler prevents accidentally swapping width and height
    /// }
    /// ```
    public struct Height {
        /// The height value
        public let value: Unit

        /// Create a height with the given value
        public init(_ value: consuming Unit) {
            self.value = value
        }
    }
}

extension Geometry.Height: Sendable where Unit: Sendable {}
extension Geometry.Height: Equatable where Unit: Equatable {}
extension Geometry.Height: Hashable where Unit: Hashable {}

// MARK: - Codable

extension Geometry.Height: Codable where Unit: Codable {}

// MARK: - AdditiveArithmetic

extension Geometry.Height: AdditiveArithmetic where Unit: AdditiveArithmetic {
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

extension Geometry.Height: Comparable where Unit: Comparable {
    public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.value < rhs.value
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
    public func map<E: Error, Result>(
        _ transform: (Unit) throws(E) -> Result
    ) throws(E) -> Geometry<Result>.Height {
        Geometry<Result>.Height(try transform(value))
    }
}
