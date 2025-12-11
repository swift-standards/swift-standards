// Tagged.swift
// A phantom-type wrapper for type-safe value distinction.

/// A value distinguished by a phantom type tag.
///
/// `Tagged` wraps a raw value with a phantom type parameter that exists
/// only at compile-time. This allows the type system to distinguish
/// otherwise identical types without runtime overhead.
///
/// ## Examples
///
/// ```swift
/// // Define phantom types for different ID domains
/// enum UserIDTag {}
/// enum OrderIDTag {}
///
/// typealias UserID = Tagged<UserIDTag, Int>
/// typealias OrderID = Tagged<OrderIDTag, Int>
///
/// let userId: UserID = Tagged(42)
/// let orderId: OrderID = Tagged(42)
///
/// // These are different types despite both wrapping Int:
/// // userId == orderId  // Compile error: cannot compare UserID with OrderID
/// ```
///
/// ## Use Cases
///
/// - **Type-safe identifiers**: Prevent mixing user IDs with order IDs
/// - **Units**: Distinguish meters from feet at the type level
/// - **Domain boundaries**: Mark validated vs unvalidated strings
///
/// ## Note
///
/// Unlike `Pair<Tag, Value>` which stores both components, `Tagged`
/// only stores the raw value. The tag is purely a compile-time marker
/// with zero runtime cost.
///
public struct Tagged<Tag, RawValue> {
    /// The underlying value.
    public var rawValue: RawValue

    /// Creates a tagged value.
    @inlinable
    public init(_ rawValue: RawValue) {
        self.rawValue = rawValue
    }

    /// Creates a tagged value.
    @inlinable
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
}

// MARK: - Conditional Conformances

extension Tagged: Sendable where RawValue: Sendable {}
extension Tagged: Equatable where RawValue: Equatable {}
extension Tagged: Hashable where RawValue: Hashable {}
extension Tagged: Codable where RawValue: Codable {}
extension Tagged: Comparable where RawValue: Comparable {
    @inlinable
    public static func < (lhs: Tagged, rhs: Tagged) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

// MARK: - Functor

extension Tagged {
    /// Transform the raw value while preserving the tag.
    ///
    /// This is the functorial map for `Tagged<Tag, _>`.
    @inlinable
    public func map<NewRawValue>(
        _ transform: (RawValue) throws -> NewRawValue
    ) rethrows -> Tagged<Tag, NewRawValue> {
        Tagged<Tag, NewRawValue>(try transform(rawValue))
    }

    /// Change the tag type while preserving the raw value.
    ///
    /// This is a zero-cost type conversion since the tag is phantom.
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
    /// Alias for `rawValue` - convenient for coordinate-style usage.
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
    /// Add a raw scalar
    @inlinable
    @_disfavoredOverload
    public static func + (lhs: Self, rhs: RawValue) -> Self {
        Self(lhs.rawValue + rhs)
    }

    /// Add to a raw scalar
    @inlinable
    @_disfavoredOverload
    public static func + (lhs: RawValue, rhs: Self) -> Self {
        Self(lhs + rhs.rawValue)
    }

    /// Subtract a raw scalar
    @inlinable
    @_disfavoredOverload
    public static func - (lhs: Self, rhs: RawValue) -> Self {
        Self(lhs.rawValue - rhs)
    }

    /// Subtract from a raw scalar
    @inlinable
    @_disfavoredOverload
    public static func - (lhs: RawValue, rhs: Self) -> Self {
        Self(lhs - rhs.rawValue)
    }
}

// MARK: - Negation

extension Tagged where RawValue: SignedNumeric {
    /// Negate
    @inlinable
    public static prefix func - (value: Self) -> Self {
        Self(-value.rawValue)
    }
}

// MARK: - Absolute Value, Min, Max

/// Absolute value of a tagged value.
///
/// Mathematically, the absolute value of a coordinate remains in the same
/// coordinate space (unlike multiplication which produces a scalar).
@inlinable
public func abs<Tag, T: SignedNumeric & Comparable>(_ x: Tagged<Tag, T>) -> Tagged<Tag, T> {
    Tagged(abs(x.rawValue))
}

/// Minimum of two tagged values.
@inlinable
public func min<Tag, T: Comparable>(_ x: Tagged<Tag, T>, _ y: Tagged<Tag, T>) -> Tagged<Tag, T> {
    x.rawValue <= y.rawValue ? x : y
}

/// Maximum of two tagged values.
@inlinable
public func max<Tag, T: Comparable>(_ x: Tagged<Tag, T>, _ y: Tagged<Tag, T>) -> Tagged<Tag, T> {
    x.rawValue >= y.rawValue ? x : y
}

// MARK: - Multiplication/Division

extension Tagged where RawValue: FloatingPoint {
    /// Multiply by a scalar
    @inlinable
    public static func * (lhs: Self, rhs: RawValue) -> Self {
        Self(lhs.rawValue * rhs)
    }

    /// Multiply scalar by value
    @inlinable
    public static func * (lhs: RawValue, rhs: Self) -> Self {
        Self(lhs * rhs.rawValue)
    }

    /// Divide by a scalar
    @inlinable
    public static func / (lhs: Self, rhs: RawValue) -> Self {
        Self(lhs.rawValue / rhs)
    }
}

// MARK: - Squared (same tag multiplication)

extension Tagged where RawValue: Numeric {
    /// Multiply two same-tagged values to get squared magnitude.
    ///
    /// Useful for distance calculations: `dx*dx + dy*dy`
    @inlinable
    @_disfavoredOverload
    public static func * (lhs: Self, rhs: Self) -> RawValue {
        lhs.rawValue * rhs.rawValue
    }
}

// MARK: - Same Tag Division (ratio)

extension Tagged where RawValue: FloatingPoint {
    /// Divide two same-tagged values to get a ratio.
    ///
    /// Useful for normalization: `dx / length`
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

// Displacement cross products: Dx * Dy = Area (scalar), etc.
// Width * Height produces a scalar (area).

extension Tagged where Tag == Index.X.Displacement, RawValue: Numeric {
    /// Multiply Dx by Dy to get a scalar (area).
    @inlinable
    @_disfavoredOverload
    public static func * (lhs: Self, rhs: Tagged<Index.Y.Displacement, RawValue>) -> RawValue {
        lhs.rawValue * rhs.rawValue
    }

    /// Multiply Dx by Dz to get a scalar.
    @inlinable
    @_disfavoredOverload
    public static func * (lhs: Self, rhs: Tagged<Index.Z.Displacement, RawValue>) -> RawValue {
        lhs.rawValue * rhs.rawValue
    }
}

extension Tagged where Tag == Index.Y.Displacement, RawValue: Numeric {
    /// Multiply Dy by Dx to get a scalar (area).
    @inlinable
    @_disfavoredOverload
    public static func * (lhs: Self, rhs: Tagged<Index.X.Displacement, RawValue>) -> RawValue {
        lhs.rawValue * rhs.rawValue
    }

    /// Multiply Dy by Dz to get a scalar.
    @inlinable
    @_disfavoredOverload
    public static func * (lhs: Self, rhs: Tagged<Index.Z.Displacement, RawValue>) -> RawValue {
        lhs.rawValue * rhs.rawValue
    }
}

extension Tagged where Tag == Index.Z.Displacement, RawValue: Numeric {
    /// Multiply Dz by Dx to get a scalar.
    @inlinable
    @_disfavoredOverload
    public static func * (lhs: Self, rhs: Tagged<Index.X.Displacement, RawValue>) -> RawValue {
        lhs.rawValue * rhs.rawValue
    }

    /// Multiply Dz by Dy to get a scalar.
    @inlinable
    @_disfavoredOverload
    public static func * (lhs: Self, rhs: Tagged<Index.Y.Displacement, RawValue>) -> RawValue {
        lhs.rawValue * rhs.rawValue
    }
}

// MARK: - Mixed Coordinate/Displacement Arithmetic

// Coordinate + Displacement = Coordinate (Point + Vector = Point)
// Coordinate - Coordinate = Displacement (Point - Point = Vector)
// Coordinate - Displacement = Coordinate (Point - Vector = Point)

extension Tagged where Tag == Index.X.Coordinate, RawValue: AdditiveArithmetic {
    /// Add a displacement to a coordinate.
    @inlinable
    public static func + (lhs: Self, rhs: Tagged<Index.X.Displacement, RawValue>) -> Self {
        Self(lhs.rawValue + rhs.rawValue)
    }

    /// Subtract two coordinates to get a displacement.
    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Tagged<Index.X.Displacement, RawValue> {
        Tagged<Index.X.Displacement, RawValue>(lhs.rawValue - rhs.rawValue)
    }

    /// Subtract a displacement from a coordinate.
    @inlinable
    public static func - (lhs: Self, rhs: Tagged<Index.X.Displacement, RawValue>) -> Self {
        Self(lhs.rawValue - rhs.rawValue)
    }
}

extension Tagged where Tag == Index.Y.Coordinate, RawValue: AdditiveArithmetic {
    /// Add a displacement to a coordinate.
    @inlinable
    public static func + (lhs: Self, rhs: Tagged<Index.Y.Displacement, RawValue>) -> Self {
        Self(lhs.rawValue + rhs.rawValue)
    }

    /// Subtract two coordinates to get a displacement.
    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Tagged<Index.Y.Displacement, RawValue> {
        Tagged<Index.Y.Displacement, RawValue>(lhs.rawValue - rhs.rawValue)
    }

    /// Subtract a displacement from a coordinate.
    @inlinable
    public static func - (lhs: Self, rhs: Tagged<Index.Y.Displacement, RawValue>) -> Self {
        Self(lhs.rawValue - rhs.rawValue)
    }
}

extension Tagged where Tag == Index.Z.Coordinate, RawValue: AdditiveArithmetic {
    /// Add a displacement to a coordinate.
    @inlinable
    public static func + (lhs: Self, rhs: Tagged<Index.Z.Displacement, RawValue>) -> Self {
        Self(lhs.rawValue + rhs.rawValue)
    }

    /// Subtract two coordinates to get a displacement.
    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Tagged<Index.Z.Displacement, RawValue> {
        Tagged<Index.Z.Displacement, RawValue>(lhs.rawValue - rhs.rawValue)
    }

    /// Subtract a displacement from a coordinate.
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
