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
    @usableFromInline
    package var _rawValue: RawValue

    /// Underlying raw value.
    ///
    /// - Note: Access to raw values is restricted via `@_spi(Internal)` to encourage
    ///   staying in typed land. Use typed operators and methods instead.
    @_spi(Internal)
    @inlinable
    public var rawValue: RawValue {
        get { _rawValue }
        set { _rawValue = newValue }
    }

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

// MARK: - Value Alias

extension Tagged {
    /// Convenient alias for `rawValue`.
    ///
    /// - Note: Access to raw values is restricted via `@_spi(Internal)` to encourage
    ///   staying in typed land. Use typed operators and methods instead.
    @_spi(Internal)
    @inlinable
    public var value: RawValue {
        get { _rawValue }
        set { _rawValue = newValue }
    }
}
