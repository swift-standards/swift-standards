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

// MARK: - Pop Accessor

extension Collections.Deque {
    /// Nested accessor for pop operations.
    ///
    /// ```swift
    /// var deque: Collections.Deque<Int> = [1, 2, 3]
    /// let back = try deque.pop.back()
    /// let front = try deque.pop.front()
    /// ```
    ///
    /// - Note: `_modify` only - no `get` accessor to prevent silent discard of mutations.
    @inlinable
    public var pop: Pop {
        _read {
            yield Pop(storage: storage)
        }
        _modify {
            // Force uniqueness only (no growth needed for removal)
            storage.ensureUnique()

            // Transfer storage ownership to proxy to maintain unique reference
            var proxy = Pop(storage: storage)
            storage = Storage()  // Clear self.storage to release our reference
            defer { storage = proxy.storage }
            yield &proxy
        }
    }
}

// MARK: - Pop Type

extension Collections.Deque {
    /// Namespace for pop operations.
    public struct Pop {
        @usableFromInline
        var storage: Storage

        @usableFromInline
        init(storage: Storage) {
            self.storage = storage
        }
    }
}

// MARK: - Pop Operations

extension Collections.Deque.Pop {
    /// Pops an element from the back of the deque.
    ///
    /// - Returns: The removed element.
    /// - Throws: `Deque.Error.empty` if the deque is empty.
    /// - Complexity: O(1).
    @inlinable
    public mutating func back() throws(Collections.Deque<Element>.Error) -> Element {
        guard !storage.isEmpty else {
            throw .empty(.init())
        }
        return storage.removeLast()
    }

    /// Pops an element from the front of the deque.
    ///
    /// - Returns: The removed element.
    /// - Throws: `Deque.Error.empty` if the deque is empty.
    /// - Complexity: O(1).
    @inlinable
    public mutating func front() throws(Collections.Deque<Element>.Error) -> Element {
        guard !storage.isEmpty else {
            throw .empty(.init())
        }
        return storage.removeFirst()
    }
}
