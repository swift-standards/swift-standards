// Enumerable Tests.swift

import StandardsTestSupport
import Testing
@testable import Dimension

// MARK: - Enumerable Tests

@Suite("Enumerable - Protocol")
struct Enumerable_ProtocolTests {
    // Test with Ordinal which conforms to Enumerable

    @Test
    func `caseCount returns correct count`() {
        #expect(Ordinal<5>.caseCount == 5)
        #expect(Ordinal<10>.caseCount == 10)
    }

    @Test(arguments: [0, 1, 2])
    func `caseIndex returns valid index`(index: Int) {
        let ordinal = Ordinal<5>(index)!
        let caseIdx = ordinal.caseIndex
        #expect(caseIdx >= 0)
        #expect(caseIdx < Ordinal<5>.caseCount)
        #expect(caseIdx == index)
    }

    @Test(arguments: [0, 1, 2, 3, 4])
    func `init from caseIndex creates correct value`(index: Int) {
        let ordinal = Ordinal<5>(caseIndex: index)
        #expect(ordinal.rawValue == index)
        #expect(ordinal.caseIndex == index)
    }

    @Test(arguments: [0, 1, 2, 3, 4])
    func `caseIndex roundtrip`(index: Int) {
        let ordinal = Ordinal<5>(caseIndex: index)
        let caseIdx = ordinal.caseIndex
        let reconstructed = Ordinal<5>(caseIndex: caseIdx)
        #expect(reconstructed == ordinal)
    }

    @Test
    func `allCases returns Enumeration`() {
        let allCases = Ordinal<5>.allCases
        #expect(allCases.count == Ordinal<5>.caseCount)
    }

    @Test(arguments: [0, 1, 2])
    func `validatingCaseIndex returns value for valid index`(index: Int) {
        let ordinal = Ordinal<3>(validatingCaseIndex: index)
        #expect(ordinal != nil)
        #expect(ordinal?.rawValue == index)
    }

    @Test(arguments: [-1, 3, 10, 100])
    func `validatingCaseIndex returns nil for invalid index`(index: Int) {
        let invalid = Ordinal<3>(validatingCaseIndex: index)
        #expect(invalid == nil)
    }
}

// MARK: - Enumerable with Ordinal

@Suite("Enumerable - Ordinal Tests")
struct Enumerable_OrdinalTests {
    @Test
    func `Ordinal conforms to Enumerable`() {
        let ordinal: Ordinal<5> = Ordinal(2)!
        #expect(ordinal.caseIndex == 2)
        #expect(Ordinal<5>.caseCount == 5)
    }

    @Test(arguments: [0, 1, 2, 3, 4])
    func `Ordinal allCases iteration`(expectedIndex: Int) {
        let allCases = Array(Ordinal<5>.allCases)
        #expect(allCases[expectedIndex].rawValue == expectedIndex)
    }

    @Test
    func `Ordinal Enumeration is RandomAccessCollection`() {
        let enumeration = Ordinal<10>.allCases
        #expect(enumeration.count == 10)
        #expect(enumeration.startIndex == 0)
        #expect(enumeration.endIndex == 10)
    }
}

// MARK: - Enumerable with Axis

@Suite("Enumerable - Axis Tests")
struct Enumerable_AxisTests {
    @Test
    func `Axis conforms to Enumerable`() {
        let axis: Axis<3> = .secondary
        #expect(axis.caseIndex == 1)
        #expect(Axis<3>.caseCount == 3)
    }

    @Test
    func `Axis allCases iteration`() {
        let allCases = Array(Axis<4>.allCases)
        #expect(allCases.count == 4)
        #expect(allCases[0].rawValue == 0)
        #expect(allCases[1].rawValue == 1)
        #expect(allCases[2].rawValue == 2)
        #expect(allCases[3].rawValue == 3)
    }

    @Test(arguments: [0, 1, 2])
    func `Axis caseIndex roundtrip`(index: Int) {
        let axis: Axis<3> = Axis(caseIndex: index)
        #expect(axis.caseIndex == index)
        let reconstructed = Axis<3>(caseIndex: axis.caseIndex)
        #expect(reconstructed.rawValue == axis.rawValue)
    }
}
