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

// MARK: - Sequence

extension Deque: Sequence {
    public struct Iterator: IteratorProtocol {
        @usableFromInline
        let storage: Storage

        @usableFromInline
        var index: Int

        @usableFromInline
        let count: Int

        @usableFromInline
        init(storage: Storage) {
            self.storage = storage
            self.index = 0
            self.count = storage.count
        }
    }

    @inlinable
    public func makeIterator() -> Iterator {
        Iterator(storage: storage)
    }
}

extension Deque.Iterator {
    @inlinable
    public mutating func next() -> Element? {
        guard index < count else { return nil }
        defer { index += 1 }
        return storage[index]
    }
}

extension Deque.Iterator: Sendable where Element: Sendable {}

// MARK: - Collection

extension Deque: Collection {
    public typealias Index = Int

    @inlinable
    public var startIndex: Index { 0 }

    @inlinable
    public var endIndex: Index { count }

    @inlinable
    public func index(after i: Index) -> Index {
        i + 1
    }
}

// MARK: - BidirectionalCollection

extension Deque: BidirectionalCollection {
    @inlinable
    public func index(before i: Index) -> Index {
        i - 1
    }
}

// MARK: - RandomAccessCollection

extension Deque: RandomAccessCollection {
    @inlinable
    public func distance(from start: Index, to end: Index) -> Int {
        end - start
    }

    @inlinable
    public func index(_ i: Index, offsetBy distance: Int) -> Index {
        i + distance
    }

    @inlinable
    public func index(_ i: Index, offsetBy distance: Int, limitedBy limit: Index) -> Index? {
        let result = i + distance
        if distance >= 0 {
            return result <= limit ? result : nil
        } else {
            return result >= limit ? result : nil
        }
    }
}

// MARK: - MutableCollection

extension Deque: MutableCollection {}
