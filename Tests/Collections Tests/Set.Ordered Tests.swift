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

@Suite("Set.Ordered")
struct OrderedSetTests {

    // MARK: - Basic Operations

    @Test("Insert and contains")
    func insertAndContains() {
        var set = Set<String>.Ordered()

        let (inserted1, index1) = set.insert("apple")
        #expect(inserted1)
        #expect(index1 == 0)

        let (inserted2, index2) = set.insert("banana")
        #expect(inserted2)
        #expect(index2 == 1)

        // Duplicate insert
        let (inserted3, index3) = set.insert("apple")
        #expect(!inserted3)
        #expect(index3 == 0)

        #expect(set.contains("apple"))
        #expect(set.contains("banana"))
        #expect(!set.contains("cherry"))
    }

    @Test("Index lookup")
    func indexLookup() {
        var set = Set<Int>.Ordered()
        set.insert(10)
        set.insert(20)
        set.insert(30)

        #expect(set.index(10) == 0)
        #expect(set.index(20) == 1)
        #expect(set.index(30) == 2)
        #expect(set.index(40) == nil)
    }

    @Test("Remove element")
    func removeElement() {
        var set: Set<Int>.Ordered = [1, 2, 3, 4, 5]

        let removed = set.remove(3)
        #expect(removed == 3)
        #expect(set.count == 4)
        #expect(!set.contains(3))

        // Indices should be updated
        #expect(set.index(4) == 2)
        #expect(set.index(5) == 3)

        // Remove non-existent
        let notRemoved = set.remove(100)
        #expect(notRemoved == nil)
    }

    // MARK: - Order Preservation

    @Test("Insertion order preserved")
    func insertionOrderPreserved() {
        var set = Set<String>.Ordered()
        set.insert("charlie")
        set.insert("alpha")
        set.insert("bravo")

        #expect(Array(set) == ["charlie", "alpha", "bravo"])
    }

    @Test("Order after removal")
    func orderAfterRemoval() {
        var set: Set<Int>.Ordered = [1, 2, 3, 4, 5]
        set.remove(2)
        set.remove(4)

        #expect(Array(set) == [1, 3, 5])
    }

    @Test("Re-insertion goes to end")
    func reinsertionGoesToEnd() {
        var set: Set<String>.Ordered = ["a", "b", "c"]
        set.remove("b")
        set.insert("b")

        #expect(Array(set) == ["a", "c", "b"])
    }

    // MARK: - Algebra Operations

    @Test("Union")
    func union() {
        let a: Set<Int>.Ordered = [1, 2, 3]
        let b: Set<Int>.Ordered = [3, 4, 5]

        let result = a.algebra.union(b)

        #expect(Array(result) == [1, 2, 3, 4, 5])
    }

    @Test("Intersection")
    func intersection() {
        let a: Set<Int>.Ordered = [1, 2, 3, 4]
        let b: Set<Int>.Ordered = [2, 4, 6]

        let result = a.algebra.intersection(b)

        #expect(Array(result) == [2, 4])
    }

    @Test("Subtract")
    func subtract() {
        let a: Set<Int>.Ordered = [1, 2, 3, 4, 5]
        let b: Set<Int>.Ordered = [2, 4]

        let result = a.algebra.subtract(b)

        #expect(Array(result) == [1, 3, 5])
    }

    @Test("Symmetric difference")
    func symmetricDifference() {
        let a: Set<Int>.Ordered = [1, 2, 3]
        let b: Set<Int>.Ordered = [2, 3, 4]

        let result = a.algebra.symmetric.difference(b)

        #expect(Array(result) == [1, 4])
    }

    // MARK: - Collection Conformance

    @Test("Subscript access")
    func subscriptAccess() {
        let set: Set<String>.Ordered = ["a", "b", "c"]

        #expect(set[0] == "a")
        #expect(set[1] == "b")
        #expect(set[2] == "c")
    }

    @Test("Iteration")
    func iteration() {
        let set: Set<Int>.Ordered = [10, 20, 30]

        var result: [Int] = []
        for element in set {
            result.append(element)
        }

        #expect(result == [10, 20, 30])
    }

    @Test("Bidirectional iteration")
    func bidirectionalIteration() {
        let set: Set<Int>.Ordered = [1, 2, 3, 4, 5]

        #expect(Array(set.reversed()) == [5, 4, 3, 2, 1])
    }

    // MARK: - Copy-on-Write

    @Test("CoW: copy shares storage")
    func cowSharesStorage() {
        let a: Set<Int>.Ordered = [1, 2, 3]
        let b = a

        #expect(a._identity == b._identity)
    }

    @Test("CoW: mutation triggers copy")
    func cowMutationTriggersCopy() {
        let a: Set<Int>.Ordered = [1, 2, 3]
        var b = a

        #expect(a._identity == b._identity)

        b.insert(4)

        #expect(a._identity != b._identity)
        #expect(a.count == 3)
        #expect(b.count == 4)
    }

    @Test("CoW: original unchanged")
    func cowOriginalUnchanged() {
        let original: Set<Int>.Ordered = [1, 2, 3]
        var copy = original

        copy.remove(2)
        copy.insert(4)

        #expect(Array(original) == [1, 2, 3])
        #expect(Array(copy) == [1, 3, 4])
    }

    // MARK: - Properties

    @Test("Empty set")
    func emptySet() {
        let set = Set<Int>.Ordered()

        #expect(set.isEmpty)
    }

    @Test("Init from sequence")
    func initFromSequence() {
        let set = Set.Ordered([1, 2, 2, 3, 3, 3])

        #expect(set.count == 3)
        #expect(Array(set) == [1, 2, 3])
    }

    @Test("Clear")
    func clear() {
        var set: Set<Int>.Ordered = [1, 2, 3, 4, 5]
        set.clear()

        #expect(set.isEmpty)
    }

    // MARK: - Equatable & Hashable

    @Test("Equality")
    func equality() {
        let a: Set<Int>.Ordered = [1, 2, 3]
        let b: Set<Int>.Ordered = [1, 2, 3]
        let c: Set<Int>.Ordered = [3, 2, 1]  // Different order

        #expect(a == b)
        #expect(a != c)  // Order matters
    }

    @Test("Hashable")
    func hashable() {
        let a: Set<Int>.Ordered = [1, 2, 3]
        let b: Set<Int>.Ordered = [1, 2, 3]

        #expect(a.hashValue == b.hashValue)
    }

    // MARK: - Error Types

    @Test("Bounds error")
    func boundsError() {
        let set: Set<Int>.Ordered = [1, 2, 3]

        #expect(throws: Set<Int>.Ordered.Error.self) {
            _ = try set.element(at: 10)
        }

        #expect(throws: Set<Int>.Ordered.Error.self) {
            _ = try set.element(at: -1)
        }
    }
}
