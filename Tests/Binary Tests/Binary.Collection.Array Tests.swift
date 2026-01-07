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

@Suite("Binary.Collection.Array")
struct BinaryCollectionArrayTests {

    // MARK: - Basic Operations

    @Test("Append and subscript")
    func appendAndSubscript() {
        var bits = Binary.Collection.Array()

        bits.append(true)
        bits.append(false)
        bits.append(true)

        #expect(bits[0] == true)
        #expect(bits[1] == false)
        #expect(bits[2] == true)
        #expect(bits.count == 3)
    }

    @Test("Subscript set")
    func subscriptSet() {
        var bits = Binary.Collection.Array([true, true, true])

        bits[1] = false

        #expect(bits[0] == true)
        #expect(bits[1] == false)
        #expect(bits[2] == true)
    }

    @Test("popLast")
    func popLast() {
        var bits = Binary.Collection.Array([true, false, true])

        let last = bits.popLast()
        #expect(last == true)
        #expect(bits.count == 2)

        let second = bits.popLast()
        #expect(second == false)
        #expect(bits.count == 1)

        let first = bits.popLast()
        #expect(first == true)
        #expect(bits.isEmpty)

        let empty = bits.popLast()
        #expect(empty == nil)
    }

    @Test("removeLast")
    func removeLast() {
        var bits = Binary.Collection.Array([true, false])

        bits.removeLast()
        #expect(bits.count == 1)
        #expect(bits[0] == true)
    }

    @Test("removeAll")
    func removeAll() {
        var bits = Binary.Collection.Array([true, false, true])

        bits.removeAll()
        #expect(bits.isEmpty)
    }

    // MARK: - Properties

    @Test("count and isEmpty")
    func countAndIsEmpty() {
        var bits = Binary.Collection.Array()
        #expect(bits.isEmpty)

        bits.append(true)
        #expect(bits.count == 1)
        #expect(!bits.isEmpty)
    }

    @Test("first and last")
    func firstAndLast() {
        var bits = Binary.Collection.Array()
        #expect(bits.first == nil)
        #expect(bits.last == nil)

        bits.append(true)
        #expect(bits.first == true)
        #expect(bits.last == true)

        bits.append(false)
        #expect(bits.first == true)
        #expect(bits.last == false)
    }

    // MARK: - Initialization

    @Test("Init from sequence")
    func initFromSequence() {
        let bits = Binary.Collection.Array([true, false, true, false])

        #expect(bits.count == 4)
        #expect(bits[0] == true)
        #expect(bits[1] == false)
        #expect(bits[2] == true)
        #expect(bits[3] == false)
    }

    @Test("Init repeating true")
    func initRepeatingTrue() {
        let bits = Binary.Collection.Array(repeating: true, count: 5)

        #expect(bits.count == 5)
        #expect(bits.allTrue)
        for i in 0..<5 {
            #expect(bits[i] == true)
        }
    }

    @Test("Init repeating false")
    func initRepeatingFalse() {
        let bits = Binary.Collection.Array(repeating: false, count: 5)

        #expect(bits.count == 5)
        #expect(bits.allFalse)
        for i in 0..<5 {
            #expect(bits[i] == false)
        }
    }

    // MARK: - Word Boundaries

    @Test("Word boundary: index 63 and 64")
    func wordBoundary63And64() {
        var bits = Binary.Collection.Array(repeating: false, count: 100)

        bits[63] = true
        bits[64] = true

        #expect(bits[63] == true)
        #expect(bits[64] == true)
        #expect(bits[62] == false)
        #expect(bits[65] == false)
    }

    @Test("Large array")
    func largeArray() {
        var bits = Binary.Collection.Array(repeating: false, count: 1000)

        bits[0] = true
        bits[500] = true
        bits[999] = true

        #expect(bits.count == 1000)
        #expect(bits.trueCount == 3)
        #expect(bits.falseCount == 997)
    }

    // MARK: - Bitwise Operations

    @Test("toggle")
    func toggle() {
        var bits = Binary.Collection.Array([true, false, true])

        bits.toggle(0)
        bits.toggle(1)
        bits.toggle(2)

        #expect(bits[0] == false)
        #expect(bits[1] == true)
        #expect(bits[2] == false)
    }

    @Test("trueCount and falseCount")
    func trueAndFalseCount() {
        let bits = Binary.Collection.Array([true, false, true, false, true])

        #expect(bits.trueCount == 3)
        #expect(bits.falseCount == 2)
    }

    @Test("allTrue and allFalse")
    func allTrueAndAllFalse() {
        let allTrue = Binary.Collection.Array([true, true, true])
        let allFalse = Binary.Collection.Array([false, false, false])
        let mixed = Binary.Collection.Array([true, false, true])

        #expect(allTrue.allTrue)
        #expect(!allTrue.allFalse)

        #expect(!allFalse.allTrue)
        #expect(allFalse.allFalse)

        #expect(!mixed.allTrue)
        #expect(!mixed.allFalse)
    }

    // MARK: - Iteration

    @Test("Iteration")
    func iteration() {
        let bits = Binary.Collection.Array([true, false, true, false])

        var values: [Bool] = []
        for bit in bits {
            values.append(bit)
        }

        #expect(values == [true, false, true, false])
    }

    @Test("Collection conformance")
    func collectionConformance() {
        let bits = Binary.Collection.Array([true, false, true])

        #expect(bits.startIndex == 0)
        #expect(bits.endIndex == 3)
        #expect(bits.indices == 0..<3)

        #expect(Array(bits) == [true, false, true])
    }

    // MARK: - Equality

    @Test("Equality")
    func equality() {
        let a = Binary.Collection.Array([true, false, true])
        let b = Binary.Collection.Array([true, false, true])
        let c = Binary.Collection.Array([true, true, true])

        #expect(a == b)
        #expect(a != c)
    }

    @Test("Empty arrays equal")
    func emptyArraysEqual() {
        let a = Binary.Collection.Array()
        let b = Binary.Collection.Array()
        #expect(a == b)
    }

    @Test("Different lengths not equal")
    func differentLengthsNotEqual() {
        let a = Binary.Collection.Array([true, false])
        let b = Binary.Collection.Array([true, false, true])
        #expect(a != b)
    }

    // MARK: - Description

    @Test("Description")
    func description() {
        let bits = Binary.Collection.Array([true, false, true])
        let desc = bits.description
        #expect(desc.contains("BitArray"))
        #expect(desc.contains("101"))
    }
}
