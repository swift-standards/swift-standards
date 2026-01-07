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

@Suite("Dictionary.Ordered - Model Tests")
struct OrderedDictionaryModelTests {

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

    /// Reference model using Array of keys + Dictionary for comparison.
    struct ArrayDictModel<Key: Hashable, Value: Equatable> {
        var keys: [Key] = []
        var dict: [Key: Value] = [:]

        var count: Int { keys.count }
        var isEmpty: Bool { keys.isEmpty }

        subscript(key: Key) -> Value? {
            get { dict[key] }
            set {
                if let value = newValue {
                    if dict[key] == nil {
                        keys.append(key)
                    }
                    dict[key] = value
                } else {
                    if let index = keys.firstIndex(of: key) {
                        keys.remove(at: index)
                    }
                    dict[key] = nil
                }
            }
        }

        func contains(_ key: Key) -> Bool {
            dict[key] != nil
        }

        func index(_ key: Key) -> Int? {
            keys.firstIndex(of: key)
        }

        @discardableResult
        mutating func remove(_ key: Key) -> Value? {
            guard let value = dict[key] else { return nil }
            if let index = keys.firstIndex(of: key) {
                keys.remove(at: index)
            }
            dict[key] = nil
            return value
        }

        var elements: [(key: Key, value: Value)] {
            keys.map { ($0, dict[$0]!) }
        }
    }

    // MARK: - Random Operations

    @Test("Random operations match model - 1000 iterations")
    func randomOperationsMatchModel() {
        var rng = LCG(seed: 11111)
        var orderedDict = [String: Int].Ordered()
        var model = ArrayDictModel<String, Int>()

        for _ in 0..<1000 {
            let key = "key\(rng.nextInt(50))"  // Limited range for collisions
            let value = rng.nextInt(10000)
            let op = rng.nextInt(5)

            switch op {
            case 0:  // set via subscript
                orderedDict[key] = value
                model[key] = value

            case 1:  // set via values.set
                orderedDict.values.set(key, value)
                model[key] = value

            case 2:  // remove
                let orderedResult = orderedDict.values.remove(key)
                let modelResult = model.remove(key)
                #expect(orderedResult == modelResult)

            case 3:  // get
                #expect(orderedDict[key] == model[key])

            case 4:  // contains
                #expect(orderedDict.contains(key) == model.contains(key))

            default:
                break
            }

            #expect(orderedDict.count == model.count)
            #expect(orderedDict.isEmpty == model.isEmpty)
        }

        let dictKeys = Array(orderedDict.keys)
        #expect(dictKeys == model.keys)

        for key in model.keys {
            #expect(orderedDict[key] == model[key])
        }
    }

    // MARK: - Order Semantics

    @Test("Insertion order preserved")
    func insertionOrderPreserved() {
        var rng = LCG(seed: 22222)
        var orderedDict = [Int: String].Ordered()
        var model = ArrayDictModel<Int, String>()

        var insertedKeys: [Int] = []
        for _ in 0..<500 {
            let key = rng.nextInt(10000)
            let value = "value\(key)"
            if !model.contains(key) {
                orderedDict[key] = value
                model[key] = value
                insertedKeys.append(key)
            }
        }

        #expect(Array(orderedDict.keys) == insertedKeys)
        #expect(Array(orderedDict.keys) == model.keys)
    }

    @Test("Update does not change order")
    func updateDoesNotChangeOrder() {
        var orderedDict = [String: Int].Ordered()
        var model = ArrayDictModel<String, Int>()

        // Insert in order
        for i in 0..<20 {
            let key = "key\(i)"
            orderedDict[key] = i
            model[key] = i
        }

        let originalOrder = Array(orderedDict.keys)

        // Update various elements (not just middle)
        for i in [0, 5, 10, 15, 19] {
            let key = "key\(i)"
            orderedDict[key] = i * 100
            model[key] = i * 100
        }

        #expect(Array(orderedDict.keys) == originalOrder)
        #expect(Array(orderedDict.keys) == model.keys)

        // Verify values were updated
        for i in [0, 5, 10, 15, 19] {
            #expect(orderedDict["key\(i)"] == i * 100)
        }
    }

    @Test("Removal shifts indices correctly")
    func removalShiftsIndices() {
        var orderedDict = [String: Int].Ordered()
        var model = ArrayDictModel<String, Int>()

        for i in 0..<10 {
            orderedDict["key\(i)"] = i
            model["key\(i)"] = i
        }

        // Remove elements from various positions
        for key in ["key2", "key5", "key8"] {
            orderedDict.values.remove(key)
            model.remove(key)
        }

        // Verify indices shifted correctly
        for key in model.keys {
            #expect(orderedDict.keys.index(key) == model.index(key))
        }

        #expect(Array(orderedDict.keys) == model.keys)
    }

    @Test("Reinsertion after removal goes to end")
    func reinsertionGoesToEnd() {
        var orderedDict = [String: Int].Ordered()
        var model = ArrayDictModel<String, Int>()

        orderedDict["a"] = 1
        orderedDict["b"] = 2
        orderedDict["c"] = 3
        orderedDict["d"] = 4
        model["a"] = 1
        model["b"] = 2
        model["c"] = 3
        model["d"] = 4

        // Remove middle element and reinsert
        orderedDict.values.remove("b")
        model.remove("b")
        orderedDict["b"] = 20
        model["b"] = 20

        #expect(Array(orderedDict.keys) == ["a", "c", "d", "b"])
        #expect(Array(orderedDict.keys) == model.keys)
        #expect(orderedDict["b"] == 20)
    }

    // MARK: - Nested Accessors

    @Test("Keys index lookup matches model")
    func keysIndexLookupMatchesModel() {
        var rng = LCG(seed: 33333)
        var orderedDict = [Int: String].Ordered()
        var model = ArrayDictModel<Int, String>()

        for _ in 0..<200 {
            let key = rng.nextInt(300)
            orderedDict[key] = "value"
            model[key] = "value"
        }

        // Test index lookup for all keys
        for key in 0..<300 {
            #expect(orderedDict.keys.index(key) == model.index(key))
        }
    }

    @Test("Values modify matches model")
    func valuesModifyMatchesModel() {
        var orderedDict = [String: Int].Ordered()
        var model = ArrayDictModel<String, Int>()

        orderedDict["counter"] = 0
        model["counter"] = 0

        for _ in 0..<100 {
            orderedDict.values.modify("counter") { $0 += 1 }
            model["counter"] = model["counter"]! + 1
        }

        #expect(orderedDict["counter"] == model["counter"])
        #expect(orderedDict["counter"] == 100)
    }

    @Test("Values modify on non-existent key")
    func valuesModifyNonExistent() {
        var orderedDict = [String: Int].Ordered()

        let result = orderedDict.values.modify("missing") { $0 += 1 }
        #expect(result == nil)
        #expect(orderedDict["missing"] == nil)
    }

    // MARK: - Merge Operations

    @Test("Merge keep first matches model")
    func mergeKeepFirstMatchesModel() {
        var orderedDict = [String: Int].Ordered()
        var model = ArrayDictModel<String, Int>()

        orderedDict["a"] = 1
        orderedDict["b"] = 2
        model["a"] = 1
        model["b"] = 2

        let pairs = [("b", 20), ("c", 3), ("d", 4), ("a", 10)]

        orderedDict.merge.keep.first(pairs)

        // Model: keep first means don't update existing
        for (key, value) in pairs {
            if !model.contains(key) {
                model[key] = value
            }
        }

        #expect(orderedDict["a"] == 1)   // kept original
        #expect(orderedDict["b"] == 2)   // kept original
        #expect(orderedDict["c"] == 3)   // new
        #expect(orderedDict["d"] == 4)   // new
        #expect(Array(orderedDict.keys) == model.keys)
    }

    @Test("Merge keep last matches model")
    func mergeKeepLastMatchesModel() {
        var orderedDict = [String: Int].Ordered()
        var model = ArrayDictModel<String, Int>()

        orderedDict["a"] = 1
        orderedDict["b"] = 2
        model["a"] = 1
        model["b"] = 2

        let pairs = [("b", 20), ("c", 3), ("d", 4)]

        orderedDict.merge.keep.last(pairs)

        // Model: keep last means update existing (but maintain position)
        for (key, value) in pairs {
            model[key] = value
        }

        #expect(orderedDict["a"] == model["a"])
        #expect(orderedDict["b"] == 20)   // updated
        #expect(orderedDict["c"] == 3)
        #expect(orderedDict["d"] == 4)

        // Order: a, b stay in place; c, d added at end
        #expect(Array(orderedDict.keys) == ["a", "b", "c", "d"])
    }

    // MARK: - Iteration

    @Test("Iteration matches model")
    func iterationMatchesModel() {
        var rng = LCG(seed: 44444)
        var orderedDict = [Int: Int].Ordered()
        var model = ArrayDictModel<Int, Int>()

        for _ in 0..<200 {
            let key = rng.nextInt(50)
            let value = rng.nextInt(10000)
            orderedDict[key] = value
            model[key] = value
        }

        var dictPairs: [(Int, Int)] = []
        for (key, value) in orderedDict {
            dictPairs.append((key, value))
        }

        let modelPairs = model.elements

        #expect(dictPairs.count == modelPairs.count)
        for i in 0..<dictPairs.count {
            #expect(dictPairs[i].0 == modelPairs[i].key)
            #expect(dictPairs[i].1 == modelPairs[i].value)
        }
    }

    @Test("Reverse iteration")
    func reverseIteration() {
        var orderedDict = [String: Int].Ordered()

        for i in 0..<10 {
            orderedDict["key\(i)"] = i
        }

        let reversed = Array(orderedDict.reversed())
        #expect(reversed.count == 10)
        #expect(reversed[0].key == "key9")
        #expect(reversed[9].key == "key0")
    }

    // MARK: - Index Access

    @Test("Index access matches model")
    func indexAccessMatchesModel() {
        var rng = LCG(seed: 55555)
        var orderedDict = [String: Int].Ordered()
        var model = ArrayDictModel<String, Int>()

        for _ in 0..<100 {
            let key = "key\(rng.nextInt(200))"
            let value = rng.nextInt(10000)
            orderedDict[key] = value
            model[key] = value
        }

        for i in 0..<orderedDict.count {
            let dictPair = orderedDict[index: i]
            let modelPair = model.elements[i]
            #expect(dictPair.key == modelPair.key)
            #expect(dictPair.value == modelPair.value)
        }
    }

    // MARK: - Heavy Operations

    @Test("Heavy insert/update/remove cycles")
    func heavyInsertUpdateRemoveCycles() {
        var rng = LCG(seed: 66666)
        var orderedDict = [Int: Int].Ordered()
        var model = ArrayDictModel<Int, Int>()

        for cycle in 0..<5 {
            // Insert phase
            for _ in 0..<100 {
                let key = rng.nextInt(200)
                let value = rng.nextInt(10000)
                orderedDict[key] = value
                model[key] = value
            }

            // Update phase
            for _ in 0..<50 {
                let key = rng.nextInt(200)
                if orderedDict.contains(key) {
                    let newValue = rng.nextInt(10000)
                    orderedDict[key] = newValue
                    model[key] = newValue
                }
            }

            // Remove phase
            for _ in 0..<30 {
                let key = rng.nextInt(200)
                orderedDict.values.remove(key)
                model.remove(key)
            }

            #expect(Array(orderedDict.keys) == model.keys, "Keys mismatch after cycle \(cycle)")
            for key in model.keys {
                #expect(orderedDict[key] == model[key], "Value mismatch for \(key) after cycle \(cycle)")
            }
        }
    }

    // MARK: - Edge Cases

    @Test("Empty dictionary operations")
    func emptyDictionaryOperations() {
        let empty = [String: Int].Ordered()

        #expect(empty.isEmpty)
        #expect(empty["missing"] == nil)
        #expect(!empty.contains("missing"))
        #expect(empty.keys.index("missing") == nil)
    }

    @Test("Single element dictionary")
    func singleElementDictionary() {
        var dict = [String: Int].Ordered()
        dict["only"] = 42

        #expect(dict.count == 1)
        #expect(dict["only"] == 42)
        #expect(dict.contains("only"))
        #expect(dict.keys.index("only") == 0)

        dict.values.remove("only")
        #expect(dict.isEmpty)
    }

    @Test("Nil assignment removes key")
    func nilAssignmentRemovesKey() {
        var orderedDict = [String: Int].Ordered()
        var model = ArrayDictModel<String, Int>()

        orderedDict["a"] = 1
        orderedDict["b"] = 2
        orderedDict["c"] = 3
        model["a"] = 1
        model["b"] = 2
        model["c"] = 3

        orderedDict["b"] = nil
        model["b"] = nil

        #expect(orderedDict.count == 2)
        #expect(!orderedDict.contains("b"))
        #expect(Array(orderedDict.keys) == model.keys)
    }
}
