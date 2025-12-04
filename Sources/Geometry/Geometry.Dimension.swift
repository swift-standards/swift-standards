// Dimension.swift
// Type-safe dimensional measurements.

extension Geometry {
    /// A generic linear measurement parameterized by unit type.
    ///
    /// This is the base type for specific dimensional types like `Width`, `Height`, and `Length`.
    public struct Dimension {
        /// The measurement value
        public let value: Unit

        /// Create a dimension with the given value
        public init(_ value: consuming Unit) {
            self.value = value
        }
    }
}

extension Geometry.Dimension: Sendable where Unit: Sendable {}
extension Geometry.Dimension: Equatable where Unit: Equatable {}
extension Geometry.Dimension: Hashable where Unit: Hashable {}

// MARK: - Codable

extension Geometry.Dimension: Codable where Unit: Codable {}

// MARK: - AdditiveArithmetic

extension Geometry.Dimension: AdditiveArithmetic where Unit: AdditiveArithmetic {
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

extension Geometry.Dimension: Comparable where Unit: Comparable {
    public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.value < rhs.value
    }
}
