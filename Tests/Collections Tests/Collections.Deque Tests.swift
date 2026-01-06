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

@Suite("Collections.Deque")
struct DequeTests {

    // MARK: - Nested Accessor: Push

    @Test("Push back via nested accessor")
    func pushBack() {
        var deque = Collections.Deque<Int>()
        deque.push.back(1)
        deque.push.back(2)
        deque.push.back(3)

        #expect(deque.count == 3)
        #expect(deque[0] == 1)
        #expect(deque[1] == 2)
        #expect(deque[2] == 3)
    }

    @Test("Push front via nested accessor")
    func pushFront() {
        var deque = Collections.Deque<Int>()
        deque.push.front(1)
        deque.push.front(2)
        deque.push.front(3)

        #expect(deque.count == 3)
        #expect(deque[0] == 3)
        #expect(deque[1] == 2)
        #expect(deque[2] == 1)
    }

    @Test("Push mixed front and back")
    func pushMixed() {
        var deque = Collections.Deque<Int>()
        deque.push.back(2)
        deque.push.front(1)
        deque.push.back(3)
        deque.push.front(0)

        #expect(Array(deque) == [0, 1, 2, 3])
    }

    // MARK: - Nested Accessor: Pop

    @Test("Pop back via nested accessor")
    func popBack() throws {
        var deque: Collections.Deque<Int> = [1, 2, 3]

        #expect(try deque.pop.back() == 3)
        #expect(try deque.pop.back() == 2)
        #expect(try deque.pop.back() == 1)
        #expect(deque.isEmpty)
    }

    @Test("Pop front via nested accessor")
    func popFront() throws {
        var deque: Collections.Deque<Int> = [1, 2, 3]

        #expect(try deque.pop.front() == 1)
        #expect(try deque.pop.front() == 2)
        #expect(try deque.pop.front() == 3)
        #expect(deque.isEmpty)
    }

    @Test("Pop from empty deque throws")
    func popEmptyThrows() {
        var deque = Collections.Deque<Int>()

        #expect(throws: Collections.Deque<Int>.Error.self) {
            _ = try deque.pop.back()
        }

        #expect(throws: Collections.Deque<Int>.Error.self) {
            _ = try deque.pop.front()
        }
    }

    // MARK: - Nested Accessor: Peek

    @Test("Peek back via nested accessor")
    func peekBack() {
        let deque: Collections.Deque<Int> = [1, 2, 3]

        #expect(deque.peek.back == 3)
        #expect(deque.count == 3)  // Peek doesn't remove
    }

    @Test("Peek front via nested accessor")
    func peekFront() {
        let deque: Collections.Deque<Int> = [1, 2, 3]

        #expect(deque.peek.front == 1)
        #expect(deque.count == 3)  // Peek doesn't remove
    }

    @Test("Peek empty deque returns nil")
    func peekEmptyReturnsNil() {
        let deque = Collections.Deque<Int>()

        #expect(deque.peek.back == nil)
        #expect(deque.peek.front == nil)
    }

    // MARK: - Basic Properties

    @Test("Empty deque")
    func emptyDeque() {
        let deque = Collections.Deque<Int>()

        #expect(deque.isEmpty)
        #expect(deque.count == 0)
    }

    @Test("Initialization from sequence")
    func initFromSequence() {
        let deque = Collections.Deque([1, 2, 3, 4, 5])

        #expect(deque.count == 5)
        #expect(Array(deque) == [1, 2, 3, 4, 5])
    }

    @Test("Array literal initialization")
    func arrayLiteralInit() {
        let deque: Collections.Deque<Int> = [10, 20, 30]

        #expect(deque.count == 3)
        #expect(deque[0] == 10)
        #expect(deque[1] == 20)
        #expect(deque[2] == 30)
    }

    // MARK: - Collection Conformance

    @Test("Random access indexing")
    func randomAccessIndexing() {
        var deque: Collections.Deque<Int> = [1, 2, 3, 4, 5]

        #expect(deque[0] == 1)
        #expect(deque[2] == 3)
        #expect(deque[4] == 5)

        deque[2] = 30
        #expect(deque[2] == 30)
    }

    @Test("Iteration order")
    func iterationOrder() {
        var deque = Collections.Deque<Int>()
        deque.push.back(1)
        deque.push.back(2)
        deque.push.front(0)

        var result: [Int] = []
        for element in deque {
            result.append(element)
        }
        #expect(result == [0, 1, 2])
    }

    @Test("Bidirectional iteration")
    func bidirectionalIteration() {
        let deque: Collections.Deque<Int> = [1, 2, 3, 4, 5]

        #expect(Array(deque.reversed()) == [5, 4, 3, 2, 1])
    }

    // MARK: - Copy-on-Write

    @Test("CoW: copy shares storage initially")
    func cowSharesStorage() {
        let a: Collections.Deque<Int> = [1, 2, 3]
        let b = a

        #expect(a._identity == b._identity)
    }

    @Test("CoW: mutation triggers copy")
    func cowMutationTriggersCopy() {
        let a: Collections.Deque<Int> = [1, 2, 3]
        var b = a

        #expect(a._identity == b._identity)

        b.push.back(4)

        #expect(a._identity != b._identity)
        #expect(a.count == 3)
        #expect(b.count == 4)
    }

    @Test("CoW: original unchanged after copy mutation")
    func cowOriginalUnchanged() {
        let original: Collections.Deque<Int> = [1, 2, 3]
        var copy = original

        copy.push.front(0)
        _ = try? copy.pop.back()

        #expect(Array(original) == [1, 2, 3])
        #expect(Array(copy) == [0, 1, 2])
    }

    // MARK: - Capacity

    @Test("Reserve capacity")
    func reserveCapacity() {
        var deque = Collections.Deque<Int>()
        let initialCapacity = deque.capacity

        deque.reserve(100)

        #expect(deque.capacity >= 100)
        #expect(deque.capacity >= initialCapacity)
    }

    @Test("Remove all")
    func removeAll() {
        var deque: Collections.Deque<Int> = [1, 2, 3, 4, 5]
        #expect(deque.count == 5)

        deque.removeAll()

        #expect(deque.isEmpty)
        #expect(deque.count == 0)
    }

    @Test("Remove all keeping capacity")
    func removeAllKeepingCapacity() {
        var deque: Collections.Deque<Int> = [1, 2, 3, 4, 5]
        deque.reserve(100)
        let capacityBefore = deque.capacity

        deque.removeAll(keepingCapacity: true)

        #expect(deque.isEmpty)
        #expect(deque.capacity == capacityBefore)
    }

    // MARK: - Equatable & Hashable

    @Test("Equality")
    func equality() {
        let a: Collections.Deque<Int> = [1, 2, 3]
        let b: Collections.Deque<Int> = [1, 2, 3]
        let c: Collections.Deque<Int> = [1, 2, 4]

        #expect(a == b)
        #expect(a != c)
    }

    @Test("Hashable")
    func hashable() {
        let a: Collections.Deque<Int> = [1, 2, 3]
        let b: Collections.Deque<Int> = [1, 2, 3]

        #expect(a.hashValue == b.hashValue)

        var set: Set<Collections.Deque<Int>> = []
        set.insert(a)
        #expect(set.contains(b))
    }

    // MARK: - Error Types

    @Test("Error types are typed")
    func errorTypesAreTyped() throws {
        var deque = Collections.Deque<Int>()

        do {
            _ = try deque.pop.back()
            Issue.record("Expected error to be thrown")
        } catch {
            switch error {
            case .empty:
                // Expected
                break
            case .bounds, .capacity:
                Issue.record("Unexpected error case")
            }
        }
    }

    @Test("Bounds error via element(at:)")
    func boundsError() {
        let deque: Collections.Deque<Int> = [1, 2, 3]

        #expect(throws: Collections.Deque<Int>.Error.self) {
            _ = try deque.element(at: 10)
        }

        #expect(throws: Collections.Deque<Int>.Error.self) {
            _ = try deque.element(at: -1)
        }
    }

    // MARK: - CoW Behavior Regression Test

    @Test("Push 1000 elements with O(log n) buffer copies")
    func pushManyElementsNoCopyExplosion() {
        #if DEBUG
        // Reset copy counter
        _DequeBufferDebug._copyCount = 0

        var deque = Collections.Deque<Int>()
        for i in 0..<1000 {
            deque.push.back(i)
        }

        let copyCount = _DequeBufferDebug._copyCount

        #expect(deque.count == 1000)
        #expect(deque.capacity >= 1000)
        #expect(deque.capacity <= 2048)  // Reasonable growth (doubling)

        // O(log n) copies: ~10 for 1000 elements (4→8→16→...→1024→2048)
        #expect(copyCount <= 15,
                "Expected O(log n) copies, got \(copyCount)")
        #endif
    }
}
