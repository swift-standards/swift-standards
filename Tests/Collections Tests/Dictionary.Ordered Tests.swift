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

@Suite
struct `Dictionary.Ordered Tests` {

    // MARK: - Basic Operations

    @Test
    func `Set and get values`() {
        var dict = [String: Int].Ordered()

        dict.values.set("apple", 1)
        dict.values.set("banana", 2)
        dict.values.set("cherry", 3)

        #expect(dict["apple"] == 1)
        #expect(dict["banana"] == 2)
        #expect(dict["cherry"] == 3)
        #expect(dict["durian"] == nil)
    }

    @Test
    func `Subscript set and get`() {
        var dict = [String: Int].Ordered()

        dict["a"] = 1
        dict["b"] = 2

        #expect(dict["a"] == 1)
        #expect(dict["b"] == 2)

        // Update
        dict["a"] = 10
        #expect(dict["a"] == 10)

        // Remove via nil
        dict["b"] = nil
        #expect(dict["b"] == nil)
        #expect(dict.count == 1)
    }

    @Test
    func `Remove value`() {
        var dict = [String: Int].Ordered()
        dict["a"] = 1
        dict["b"] = 2
        dict["c"] = 3

        let removed = dict.values.remove("b")
        #expect(removed == 2)
        #expect(dict.count == 2)
        #expect(!dict.contains("b"))

        // Keys.index should be updated
        #expect(dict.keys.index("c") == 1)
    }

    @Test
    func `Keys index lookup`() {
        var dict = [String: Int].Ordered()
        dict["first"] = 1
        dict["second"] = 2
        dict["third"] = 3

        #expect(dict.keys.index("first") == 0)
        #expect(dict.keys.index("second") == 1)
        #expect(dict.keys.index("third") == 2)
        #expect(dict.keys.index("fourth") == nil)
    }

    // MARK: - Order Preservation

    @Test
    func `Insertion order preserved`() {
        var dict = [String: Int].Ordered()
        dict["charlie"] = 3
        dict["alpha"] = 1
        dict["bravo"] = 2

        let keys = Array(dict.keys)
        #expect(keys == ["charlie", "alpha", "bravo"])
    }

    @Test
    func `Update does not change order`() {
        var dict = [String: Int].Ordered()
        dict["a"] = 1
        dict["b"] = 2
        dict["c"] = 3

        // Update middle element
        dict["b"] = 20

        let keys = Array(dict.keys)
        #expect(keys == ["a", "b", "c"])
        #expect(dict["b"] == 20)
    }

    @Test
    func `Re-insertion goes to end`() {
        var dict = [String: Int].Ordered()
        dict["a"] = 1
        dict["b"] = 2
        dict["c"] = 3

        dict.values.remove("b")
        dict["b"] = 20

        let keys = Array(dict.keys)
        #expect(keys == ["a", "c", "b"])
    }

    // MARK: - Nested Accessors

    @Test
    func `Values modify`() {
        var dict = [String: Int].Ordered()
        dict["counter"] = 0

        dict.values.modify("counter") { $0 += 1 }
        dict.values.modify("counter") { $0 += 1 }

        #expect(dict["counter"] == 2)
    }

    @Test
    func `Merge keep first`() {
        var dict = [String: Int].Ordered()
        dict["a"] = 1
        dict["b"] = 2

        dict.merge.keep.first([("b", 20), ("c", 3)])

        #expect(dict["a"] == 1)
        #expect(dict["b"] == 2)  // Kept first
        #expect(dict["c"] == 3)
    }

    @Test
    func `Merge keep last`() {
        var dict = [String: Int].Ordered()
        dict["a"] = 1
        dict["b"] = 2

        dict.merge.keep.last([("b", 20), ("c", 3)])

        #expect(dict["a"] == 1)
        #expect(dict["b"] == 20)  // Kept last
        #expect(dict["c"] == 3)

        // Order should be preserved (b was updated, not re-inserted)
        let keys = Array(dict.keys)
        #expect(keys == ["a", "b", "c"])
    }

    // MARK: - Initialization

    @Test
    func `Init from pairs`() throws {
        let dict = try [String: Int].Ordered([
            ("a", 1),
            ("b", 2),
            ("c", 3),
        ])

        #expect(dict.count == 3)
        #expect(dict["a"] == 1)
        #expect(dict["b"] == 2)
        #expect(dict["c"] == 3)
    }

    @Test
    func `Init throws on duplicate`() {
        #expect(throws: [String: Int].Ordered.Error.self) {
            _ = try [String: Int].Ordered([
                ("a", 1),
                ("b", 2),
                ("a", 3),  // Duplicate
            ])
        }
    }

    @Test
    func `Init with uniquing closure`() {
        let dict = [String: Int].Ordered(
            [("a", 1), ("b", 2), ("a", 10)],
            uniquingKeysWith: { $0 + $1 }
        )

        #expect(dict["a"] == 11)  // 1 + 10
        #expect(dict["b"] == 2)
    }

    // MARK: - Collection Conformance

    @Test
    func `Index access`() {
        var dict = [String: Int].Ordered()
        dict["a"] = 1
        dict["b"] = 2
        dict["c"] = 3

        let pair = dict[index: 1]
        #expect(pair.key == "b")
        #expect(pair.value == 2)
    }

    @Test
    func `Iteration`() {
        var dict = [String: Int].Ordered()
        dict["x"] = 10
        dict["y"] = 20
        dict["z"] = 30

        var keys: [String] = []
        var values: [Int] = []
        for (key, value) in dict {
            keys.append(key)
            values.append(value)
        }

        #expect(keys == ["x", "y", "z"])
        #expect(values == [10, 20, 30])
    }

    @Test
    func `Bidirectional iteration`() {
        var dict = [String: Int].Ordered()
        dict["a"] = 1
        dict["b"] = 2
        dict["c"] = 3

        let reversed = Array(dict.reversed())
        #expect(reversed.map { $0.key } == ["c", "b", "a"])
    }

    // MARK: - Copy-on-Write

    @Test
    func `CoW: copy shares storage`() {
        var dict = [String: Int].Ordered()
        dict["a"] = 1
        let copy = dict

        #expect(dict._identity == copy._identity)
    }

    @Test
    func `CoW: mutation triggers copy`() {
        var dict = [String: Int].Ordered()
        dict["a"] = 1
        var copy = dict

        #expect(dict._identity == copy._identity)

        copy["b"] = 2

        #expect(dict._identity != copy._identity)
        #expect(dict.count == 1)
        #expect(copy.count == 2)
    }

    // MARK: - Properties

    @Test
    func `Empty dictionary`() {
        let dict = [String: Int].Ordered()

        #expect(dict.isEmpty)
    }

    @Test("Clear")
    func clear() {
        var dict = [String: Int].Ordered()
        dict["a"] = 1
        dict["b"] = 2

        dict.clear()

        #expect(dict.isEmpty)
    }

    @Test
    func `Contains`() {
        var dict = [String: Int].Ordered()
        dict["apple"] = 1

        #expect(dict.contains("apple"))
        #expect(!dict.contains("banana"))
    }

    // MARK: - Equatable

    @Test("Equality")
    func equality() {
        var a = [String: Int].Ordered()
        a["x"] = 1
        a["y"] = 2

        var b = [String: Int].Ordered()
        b["x"] = 1
        b["y"] = 2

        var c = [String: Int].Ordered()
        c["y"] = 2
        c["x"] = 1  // Different order

        #expect(a == b)
        #expect(a != c)  // Order matters
    }
}
