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

@Suite("Deque")
struct DequeTests {

    // MARK: - Nested Accessor: Push

    @Test
    func `Push back via nested accessor`() {
        var deque = Deque<Int>()
        deque.push.back(1)
        deque.push.back(2)
        deque.push.back(3)

        #expect(deque.count == 3)
        #expect(deque[0] == 1)
        #expect(deque[1] == 2)
        #expect(deque[2] == 3)
    }

    @Test
    func `Push front via nested accessor`() {
        var deque = Deque<Int>()
        deque.push.front(1)
        deque.push.front(2)
        deque.push.front(3)

        #expect(deque.count == 3)
        #expect(deque[0] == 3)
        #expect(deque[1] == 2)
        #expect(deque[2] == 1)
    }

    @Test
    func `Push mixed front and back`() {
        var deque = Deque<Int>()
        deque.push.back(2)
        deque.push.front(1)
        deque.push.back(3)
        deque.push.front(0)

        #expect(Array(deque) == [0, 1, 2, 3])
    }

    // MARK: - Nested Accessor: Pop

    @Test
    func `Pop back via nested accessor`() throws {
        var deque: Deque<Int> = [1, 2, 3]

        #expect(try deque.pop.back() == 3)
        #expect(try deque.pop.back() == 2)
        #expect(try deque.pop.back() == 1)
        #expect(deque.isEmpty)
    }

    @Test
    func `Pop front via nested accessor`() throws {
        var deque: Deque<Int> = [1, 2, 3]

        #expect(try deque.pop.front() == 1)
        #expect(try deque.pop.front() == 2)
        #expect(try deque.pop.front() == 3)
        #expect(deque.isEmpty)
    }

    @Test
    func `Pop from empty deque throws`() {
        var deque = Deque<Int>()

        #expect(throws: Deque<Int>.Error.self) {
            _ = try deque.pop.back()
        }

        #expect(throws: Deque<Int>.Error.self) {
            _ = try deque.pop.front()
        }
    }

    // MARK: - Nested Accessor: Peek

    @Test
    func `Peek back via nested accessor`() {
        let deque: Deque<Int> = [1, 2, 3]

        #expect(deque.peek.back == 3)
        #expect(deque.count == 3)  // Peek doesn't remove
    }

    @Test
    func `Peek front via nested accessor`() {
        let deque: Deque<Int> = [1, 2, 3]

        #expect(deque.peek.front == 1)
        #expect(deque.count == 3)  // Peek doesn't remove
    }

    @Test
    func `Peek empty deque returns nil`() {
        let deque = Deque<Int>()

        #expect(deque.peek.back == nil)
        #expect(deque.peek.front == nil)
    }

    // MARK: - Nested Accessor: Take

    @Test
    func `Take back via nested accessor`() {
        var deque: Deque<Int> = [1, 2, 3]

        #expect(deque.take.back == 3)
        #expect(deque.take.back == 2)
        #expect(deque.take.back == 1)
        #expect(deque.isEmpty)
    }

    @Test
    func `Take front via nested accessor`() {
        var deque: Deque<Int> = [1, 2, 3]

        #expect(deque.take.front == 1)
        #expect(deque.take.front == 2)
        #expect(deque.take.front == 3)
        #expect(deque.isEmpty)
    }

    @Test
    func `Take from empty deque returns nil`() {
        var deque = Deque<Int>()

        #expect(deque.take.back == nil)
        #expect(deque.take.front == nil)
        #expect(deque.isEmpty)
    }

    @Test
    func `Take as queue drain loop`() {
        var queue: Deque<Int> = [1, 2, 3, 4, 5]
        var result: [Int] = []

        while let element = queue.take.front {
            result.append(element)
        }

        #expect(result == [1, 2, 3, 4, 5])
        #expect(queue.isEmpty)
    }

    @Test
    func `Take as stack drain loop`() {
        var stack: Deque<Int> = [1, 2, 3, 4, 5]
        var result: [Int] = []

        while let element = stack.take.back {
            result.append(element)
        }

        #expect(result == [5, 4, 3, 2, 1])
        #expect(stack.isEmpty)
    }

    @Test
    func `Take maintains CoW semantics`() {
        let original: Deque<Int> = [1, 2, 3]
        var copy = original

        #expect(original._identity == copy._identity)

        _ = copy.take.front

        #expect(original._identity != copy._identity)
        #expect(Array(original) == [1, 2, 3])
        #expect(Array(copy) == [2, 3])
    }

    // MARK: - Basic Properties

    @Test
    func `Empty deque`() {
        let deque = Deque<Int>()

        #expect(deque.isEmpty)
    }

    @Test
    func `Initialization from sequence`() {
        let deque = Deque([1, 2, 3, 4, 5])

        #expect(deque.count == 5)
        #expect(Array(deque) == [1, 2, 3, 4, 5])
    }

    @Test
    func `Array literal initialization`() {
        let deque: Deque<Int> = [10, 20, 30]

        #expect(deque.count == 3)
        #expect(deque[0] == 10)
        #expect(deque[1] == 20)
        #expect(deque[2] == 30)
    }

    // MARK: - Collection Conformance

    @Test
    func `Random access indexing`() {
        var deque: Deque<Int> = [1, 2, 3, 4, 5]

        #expect(deque[0] == 1)
        #expect(deque[2] == 3)
        #expect(deque[4] == 5)

        deque[2] = 30
        #expect(deque[2] == 30)
    }

    @Test
    func `Iteration order`() {
        var deque = Deque<Int>()
        deque.push.back(1)
        deque.push.back(2)
        deque.push.front(0)

        var result: [Int] = []
        for element in deque {
            result.append(element)
        }
        #expect(result == [0, 1, 2])
    }

    @Test
    func `Bidirectional iteration`() {
        let deque: Deque<Int> = [1, 2, 3, 4, 5]

        #expect(Array(deque.reversed()) == [5, 4, 3, 2, 1])
    }

    // MARK: - Copy-on-Write

    @Test
    func `CoW: copy shares storage initially`() {
        let a: Deque<Int> = [1, 2, 3]
        let b = a

        #expect(a._identity == b._identity)
    }

    @Test
    func `CoW: mutation triggers copy`() {
        let a: Deque<Int> = [1, 2, 3]
        var b = a

        #expect(a._identity == b._identity)

        b.push.back(4)

        #expect(a._identity != b._identity)
        #expect(a.count == 3)
        #expect(b.count == 4)
    }

    @Test
    func `CoW: original unchanged after copy mutation`() {
        let original: Deque<Int> = [1, 2, 3]
        var copy = original

        copy.push.front(0)
        _ = try? copy.pop.back()

        #expect(Array(original) == [1, 2, 3])
        #expect(Array(copy) == [0, 1, 2])
    }

    // MARK: - Capacity

    @Test
    func `Reserve capacity`() {
        var deque = Deque<Int>()
        let initialCapacity = deque.capacity

        deque.reserve(100)

        #expect(deque.capacity >= 100)
        #expect(deque.capacity >= initialCapacity)
    }

    @Test
    func `Remove all`() {
        var deque: Deque<Int> = [1, 2, 3, 4, 5]
        #expect(deque.count == 5)

        deque.removeAll()

        #expect(deque.isEmpty)
    }

    @Test
    func `Remove all keeping capacity`() {
        var deque: Deque<Int> = [1, 2, 3, 4, 5]
        deque.reserve(100)
        let capacityBefore = deque.capacity

        deque.removeAll(keepingCapacity: true)

        #expect(deque.isEmpty)
        #expect(deque.capacity == capacityBefore)
    }

    // MARK: - Equatable & Hashable

    @Test("Equality")
    func equality() {
        let a: Deque<Int> = [1, 2, 3]
        let b: Deque<Int> = [1, 2, 3]
        let c: Deque<Int> = [1, 2, 4]

        #expect(a == b)
        #expect(a != c)
    }

    @Test
    func `Hashable`() {
        let a: Deque<Int> = [1, 2, 3]
        let b: Deque<Int> = [1, 2, 3]

        #expect(a.hashValue == b.hashValue)

        var set: Set<Deque<Int>> = []
        set.insert(a)
        #expect(set.contains(b))
    }

    // MARK: - Error Types

    @Test
    func `Error types are typed`() throws {
        var deque = Deque<Int>()

        do throws(Deque<Int>.Error) {
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

    @Test
    func `Bounds error via element(at:)`() {
        let deque: Deque<Int> = [1, 2, 3]

        #expect(throws: Deque<Int>.Error.self) {
            _ = try deque.element(at: 10)
        }

        #expect(throws: Deque<Int>.Error.self) {
            _ = try deque.element(at: -1)
        }
    }

    // MARK: - CoW Behavior Regression Test

    @Test
    func `Push 1000 elements with O(log n) buffer copies`() {
        #if DEBUG
            // Reset copy counter
            _DequeBufferDebug._copyCount = 0

            var deque = Deque<Int>()
            for i in 0..<1000 {
                deque.push.back(i)
            }

            let copyCount = _DequeBufferDebug._copyCount

            #expect(deque.count == 1000)
            #expect(deque.capacity >= 1000)
            #expect(deque.capacity <= 2048)  // Reasonable growth (doubling)

            // O(log n) copies: ~10-20 for 1000 elements (4→8→16→...→1024→2048)
            // The proxy-based _modify may trigger slightly more copies due to double ensureUnique,
            // but should still be O(log n), not O(n) which would be ~1000 copies.
            #expect(
                copyCount <= 25,
                "Expected O(log n) copies, got \(copyCount)"
            )
        #endif
    }
}
