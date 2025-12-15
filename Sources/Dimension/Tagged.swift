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
    /// Internal storage for the raw value.
    ///
    /// - Note: Use typed operators and methods instead of accessing raw values directly.
    ///   This is `package` visible to allow `@inlinable` operators within the package.
    public var _rawValue: RawValue

    /// Creates a tagged value from a raw value.
    @inlinable
    public init(_ rawValue: RawValue) {
        self._rawValue = rawValue
    }

    /// Creates a tagged value from a raw value.
    @inlinable
    public init(rawValue: RawValue) {
        self._rawValue = rawValue
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
        lhs._rawValue < rhs._rawValue
    }

    /// Returns the greater of two tagged values.
    ///
    /// Equivalent to `Swift.max(a, b)` but avoids verbose type annotations.
    @inlinable
    public static func max(_ a: Self, _ b: Self) -> Self {
        a._rawValue >= b._rawValue ? a : b
    }

    /// Returns the lesser of two tagged values.
    ///
    /// Equivalent to `Swift.min(a, b)` but avoids verbose type annotations.
    @inlinable
    public static func min(_ a: Self, _ b: Self) -> Self {
        a._rawValue <= b._rawValue ? a : b
    }
}

// MARK: - Functor (Static Implementation)

extension Tagged {
    /// Transforms the raw value of a tagged value while preserving the tag.
    @inlinable
    public static func map<NewRawValue>(
        _ tagged: Tagged,
        transform: (RawValue) throws -> NewRawValue
    ) rethrows -> Tagged<Tag, NewRawValue> {
        Tagged<Tag, NewRawValue>(try transform(tagged._rawValue))
    }

    /// Changes the tag type of a tagged value while preserving the raw value (zero-cost conversion).
    @inlinable
    public static func retag<NewTag>(
        _ tagged: Tagged,
        to _: NewTag.Type = NewTag.self
    ) -> Tagged<NewTag, RawValue> {
        Tagged<NewTag, RawValue>(tagged._rawValue)
    }
}

// MARK: - Functor (Instance Convenience)

extension Tagged {
    /// Transforms the raw value while preserving the tag.
    @inlinable
    public func map<NewRawValue>(
        _ transform: (RawValue) throws -> NewRawValue
    ) rethrows -> Tagged<Tag, NewRawValue> {
        try Self.map(self, transform: transform)
    }

    /// Changes the tag type while preserving the raw value (zero-cost conversion).
    @inlinable
    public func retag<NewTag>(_: NewTag.Type = NewTag.self) -> Tagged<NewTag, RawValue> {
        Self.retag(self, to: NewTag.self)
    }
}

// MARK: - ExpressibleBy Literals

extension Tagged: ExpressibleByIntegerLiteral where RawValue: ExpressibleByIntegerLiteral {
    @inlinable
    public init(integerLiteral value: RawValue.IntegerLiteralType) {
        self._rawValue = RawValue(integerLiteral: value)
    }
}

extension Tagged: ExpressibleByFloatLiteral where RawValue: ExpressibleByFloatLiteral {
    @inlinable
    public init(floatLiteral value: RawValue.FloatLiteralType) {
        self._rawValue = RawValue(floatLiteral: value)
    }
}

extension Tagged: ExpressibleByUnicodeScalarLiteral
where RawValue: ExpressibleByUnicodeScalarLiteral {
    @inlinable
    public init(unicodeScalarLiteral value: RawValue.UnicodeScalarLiteralType) {
        self._rawValue = RawValue(unicodeScalarLiteral: value)
    }
}

extension Tagged: ExpressibleByExtendedGraphemeClusterLiteral
where RawValue: ExpressibleByExtendedGraphemeClusterLiteral {
    @inlinable
    public init(extendedGraphemeClusterLiteral value: RawValue.ExtendedGraphemeClusterLiteralType) {
        self._rawValue = RawValue(extendedGraphemeClusterLiteral: value)
    }
}

extension Tagged: ExpressibleByStringLiteral where RawValue: ExpressibleByStringLiteral {
    @inlinable
    public init(stringLiteral value: RawValue.StringLiteralType) {
        self._rawValue = RawValue(stringLiteral: value)
    }
}

extension Tagged: ExpressibleByBooleanLiteral where RawValue: ExpressibleByBooleanLiteral {
    @inlinable
    public init(booleanLiteral value: RawValue.BooleanLiteralType) {
        self._rawValue = RawValue(booleanLiteral: value)
    }
}

// MARK: - FloatingPoint Properties

extension Tagged where RawValue: FloatingPoint {
    /// The unit value in the last place of 1.0.
    @inlinable
    public static var ulpOfOne: Self { Self(RawValue.ulpOfOne) }

    /// Positive infinity.
    @inlinable
    public static var infinity: Self { Self(RawValue.infinity) }

    /// A quiet NaN ("not a number").
    @inlinable
    public static var nan: Self { Self(RawValue.nan) }

    /// A Boolean value indicating whether this instance is NaN.
    @inlinable
    public var isNaN: Bool { _rawValue.isNaN }

    /// A Boolean value indicating whether this instance is infinite.
    @inlinable
    public var isInfinite: Bool { _rawValue.isInfinite }

    /// A Boolean value indicating whether this instance is finite.
    @inlinable
    public var isFinite: Bool { _rawValue.isFinite }

    /// A Boolean value indicating whether this instance is zero.
    @inlinable
    public var isZero: Bool { _rawValue.isZero }

    /// The sign of this value.
    @inlinable
    public var sign: FloatingPointSign { _rawValue.sign }
}

// MARK: - Square Root for Measures

/// Square root of area returns magnitude (Length).
///
/// Dimensionally: √(L²) = L
@inlinable
public func sqrt<Space, Scalar: FloatingPoint>(
    _ value: Tagged<Area<Space>, Scalar>
) -> Tagged<Magnitude<Space>, Scalar> {
    Tagged(value._rawValue.squareRoot())
}

/// Square root of volume returns area.
///
/// Dimensionally: √(L³) = L^1.5 (not exact, but useful for certain calculations)
@inlinable
public func sqrt<Space, Scalar: FloatingPoint>(
    _ value: Tagged<Volume<Space>, Scalar>
) -> Tagged<Area<Space>, Scalar> {
    Tagged(value._rawValue.squareRoot())
}

extension Tagged where RawValue: FloatingPoint {
    /// The square root of this value.
    @inlinable
    public func squareRoot() -> Self {
        Self(_rawValue.squareRoot())
    }
}

// MARK: - Strideable

extension Tagged: Strideable where RawValue: Strideable {
    public typealias Stride = RawValue.Stride

    @inlinable
    public func distance(to other: Self) -> Stride {
        _rawValue.distance(to: other._rawValue)
    }

    @inlinable
    public func advanced(by n: Stride) -> Self {
        Self(_rawValue.advanced(by: n))
    }
}

extension Tagged where RawValue: BinaryFloatingPoint {
    public init<I: BinaryInteger>(_ value: I) {
        self.init(RawValue(value))
    }
}

// MARK: - Magnitude / Absolute Value

extension Tagged where RawValue: SignedNumeric, RawValue.Magnitude == RawValue {
    /// The magnitude (absolute value) of this tagged value.
    ///
    /// For signed numeric values, this returns the absolute value while preserving the tag type.
    /// Mathematically: `|x|` where the result has the same unit/type as the input.
    @inlinable
    public var magnitude: Self {
        Self(_rawValue.magnitude)
    }
}

// MARK: - BinaryFloatingPoint Properties

extension Tagged where RawValue: BinaryFloatingPoint {
    /// The mathematical constant pi (π).
    @inlinable
    public static var pi: Self { Self(RawValue.pi) }
}
