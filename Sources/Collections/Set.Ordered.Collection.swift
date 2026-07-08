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

extension Set.Ordered: Sequence {
    public struct Iterator: IteratorProtocol {
        @usableFromInline
        var base: ContiguousArray<Element>.Iterator

        @usableFromInline
        init(_ elements: ContiguousArray<Element>) {
            self.base = elements.makeIterator()
        }
    }

    @inlinable
    public func makeIterator() -> Iterator {
        Iterator(storage.elements)
    }
}

extension Set.Ordered.Iterator {
    @inlinable
    public mutating func next() -> Element? {
        base.next()
    }
}

extension Set.Ordered.Iterator: Sendable where Element: Sendable {}

// MARK: - Collection

extension Set.Ordered: Collection {
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

extension Set.Ordered: BidirectionalCollection {
    @inlinable
    public func index(before i: Index) -> Index {
        i - 1
    }
}

// MARK: - RandomAccessCollection

extension Set.Ordered: RandomAccessCollection {
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
