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

@Suite("Collections.Dictionary.Ordered - Model Tests")
struct OrderedDictionaryModelTests {

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

    @Test("Random operations match model")
    func randomOperationsMatchModel() {
        var rng = SeededRNG(seed: 11111)
        var orderedDict = Collections.Dictionary.Ordered<String, Int>()
        var model = ArrayDictModel<String, Int>()

        for _ in 0..<1000 {
            let key = "key\(rng.next() % 50)"  // Limited range for collisions
            let value = Int(rng.next() % 1000)
            let op = rng.next() % 5

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

            // Verify invariants
            #expect(orderedDict.count == model.count)
            #expect(orderedDict.isEmpty == model.isEmpty)
        }

        // Final verification: keys and values match
        let dictKeys = Array(orderedDict.keys)
        #expect(dictKeys == model.keys)

        for key in model.keys {
            #expect(orderedDict[key] == model[key])
        }
    }

    @Test("Insertion order preserved")
    func insertionOrderPreserved() {
        var rng = SeededRNG(seed: 22222)
        var orderedDict = Collections.Dictionary.Ordered<Int, String>()
        var model = ArrayDictModel<Int, String>()

        var insertedKeys: [Int] = []
        for _ in 0..<200 {
            let key = Int(rng.next() % 10000)
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
        var orderedDict = Collections.Dictionary.Ordered<String, Int>()
        var model = ArrayDictModel<String, Int>()

        // Insert in order
        for i in 0..<10 {
            let key = "key\(i)"
            orderedDict[key] = i
            model[key] = i
        }

        let originalOrder = Array(orderedDict.keys)

        // Update middle elements
        orderedDict["key5"] = 500
        model["key5"] = 500
        orderedDict["key3"] = 300
        model["key3"] = 300

        #expect(Array(orderedDict.keys) == originalOrder)
        #expect(Array(orderedDict.keys) == model.keys)
        #expect(orderedDict["key5"] == 500)
        #expect(orderedDict["key3"] == 300)
    }

    @Test("Removal shifts indices")
    func removalShiftsIndices() {
        var orderedDict = Collections.Dictionary.Ordered<String, Int>()
        var model = ArrayDictModel<String, Int>()

        for i in 0..<5 {
            orderedDict["key\(i)"] = i
            model["key\(i)"] = i
        }

        // Remove middle element
        orderedDict.values.remove("key2")
        model.remove("key2")

        #expect(orderedDict.keys.index("key3") == model.index("key3"))
        #expect(orderedDict.keys.index("key4") == model.index("key4"))
        #expect(Array(orderedDict.keys) == model.keys)
    }

    @Test("Reinsertion after removal goes to end")
    func reinsertionGoesToEnd() {
        var orderedDict = Collections.Dictionary.Ordered<String, Int>()
        var model = ArrayDictModel<String, Int>()

        orderedDict["a"] = 1
        orderedDict["b"] = 2
        orderedDict["c"] = 3
        model["a"] = 1
        model["b"] = 2
        model["c"] = 3

        // Remove and reinsert
        orderedDict.values.remove("b")
        model.remove("b")
        orderedDict["b"] = 20
        model["b"] = 20

        #expect(Array(orderedDict.keys) == ["a", "c", "b"])
        #expect(Array(orderedDict.keys) == model.keys)
    }

    @Test("Keys index lookup matches model")
    func keysIndexLookupMatchesModel() {
        var rng = SeededRNG(seed: 33333)
        var orderedDict = Collections.Dictionary.Ordered<Int, String>()
        var model = ArrayDictModel<Int, String>()

        for _ in 0..<100 {
            let key = Int(rng.next() % 200)
            orderedDict[key] = "value"
            model[key] = "value"
        }

        // Test index lookup for all possible keys
        for key in 0..<200 {
            #expect(orderedDict.keys.index(key) == model.index(key))
        }
    }

    @Test("Values modify matches model")
    func valuesModifyMatchesModel() {
        var orderedDict = Collections.Dictionary.Ordered<String, Int>()
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

    @Test("Merge keep first matches model")
    func mergeKeepFirstMatchesModel() {
        var orderedDict = Collections.Dictionary.Ordered<String, Int>()
        var model = ArrayDictModel<String, Int>()

        orderedDict["a"] = 1
        orderedDict["b"] = 2
        model["a"] = 1
        model["b"] = 2

        let pairs = [("b", 20), ("c", 3), ("d", 4)]

        orderedDict.merge.keep.first(pairs)

        // Model: keep first means don't update existing
        for (key, value) in pairs {
            if !model.contains(key) {
                model[key] = value
            }
        }

        #expect(orderedDict["a"] == model["a"])
        #expect(orderedDict["b"] == model["b"])  // Should be 2, not 20
        #expect(orderedDict["c"] == model["c"])
        #expect(orderedDict["d"] == model["d"])
        #expect(Array(orderedDict.keys) == model.keys)
    }

    @Test("Merge keep last matches model")
    func mergeKeepLastMatchesModel() {
        var orderedDict = Collections.Dictionary.Ordered<String, Int>()
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
        #expect(orderedDict["b"] == model["b"])  // Should be 20
        #expect(orderedDict["c"] == model["c"])
        #expect(orderedDict["d"] == model["d"])

        // Order should be a, b, c, d (b stays in place)
        #expect(Array(orderedDict.keys) == ["a", "b", "c", "d"])
    }

    @Test("Iteration matches model")
    func iterationMatchesModel() {
        var rng = SeededRNG(seed: 44444)
        var orderedDict = Collections.Dictionary.Ordered<Int, Int>()
        var model = ArrayDictModel<Int, Int>()

        for _ in 0..<100 {
            let key = Int(rng.next() % 50)
            let value = Int(rng.next() % 1000)
            orderedDict[key] = value
            model[key] = value
        }

        // Forward iteration
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

    @Test("Index access matches model")
    func indexAccessMatchesModel() {
        var rng = SeededRNG(seed: 55555)
        var orderedDict = Collections.Dictionary.Ordered<String, Int>()
        var model = ArrayDictModel<String, Int>()

        for _ in 0..<50 {
            let key = "key\(rng.next() % 100)"
            let value = Int(rng.next() % 1000)
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
}
