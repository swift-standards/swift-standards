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
    /// A non-resizable array that is always fully initialized.
    ///
    /// Unlike standard `Array`, `Fixed` cannot grow or shrink after creation.
    /// All elements are initialized at construction time.
    public struct Fixed: ~Copyable {
        @usableFromInline
        var storage: UnsafeMutablePointer<Element>

        /// The number of elements in the array.
        public let count: Int

        deinit {
            for i in 0..<count {
                (storage + i).deinitialize(count: 1)
            }
            if count > 0 {
                storage.deallocate()
            }
        }
    }
}

// MARK: - Initialization

extension Collections.Array.Fixed {
    /// Creates a fixed array with the specified count, initializing each element.
    ///
    /// - Parameters:
    ///   - count: The number of elements. Must be non-negative.
    ///   - initializer: A closure that provides the element for each index.
    @inlinable
    public init(
        count: Int,
        initializingWith initializer: (Int) -> Element
    ) {
        precondition(count >= 0, "Count must be non-negative")

        if count == 0 {
            self.storage = UnsafeMutablePointer<Element>(bitPattern: MemoryLayout<Element>.alignment)!
            self.count = 0
            return
        }

        let storage = UnsafeMutablePointer<Element>.allocate(capacity: count)
        for i in 0..<count {
            (storage + i).initialize(to: initializer(i))
        }
        self.storage = storage
        self.count = count
    }
}

// MARK: - Properties

extension Collections.Array.Fixed {
    /// Whether the array is empty.
    @inlinable
    public var isEmpty: Bool { count == 0 }
}

// MARK: - Subscript

extension Collections.Array.Fixed {
    /// Accesses the element at the specified index.
    @inlinable
    public subscript(index: Int) -> Element {
        _read {
            precondition(index >= 0 && index < count, "Index out of bounds")
            yield storage[index]
        }
        _modify {
            precondition(index >= 0 && index < count, "Index out of bounds")
            yield &storage[index]
        }
    }
}

// MARK: - Update

extension Collections.Array.Fixed {
    /// Updates the element at the specified index.
    @inlinable
    public mutating func update<E: Swift.Error>(
        at index: Int,
        _ body: (inout Element) throws(E) -> Void
    ) throws(E) {
        precondition(index >= 0 && index < count, "Index out of bounds")
        try body(&storage[index])
    }
}

// MARK: - Pointer Access

extension Collections.Array.Fixed {
    @inlinable
    public func withUnsafeBufferPointer<R, E: Swift.Error>(
        _ body: (UnsafeBufferPointer<Element>) throws(E) -> R
    ) throws(E) -> R {
        try body(UnsafeBufferPointer(start: count > 0 ? storage : nil, count: count))
    }

    @inlinable
    public mutating func withUnsafeMutableBufferPointer<R, E: Swift.Error>(
        _ body: (UnsafeMutableBufferPointer<Element>) throws(E) -> R
    ) throws(E) -> R {
        try body(UnsafeMutableBufferPointer(start: count > 0 ? storage : nil, count: count))
    }
}

// MARK: - Sendable

extension Collections.Array.Fixed: @unchecked Sendable where Element: Sendable {}
