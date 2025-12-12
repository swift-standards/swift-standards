// Pair Tests.swift

import StandardsTestSupport
import Testing
@testable import Dimension

// MARK: - Pair - Static Functions

@Suite("Pair - Static Functions")
struct Pair_StaticTests {
    @Test
    func `map transforms second component`() {
        let pair = Pair("a", 10)
        let result = Pair<String, Int>.map(pair) { $0 * 2 }
        #expect(result.first == "a")
        #expect(result.second == 20)
    }

    @Test
    func `mapFirst transforms first component`() {
        let pair = Pair(10, "b")
        let result = Pair<Int, String>.mapFirst(pair) { $0 * 2 }
        #expect(result.first == 20)
        #expect(result.second == "b")
    }

    @Test
    func `bimap transforms both components`() {
        let pair = Pair(10, 20)
        let result = Pair<Int, Int>.bimap(pair, first: { $0 * 2 }, second: { $0 * 3 })
        #expect(result.first == 20)
        #expect(result.second == 60)
    }

    @Test
    func `swapped swaps components`() {
        let pair = Pair("first", 42)
        let result = Pair.swapped(pair)
        #expect(result.first == 42)
        #expect(result.second == "first")
    }

    @Test
    func `swapped is involution for Int pairs`() {
        let pair = Pair(1, 2)
        let swapped = Pair.swapped(pair)
        let doubleSwapped = Pair.swapped(swapped)
        #expect(doubleSwapped.first == pair.first)
        #expect(doubleSwapped.second == pair.second)
    }

    @Test
    func `swapped is involution for Direction-Double pairs`() {
        let pair = Pair(Direction.positive, 10.0)
        let swapped = Pair.swapped(pair)
        let doubleSwapped = Pair.swapped(swapped)
        #expect(doubleSwapped.first == pair.first)
        #expect(doubleSwapped.second == pair.second)
    }

    @Test
    func `swapped is involution for String pairs`() {
        let pair = Pair("key", "value")
        let swapped = Pair.swapped(pair)
        let doubleSwapped = Pair.swapped(swapped)
        #expect(doubleSwapped.first == pair.first)
        #expect(doubleSwapped.second == pair.second)
    }
}

// MARK: - Pair - Properties

@Suite("Pair - Properties")
struct Pair_PropertyTests {
    @Test
    func `first and second accessors`() {
        let pair = Pair(10, "value")
        #expect(pair.first == 10)
        #expect(pair.second == "value")
    }

    @Test
    func `map property delegates to static function`() {
        let pair = Pair("a", 10)
        let result1 = pair.map { $0 * 2 }
        let result2 = Pair<String, Int>.map(pair) { $0 * 2 }
        #expect(result1.first == result2.first)
        #expect(result1.second == result2.second)
    }

    @Test
    func `mapSecond is alias for map`() {
        let pair = Pair("a", 10)
        let result1 = pair.map { $0 * 2 }
        let result2 = pair.mapSecond { $0 * 2 }
        #expect(result1.first == result2.first)
        #expect(result1.second == result2.second)
    }

    @Test
    func `mapFirst property delegates to static function`() {
        let pair = Pair(10, "b")
        let result1 = pair.mapFirst { $0 * 2 }
        let result2 = Pair<Int, String>.mapFirst(pair) { $0 * 2 }
        #expect(result1.first == result2.first)
        #expect(result1.second == result2.second)
    }

    @Test
    func `bimap property delegates to static function`() {
        let pair = Pair(10, 20)
        let result1 = pair.bimap(first: { $0 * 2 }, second: { $0 * 3 })
        let result2 = Pair<Int, Int>.bimap(pair, first: { $0 * 2 }, second: { $0 * 3 })
        #expect(result1.first == result2.first)
        #expect(result1.second == result2.second)
    }

    @Test
    func `swapped property delegates to static function`() {
        let pair = Pair("first", 42)
        let result1 = pair.swapped
        let result2 = Pair<String, Int>.swapped(pair)
        #expect(result1.first == result2.first)
        #expect(result1.second == result2.second)
    }
}

// MARK: - Pair - Initializers

@Suite("Pair - Initializers")
struct Pair_InitializerTests {
    @Test
    func `init with two parameters`() {
        let pair = Pair(10, "value")
        #expect(pair.first == 10)
        #expect(pair.second == "value")
    }

    @Test
    func `init from tuple`() {
        let tuple = (10, "value")
        let pair = Pair(tuple)
        #expect(pair.first == 10)
        #expect(pair.second == "value")
    }

    @Test
    func `tuple property roundtrip`() {
        let original = Pair(42, "test")
        let tuple = original.tuple
        let reconstructed = Pair(tuple)
        #expect(reconstructed.first == original.first)
        #expect(reconstructed.second == original.second)
    }
}

// MARK: - Pair - Protocol Conformances

@Suite("Pair - Protocol Conformances")
struct Pair_ProtocolTests {
    @Test
    func `Equatable when components are Equatable`() {
        let pair1 = Pair(10, "value")
        let pair2 = Pair(10, "value")
        let pair3 = Pair(20, "value")
        #expect(pair1 == pair2)
        #expect(pair1 != pair3)
    }

    @Test
    func `Hashable when components are Hashable`() {
        let set: Set<Pair<Int, String>> = [
            Pair(10, "a"),
            Pair(20, "b"),
            Pair(10, "a")
        ]
        #expect(set.count == 2)
    }
}

// MARK: - Pair - Type-Specific Tests

@Suite("Pair - Type-Specific Tests")
struct Pair_TypeSpecificTests {
    @Test
    func `allFirsts when First is CaseIterable`() {
        let allDirections = Pair<Direction, Int>.allFirsts
        #expect(Array(allDirections).count == 2)
        #expect(Array(allDirections).contains(.positive))
        #expect(Array(allDirections).contains(.negative))
    }

    @Test
    func `Oriented typealias for orientation types`() {
        let horizontal: Oriented<Horizontal, Double> = Pair(.rightward, 10.0)
        #expect(horizontal.first == .rightward)
        #expect(horizontal.second == 10.0)

        let vertical: Vertical.Value<Double> = Pair(.upward, 5.0)
        #expect(vertical.first == .upward)
        #expect(vertical.second == 5.0)
    }
}
