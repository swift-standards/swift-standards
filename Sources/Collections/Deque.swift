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

/// Double-ended queue with O(1) amortized operations at both ends.
///
/// `Deque` is a value type with copy-on-write semantics backed by a ring buffer.
/// It supports efficient insertion and removal at both the front and back.
///
/// ## API
///
/// Operations use nested accessors with positional naming:
///
/// ```swift
/// var deque = Deque<Int>()
///
/// // Push
/// deque.push.back(1)    // push to back
/// deque.push.front(0)   // push to front
///
/// // Pop
/// let x = try deque.pop.back()   // pop from back
/// let y = try deque.pop.front()  // pop from front
///
/// // Peek (non-throwing)
/// if let back = deque.peek.back { ... }
/// if let front = deque.peek.front { ... }
/// ```
///
/// ## Thread Safety
///
/// Not thread-safe for concurrent mutation. Synchronize externally.
///
/// ## Complexity
///
/// - Push/pop at either end: O(1) amortized
/// - Random access: O(1)
/// - Insertion/removal in middle: O(n)
public struct Deque<Element> {
    @usableFromInline
    var storage: Storage

    /// Creates an empty deque.
    @inlinable
    public init() {
        self.storage = Storage()
    }
}

// MARK: - End

extension Deque {
    /// Which end of the deque to operate on.
    public enum End: Sendable, Equatable {
        /// The front (head) of the deque.
        case front
        /// The back (tail) of the deque.
        case back
    }
}

// MARK: - Initialization

extension Deque {
    /// Creates a deque containing the elements of a sequence.
    ///
    /// - Parameter elements: The sequence of elements.
    @inlinable
    public init<S: Sequence>(_ elements: S) where S.Element == Element {
        self.init()
        for element in elements {
            storage.append(element)
        }
    }
}

// MARK: - Properties

extension Deque {
    /// The number of elements in the deque.
    @inlinable
    public var count: Int {
        storage.count
    }

    /// Whether the deque is empty.
    @inlinable
    public var isEmpty: Bool {
        storage.isEmpty
    }

    /// The current capacity of the deque.
    @inlinable
    public var capacity: Int {
        storage.capacity
    }
}

// MARK: - Capacity

extension Deque {
    /// Reserves enough space to store the specified number of elements.
    ///
    /// - Parameter minimumCapacity: The minimum number of elements to reserve space for.
    @inlinable
    public mutating func reserve(_ minimumCapacity: Int) {
        storage.ensureUnique(minimumCapacity: minimumCapacity)
    }
}

// MARK: - Push (Internal Helper)

extension Deque {
    /// Internal helper for push operations.
    @inlinable
    mutating func _push(_ element: Element, to end: End) {
        switch end {
        case .front:
            storage.prepend(element)
        case .back:
            storage.append(element)
        }
    }
}

// MARK: - Pop (Internal Helper)

extension Deque {
    /// Internal helper for pop operations.
    @inlinable
    mutating func _pop(from end: End) throws(Error) -> Element {
        guard !isEmpty else {
            throw .empty(.init())
        }
        switch end {
        case .front:
            return storage.removeFirst()
        case .back:
            return storage.removeLast()
        }
    }
}

// MARK: - Peek (Internal Helper)

extension Deque {
    /// Internal helper for peek operations.
    @inlinable
    func _peek(at end: End) -> Element? {
        guard !isEmpty else { return nil }
        switch end {
        case .front:
            return storage[0]
        case .back:
            return storage[count - 1]
        }
    }
}

// MARK: - Element Access

extension Deque {
    /// Accesses the element at the specified index.
    ///
    /// - Parameter index: The index of the element to access.
    /// - Returns: The element at the index.
    /// - Throws: `Deque.Error.bounds` if the index is out of bounds.
    @inlinable
    public func element(at index: Int) throws(Error) -> Element {
        guard index >= 0 && index < count else {
            throw .bounds(.init(index: index, count: count))
        }
        return storage[index]
    }

    /// Subscript access to elements.
    ///
    /// - Parameter index: The index of the element.
    /// - Precondition: The index must be in bounds.
    @inlinable
    public subscript(index: Int) -> Element {
        get {
            precondition(index >= 0 && index < count, "Index out of bounds")
            return storage[index]
        }
        set {
            precondition(index >= 0 && index < count, "Index out of bounds")
            storage[index] = newValue
        }
    }
}

// MARK: - Remove All

extension Deque {
    /// Removes all elements from the deque.
    ///
    /// - Parameter keepingCapacity: Whether to keep the current capacity.
    @inlinable
    public mutating func removeAll(keepingCapacity: Bool = false) {
        storage.removeAll(keepingCapacity: keepingCapacity)
    }
}

// MARK: - Sendable

extension Deque: Sendable where Element: Sendable {}

// MARK: - Equatable

extension Deque: Equatable where Element: Equatable {
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        guard lhs.count == rhs.count else { return false }
        for i in 0..<lhs.count {
            if lhs.storage[i] != rhs.storage[i] {
                return false
            }
        }
        return true
    }
}

// MARK: - Hashable

extension Deque: Hashable where Element: Hashable {
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(count)
        for i in 0..<count {
            hasher.combine(storage[i])
        }
    }
}

// MARK: - ExpressibleByArrayLiteral

extension Deque: ExpressibleByArrayLiteral {
    @inlinable
    public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
}

// MARK: - CustomStringConvertible

extension Deque: CustomStringConvertible {
    public var description: String {
        var result = "Deque(["
        var first = true
        for i in 0..<count {
            if !first { result += ", " }
            result += String(describing: storage[i])
            first = false
        }
        result += "])"
        return result
    }
}

// MARK: - Internal CoW Identity (for testing)

extension Deque {
    /// Buffer identity for CoW testing.
    ///
    /// Access via `@testable import StandardsCollections`.
    @usableFromInline
    internal var _identity: ObjectIdentifier {
        ObjectIdentifier(storage.buffer)
    }
}
