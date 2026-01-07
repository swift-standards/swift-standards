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

extension Binary.Collection {
    /// A set of non-negative integers using one bit per element.
    ///
    /// `Binary.Collection.Set` provides space-efficient storage for sets of
    /// non-negative integers, using a single bit to represent each potential
    /// element. This makes it ideal for scenarios involving membership tests
    /// on dense integer ranges.
    ///
    /// ## Storage Model
    ///
    /// The set stores an array of machine words (`UInt`), where each bit
    /// represents the presence of an integer. Integer `n` is stored at
    /// bit `n % UInt.bitWidth` of word `n / UInt.bitWidth`.
    ///
    /// ## Performance
    ///
    /// - Membership test: O(1)
    /// - Insert/remove: O(1) amortized
    /// - Set operations: O(n/w) where w is word bit width
    ///
    /// ## Example
    ///
    /// ```swift
    /// var bits = Binary.Collection.Set()
    /// bits.insert(0)
    /// bits.insert(64)
    /// bits.insert(128)
    ///
    /// print(bits.contains(64))  // true
    /// print(bits.contains(65))  // false
    ///
    /// let union = bits.algebra.union(other)
    /// ```
    public struct Set: Sendable, Equatable, Hashable {
        /// The underlying word storage.
        @usableFromInline
        var words: [UInt]

        /// Creates an empty bit set.
        @inlinable
        public init() {
            self.words = []
        }

        /// Creates a bit set from existing words.
        ///
        /// - Parameter words: The word array to use as storage.
        @usableFromInline
        init(words: [UInt]) {
            self.words = words
        }
    }
}

// MARK: - Word Constants

extension Binary.Collection.Set {
    /// The number of bits per word.
    @inlinable
    static var bitsPerWord: Int { UInt.bitWidth }

    /// Computes the word index for a given element.
    @inlinable
    static func wordIndex(_ element: Int) -> Int {
        element / bitsPerWord
    }

    /// Computes the bit index within a word for a given element.
    @inlinable
    static func bitIndex(_ element: Int) -> Int {
        element % bitsPerWord
    }

    /// Creates a mask for a single bit at the given index.
    @inlinable
    static func bitMask(_ bitIndex: Int) -> UInt {
        1 << bitIndex
    }
}

// MARK: - Core Operations

extension Binary.Collection.Set {
    /// Returns `true` if the set contains the given element.
    ///
    /// - Parameter element: The integer to test for membership.
    /// - Returns: `true` if `element` is in the set.
    /// - Complexity: O(1)
    @inlinable
    public func contains(_ element: Int) -> Bool {
        guard element >= 0 else { return false }
        let word = Self.wordIndex(element)
        guard word < words.count else { return false }
        let bit = Self.bitIndex(element)
        return (words[word] & Self.bitMask(bit)) != 0
    }

    /// Inserts an element into the set.
    ///
    /// - Parameter element: The non-negative integer to insert.
    /// - Returns: `true` if the element was inserted, `false` if already present.
    /// - Precondition: `element >= 0`
    /// - Complexity: O(1) amortized
    @discardableResult
    @inlinable
    public mutating func insert(_ element: Int) -> Bool {
        precondition(element >= 0, "Element must be non-negative")
        let word = Self.wordIndex(element)
        let bit = Self.bitIndex(element)
        let mask = Self.bitMask(bit)

        ensureCapacity(word + 1)

        let wasPresent = (words[word] & mask) != 0
        words[word] |= mask
        return !wasPresent
    }

    /// Removes an element from the set.
    ///
    /// - Parameter element: The integer to remove.
    /// - Returns: `true` if the element was removed, `false` if not present.
    /// - Complexity: O(1)
    @discardableResult
    @inlinable
    public mutating func remove(_ element: Int) -> Bool {
        guard element >= 0 else { return false }
        let word = Self.wordIndex(element)
        guard word < words.count else { return false }

        let bit = Self.bitIndex(element)
        let mask = Self.bitMask(bit)

        let wasPresent = (words[word] & mask) != 0
        words[word] &= ~mask
        return wasPresent
    }

    /// Ensures the word array has at least the given capacity.
    @inlinable
    mutating func ensureCapacity(_ wordCount: Int) {
        if words.count < wordCount {
            words.append(contentsOf: repeatElement(0 as UInt, count: wordCount - words.count))
        }
    }
}

// MARK: - Properties

extension Binary.Collection.Set {
    /// The number of elements in the set.
    ///
    /// - Complexity: O(n/w) where w is word bit width
    @inlinable
    public var count: Int {
        words.reduce(0) { $0 + $1.nonzeroBitCount }
    }

    /// Whether the set is empty.
    ///
    /// - Complexity: O(n/w) where w is word bit width
    @inlinable
    public var isEmpty: Bool {
        words.allSatisfy { $0 == 0 }
    }

    /// Removes all elements from the set.
    @inlinable
    public mutating func clear() {
        words.removeAll(keepingCapacity: true)
    }

    /// The largest element in the set, or `nil` if empty.
    ///
    /// - Complexity: O(n/w) where w is word bit width
    @inlinable
    public var max: Int? {
        for wordIndex in words.indices.reversed() {
            let word = words[wordIndex]
            if word != 0 {
                let highestBit = UInt.bitWidth - 1 - word.leadingZeroBitCount
                return wordIndex * Self.bitsPerWord + highestBit
            }
        }
        return nil
    }

    /// The smallest element in the set, or `nil` if empty.
    ///
    /// - Complexity: O(n/w) where w is word bit width
    @inlinable
    public var min: Int? {
        for wordIndex in words.indices {
            let word = words[wordIndex]
            if word != 0 {
                let lowestBit = word.trailingZeroBitCount
                return wordIndex * Self.bitsPerWord + lowestBit
            }
        }
        return nil
    }
}

// MARK: - Bulk Operations

extension Binary.Collection.Set {
    /// Creates a bit set from a sequence of integers.
    ///
    /// - Parameter elements: The elements to include.
    @inlinable
    public init<S: Sequence>(_ elements: S) where S.Element == Int {
        self.init()
        for element in elements {
            insert(element)
        }
    }

    /// Inserts all elements from a sequence.
    ///
    /// - Parameter elements: The elements to insert.
    @inlinable
    public mutating func formUnion<S: Sequence>(_ elements: S) where S.Element == Int {
        for element in elements {
            insert(element)
        }
    }
}

// MARK: - Identity (for testing)

extension Binary.Collection.Set {
    /// Internal identity for CoW testing.
    ///
    /// This is not CoW in the class sense, but tests can use this to verify
    /// that the underlying array buffer is shared/copied as expected.
    @usableFromInline
    var _identity: ObjectIdentifier? {
        withUnsafePointer(to: words) { _ in
            // Arrays in Swift use CoW internally
            nil  // BitSet doesn't use class-based storage
        }
    }
}

// MARK: - Sequence

extension Binary.Collection.Set: Sequence {
    /// An iterator over the elements of a bit set.
    public struct Iterator: IteratorProtocol {
        @usableFromInline
        let words: [UInt]

        @usableFromInline
        var wordIndex: Int

        @usableFromInline
        var currentWord: UInt

        @usableFromInline
        init(words: [UInt]) {
            self.words = words
            self.wordIndex = 0
            self.currentWord = words.isEmpty ? 0 : words[0]
        }

        @inlinable
        public mutating func next() -> Int? {
            while currentWord == 0 {
                wordIndex += 1
                guard wordIndex < words.count else { return nil }
                currentWord = words[wordIndex]
            }

            let bit = currentWord.trailingZeroBitCount
            currentWord &= currentWord &- 1  // Clear lowest set bit
            return wordIndex * UInt.bitWidth + bit
        }
    }

    @inlinable
    public func makeIterator() -> Iterator {
        Iterator(words: words)
    }
}

extension Binary.Collection.Set.Iterator: Sendable {}

// MARK: - CustomStringConvertible

extension Binary.Collection.Set: CustomStringConvertible {
    public var description: String {
        let elements = Array(self.prefix(10))
        let suffix = count > 10 ? ", ..." : ""
        return "BitSet(\(elements.map(String.init).joined(separator: ", "))\(suffix))"
    }
}
