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

extension Set {
    /// An ordered set that preserves insertion order with O(1) membership testing.
    ///
    /// `Ordered` combines the uniqueness guarantees of a set with the ordering
    /// semantics of an array. Elements are stored in insertion order and can be
    /// accessed by index.
    ///
    /// ## API
    ///
    /// Core operations use single-token names:
    ///
    /// ```swift
    /// var set = Set<String>.Ordered()
    ///
    /// // Insert
    /// set.insert("apple")
    /// set.insert("banana")
    ///
    /// // Membership
    /// if set.contains("apple") { ... }
    ///
    /// // Index lookup
    /// if let idx = set.index("apple") { ... }
    ///
    /// // Remove
    /// set.remove("banana")
    /// ```
    ///
    /// Set algebra uses nested accessors:
    ///
    /// ```swift
    /// let union = a.algebra.union(b)
    /// let intersection = a.algebra.intersection(b)
    /// let difference = a.algebra.subtract(b)
    /// let symmetric = a.algebra.symmetric.difference(b)
    /// ```
    ///
    /// ## Ordering Semantics
    ///
    /// - Insertion adds to the end if the element is new
    /// - Removal shifts subsequent elements (indices change)
    /// - Re-insertion of a removed element adds to the end
    ///
    /// ## Thread Safety
    ///
    /// Not thread-safe for concurrent mutation. Synchronize externally.
    ///
    /// ## Complexity
    ///
    /// - Insert/remove/contains: O(1) average
    /// - Index lookup: O(1) average
    /// - Random access by index: O(1)
    public struct Ordered {
        @usableFromInline
        var storage: Storage

        /// Creates an empty ordered set.
        @inlinable
        public init() {
            self.storage = Storage()
        }
    }
}

// MARK: - Initialization

extension Set.Ordered {
    /// Creates an ordered set containing the elements of a sequence.
    ///
    /// Duplicate elements are ignored; only the first occurrence is kept.
    ///
    /// - Parameter elements: The sequence of elements.
    @inlinable
    public init<S: Sequence>(_ elements: S) where S.Element == Element {
        self.init()
        for element in elements {
            insert(element)
        }
    }
}

// MARK: - Properties

extension Set.Ordered {
    /// The number of elements in the set.
    @inlinable
    public var count: Int {
        storage.count
    }

    /// Whether the set is empty.
    @inlinable
    public var isEmpty: Bool {
        storage.isEmpty
    }

    /// The current capacity of the set.
    @inlinable
    public var capacity: Int {
        storage.capacity
    }
}

// MARK: - Core Operations

extension Set.Ordered {
    /// Returns the index of the given element, or `nil` if not present.
    ///
    /// - Parameter element: The element to find.
    /// - Returns: The index of the element, or `nil`.
    /// - Complexity: O(1) average.
    @inlinable
    public func index(_ element: Element) -> Int? {
        storage.index(element)
    }

    /// Inserts an element into the set.
    ///
    /// If the element already exists, the set is unchanged.
    ///
    /// - Parameter element: The element to insert.
    /// - Returns: A tuple indicating whether insertion occurred and the index.
    /// - Complexity: O(1) average.
    @inlinable
    @discardableResult
    public mutating func insert(_ element: Element) -> (inserted: Bool, index: Int) {
        ensureUnique()
        return storage.insert(element)
    }

    /// Removes an element from the set.
    ///
    /// - Parameter element: The element to remove.
    /// - Returns: The removed element, or `nil` if not present.
    /// - Complexity: O(n) due to index shifting.
    @inlinable
    @discardableResult
    public mutating func remove(_ element: Element) -> Element? {
        ensureUnique()
        return storage.remove(element)
    }

    /// Returns whether the set contains the given element.
    ///
    /// - Parameter element: The element to check.
    /// - Returns: `true` if the element is in the set.
    /// - Complexity: O(1) average.
    @inlinable
    public func contains(_ element: Element) -> Bool {
        storage.contains(element)
    }
}

// MARK: - Capacity

extension Set.Ordered {
    /// Reserves enough space to store the specified number of elements.
    ///
    /// - Parameter minimumCapacity: The minimum number of elements.
    @inlinable
    public mutating func reserve(_ minimumCapacity: Int) {
        ensureUnique()
        storage.reserve(minimumCapacity)
    }

    /// Removes all elements from the set.
    ///
    /// - Parameter keepingCapacity: Whether to keep the current capacity.
    @inlinable
    public mutating func clear(keepingCapacity: Bool = false) {
        ensureUnique()
        storage.clear(keepingCapacity: keepingCapacity)
    }
}

// MARK: - Element Access

extension Set.Ordered {
    /// Accesses the element at the specified index.
    ///
    /// - Parameter index: The index of the element.
    /// - Returns: The element at the index.
    /// - Throws: `Ordered.Error.bounds` if the index is out of bounds.
    @inlinable
    public func element(at index: Int) throws(Error) -> Element {
        guard index >= 0 && index < count else {
            throw .bounds(.init(index: index, count: count))
        }
        return storage.elements[index]
    }

    /// Subscript access to elements by index.
    ///
    /// - Parameter index: The index of the element.
    /// - Precondition: The index must be in bounds.
    @inlinable
    public subscript(index: Int) -> Element {
        precondition(index >= 0 && index < count, "Index out of bounds")
        return storage.elements[index]
    }
}

// MARK: - Sendable

extension Set.Ordered: Sendable where Element: Sendable {}

// MARK: - Equatable

extension Set.Ordered: Equatable {
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.storage.elements == rhs.storage.elements
    }
}

// MARK: - Hashable

extension Set.Ordered: Hashable {
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(count)
        for element in storage.elements {
            hasher.combine(element)
        }
    }
}

// MARK: - ExpressibleByArrayLiteral

extension Set.Ordered: ExpressibleByArrayLiteral {
    @inlinable
    public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
}

// MARK: - CustomStringConvertible

extension Set.Ordered: CustomStringConvertible {
    public var description: String {
        var result = "Set.Ordered(["
        var first = true
        for element in storage.elements {
            if !first { result += ", " }
            result += String(describing: element)
            first = false
        }
        result += "])"
        return result
    }
}

// MARK: - Internal Identity (for testing)

extension Set.Ordered {
    /// Storage identity for CoW testing.
    @usableFromInline
    internal var _identity: ObjectIdentifier {
        ObjectIdentifier(storage)
    }
}
