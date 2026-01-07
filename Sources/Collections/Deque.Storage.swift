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

extension Deque {
    /// Type-local CoW storage for Deque.
    ///
    /// Implements a ring buffer with copy-on-write semantics.
    @usableFromInline
    struct Storage {
        @usableFromInline
        var buffer: Buffer

        @usableFromInline
        init() {
            self.buffer = Buffer.create(minimumCapacity: 0)
        }

        @usableFromInline
        init(buffer: Buffer) {
            self.buffer = buffer
        }
    }
}

// MARK: - Buffer Header

extension Deque.Storage {
    /// Header for the ring buffer.
    @usableFromInline
    struct Header {
        /// Current number of elements.
        @usableFromInline
        var count: Int

        /// Index of the first element in the buffer.
        @usableFromInline
        var head: Int

        /// Total capacity of the buffer.
        @usableFromInline
        var capacity: Int

        @usableFromInline
        init(count: Int = 0, head: Int = 0, capacity: Int = 0) {
            self.count = count
            self.head = head
            self.capacity = capacity
        }
    }
}

// MARK: - Buffer

// MARK: - Debug Copy Counter

#if DEBUG
/// Debug-only copy counter for testing CoW behavior.
/// Must be outside generic Buffer class since static stored properties
/// are not supported in generic types.
@usableFromInline
enum _DequeBufferDebug {
    @usableFromInline
    nonisolated(unsafe) static var _copyCount: Int = 0
}
#endif

extension Deque.Storage {
    /// ManagedBuffer-based storage for the ring buffer.
    @usableFromInline
    final class Buffer: ManagedBuffer<Header, Element> {
        @usableFromInline
        static func create(minimumCapacity: Int) -> Buffer {
            let requestedCapacity = Swift.max(minimumCapacity, 4)
            let buffer = self.create(minimumCapacity: requestedCapacity) { buffer in
                // Use the actual capacity from ManagedBuffer, not the requested one
                Header(count: 0, head: 0, capacity: buffer.capacity)
            }
            return unsafeDowncast(buffer, to: Buffer.self)
        }

        @usableFromInline
        func copy(minimumCapacity: Int) -> Buffer {
            #if DEBUG
            _DequeBufferDebug._copyCount += 1
            #endif
            let requestedCapacity = Swift.max(minimumCapacity, header.count, 4)
            let newBuffer = Buffer.create(minimumCapacity: requestedCapacity)
            // Note: newBuffer.header.capacity is already set to actual capacity by create()

            newBuffer.header.count = header.count
            newBuffer.header.head = 0

            // Copy elements in logical order
            withUnsafeMutablePointerToElements { src in
                newBuffer.withUnsafeMutablePointerToElements { dst in
                    let count = header.count
                    let cap = header.capacity
                    let head = header.head

                    for i in 0..<count {
                        let srcIndex = (head + i) % cap
                        (dst + i).initialize(to: src[srcIndex])
                    }
                }
            }

            return newBuffer
        }

        deinit {
            withUnsafeMutablePointers { header, elements in
                let count = header.pointee.count
                let capacity = header.pointee.capacity
                let head = header.pointee.head

                for i in 0..<count {
                    let index = (head + i) % capacity
                    (elements + index).deinitialize(count: 1)
                }
            }
        }
    }
}

// MARK: - Storage Properties

extension Deque.Storage {
    @usableFromInline
    var count: Int {
        buffer.header.count
    }

    @usableFromInline
    var capacity: Int {
        buffer.header.capacity
    }

    @usableFromInline
    var isEmpty: Bool {
        // swiftlint:disable:next empty_count
        count == 0  // Defining isEmpty in terms of count is correct here
    }
}

// MARK: - Uniqueness

extension Deque.Storage {
    /// Ensures the buffer is uniquely referenced with at least the specified capacity.
    @usableFromInline
    mutating func ensureUnique(minimumCapacity: Int = 0) {
        let requiredCapacity = Swift.max(minimumCapacity, count)

        if !isKnownUniquelyReferenced(&buffer) || capacity < requiredCapacity {
            let newCapacity = Swift.max(requiredCapacity, capacity * 2, 4)
            buffer = buffer.copy(minimumCapacity: newCapacity)
        }
    }
}

// MARK: - Element Access

extension Deque.Storage {
    /// Physical index in the buffer for a logical index.
    @usableFromInline
    func physicalIndex(_ logicalIndex: Int) -> Int {
        (buffer.header.head + logicalIndex) % buffer.header.capacity
    }

    /// Access element at logical index.
    @usableFromInline
    subscript(_ index: Int) -> Element {
        get {
            buffer.withUnsafeMutablePointerToElements { elements in
                elements[physicalIndex(index)]
            }
        }
        set {
            ensureUnique()
            buffer.withUnsafeMutablePointerToElements { elements in
                elements[physicalIndex(index)] = newValue
            }
        }
    }
}

// MARK: - Append / Prepend

extension Deque.Storage {
    /// Appends an element to the back.
    @usableFromInline
    mutating func append(_ element: Element) {
        ensureUnique(minimumCapacity: count + 1)

        buffer.withUnsafeMutablePointers { header, elements in
            let tail = (header.pointee.head + header.pointee.count) % header.pointee.capacity
            (elements + tail).initialize(to: element)
            header.pointee.count += 1
        }
    }

    /// Prepends an element to the front.
    @usableFromInline
    mutating func prepend(_ element: Element) {
        ensureUnique(minimumCapacity: count + 1)

        buffer.withUnsafeMutablePointers { header, elements in
            let capacity = header.pointee.capacity
            let newHead = (header.pointee.head - 1 + capacity) % capacity
            (elements + newHead).initialize(to: element)
            header.pointee.head = newHead
            header.pointee.count += 1
        }
    }
}

// MARK: - Remove

extension Deque.Storage {
    /// Removes and returns the last element.
    @usableFromInline
    mutating func removeLast() -> Element {
        precondition(!isEmpty, "Cannot remove from empty deque")
        ensureUnique()

        return buffer.withUnsafeMutablePointers { header, elements in
            header.pointee.count -= 1
            let tail = (header.pointee.head + header.pointee.count) % header.pointee.capacity
            return (elements + tail).move()
        }
    }

    /// Removes and returns the first element.
    @usableFromInline
    mutating func removeFirst() -> Element {
        precondition(!isEmpty, "Cannot remove from empty deque")
        ensureUnique()

        return buffer.withUnsafeMutablePointers { header, elements in
            let oldHead = header.pointee.head
            let capacity = header.pointee.capacity
            header.pointee.head = (oldHead + 1) % capacity
            header.pointee.count -= 1
            return (elements + oldHead).move()
        }
    }
}

// MARK: - Clear

extension Deque.Storage {
    /// Removes all elements.
    @usableFromInline
    mutating func removeAll(keepingCapacity: Bool = false) {
        if keepingCapacity {
            ensureUnique()
            buffer.withUnsafeMutablePointers { header, elements in
                let count = header.pointee.count
                let capacity = header.pointee.capacity
                let head = header.pointee.head

                for i in 0..<count {
                    let index = (head + i) % capacity
                    (elements + index).deinitialize(count: 1)
                }

                header.pointee.count = 0
                header.pointee.head = 0
            }
        } else {
            buffer = Buffer.create(minimumCapacity: 0)
        }
    }
}

// MARK: - Sendable

// Storage is @unchecked Sendable because:
// - CoW semantics ensure the buffer is never mutated when shared
// - `isKnownUniquelyReferenced` is checked before any mutation
// - When shared across threads (via Sendable Deque), the buffer is immutable
// - Buffer inherits unavailable Sendable from ManagedBuffer, so we mark Storage directly
extension Deque.Storage: @unchecked Sendable where Element: Sendable {}
