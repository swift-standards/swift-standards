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

extension Collections.Array {
    /// An array that stores up to N elements inline, then spills to heap.
    ///
    /// This provides small-buffer optimization for arrays where most instances
    /// contain few elements. When count exceeds N, storage moves to heap and
    /// can grow unbounded.
    public struct Inline<let N: Int>: ~Copyable {
        @usableFromInline
        var _storage: UnsafeMutablePointer<Element>?

        @usableFromInline
        var _count: Int

        @usableFromInline
        var _capacity: Int

        /// Creates an empty inline array.
        @inlinable
        public init() {
            self._storage = nil
            self._count = 0
            self._capacity = 0
        }

        deinit {
            if let storage = _storage {
                for i in 0..<_count {
                    (storage + i).deinitialize(count: 1)
                }
                storage.deallocate()
            }
        }
    }
}

// MARK: - Properties

extension Collections.Array.Inline {
    /// The number of elements in the array.
    @inlinable
    public var count: Int { _count }

    /// Whether the array is empty.
    @inlinable
    public var isEmpty: Bool { _count == 0 }

    /// The current capacity of the array.
    @inlinable
    public var capacity: Int { _capacity }

    /// Whether the array is still using inline storage (capacity <= N).
    @inlinable
    public var isInline: Bool { _capacity <= N }
}

// MARK: - Core Operations

extension Collections.Array.Inline {
    /// Appends an element to the array.
    @inlinable
    public mutating func append(_ element: consuming Element) {
        if _count >= _capacity {
            grow()
        }
        (_storage! + _count).initialize(to: element)
        _count += 1
    }

    /// Removes and returns the last element, or nil if empty.
    @inlinable
    public mutating func removeLast() -> Element? {
        guard _count > 0 else {
            return nil
        }
        _count -= 1
        return (_storage! + _count).move()
    }

    /// Removes all elements from the array.
    @inlinable
    public mutating func removeAll() {
        guard let storage = _storage else { return }
        for i in 0..<_count {
            (storage + i).deinitialize(count: 1)
        }
        _count = 0
    }

    @usableFromInline
    mutating func grow() {
        let newCapacity = _capacity == 0 ? max(N, 1) : _capacity * 2
        let newStorage = UnsafeMutablePointer<Element>.allocate(capacity: newCapacity)

        if let oldStorage = _storage {
            newStorage.moveInitialize(from: oldStorage, count: _count)
            oldStorage.deallocate()
        }

        _storage = newStorage
        _capacity = newCapacity
    }
}

// MARK: - Iteration

extension Collections.Array.Inline {
    /// Iterates over all elements.
    @inlinable
    public func forEach(_ body: (borrowing Element) throws -> Void) rethrows {
        guard let storage = _storage else { return }
        for i in 0..<_count {
            try body((storage + i).pointee)
        }
    }

    /// Removes and consumes all elements.
    @inlinable
    public mutating func drain(_ body: (consuming Element) -> Void) {
        guard let storage = _storage else { return }
        for i in 0..<_count {
            body((storage + i).move())
        }
        _count = 0
    }
}

// MARK: - Sendable

extension Collections.Array.Inline: @unchecked Sendable where Element: Sendable {}

// MARK: - Convenience Typealiases

extension Collections.Array {
    public typealias Small1 = Inline<1>
    public typealias Small4 = Inline<4>
    public typealias Small8 = Inline<8>
}
