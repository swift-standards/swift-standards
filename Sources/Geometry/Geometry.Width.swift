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
    /// func setDimensions(width: Geometry.Width<Points>, height: Geometry.Height<Points>) {
    ///     // Compiler prevents accidentally swapping width and height
    /// }
    /// ```
    public struct Width {
        /// The width value
        public let value: Unit

        /// Create a width with the given value
        public init(_ value: consuming Unit) {
            self.value = value
        }
    }
}

extension Geometry.Width: Sendable where Unit: Sendable {}
extension Geometry.Width: Equatable where Unit: Equatable {}
extension Geometry.Width: Hashable where Unit: Hashable {}

// MARK: - Codable

extension Geometry.Width: Codable where Unit: Codable {}

// MARK: - AdditiveArithmetic

extension Geometry.Width: AdditiveArithmetic where Unit: AdditiveArithmetic {
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

extension Geometry.Width: Comparable where Unit: Comparable {
    public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.value < rhs.value
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
    public func map<E: Error, Result>(
        _ transform: (Unit) throws(E) -> Result
    ) throws(E) -> Geometry<Result>.Width {
        Geometry<Result>.Width(try transform(value))
    }
}
