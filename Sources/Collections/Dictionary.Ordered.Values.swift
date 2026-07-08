// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-standards open source project
//
// Copyright (c) 2024-2025 Coen ten Thije Boonkkamp and the swift-standards project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

// MARK: - Values Accessor

extension Dictionary.Ordered {
    /// Nested accessor for value operations.
    ///
    /// ```swift
    /// dict.values.set("apple", 1)
    /// let removed = dict.values.remove("banana")
    /// let allValues = dict.values.all
    /// ```
    @inlinable
    public var values: Values {
        get { Values(dict: self) }
        _modify {
            var proxy = Values(dict: self)
            defer { self = proxy.dict }
            yield &proxy
        }
    }
}

// MARK: - Values Type

extension Dictionary.Ordered {
    /// Namespace for value operations.
    public struct Values {
        @usableFromInline
        var dict: Dictionary<Key, Value>.Ordered

        @usableFromInline
        init(dict: Dictionary<Key, Value>.Ordered) {
            self.dict = dict
        }
    }
}

// MARK: - Values Operations

extension Dictionary.Ordered.Values {
    /// Sets the value for the given key.
    ///
    /// If the key exists, updates the value without changing position.
    /// If the key is new, adds to the end.
    ///
    /// - Parameters:
    ///   - key: The key.
    ///   - value: The value.
    /// - Complexity: O(1) average.
    @inlinable
    public mutating func set(_ key: Key, _ value: Value) {
        dict[key] = value
    }

    /// Removes the value for the given key.
    ///
    /// - Parameter key: The key to remove.
    /// - Returns: The removed value, or `nil` if not present.
    /// - Complexity: O(n) due to index shifting.
    @inlinable
    @discardableResult
    public mutating func remove(_ key: Key) -> Value? {
        guard let index = dict._keys.index(key) else { return nil }
        dict._keys.remove(key)
        return dict._values.remove(at: index)
    }

    /// Updates the value for the given key using a closure.
    ///
    /// - Parameters:
    ///   - key: The key to update.
    ///   - transform: A closure that transforms the current value.
    /// - Returns: The new value, or `nil` if the key doesn't exist.
    @inlinable
    @discardableResult
    public mutating func modify(_ key: Key, _ transform: (inout Value) -> Void) -> Value? {
        guard let index = dict._keys.index(key) else { return nil }
        transform(&dict._values[index])
        return dict._values[index]
    }

    /// All values in order.
    @inlinable
    public var all: ContiguousArray<Value> {
        dict._values
    }

    /// The value at the given index.
    ///
    /// - Parameter index: The index.
    /// - Precondition: The index must be in bounds.
    @inlinable
    public subscript(_ index: Int) -> Value {
        get { dict._values[index] }
        set { dict._values[index] = newValue }
    }
}

// MARK: - Sequence Conformance

extension Dictionary.Ordered.Values: Sequence {
    public struct Iterator: IteratorProtocol {
        @usableFromInline
        var base: ContiguousArray<Value>.Iterator

        @usableFromInline
        init(_ values: ContiguousArray<Value>) {
            self.base = values.makeIterator()
        }
    }

    @inlinable
    public func makeIterator() -> Iterator {
        Iterator(dict._values)
    }
}

extension Dictionary.Ordered.Values.Iterator {
    @inlinable
    public mutating func next() -> Value? {
        base.next()
    }
}

extension Dictionary.Ordered.Values.Iterator: Sendable where Value: Sendable {}
