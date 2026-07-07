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

/// A fixed-capacity, typed memory slab with manual element lifecycle.
public struct Slab<Element: ~Copyable>: ~Copyable {
    @usableFromInline
    var storage: UnsafeMutablePointer<Element>

    /// The number of slots in the slab.
    public let capacity: Int

    /// Creates a slab with the specified capacity.
    @inlinable
    public init(capacity: Int) throws(Slab.Error) {
        guard capacity >= 0 else {
            throw .invalidCapacity
        }

        if capacity == 0 {
            self.storage = UnsafeMutablePointer<Element>(
                bitPattern: MemoryLayout<Element>.alignment
            )!
            self.capacity = 0
            return
        }

        let storage = UnsafeMutablePointer<Element>.allocate(capacity: capacity)
        self.storage = storage
        self.capacity = capacity
    }

    deinit {
        if capacity > 0 {
            storage.deallocate()
        }
    }
}

// MARK: - Lifecycle Management

extension Slab {
    @inlinable
    public mutating func initialize(at index: Int, to value: consuming Element) {
        precondition(index >= 0 && index < capacity)
        (storage + index).initialize(to: value)
    }

    @inlinable
    public mutating func deinitialize(at index: Int) -> Element {
        precondition(index >= 0 && index < capacity)
        return (storage + index).move()
    }
}

// MARK: - Pointer Access

extension Slab {
    @inlinable
    public func withUnsafePointer<R, E: Swift.Error>(
        at index: Int,
        _ body: (UnsafePointer<Element>) throws(E) -> R
    ) throws(E) -> R {
        precondition(index >= 0 && index < capacity)
        return try body(storage + index)
    }

    @inlinable
    public mutating func withUnsafeMutablePointer<R, E: Swift.Error>(
        at index: Int,
        _ body: (UnsafeMutablePointer<Element>) throws(E) -> R
    ) throws(E) -> R {
        precondition(index >= 0 && index < capacity)
        return try body(storage + index)
    }
}

// MARK: - Sendable

extension Slab: @unchecked Sendable where Element: Sendable {}
