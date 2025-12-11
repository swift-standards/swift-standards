// Product.swift
// The n-ary cartesian product type.

/// N-ary cartesian product of types.
///
/// Represents the product `A × B × C × ...` using Swift's parameter packs.
/// Use this when you need a named tuple type with dynamic member lookup.
///
/// ## Example
///
/// ```swift
/// let pair = Product(1, "hello")           // Product<Int, String>
/// let triple = Product(1, "hello", true)   // Product<Int, String, Bool>
///
/// print(pair.values.0)    // 1
/// print(pair.0)           // 1 (via dynamic member lookup)
/// ```
///
/// ## Note
///
/// This is the categorical product in the category of types. For practical
/// purposes, it's a named wrapper around Swift tuples with convenient access.
///
@dynamicMemberLookup
public struct Product<each Element> {
    /// Tuple of component values.
    public var values: (repeat each Element)

    /// Creates a product from component values.
    @inlinable
    public init(_ values: repeat each Element) {
        self.values = (repeat each values)
    }

    /// Direct access to tuple elements via key paths.
    ///
    /// Enables `product.0` instead of `product.values.0`.
    @inlinable
    public subscript<T>(dynamicMember keyPath: KeyPath<(repeat each Element), T>) -> T {
        values[keyPath: keyPath]
    }
}

// MARK: - Conditional Conformances

extension Product: Sendable where repeat each Element: Sendable {}

extension Product: Equatable where repeat each Element: Equatable {
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        func isEqual<T: Equatable>(_ l: T, _ r: T) -> Bool { l == r }

        for result in repeat isEqual(each lhs.values, each rhs.values) {
            if !result { return false }
        }
        return true
    }
}

extension Product: Hashable where repeat each Element: Hashable {
    @inlinable
    public func hash(into hasher: inout Hasher) {
        func hashElement<T: Hashable>(_ element: T, _ hasher: inout Hasher) {
            hasher.combine(element)
        }
        repeat hashElement(each values, &hasher)
    }
}

// Note: Codable conformance for parameter packs requires more complex handling
// and may not be directly expressible in current Swift.
