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

@Suite("Binary.Collection.Set - Model Tests")
struct BitSetModelTests {

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

    /// Reference model using Swift.Set<Int> for comparison.
    typealias SetModel = Swift.Set<Int>

    @Test("Random operations match Swift.Set model")
    func randomOperationsMatchModel() {
        var rng = SeededRNG(seed: 12345)
        var bitSet = Binary.Collection.Set()
        var model = SetModel()

        for _ in 0..<1000 {
            let value = Int(rng.next() % 500)  // Range up to 500
            let op = rng.next() % 3

            switch op {
            case 0:  // insert
                let bitResult = bitSet.insert(value)
                let modelResult = model.insert(value).inserted
                #expect(bitResult == modelResult)

            case 1:  // remove
                let bitResult = bitSet.remove(value)
                let modelResult = model.remove(value) != nil
                #expect(bitResult == modelResult)

            case 2:  // contains
                #expect(bitSet.contains(value) == model.contains(value))

            default:
                break
            }

            // Verify count
            #expect(bitSet.count == model.count)
            #expect(bitSet.isEmpty == model.isEmpty)
        }

        // Final verification
        #expect(Set(bitSet) == model)
    }

    @Test("Word boundary operations match model")
    func wordBoundaryOperationsMatchModel() {
        var bitSet = Binary.Collection.Set()
        var model = SetModel()

        // Test around word boundaries (0, 63, 64, 127, 128)
        let boundaryValues = [0, 1, 62, 63, 64, 65, 126, 127, 128, 129, 191, 192]

        for value in boundaryValues {
            #expect(bitSet.insert(value) == true)
            model.insert(value)
        }

        #expect(bitSet.count == model.count)

        for value in boundaryValues {
            #expect(bitSet.contains(value) == model.contains(value))
        }

        // Remove every other
        for (index, value) in boundaryValues.enumerated() where index % 2 == 0 {
            #expect(bitSet.remove(value) == true)
            model.remove(value)
        }

        #expect(Set(bitSet) == model)
    }

    @Test("Union matches model")
    func unionMatchesModel() {
        var rng = SeededRNG(seed: 23456)

        var bitSetA = Binary.Collection.Set()
        var bitSetB = Binary.Collection.Set()
        var modelA = SetModel()
        var modelB = SetModel()

        for _ in 0..<100 {
            let valueA = Int(rng.next() % 200)
            let valueB = Int(rng.next() % 200)
            bitSetA.insert(valueA)
            bitSetB.insert(valueB)
            modelA.insert(valueA)
            modelB.insert(valueB)
        }

        let bitUnion = bitSetA.algebra.union(bitSetB)
        let modelUnion = modelA.union(modelB)

        #expect(Set(bitUnion) == modelUnion)
    }

    @Test("Intersection matches model")
    func intersectionMatchesModel() {
        var rng = SeededRNG(seed: 34567)

        var bitSetA = Binary.Collection.Set()
        var bitSetB = Binary.Collection.Set()
        var modelA = SetModel()
        var modelB = SetModel()

        for _ in 0..<100 {
            let valueA = Int(rng.next() % 100)
            let valueB = Int(rng.next() % 100)
            bitSetA.insert(valueA)
            bitSetB.insert(valueB)
            modelA.insert(valueA)
            modelB.insert(valueB)
        }

        let bitIntersection = bitSetA.algebra.intersection(bitSetB)
        let modelIntersection = modelA.intersection(modelB)

        #expect(Set(bitIntersection) == modelIntersection)
    }

    @Test("Subtract matches model")
    func subtractMatchesModel() {
        var rng = SeededRNG(seed: 45678)

        var bitSetA = Binary.Collection.Set()
        var bitSetB = Binary.Collection.Set()
        var modelA = SetModel()
        var modelB = SetModel()

        for _ in 0..<100 {
            let valueA = Int(rng.next() % 100)
            let valueB = Int(rng.next() % 100)
            bitSetA.insert(valueA)
            bitSetB.insert(valueB)
            modelA.insert(valueA)
            modelB.insert(valueB)
        }

        let bitDifference = bitSetA.algebra.subtract(bitSetB)
        let modelDifference = modelA.subtracting(modelB)

        #expect(Set(bitDifference) == modelDifference)
    }

    @Test("Symmetric difference matches model")
    func symmetricDifferenceMatchesModel() {
        var rng = SeededRNG(seed: 56789)

        var bitSetA = Binary.Collection.Set()
        var bitSetB = Binary.Collection.Set()
        var modelA = SetModel()
        var modelB = SetModel()

        for _ in 0..<100 {
            let valueA = Int(rng.next() % 100)
            let valueB = Int(rng.next() % 100)
            bitSetA.insert(valueA)
            bitSetB.insert(valueB)
            modelA.insert(valueA)
            modelB.insert(valueB)
        }

        let bitSymmetric = bitSetA.algebra.symmetric.difference(bitSetB)
        let modelSymmetric = modelA.symmetricDifference(modelB)

        #expect(Set(bitSymmetric) == modelSymmetric)
    }

    @Test("isSubset matches model")
    func isSubsetMatchesModel() {
        var bitSetA = Binary.Collection.Set()
        var bitSetB = Binary.Collection.Set()
        var modelA = SetModel()
        var modelB = SetModel()

        // A is subset of B
        for i in 0..<10 {
            bitSetA.insert(i)
            modelA.insert(i)
        }
        for i in 0..<20 {
            bitSetB.insert(i)
            modelB.insert(i)
        }

        #expect(bitSetA.algebra.isSubset(bitSetB) == modelA.isSubset(of: modelB))
        #expect(bitSetB.algebra.isSubset(bitSetA) == modelB.isSubset(of: modelA))

        // Add element not in B
        bitSetA.insert(100)
        modelA.insert(100)
        #expect(bitSetA.algebra.isSubset(bitSetB) == modelA.isSubset(of: modelB))
    }

    @Test("isSuperset matches model")
    func isSupersetMatchesModel() {
        var bitSetA = Binary.Collection.Set()
        var bitSetB = Binary.Collection.Set()
        var modelA = SetModel()
        var modelB = SetModel()

        for i in 0..<20 {
            bitSetA.insert(i)
            modelA.insert(i)
        }
        for i in 0..<10 {
            bitSetB.insert(i)
            modelB.insert(i)
        }

        #expect(bitSetA.algebra.isSuperset(bitSetB) == modelA.isSuperset(of: modelB))
        #expect(bitSetB.algebra.isSuperset(bitSetA) == modelB.isSuperset(of: modelA))
    }

    @Test("isDisjoint matches model")
    func isDisjointMatchesModel() {
        var bitSetA = Binary.Collection.Set()
        var bitSetB = Binary.Collection.Set()
        var modelA = SetModel()
        var modelB = SetModel()

        // Disjoint
        for i in 0..<10 {
            bitSetA.insert(i)
            modelA.insert(i)
        }
        for i in 10..<20 {
            bitSetB.insert(i)
            modelB.insert(i)
        }

        #expect(bitSetA.algebra.isDisjoint(bitSetB) == modelA.isDisjoint(with: modelB))

        // Not disjoint
        bitSetA.insert(15)
        modelA.insert(15)
        #expect(bitSetA.algebra.isDisjoint(bitSetB) == modelA.isDisjoint(with: modelB))
    }

    @Test("Min and max match model")
    func minAndMaxMatchModel() {
        var rng = SeededRNG(seed: 67890)
        var bitSet = Binary.Collection.Set()
        var model = SetModel()

        for _ in 0..<100 {
            let value = Int(rng.next() % 1000)
            bitSet.insert(value)
            model.insert(value)
        }

        #expect(bitSet.min == model.min())
        #expect(bitSet.max == model.max())
    }

    @Test("Iteration produces sorted elements")
    func iterationProducesSortedElements() {
        var rng = SeededRNG(seed: 78901)
        var bitSet = Binary.Collection.Set()

        for _ in 0..<100 {
            bitSet.insert(Int(rng.next() % 500))
        }

        let elements = Array(bitSet)

        // Should be sorted
        #expect(elements == elements.sorted())

        // Should match count
        #expect(elements.count == bitSet.count)
    }

    @Test("Large sparse set matches model")
    func largeSparseSetMatchesModel() {
        var rng = SeededRNG(seed: 89012)
        var bitSet = Binary.Collection.Set()
        var model = SetModel()

        // Insert sparse values across a wide range
        for _ in 0..<50 {
            let value = Int(rng.next() % 100000)
            bitSet.insert(value)
            model.insert(value)
        }

        #expect(bitSet.count == model.count)
        #expect(Set(bitSet) == model)

        // Remove some
        for _ in 0..<25 {
            let value = Int(rng.next() % 100000)
            bitSet.remove(value)
            model.remove(value)
        }

        #expect(Set(bitSet) == model)
    }

    @Test("Heavy insert/remove cycles")
    func heavyInsertRemoveCycles() {
        var rng = SeededRNG(seed: 90123)
        var bitSet = Binary.Collection.Set()
        var model = SetModel()

        for cycle in 0..<10 {
            // Insert phase
            for _ in 0..<100 {
                let value = Int(rng.next() % 200)
                bitSet.insert(value)
                model.insert(value)
            }

            #expect(Set(bitSet) == model, "Mismatch after insert phase \(cycle)")

            // Remove phase
            for _ in 0..<50 {
                let value = Int(rng.next() % 200)
                bitSet.remove(value)
                model.remove(value)
            }

            #expect(Set(bitSet) == model, "Mismatch after remove phase \(cycle)")
        }
    }
}
