// Tagged.swift
// A phantom-type wrapper for type-safe value distinction.
//
// Inspired by swift-tagged by Point-Free (https://github.com/pointfreeco/swift-tagged)
// This implementation extends the concept with coordinate/displacement arithmetic.

/// A value wrapped with a compile-time phantom type tag.
///
/// `Tagged` provides zero-cost type safety by wrapping a raw value with a phantom `Tag` parameter that exists only at compile time. Use it to prevent mixing incompatible values (user IDs vs order IDs), distinguish units (meters vs feet), or enforce domain boundaries (validated vs raw strings).
///
/// The tag adds no runtime overhead—only the raw value is stored. This is the foundation for coordinate/displacement arithmetic in affine geometry.
///
/// ## Example
///
/// ```swift
/// enum UserIDTag {}
/// enum OrderIDTag {}
/// typealias UserID = Tagged<UserIDTag, Int>
/// typealias OrderID = Tagged<OrderIDTag, Int>
///
/// let user: UserID = 42
/// let order: OrderID = 42
/// // user == order  // Error: cannot compare different tagged types
/// ```
public struct Tagged<Tag, RawValue> {
    /// Underlying raw value.
    public var rawValue: RawValue

    /// Creates a tagged value from a raw value.
    @inlinable
    public init(_ rawValue: RawValue) {
        self.rawValue = rawValue
    }

    /// Creates a tagged value from a raw value.
    @inlinable
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
}

// MARK: - Conditional Conformances

extension Tagged: Sendable where RawValue: Sendable {}
extension Tagged: Equatable where RawValue: Equatable {}
extension Tagged: Hashable where RawValue: Hashable {}

#if Codable
    extension Tagged: Codable where RawValue: Codable {}
#endif
extension Tagged: Comparable where RawValue: Comparable {
    @inlinable
    public static func < (lhs: Tagged, rhs: Tagged) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

// MARK: - Functor

extension Tagged {
    /// Transforms the raw value while preserving the tag.
    @inlinable
    public func map<NewRawValue>(
        _ transform: (RawValue) throws -> NewRawValue
    ) rethrows -> Tagged<Tag, NewRawValue> {
        Tagged<Tag, NewRawValue>(try transform(rawValue))
    }

    /// Changes the tag type while preserving the raw value (zero-cost conversion).
    @inlinable
    public func retag<NewTag>(_: NewTag.Type = NewTag.self) -> Tagged<NewTag, RawValue> {
        Tagged<NewTag, RawValue>(rawValue)
    }
}

// MARK: - ExpressibleBy Literals

extension Tagged: ExpressibleByIntegerLiteral where RawValue: ExpressibleByIntegerLiteral {
    @inlinable
    public init(integerLiteral value: RawValue.IntegerLiteralType) {
        self.rawValue = RawValue(integerLiteral: value)
    }
}

extension Tagged: ExpressibleByFloatLiteral where RawValue: ExpressibleByFloatLiteral {
    @inlinable
    public init(floatLiteral value: RawValue.FloatLiteralType) {
        self.rawValue = RawValue(floatLiteral: value)
    }
}

extension Tagged: ExpressibleByUnicodeScalarLiteral
where RawValue: ExpressibleByUnicodeScalarLiteral {
    @inlinable
    public init(unicodeScalarLiteral value: RawValue.UnicodeScalarLiteralType) {
        self.rawValue = RawValue(unicodeScalarLiteral: value)
    }
}

extension Tagged: ExpressibleByExtendedGraphemeClusterLiteral
where RawValue: ExpressibleByExtendedGraphemeClusterLiteral {
    @inlinable
    public init(extendedGraphemeClusterLiteral value: RawValue.ExtendedGraphemeClusterLiteralType) {
        self.rawValue = RawValue(extendedGraphemeClusterLiteral: value)
    }
}

extension Tagged: ExpressibleByStringLiteral where RawValue: ExpressibleByStringLiteral {
    @inlinable
    public init(stringLiteral value: RawValue.StringLiteralType) {
        self.rawValue = RawValue(stringLiteral: value)
    }
}

extension Tagged: ExpressibleByBooleanLiteral where RawValue: ExpressibleByBooleanLiteral {
    @inlinable
    public init(booleanLiteral value: RawValue.BooleanLiteralType) {
        self.rawValue = RawValue(booleanLiteral: value)
    }
}

// MARK: - Value Alias

extension Tagged {
    /// Convenient alias for `rawValue`.
    @inlinable
    public var value: RawValue {
        get { rawValue }
        set { rawValue = newValue }
    }
}

// MARK: - AdditiveArithmetic

extension Tagged: AdditiveArithmetic where RawValue: AdditiveArithmetic {
    @inlinable
    public static var zero: Self {
        Self(.zero)
    }

    @inlinable
    @_disfavoredOverload
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(lhs.rawValue + rhs.rawValue)
    }

    @inlinable
    @_disfavoredOverload
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(lhs.rawValue - rhs.rawValue)
    }
}

// MARK: - Scalar Arithmetic

extension Tagged where RawValue: AdditiveArithmetic {
    /// Adds a raw scalar to a tagged value.
    @inlinable
    @_disfavoredOverload
    public static func + (lhs: Self, rhs: RawValue) -> Self {
        Self(lhs.rawValue + rhs)
    }

    /// Adds a tagged value to a raw scalar.
    @inlinable
    @_disfavoredOverload
    public static func + (lhs: RawValue, rhs: Self) -> Self {
        Self(lhs + rhs.rawValue)
    }

    /// Subtracts a raw scalar from a tagged value.
    @inlinable
    @_disfavoredOverload
    public static func - (lhs: Self, rhs: RawValue) -> Self {
        Self(lhs.rawValue - rhs)
    }

    /// Subtracts a tagged value from a raw scalar.
    @inlinable
    @_disfavoredOverload
    public static func - (lhs: RawValue, rhs: Self) -> Self {
        Self(lhs - rhs.rawValue)
    }
}

// MARK: - Negation

extension Tagged where RawValue: SignedNumeric {
    /// Returns the negation of this value.
    @inlinable
    public static prefix func - (value: Self) -> Self {
        Self(-value.rawValue)
    }
}

// MARK: - Absolute Value, Min, Max

/// Returns the absolute value of a tagged value.
@inlinable
public func abs<Tag, T: SignedNumeric & Comparable>(_ x: Tagged<Tag, T>) -> Tagged<Tag, T> {
    Tagged(abs(x.rawValue))
}

/// Returns the minimum of two tagged values.
@inlinable
public func min<Tag, T: Comparable>(_ x: Tagged<Tag, T>, _ y: Tagged<Tag, T>) -> Tagged<Tag, T> {
    x.rawValue <= y.rawValue ? x : y
}

/// Returns the maximum of two tagged values.
@inlinable
public func max<Tag, T: Comparable>(_ x: Tagged<Tag, T>, _ y: Tagged<Tag, T>) -> Tagged<Tag, T> {
    x.rawValue >= y.rawValue ? x : y
}

// MARK: - Multiplication/Division

extension Tagged where RawValue: FloatingPoint {
    /// Multiplies a tagged value by a scalar.
    @inlinable
    public static func * (lhs: Self, rhs: RawValue) -> Self {
        Self(lhs.rawValue * rhs)
    }

    /// Multiplies a scalar by a tagged value.
    @inlinable
    public static func * (lhs: RawValue, rhs: Self) -> Self {
        Self(lhs * rhs.rawValue)
    }

    /// Divides a tagged value by a scalar.
    @inlinable
    public static func / (lhs: Self, rhs: RawValue) -> Self {
        Self(lhs.rawValue / rhs)
    }
}

// MARK: - Squared (same tag multiplication)

extension Tagged where RawValue: Numeric {
    /// Multiplies two same-tagged values, returning the raw squared magnitude.
    @inlinable
    @_disfavoredOverload
    public static func * (lhs: Self, rhs: Self) -> RawValue {
        lhs.rawValue * rhs.rawValue
    }
}

// MARK: - Same Tag Division (ratio)

extension Tagged where RawValue: FloatingPoint {
    /// Divides two same-tagged values, returning the raw ratio.
    @inlinable
    @_disfavoredOverload
    public static func / (lhs: Self, rhs: Self) -> RawValue {
        lhs.rawValue / rhs.rawValue
    }
}

// MARK: - Compound Assignment Operators

extension Tagged where RawValue: AdditiveArithmetic {
    /// Add and assign
    @inlinable
    public static func += (lhs: inout Self, rhs: Self) {
        lhs.rawValue = lhs.rawValue + rhs.rawValue
    }

    /// Subtract and assign
    @inlinable
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs.rawValue = lhs.rawValue - rhs.rawValue
    }

    /// Add scalar and assign
    @inlinable
    @_disfavoredOverload
    public static func += (lhs: inout Self, rhs: RawValue) {
        lhs.rawValue = lhs.rawValue + rhs
    }

    /// Subtract scalar and assign
    @inlinable
    @_disfavoredOverload
    public static func -= (lhs: inout Self, rhs: RawValue) {
        lhs.rawValue = lhs.rawValue - rhs
    }
}

extension Tagged where RawValue: FloatingPoint {
    /// Multiply and assign by scalar
    @inlinable
    public static func *= (lhs: inout Self, rhs: RawValue) {
        lhs.rawValue = lhs.rawValue * rhs
    }

    /// Divide and assign by scalar
    @inlinable
    public static func /= (lhs: inout Self, rhs: RawValue) {
        lhs.rawValue = lhs.rawValue / rhs
    }
}

// MARK: - Cross-Axis Displacement Multiplication

// Displacement cross products: Dx × Dy = Area (scalar), Width × Height = scalar

extension Tagged where Tag == Index.X.Displacement, RawValue: Numeric {
    /// Multiplies X-displacement by Y-displacement, returning area (scalar).
    @inlinable
    @_disfavoredOverload
    public static func * (lhs: Self, rhs: Tagged<Index.Y.Displacement, RawValue>) -> RawValue {
        lhs.rawValue * rhs.rawValue
    }

    /// Multiplies X-displacement by Z-displacement, returning a scalar.
    @inlinable
    @_disfavoredOverload
    public static func * (lhs: Self, rhs: Tagged<Index.Z.Displacement, RawValue>) -> RawValue {
        lhs.rawValue * rhs.rawValue
    }
}

extension Tagged where Tag == Index.Y.Displacement, RawValue: Numeric {
    /// Multiplies Y-displacement by X-displacement, returning area (scalar).
    @inlinable
    @_disfavoredOverload
    public static func * (lhs: Self, rhs: Tagged<Index.X.Displacement, RawValue>) -> RawValue {
        lhs.rawValue * rhs.rawValue
    }

    /// Multiplies Y-displacement by Z-displacement, returning a scalar.
    @inlinable
    @_disfavoredOverload
    public static func * (lhs: Self, rhs: Tagged<Index.Z.Displacement, RawValue>) -> RawValue {
        lhs.rawValue * rhs.rawValue
    }
}

extension Tagged where Tag == Index.Z.Displacement, RawValue: Numeric {
    /// Multiplies Z-displacement by X-displacement, returning a scalar.
    @inlinable
    @_disfavoredOverload
    public static func * (lhs: Self, rhs: Tagged<Index.X.Displacement, RawValue>) -> RawValue {
        lhs.rawValue * rhs.rawValue
    }

    /// Multiplies Z-displacement by Y-displacement, returning a scalar.
    @inlinable
    @_disfavoredOverload
    public static func * (lhs: Self, rhs: Tagged<Index.Y.Displacement, RawValue>) -> RawValue {
        lhs.rawValue * rhs.rawValue
    }
}

// MARK: - Mixed Coordinate/Displacement Arithmetic

// Affine geometry: Point + Vector = Point, Point - Point = Vector, Point - Vector = Point

extension Tagged where Tag == Index.X.Coordinate, RawValue: AdditiveArithmetic {
    /// Adds a displacement to a coordinate, returning a coordinate.
    @inlinable
    public static func + (lhs: Self, rhs: Tagged<Index.X.Displacement, RawValue>) -> Self {
        Self(lhs.rawValue + rhs.rawValue)
    }

    /// Subtracts two coordinates, returning a displacement.
    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Tagged<Index.X.Displacement, RawValue> {
        Tagged<Index.X.Displacement, RawValue>(lhs.rawValue - rhs.rawValue)
    }

    /// Subtracts a displacement from a coordinate, returning a coordinate.
    @inlinable
    public static func - (lhs: Self, rhs: Tagged<Index.X.Displacement, RawValue>) -> Self {
        Self(lhs.rawValue - rhs.rawValue)
    }
}

extension Tagged where Tag == Index.Y.Coordinate, RawValue: AdditiveArithmetic {
    /// Adds a displacement to a coordinate, returning a coordinate.
    @inlinable
    public static func + (lhs: Self, rhs: Tagged<Index.Y.Displacement, RawValue>) -> Self {
        Self(lhs.rawValue + rhs.rawValue)
    }

    /// Subtracts two coordinates, returning a displacement.
    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Tagged<Index.Y.Displacement, RawValue> {
        Tagged<Index.Y.Displacement, RawValue>(lhs.rawValue - rhs.rawValue)
    }

    /// Subtracts a displacement from a coordinate, returning a coordinate.
    @inlinable
    public static func - (lhs: Self, rhs: Tagged<Index.Y.Displacement, RawValue>) -> Self {
        Self(lhs.rawValue - rhs.rawValue)
    }
}

extension Tagged where Tag == Index.Z.Coordinate, RawValue: AdditiveArithmetic {
    /// Adds a displacement to a coordinate, returning a coordinate.
    @inlinable
    public static func + (lhs: Self, rhs: Tagged<Index.Z.Displacement, RawValue>) -> Self {
        Self(lhs.rawValue + rhs.rawValue)
    }

    /// Subtracts two coordinates, returning a displacement.
    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Tagged<Index.Z.Displacement, RawValue> {
        Tagged<Index.Z.Displacement, RawValue>(lhs.rawValue - rhs.rawValue)
    }

    /// Subtracts a displacement from a coordinate, returning a coordinate.
    @inlinable
    public static func - (lhs: Self, rhs: Tagged<Index.Z.Displacement, RawValue>) -> Self {
        Self(lhs.rawValue - rhs.rawValue)
    }
}

// MARK: - Strideable

extension Tagged: Strideable where RawValue: Strideable {
    public typealias Stride = RawValue.Stride

    @inlinable
    public func distance(to other: Self) -> Stride {
        rawValue.distance(to: other.rawValue)
    }

    @inlinable
    public func advanced(by n: Stride) -> Self {
        Self(rawValue.advanced(by: n))
    }
}
