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
@testable import Binary

@Suite("Binary.Collection.Set")
struct BinaryCollectionSetTests {

    // MARK: - Basic Operations

    @Test("Insert and contains")
    func insertAndContains() {
        var set = Binary.Collection.Set()

        #expect(set.insert(0) == true)
        #expect(set.insert(1) == true)
        #expect(set.insert(63) == true)
        #expect(set.insert(64) == true)
        #expect(set.insert(127) == true)

        #expect(set.contains(0))
        #expect(set.contains(1))
        #expect(set.contains(63))
        #expect(set.contains(64))
        #expect(set.contains(127))

        #expect(!set.contains(2))
        #expect(!set.contains(65))
        #expect(!set.contains(1000))
    }

    @Test("Insert returns false for existing")
    func insertReturnsFalse() {
        var set = Binary.Collection.Set()

        #expect(set.insert(42) == true)
        #expect(set.insert(42) == false)
    }

    @Test("Remove")
    func remove() {
        var set = Binary.Collection.Set()
        set.insert(10)
        set.insert(20)
        set.insert(30)

        #expect(set.remove(20) == true)
        #expect(!set.contains(20))
        #expect(set.contains(10))
        #expect(set.contains(30))

        #expect(set.remove(20) == false)
        #expect(set.remove(100) == false)
    }

    @Test("Negative element not contained")
    func negativeNotContained() {
        let set = Binary.Collection.Set()
        #expect(!set.contains(-1))
        #expect(!set.contains(-100))
    }

    // MARK: - Word Boundaries

    @Test("Word boundary: 63 and 64")
    func wordBoundary63And64() {
        var set = Binary.Collection.Set()
        set.insert(63)
        set.insert(64)

        #expect(set.contains(63))
        #expect(set.contains(64))
        #expect(!set.contains(62))
        #expect(!set.contains(65))
    }

    @Test("Word boundary: 127 and 128")
    func wordBoundary127And128() {
        var set = Binary.Collection.Set()
        set.insert(127)
        set.insert(128)

        #expect(set.contains(127))
        #expect(set.contains(128))
        #expect(!set.contains(126))
        #expect(!set.contains(129))
    }

    @Test("Large elements")
    func largeElements() {
        var set = Binary.Collection.Set()
        set.insert(1000)
        set.insert(10000)
        set.insert(100000)

        #expect(set.contains(1000))
        #expect(set.contains(10000))
        #expect(set.contains(100000))
        #expect(set.count == 3)
    }

    // MARK: - Properties

    @Test("Count")
    func count() {
        var set = Binary.Collection.Set()
        #expect(set.isEmpty)

        set.insert(0)
        #expect(set.count == 1)

        set.insert(64)
        #expect(set.count == 2)

        set.insert(128)
        #expect(set.count == 3)

        set.remove(64)
        #expect(set.count == 2)
    }

    @Test("isEmpty")
    func isEmpty() {
        var set = Binary.Collection.Set()
        #expect(set.isEmpty)

        set.insert(42)
        #expect(!set.isEmpty)

        set.remove(42)
        #expect(set.isEmpty)
    }

    @Test("Min and max")
    func minAndMax() {
        var set = Binary.Collection.Set()
        #expect(set.min == nil)
        #expect(set.max == nil)

        set.insert(50)
        #expect(set.min == 50)
        #expect(set.max == 50)

        set.insert(10)
        set.insert(90)
        #expect(set.min == 10)
        #expect(set.max == 90)

        set.insert(0)
        set.insert(200)
        #expect(set.min == 0)
        #expect(set.max == 200)
    }

    @Test("Clear")
    func clear() {
        var set = Binary.Collection.Set()
        set.insert(1)
        set.insert(2)
        set.insert(3)

        set.clear()
        #expect(set.isEmpty)
    }

    // MARK: - Initialization

    @Test("Init from sequence")
    func initFromSequence() {
        let set = Binary.Collection.Set([1, 2, 3, 64, 65, 66])

        #expect(set.count == 6)
        #expect(set.contains(1))
        #expect(set.contains(2))
        #expect(set.contains(3))
        #expect(set.contains(64))
        #expect(set.contains(65))
        #expect(set.contains(66))
    }

    @Test("Init with duplicates")
    func initWithDuplicates() {
        let set = Binary.Collection.Set([1, 2, 1, 3, 2, 1])
        #expect(set.count == 3)
    }

    // MARK: - Iteration

    @Test("Iteration order")
    func iterationOrder() {
        var set = Binary.Collection.Set()
        set.insert(100)
        set.insert(10)
        set.insert(50)
        set.insert(1)

        let elements = Array(set)
        #expect(elements == [1, 10, 50, 100])
    }

    @Test("Iteration across word boundaries")
    func iterationAcrossWordBoundaries() {
        var set = Binary.Collection.Set()
        set.insert(0)
        set.insert(63)
        set.insert(64)
        set.insert(127)
        set.insert(128)

        let elements = Array(set)
        #expect(elements == [0, 63, 64, 127, 128])
    }

    // MARK: - Set Algebra

    @Test("Union")
    func union() {
        let a = Binary.Collection.Set([1, 2, 3])
        let b = Binary.Collection.Set([3, 4, 5])

        let result = a.algebra.union(b)

        #expect(result.count == 5)
        for i in 1...5 {
            #expect(result.contains(i))
        }
    }

    @Test("Intersection")
    func intersection() {
        let a = Binary.Collection.Set([1, 2, 3, 4])
        let b = Binary.Collection.Set([3, 4, 5, 6])

        let result = a.algebra.intersection(b)

        #expect(result.count == 2)
        #expect(result.contains(3))
        #expect(result.contains(4))
        #expect(!result.contains(1))
        #expect(!result.contains(5))
    }

    @Test("Subtract")
    func subtract() {
        let a = Binary.Collection.Set([1, 2, 3, 4, 5])
        let b = Binary.Collection.Set([2, 4])

        let result = a.algebra.subtract(b)

        #expect(result.count == 3)
        #expect(result.contains(1))
        #expect(result.contains(3))
        #expect(result.contains(5))
        #expect(!result.contains(2))
        #expect(!result.contains(4))
    }

    @Test("Symmetric difference")
    func symmetricDifference() {
        let a = Binary.Collection.Set([1, 2, 3])
        let b = Binary.Collection.Set([2, 3, 4])

        let result = a.algebra.symmetric.difference(b)

        #expect(result.count == 2)
        #expect(result.contains(1))
        #expect(result.contains(4))
        #expect(!result.contains(2))
        #expect(!result.contains(3))
    }

    @Test("Union across word boundaries")
    func unionAcrossWordBoundaries() {
        let a = Binary.Collection.Set([0, 63])
        let b = Binary.Collection.Set([64, 127])

        let result = a.algebra.union(b)

        #expect(result.count == 4)
        #expect(result.contains(0))
        #expect(result.contains(63))
        #expect(result.contains(64))
        #expect(result.contains(127))
    }

    // MARK: - Predicates

    @Test("isSubset")
    func isSubset() {
        let small = Binary.Collection.Set([1, 2, 3])
        let large = Binary.Collection.Set([1, 2, 3, 4, 5])
        let disjoint = Binary.Collection.Set([10, 11, 12])

        #expect(small.algebra.isSubset(large))
        #expect(!large.algebra.isSubset(small))
        #expect(!small.algebra.isSubset(disjoint))
        #expect(small.algebra.isSubset(small))  // Every set is subset of itself
    }

    @Test("isSuperset")
    func isSuperset() {
        let small = Binary.Collection.Set([1, 2, 3])
        let large = Binary.Collection.Set([1, 2, 3, 4, 5])

        #expect(large.algebra.isSuperset(small))
        #expect(!small.algebra.isSuperset(large))
        #expect(small.algebra.isSuperset(small))  // Every set is superset of itself
    }

    @Test("isDisjoint")
    func isDisjoint() {
        let a = Binary.Collection.Set([1, 2, 3])
        let b = Binary.Collection.Set([4, 5, 6])
        let c = Binary.Collection.Set([3, 4, 5])

        #expect(a.algebra.isDisjoint(b))
        #expect(!a.algebra.isDisjoint(c))
    }

    // MARK: - Equality

    @Test("Equality")
    func equality() {
        let a = Binary.Collection.Set([1, 2, 3])
        let b = Binary.Collection.Set([1, 2, 3])
        let c = Binary.Collection.Set([1, 2, 4])

        #expect(a == b)
        #expect(a != c)
    }

    @Test("Empty sets equal")
    func emptySetsEqual() {
        let a = Binary.Collection.Set()
        let b = Binary.Collection.Set()
        #expect(a == b)
    }

    // MARK: - Description

    @Test("Description")
    func description() {
        let set = Binary.Collection.Set([1, 2, 3])
        let desc = set.description
        #expect(desc.contains("BitSet"))
        #expect(desc.contains("1"))
        #expect(desc.contains("2"))
        #expect(desc.contains("3"))
    }
}
