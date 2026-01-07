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

extension Set.Ordered {
    /// Type-local CoW storage for ordered set.
    ///
    /// Combines a contiguous array for order with a hash table for O(1) lookups.
    @usableFromInline
    final class Storage {
        /// Elements in insertion order.
        @usableFromInline
        var elements: ContiguousArray<Element>

        /// Maps element to its index in `elements`.
        @usableFromInline
        var indices: [Element: Int]

        @usableFromInline
        init() {
            self.elements = []
            self.indices = [:]
        }

        @usableFromInline
        init(elements: ContiguousArray<Element>, indices: [Element: Int]) {
            self.elements = elements
            self.indices = indices
        }
    }
}

// MARK: - Storage Properties

extension Set.Ordered.Storage {
    @usableFromInline
    var count: Int {
        elements.count
    }

    @usableFromInline
    var isEmpty: Bool {
        elements.isEmpty
    }

    @usableFromInline
    var capacity: Int {
        elements.capacity
    }
}

// MARK: - Copy

extension Set.Ordered.Storage {
    @usableFromInline
    func copy() -> Set<Element>.Ordered.Storage {
        Set<Element>.Ordered.Storage(elements: elements, indices: indices)
    }
}

// MARK: - Uniqueness Helper

extension Set.Ordered {
    /// Ensures storage is uniquely referenced before mutation.
    @usableFromInline
    mutating func ensureUnique() {
        if !isKnownUniquelyReferenced(&storage) {
            storage = storage.copy()
        }
    }
}

// MARK: - Core Operations

extension Set.Ordered.Storage {
    @usableFromInline
    func index(_ element: Element) -> Int? {
        indices[element]
    }

    @usableFromInline
    func contains(_ element: Element) -> Bool {
        indices[element] != nil
    }

    @usableFromInline
    func insert(_ element: Element) -> (inserted: Bool, index: Int) {
        if let existing = indices[element] {
            return (false, existing)
        }
        let index = elements.count
        elements.append(element)
        indices[element] = index
        return (true, index)
    }

    @usableFromInline
    func remove(_ element: Element) -> Element? {
        guard let index = indices.removeValue(forKey: element) else {
            return nil
        }
        let removed = elements.remove(at: index)

        // Update indices for shifted elements
        for i in index..<elements.count {
            indices[elements[i]] = i
        }

        return removed
    }
}

// MARK: - Capacity

extension Set.Ordered.Storage {
    @usableFromInline
    func reserve(_ minimumCapacity: Int) {
        elements.reserveCapacity(minimumCapacity)
        indices.reserveCapacity(minimumCapacity)
    }

    @usableFromInline
    func clear(keepingCapacity: Bool) {
        if keepingCapacity {
            elements.removeAll(keepingCapacity: true)
            indices.removeAll(keepingCapacity: true)
        } else {
            elements = []
            indices = [:]
        }
    }
}

// MARK: - Sendable

// Storage is @unchecked Sendable because:
// - CoW semantics ensure storage is never mutated when shared
// - ensureUnique() is called before any mutation
// - When shared across threads, storage is immutable
extension Set.Ordered.Storage: @unchecked Sendable where Element: Sendable {}
