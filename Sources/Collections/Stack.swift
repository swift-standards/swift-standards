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

/// A fixed-capacity LIFO stack with manual element lifecycle.
public struct Stack<Element: ~Copyable>: ~Copyable {
    @usableFromInline
    var storage: UnsafeMutablePointer<Element>

    /// The maximum number of elements the stack can hold.
    public let capacity: Int

    /// The current number of elements in the stack.
    @usableFromInline
    var _count: Int

    /// Creates a stack with the specified capacity.
    @inlinable
    public init(capacity: Int) throws(Stack.Error) {
        guard capacity >= 0 else {
            throw .invalidCapacity
        }

        if capacity == 0 {
            self.storage = UnsafeMutablePointer<Element>(
                bitPattern: MemoryLayout<Element>.alignment
            )!
            self.capacity = 0
            self._count = 0
            return
        }

        let storage = UnsafeMutablePointer<Element>.allocate(capacity: capacity)
        self.storage = storage
        self.capacity = capacity
        self._count = 0
    }

    deinit {
        // Deinitialize all elements
        for i in 0..<_count {
            (storage + i).deinitialize(count: 1)
        }
        if capacity > 0 {
            storage.deallocate()
        }
    }
}

// MARK: - Properties

extension Stack where Element: ~Copyable {
    /// The current number of elements in the stack.
    @inlinable
    public var count: Int { _count }

    /// Whether the stack is empty.
    @inlinable
    public var isEmpty: Bool { _count == 0 }

    /// Whether the stack is full.
    @inlinable
    public var isFull: Bool { _count == capacity }
}

// MARK: - Core Operations

extension Stack where Element: ~Copyable {
    /// Pushes an element onto the stack.
    @inlinable
    public mutating func push(_ element: consuming Element) throws(Stack.Error) {
        guard _count < capacity else {
            throw .overflow
        }
        (storage + _count).initialize(to: element)
        _count += 1
    }

    /// Pops and returns the top element, or nil if empty.
    @inlinable
    public mutating func pop() -> Element? {
        guard _count > 0 else {
            return nil
        }
        _count -= 1
        return (storage + _count).move()
    }
}

// MARK: - Peek

extension Stack {
    /// Peeks at the top element without removing it.
    @inlinable
    public func peek<R>(_ body: (borrowing Element) throws -> R) rethrows -> R? {
        guard _count > 0 else {
            return nil
        }
        return try body((storage + _count - 1).pointee)
    }
}

// MARK: - Pointer Access

extension Stack where Element: ~Copyable {
    @inlinable
    public func withUnsafePointer<R, E: Swift.Error>(
        at index: Int,
        _ body: (UnsafePointer<Element>) throws(E) -> R
    ) throws(E) -> R {
        precondition(index >= 0 && index < _count)
        return try body(storage + index)
    }

    @inlinable
    public mutating func withUnsafeMutablePointer<R, E: Swift.Error>(
        at index: Int,
        _ body: (UnsafeMutablePointer<Element>) throws(E) -> R
    ) throws(E) -> R {
        precondition(index >= 0 && index < _count)
        return try body(storage + index)
    }
}

// MARK: - Sendable

extension Stack: @unchecked Sendable where Element: Sendable {}
