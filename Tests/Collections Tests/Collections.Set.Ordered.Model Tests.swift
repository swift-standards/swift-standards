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

@Suite("Collections.Set.Ordered - Model Tests")
struct OrderedSetModelTests {

    /// Deterministic PRNG for reproducible tests.
    struct SeededRNG: RandomNumberGenerator {
        var state: UInt64

        init(seed: UInt64) {
            self.state = seed
        }

        mutating func next() -> UInt64 {
            state ^= state << 13
            state ^= state >> 7
            state ^= state << 17
            return state
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

    @Test("Random operations match model")
    func randomOperationsMatchModel() {
        var rng = SeededRNG(seed: 33333)
        var orderedSet = Collections.Set.Ordered<Int>()
        var model = ArraySetModel<Int>()

        for _ in 0..<1000 {
            let value = Int(rng.next() % 100)  // Limited range to ensure collisions
            let op = rng.next() % 4

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

            // Verify invariants
            #expect(orderedSet.count == model.count)
            #expect(orderedSet.isEmpty == model.isEmpty)
        }

        // Final verification
        #expect(Array(orderedSet) == model.elements)
    }

    @Test("Insertion order preserved")
    func insertionOrderPreserved() {
        var rng = SeededRNG(seed: 44444)
        var orderedSet = Collections.Set.Ordered<Int>()
        var model = ArraySetModel<Int>()

        // Insert many unique values
        var inserted: [Int] = []
        for _ in 0..<200 {
            let value = Int(rng.next() % 10000)
            if !model.contains(value) {
                orderedSet.insert(value)
                model.insert(value)
                inserted.append(value)
            }
        }

        // Verify order matches insertion order
        #expect(Array(orderedSet) == inserted)
        #expect(Array(orderedSet) == model.elements)
    }

    @Test("Remove maintains order of remaining elements")
    func removesMaintainOrder() {
        var rng = SeededRNG(seed: 55555)
        var orderedSet = Collections.Set.Ordered<Int>()
        var model = ArraySetModel<Int>()

        // Insert
        for i in 0..<100 {
            orderedSet.insert(i)
            model.insert(i)
        }

        // Remove random elements
        for _ in 0..<50 {
            let value = Int(rng.next() % 100)
            orderedSet.remove(value)
            model.remove(value)
        }

        #expect(Array(orderedSet) == model.elements)
    }

    @Test("Algebra union matches model")
    func algebraUnionMatchesModel() {
        var rng = SeededRNG(seed: 66666)

        var setA = Collections.Set.Ordered<Int>()
        var setB = Collections.Set.Ordered<Int>()
        var modelA = ArraySetModel<Int>()
        var modelB = ArraySetModel<Int>()

        // Build sets
        for _ in 0..<50 {
            let valueA = Int(rng.next() % 100)
            let valueB = Int(rng.next() % 100)
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
        var rng = SeededRNG(seed: 77777)

        var setA = Collections.Set.Ordered<Int>()
        var setB = Collections.Set.Ordered<Int>()

        // Build sets with some overlap
        for _ in 0..<100 {
            setA.insert(Int(rng.next() % 50))
            setB.insert(Int(rng.next() % 50))
        }

        let intersection = setA.algebra.intersection(setB)

        // Model: elements in A that are also in B, maintaining A's order
        let modelIntersection = Array(setA).filter { setB.contains($0) }

        #expect(Array(intersection) == modelIntersection)
    }

    @Test("Algebra subtract matches model")
    func algebraSubtractMatchesModel() {
        var rng = SeededRNG(seed: 88888)

        var setA = Collections.Set.Ordered<Int>()
        var setB = Collections.Set.Ordered<Int>()

        for _ in 0..<100 {
            setA.insert(Int(rng.next() % 50))
            setB.insert(Int(rng.next() % 50))
        }

        let difference = setA.algebra.subtract(setB)

        // Model: elements in A that are not in B
        let modelDifference = Array(setA).filter { !setB.contains($0) }

        #expect(Array(difference) == modelDifference)
    }

    @Test("Algebra symmetric difference matches model")
    func algebraSymmetricDifferenceMatchesModel() {
        var rng = SeededRNG(seed: 99999)

        var setA = Collections.Set.Ordered<Int>()
        var setB = Collections.Set.Ordered<Int>()

        for _ in 0..<100 {
            setA.insert(Int(rng.next() % 50))
            setB.insert(Int(rng.next() % 50))
        }

        let symmetric = setA.algebra.symmetric.difference(setB)

        // Model: (A - B) union (B - A), with A's elements first
        let onlyA = Array(setA).filter { !setB.contains($0) }
        let onlyB = Array(setB).filter { !setA.contains($0) }
        let modelSymmetric = onlyA + onlyB

        #expect(Array(symmetric) == modelSymmetric)
    }

    @Test("Index access matches model")
    func indexAccessMatchesModel() {
        var rng = SeededRNG(seed: 10101)
        var orderedSet = Collections.Set.Ordered<Int>()
        var model = ArraySetModel<Int>()

        for _ in 0..<100 {
            let value = Int(rng.next() % 1000)
            orderedSet.insert(value)
            model.insert(value)
        }

        // Verify all indices
        for i in 0..<orderedSet.count {
            #expect(orderedSet[i] == model.elements[i])
        }
    }

}
