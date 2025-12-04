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
    /// func drawCircle(center: Geometry.Point<Points>, radius: Geometry.Length<Points>) {
    ///     // ...
    /// }
    /// ```
    public struct Length {
        /// The length value
        public let value: Unit

        /// Create a length with the given value
        public init(_ value: consuming Unit) {
            self.value = value
        }
    }
}

extension Geometry.Length: Sendable where Unit: Sendable {}
extension Geometry.Length: Equatable where Unit: Equatable {}
extension Geometry.Length: Hashable where Unit: Hashable {}

// MARK: - Codable

extension Geometry.Length: Codable where Unit: Codable {}

// MARK: - AdditiveArithmetic

extension Geometry.Length: AdditiveArithmetic where Unit: AdditiveArithmetic {
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

extension Geometry.Length: Comparable where Unit: Comparable {
    public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.value < rhs.value
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
    public func map<E: Error, Result>(
        _ transform: (Unit) throws(E) -> Result
    ) throws(E) -> Geometry<Result>.Length {
        Geometry<Result>.Length(try transform(value))
    }
}
