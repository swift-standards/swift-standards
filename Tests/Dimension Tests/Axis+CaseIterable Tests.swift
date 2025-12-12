// Axis+CaseIterable Tests.swift

import StandardsTestSupport
import Testing
@testable import Dimension

// MARK: - Axis+CaseIterable - Enumerable Conformance

@Suite("Axis+CaseIterable - Enumerable")
struct AxisCaseIterable_EnumerableTests {
    @Test
    func `caseCount equals dimension`() {
        #expect(Axis<1>.caseCount == 1)
        #expect(Axis<2>.caseCount == 2)
        #expect(Axis<3>.caseCount == 3)
        #expect(Axis<4>.caseCount == 4)
    }

    @Test(arguments: [Axis<3>.primary, Axis<3>.secondary, Axis<3>.tertiary])
    func `caseIndex matches rawValue`(axis: Axis<3>) {
        #expect(axis.caseIndex == axis.rawValue)
    }

    @Test(arguments: [0, 1, 2])
    func `init from caseIndex creates correct axis`(index: Int) {
        let axis: Axis<3> = Axis(caseIndex: index)
        #expect(axis.rawValue == index)
    }

    @Test(arguments: [0, 1, 2, 3])
    func `caseIndex roundtrip`(index: Int) {
        let axis: Axis<4> = Axis(caseIndex: index)
        #expect(axis.caseIndex == index)
        let reconstructed = Axis<4>(caseIndex: axis.caseIndex)
        #expect(reconstructed.rawValue == axis.rawValue)
    }
}

// MARK: - Axis+CaseIterable - AllCases

@Suite("Axis+CaseIterable - AllCases")
struct AxisCaseIterable_AllCasesTests {
    @Test
    func `allCases for 1D has 1 element`() {
        let allCases = Array(Axis<1>.allCases)
        #expect(allCases.count == 1)
        #expect(allCases[0].rawValue == 0)
    }

    @Test
    func `allCases for 2D has 2 elements`() {
        let allCases = Array(Axis<2>.allCases)
        #expect(allCases.count == 2)
        #expect(allCases[0] == .primary)
        #expect(allCases[1] == .secondary)
    }

    @Test
    func `allCases for 3D has 3 elements`() {
        let allCases = Array(Axis<3>.allCases)
        #expect(allCases.count == 3)
        #expect(allCases[0] == .primary)
        #expect(allCases[1] == .secondary)
        #expect(allCases[2] == .tertiary)
    }

    @Test
    func `allCases for 4D has 4 elements`() {
        let allCases = Array(Axis<4>.allCases)
        #expect(allCases.count == 4)
        #expect(allCases[0] == .primary)
        #expect(allCases[1] == .secondary)
        #expect(allCases[2] == .tertiary)
        #expect(allCases[3] == .quaternary)
    }

    @Test
    func `allCases are in order by rawValue`() {
        let allCases = Array(Axis<4>.allCases)
        for (index, axis) in allCases.enumerated() {
            #expect(axis.rawValue == index)
        }
    }
}

// MARK: - Axis+CaseIterable - Iteration

@Suite("Axis+CaseIterable - Iteration")
struct AxisCaseIterable_IterationTests {
    @Test
    func `for-in loop over allCases`() {
        var rawValues: [Int] = []
        for axis in Axis<3>.allCases {
            rawValues.append(axis.rawValue)
        }
        #expect(rawValues == [0, 1, 2])
    }

    @Test
    func `allCases supports RandomAccessCollection operations`() {
        let allCases = Axis<5>.allCases
        #expect(allCases.count == 5)
        #expect(allCases[2].rawValue == 2)
        #expect(allCases.first?.rawValue == 0)
        #expect(allCases.last?.rawValue == 4)
    }
}
