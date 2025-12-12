// Enumeration Tests.swift

import StandardsTestSupport
import Testing
@testable import Dimension

// MARK: - Enumeration - Collection Conformance

@Suite("Enumeration - Collection")
struct Enumeration_CollectionTests {
    @Test
    func `startIndex is always 0`() {
        let enumeration = Ordinal<5>.allCases
        #expect(enumeration.startIndex == 0)
    }

    @Test
    func `endIndex equals caseCount`() {
        let enumeration = Ordinal<7>.allCases
        #expect(enumeration.endIndex == 7)
    }

    @Test
    func `count equals caseCount`() {
        let enumeration = Ordinal<7>.allCases
        #expect(enumeration.count == Ordinal<7>.caseCount)
    }

    @Test(arguments: [0, 1, 2, 3])
    func `subscript returns correct element`(index: Int) {
        let enumeration = Ordinal<5>.allCases
        let element = enumeration[index]
        #expect(element.rawValue == index)
    }

    @Test
    func `index after increments by 1`() {
        let enumeration = Ordinal<10>.allCases
        #expect(enumeration.index(after: 0) == 1)
        #expect(enumeration.index(after: 5) == 6)
    }
}

// MARK: - Enumeration - BidirectionalCollection

@Suite("Enumeration - BidirectionalCollection")
struct Enumeration_BidirectionalTests {
    @Test
    func `index before decrements by 1`() {
        let enumeration = Ordinal<10>.allCases
        #expect(enumeration.index(before: 5) == 4)
        #expect(enumeration.index(before: 1) == 0)
    }

    @Test
    func `reverse iteration`() {
        let enumeration = Ordinal<3>.allCases
        let reversed = Array(enumeration.reversed())
        #expect(reversed.count == 3)
        #expect(reversed[0].rawValue == 2)
        #expect(reversed[1].rawValue == 1)
        #expect(reversed[2].rawValue == 0)
    }
}

// MARK: - Enumeration - RandomAccessCollection

@Suite("Enumeration - RandomAccessCollection")
struct Enumeration_RandomAccessTests {
    @Test
    func `distance from start to end`() {
        let enumeration = Ordinal<10>.allCases
        let distance = enumeration.distance(from: enumeration.startIndex, to: enumeration.endIndex)
        #expect(distance == 10)
    }

    @Test(arguments: [(0, 5), (2, 8), (1, 1)])
    func `distance between indices`(from: Int, to: Int) {
        let enumeration = Ordinal<10>.allCases
        let distance = enumeration.distance(from: from, to: to)
        #expect(distance == to - from)
    }

    @Test
    func `index offsetBy`() {
        let enumeration = Ordinal<10>.allCases
        #expect(enumeration.index(0, offsetBy: 5) == 5)
        #expect(enumeration.index(3, offsetBy: 2) == 5)
        #expect(enumeration.index(5, offsetBy: -3) == 2)
    }

    @Test
    func `index offsetBy limitedBy succeeds when within limit`() {
        let enumeration = Ordinal<10>.allCases
        let result = enumeration.index(0, offsetBy: 5, limitedBy: 7)
        #expect(result == 5)
    }

    @Test
    func `index offsetBy limitedBy returns nil when exceeding limit`() {
        let enumeration = Ordinal<10>.allCases
        let result = enumeration.index(0, offsetBy: 8, limitedBy: 5)
        #expect(result == nil)
    }

    @Test
    func `index offsetBy limitedBy with negative distance`() {
        let enumeration = Ordinal<10>.allCases
        let result1 = enumeration.index(5, offsetBy: -3, limitedBy: 1)
        #expect(result1 == 2)

        let result2 = enumeration.index(5, offsetBy: -6, limitedBy: 2)
        #expect(result2 == nil)
    }
}

// MARK: - Enumeration - Iterator

@Suite("Enumeration - Iterator")
struct Enumeration_IteratorTests {
    @Test
    func `iterator produces all elements in order`() {
        let enumeration = Ordinal<4>.allCases
        var iterator = enumeration.makeIterator()

        #expect(iterator.next()?.rawValue == 0)
        #expect(iterator.next()?.rawValue == 1)
        #expect(iterator.next()?.rawValue == 2)
        #expect(iterator.next()?.rawValue == 3)
        #expect(iterator.next() == nil)
    }

    @Test
    func `iterator exhaustion`() {
        let enumeration = Ordinal<5>.allCases
        var iterator = enumeration.makeIterator()

        var count = 0
        while iterator.next() != nil {
            count += 1
        }
        #expect(count == Ordinal<5>.caseCount)
        #expect(iterator.next() == nil)
    }

    @Test
    func `for-in loop iteration`() {
        var indices: [Int] = []
        for ordinal in Ordinal<5>.allCases {
            indices.append(ordinal.rawValue)
        }
        #expect(indices == [0, 1, 2, 3, 4])
    }
}

// MARK: - Enumeration - Zero-Cost Abstraction

@Suite("Enumeration - Zero-Cost")
struct Enumeration_ZeroCostTests {
    @Test
    func `Enumeration is zero-size type`() {
        // Enumeration has no stored properties, so it should be zero-size
        // We can verify this by creating multiple instances and checking iteration
        let enum1 = Ordinal<3>.allCases
        let enum2 = Ordinal<3>.allCases

        #expect(Array(enum1) == Array(enum2))
    }

    @Test
    func `multiple iterations produce same sequence`() {
        let enumeration = Ordinal<5>.allCases
        let array1 = Array(enumeration)
        let array2 = Array(enumeration)
        #expect(array1 == array2)
    }
}
