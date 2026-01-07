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

import Testing
@testable import StandardsCollections

@Suite("Heap")
struct HeapTests {
    @Test("Min-max heap provides both min and max")
    func minMaxHeapOrdering() throws {
        var heap: Heap<Int> = [5, 3, 7, 1, 9]

        #expect(heap.peek.min == 1)
        #expect(heap.peek.max == 9)

        #expect(try heap.pop.min() == 1)
        #expect(try heap.pop.max() == 9)
        #expect(heap.peek.min == 3)
        #expect(heap.peek.max == 7)
    }

    @Test("Pop min in order")
    func popMinInOrder() throws {
        var heap: Heap<Int> = [5, 3, 7, 1]

        #expect(try heap.pop.min() == 1)
        #expect(try heap.pop.min() == 3)
        #expect(try heap.pop.min() == 5)
        #expect(try heap.pop.min() == 7)
        #expect(heap.isEmpty)
    }

    @Test("Pop max in order")
    func popMaxInOrder() throws {
        var heap: Heap<Int> = [5, 3, 7, 1]

        #expect(try heap.pop.max() == 7)
        #expect(try heap.pop.max() == 5)
        #expect(try heap.pop.max() == 3)
        #expect(try heap.pop.max() == 1)
        #expect(heap.isEmpty)
    }

    @Test("Peek does not remove")
    func peekDoesNotRemove() {
        var heap: Heap<Int> = [3, 1, 2]

        #expect(heap.peek.min == 1)
        #expect(heap.peek.min == 1)
        #expect(heap.peek.max == 3)
        #expect(heap.peek.max == 3)
        #expect(heap.count == 3)
    }

    @Test("Empty heap")
    func emptyHeap() {
        var heap = Heap<Int>()
        #expect(heap.isEmpty)
        #expect(heap.peek.min == nil)
        #expect(heap.peek.max == nil)
        #expect(heap.take.min == nil)
        #expect(heap.take.max == nil)
    }

    @Test("Single element")
    func singleElement() throws {
        var heap: Heap<Int> = [42]
        #expect(!heap.isEmpty)
        #expect(heap.count == 1)
        #expect(heap.peek.min == 42)
        #expect(heap.peek.max == 42)
        #expect(try heap.pop.min() == 42)
        #expect(heap.isEmpty)
    }

    @Test("Remove all")
    func removeAll() {
        var heap: Heap<Int> = [1, 2, 3]
        #expect(heap.count == 3)

        heap.removeAll()
        #expect(heap.isEmpty)
    }

    @Test("Duplicate elements")
    func duplicateElements() {
        var heap: Heap<Int> = [5, 5, 5]

        #expect(heap.take.min == 5)
        #expect(heap.take.min == 5)
        #expect(heap.take.min == 5)
        #expect(heap.take.min == nil)
    }

    @Test("Push elements")
    func pushElements() {
        var heap = Heap<Int>()
        heap.push(5)
        heap.push(3)
        heap.push(7)

        #expect(heap.count == 3)
        #expect(heap.peek.min == 3)
        #expect(heap.peek.max == 7)
    }

    @Test("Take returns nil when empty")
    func takeReturnsNil() {
        var heap = Heap<Int>()
        #expect(heap.take.min == nil)
        #expect(heap.take.max == nil)
    }

    @Test("Pop throws when empty")
    func popThrowsWhenEmpty() {
        var heap = Heap<Int>()
        #expect(throws: Heap<Int>.Error.self) {
            try heap.pop.min()
        }
        #expect(throws: Heap<Int>.Error.self) {
            try heap.pop.max()
        }
    }
}
