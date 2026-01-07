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

@Suite("Set.Ordered - Model Tests")
struct OrderedSetModelTests {

    /// Linear congruential generator for deterministic randomness.
    struct LCG {
        var state: UInt64

        init(seed: UInt64) {
            self.state = seed
        }

        mutating func next() -> UInt64 {
            state = state &* 6364136223846793005 &+ 1442695040888963407
            return state
        }

        mutating func nextInt(_ bound: Int) -> Int {
            Int(next() % UInt64(bound))
        }

        mutating func nextBool() -> Bool {
            next() % 2 == 0
        }
    }

    /// Reference model using Array + Set for comparison.
    struct ArraySetModel<Element: Hashable> {
        var elements: [Element] = []
        var set: Swift.Set<Element> = []

        var count: Int { elements.count }
        var isEmpty: Bool { elements.isEmpty }

        func contains(_ element: Element) -> Bool {
            set.contains(element)
        }

        func index(_ element: Element) -> Int? {
            elements.firstIndex(of: element)
        }

        @discardableResult
        mutating func insert(_ element: Element) -> (inserted: Bool, index: Int) {
            if let existing = elements.firstIndex(of: element) {
                return (false, existing)
            }
            elements.append(element)
            set.insert(element)
            return (true, elements.count - 1)
        }

        @discardableResult
        mutating func remove(_ element: Element) -> Element? {
            guard let index = elements.firstIndex(of: element) else { return nil }
            set.remove(element)
            return elements.remove(at: index)
        }
    }

    // MARK: - Random Operations

    @Test("Random operations match model - 1000 iterations")
    func randomOperationsMatchModel() {
        var rng = LCG(seed: 33333)
        var orderedSet = Set<Int>.Ordered()
        var model = ArraySetModel<Int>()

        for _ in 0..<1000 {
            let value = rng.nextInt(100)  // Limited range to ensure collisions
            let op = rng.nextInt(4)

            switch op {
            case 0:  // insert
                let orderedResult = orderedSet.insert(value)
                let modelResult = model.insert(value)
                #expect(orderedResult.inserted == modelResult.inserted)
                #expect(orderedResult.index == modelResult.index)

            case 1:  // remove
                let orderedResult = orderedSet.remove(value)
                let modelResult = model.remove(value)
                #expect(orderedResult == modelResult)

            case 2:  // contains
                #expect(orderedSet.contains(value) == model.contains(value))

            case 3:  // index
                #expect(orderedSet.index(value) == model.index(value))

            default:
                break
            }

            #expect(orderedSet.count == model.count)
            #expect(orderedSet.isEmpty == model.isEmpty)
        }

        #expect(Array(orderedSet) == model.elements)
    }

    // MARK: - Order Preservation

    @Test("Insertion order strictly preserved")
    func insertionOrderPreserved() {
        var rng = LCG(seed: 44444)
        var orderedSet = Set<Int>.Ordered()
        var model = ArraySetModel<Int>()

        var inserted: [Int] = []
        for _ in 0..<500 {
            let value = rng.nextInt(10000)
            if !model.contains(value) {
                orderedSet.insert(value)
                model.insert(value)
                inserted.append(value)
            }
        }

        #expect(Array(orderedSet) == inserted)
        #expect(Array(orderedSet) == model.elements)
    }

    @Test("Remove maintains order of remaining elements")
    func removeMaintainsOrder() {
        var rng = LCG(seed: 55555)
        var orderedSet = Set<Int>.Ordered()
        var model = ArraySetModel<Int>()

        // Insert 200 elements
        for i in 0..<200 {
            orderedSet.insert(i)
            model.insert(i)
        }

        // Remove 100 random elements
        for _ in 0..<100 {
            let value = rng.nextInt(200)
            orderedSet.remove(value)
            model.remove(value)
        }

        #expect(Array(orderedSet) == model.elements)

        // Verify indices are correct after removals
        for (idx, element) in orderedSet.enumerated() {
            #expect(orderedSet.index(element) == idx)
            #expect(model.index(element) == idx)
        }
    }

    // MARK: - Set Algebra

    @Test("Algebra union matches model")
    func algebraUnionMatchesModel() {
        var rng = LCG(seed: 66666)

        var setA = Set<Int>.Ordered()
        var setB = Set<Int>.Ordered()
        var modelA = ArraySetModel<Int>()
        var modelB = ArraySetModel<Int>()

        for _ in 0..<100 {
            let valueA = rng.nextInt(100)
            let valueB = rng.nextInt(100)
            setA.insert(valueA)
            setB.insert(valueB)
            modelA.insert(valueA)
            modelB.insert(valueB)
        }

        let union = setA.algebra.union(setB)

        // Model union: all from A, then new from B
        var modelUnion = modelA
        for element in modelB.elements {
            modelUnion.insert(element)
        }

        #expect(union.count == modelUnion.count)
        #expect(Array(union) == modelUnion.elements)
    }

    @Test("Algebra intersection matches model")
    func algebraIntersectionMatchesModel() {
        var rng = LCG(seed: 77777)

        var setA = Set<Int>.Ordered()
        var setB = Set<Int>.Ordered()

        for _ in 0..<200 {
            setA.insert(rng.nextInt(50))
            setB.insert(rng.nextInt(50))
        }

        let intersection = setA.algebra.intersection(setB)

        // Model: elements in A that are also in B, maintaining A's order
        let modelIntersection = Array(setA).filter { setB.contains($0) }

        #expect(Array(intersection) == modelIntersection)
    }

    @Test("Algebra subtract matches model")
    func algebraSubtractMatchesModel() {
        var rng = LCG(seed: 88888)

        var setA = Set<Int>.Ordered()
        var setB = Set<Int>.Ordered()

        for _ in 0..<200 {
            setA.insert(rng.nextInt(50))
            setB.insert(rng.nextInt(50))
        }

        let difference = setA.algebra.subtract(setB)
        let modelDifference = Array(setA).filter { !setB.contains($0) }

        #expect(Array(difference) == modelDifference)
    }

    @Test("Algebra symmetric difference matches model")
    func algebraSymmetricDifferenceMatchesModel() {
        var rng = LCG(seed: 99999)

        var setA = Set<Int>.Ordered()
        var setB = Set<Int>.Ordered()

        for _ in 0..<200 {
            setA.insert(rng.nextInt(50))
            setB.insert(rng.nextInt(50))
        }

        let symmetric = setA.algebra.symmetric.difference(setB)

        // Model: (A - B) union (B - A), with A's elements first
        let onlyA = Array(setA).filter { !setB.contains($0) }
        let onlyB = Array(setB).filter { !setA.contains($0) }
        let modelSymmetric = onlyA + onlyB

        #expect(Array(symmetric) == modelSymmetric)
    }

    // MARK: - Index Access

    @Test("Index access matches model")
    func indexAccessMatchesModel() {
        var rng = LCG(seed: 10101)
        var orderedSet = Set<Int>.Ordered()
        var model = ArraySetModel<Int>()

        for _ in 0..<200 {
            let value = rng.nextInt(1000)
            orderedSet.insert(value)
            model.insert(value)
        }

        // Verify all indices
        for i in 0..<orderedSet.count {
            #expect(orderedSet[i] == model.elements[i])
        }

        // Random access
        for _ in 0..<100 {
            let idx = rng.nextInt(orderedSet.count)
            #expect(orderedSet[idx] == model.elements[idx])
        }
    }

    // MARK: - Heavy Operations

    @Test("Heavy insert/remove cycles")
    func heavyInsertRemoveCycles() {
        var rng = LCG(seed: 20202)
        var orderedSet = Set<Int>.Ordered()
        var model = ArraySetModel<Int>()

        for cycle in 0..<5 {
            // Insert phase
            for _ in 0..<100 {
                let value = rng.nextInt(200)
                orderedSet.insert(value)
                model.insert(value)
            }

            #expect(Array(orderedSet) == model.elements, "Mismatch after insert phase \(cycle)")

            // Remove phase
            for _ in 0..<50 {
                let value = rng.nextInt(200)
                orderedSet.remove(value)
                model.remove(value)
            }

            #expect(Array(orderedSet) == model.elements, "Mismatch after remove phase \(cycle)")
        }
    }

    @Test("Large set operations")
    func largeSetOperations() {
        var setA = Set<Int>.Ordered()
        var setB = Set<Int>.Ordered()

        // Build large sets with known overlap
        for i in 0..<1000 {
            setA.insert(i)
        }
        for i in 500..<1500 {
            setB.insert(i)
        }

        let union = setA.algebra.union(setB)
        #expect(union.count == 1500)  // 0-1499

        let intersection = setA.algebra.intersection(setB)
        #expect(intersection.count == 500)  // 500-999

        let difference = setA.algebra.subtract(setB)
        #expect(difference.count == 500)  // 0-499

        let symmetric = setA.algebra.symmetric.difference(setB)
        #expect(symmetric.count == 1000)  // 0-499 and 1000-1499
    }

    // MARK: - Edge Cases

    @Test("Empty set operations")
    func emptySetOperations() {
        let empty = Set<Int>.Ordered()
        var nonEmpty = Set<Int>.Ordered()
        nonEmpty.insert(1)
        nonEmpty.insert(2)
        nonEmpty.insert(3)

        // Union with empty
        #expect(Array(empty.algebra.union(nonEmpty)) == [1, 2, 3])
        #expect(Array(nonEmpty.algebra.union(empty)) == [1, 2, 3])

        // Intersection with empty (testing intersection method returns empty set)
        // swiftlint:disable:next is_disjoint
        #expect(empty.algebra.intersection(nonEmpty).isEmpty)
        // swiftlint:disable:next is_disjoint
        #expect(nonEmpty.algebra.intersection(empty).isEmpty)

        // Subtract empty
        #expect(Array(nonEmpty.algebra.subtract(empty)) == [1, 2, 3])
        #expect(empty.algebra.subtract(nonEmpty).isEmpty)
    }

    @Test("Single element set operations")
    func singleElementSetOperations() {
        var set = Set<Int>.Ordered()
        set.insert(42)

        #expect(set.contains(42))
        #expect(!set.contains(0))
        #expect(set.index(42) == 0)
        #expect(set.index(0) == nil)
        #expect(set.count == 1)

        set.remove(42)
        #expect(set.isEmpty)
        #expect(!set.contains(42))
    }

    @Test("Duplicate insert behavior")
    func duplicateInsertBehavior() {
        var orderedSet = Set<Int>.Ordered()
        var model = ArraySetModel<Int>()

        // First insert
        let first = orderedSet.insert(42)
        let modelFirst = model.insert(42)
        #expect(first.inserted == modelFirst.inserted)
        #expect(first.inserted == true)
        #expect(first.index == 0)

        // Duplicate insert
        let second = orderedSet.insert(42)
        let modelSecond = model.insert(42)
        #expect(second.inserted == modelSecond.inserted)
        #expect(second.inserted == false)
        #expect(second.index == 0)

        #expect(orderedSet.count == 1)
    }
}
