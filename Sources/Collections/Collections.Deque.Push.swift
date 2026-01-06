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

// MARK: - Push Accessor

extension Collections.Deque {
    /// Nested accessor for push operations.
    ///
    /// ```swift
    /// var deque = Collections.Deque<Int>()
    /// deque.push.back(1)
    /// deque.push.front(0)
    /// ```
    ///
    /// - Note: `_modify` only - no `get` accessor to prevent silent discard of mutations.
    @inlinable
    public var push: Push {
        // _read provides a snapshot for read-only access (rarely used)
        _read {
            yield Push(storage: storage)
        }
        _modify {
            // CRITICAL: Force uniqueness + growth BEFORE transferring storage
            // At this point, self.storage is the only reference
            storage.ensureUnique(minimumCapacity: storage.count + 1)

            // Transfer storage ownership to proxy to maintain unique reference
            // After this, proxy.storage.buffer is the only reference
            var proxy = Push(storage: storage)
            storage = Storage()  // Clear self.storage to release our reference
            defer { storage = proxy.storage }
            yield &proxy
        }
    }
}

// MARK: - Push Type

extension Collections.Deque {
    /// Namespace for push operations.
    public struct Push {
        @usableFromInline
        var storage: Storage

        @usableFromInline
        init(storage: Storage) {
            self.storage = storage
        }
    }
}

// MARK: - Push Operations

extension Collections.Deque.Push {
    /// Pushes an element to the back of the deque.
    ///
    /// - Parameter element: The element to push.
    /// - Complexity: O(1) amortized.
    @inlinable
    public mutating func back(_ element: Element) {
        // ensureUnique already called in _modify, just append
        storage.append(element)
    }

    /// Pushes an element to the front of the deque.
    ///
    /// - Parameter element: The element to push.
    /// - Complexity: O(1) amortized.
    @inlinable
    public mutating func front(_ element: Element) {
        // ensureUnique already called in _modify, just prepend
        storage.prepend(element)
    }
}
