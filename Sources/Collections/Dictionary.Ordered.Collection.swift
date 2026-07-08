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

extension Dictionary.Ordered: Sequence {
    public struct Iterator: IteratorProtocol {
        @usableFromInline
        var index: Int

        @usableFromInline
        let keys: Set<Key>.Ordered

        @usableFromInline
        let values: ContiguousArray<Value>

        @usableFromInline
        init(keys: Set<Key>.Ordered, values: ContiguousArray<Value>) {
            self.index = 0
            self.keys = keys
            self.values = values
        }
    }

    @inlinable
    public func makeIterator() -> Iterator {
        Iterator(keys: _keys, values: _values)
    }
}

extension Dictionary.Ordered.Iterator {
    @inlinable
    public mutating func next() -> (key: Key, value: Value)? {
        guard index < keys.count else { return nil }
        defer { index += 1 }
        return (keys[index], values[index])
    }
}

extension Dictionary.Ordered.Iterator: Sendable where Key: Sendable, Value: Sendable {}

// MARK: - Collection

extension Dictionary.Ordered: Collection {
    public typealias Index = Int
    public typealias Element = (key: Key, value: Value)

    @inlinable
    public var startIndex: Index { 0 }

    @inlinable
    public var endIndex: Index { count }

    @inlinable
    public func index(after i: Index) -> Index {
        i + 1
    }

    @inlinable
    public subscript(position: Index) -> Element {
        precondition(position >= 0 && position < count, "Index out of bounds")
        return (_keys[position], _values[position])
    }
}

// MARK: - BidirectionalCollection

extension Dictionary.Ordered: BidirectionalCollection {
    @inlinable
    public func index(before i: Index) -> Index {
        i - 1
    }
}

// MARK: - RandomAccessCollection

extension Dictionary.Ordered: RandomAccessCollection {
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
