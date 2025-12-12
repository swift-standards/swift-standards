// Axis Tests.swift

import StandardsTestSupport
import Testing
@testable import Dimension

// MARK: - Axis - Static Functions

@Suite("Axis - Static Functions")
struct Axis_StaticTests {
    @Test(arguments: [Axis<2>.primary, Axis<2>.secondary])
    func `perpendicular is involution in 2D`(axis: Axis<2>) {
        let perp1 = Axis<2>.perpendicular(of: axis)
        let perp2 = Axis<2>.perpendicular(of: perp1)
        #expect(perp2 == axis)
    }

    @Test
    func `perpendicular maps primary to secondary in 2D`() {
        #expect(Axis<2>.perpendicular(of: .primary) == .secondary)
    }

    @Test
    func `perpendicular maps secondary to primary in 2D`() {
        #expect(Axis<2>.perpendicular(of: .secondary) == .primary)
    }
}

// MARK: - Axis - Properties

@Suite("Axis - Properties")
struct Axis_PropertyTests {
    @Test(arguments: [Axis<2>.primary, Axis<2>.secondary])
    func `perpendicular property delegates to static function`(axis: Axis<2>) {
        #expect(axis.perpendicular == Axis<2>.perpendicular(of: axis))
    }

    @Test(arguments: [0, 1, 2, 3])
    func `rawValue accessor`(value: Int) {
        let axis: Axis<5>? = Axis(value)
        #expect(axis?.rawValue == value)
    }
}

// MARK: - Axis - Initializers

@Suite("Axis - Initializers")
struct Axis_InitializerTests {
    @Test(arguments: [0, 1, 2, 3, 4])
    func `init with valid rawValue`(value: Int) {
        let axis: Axis<5>? = Axis(value)
        #expect(axis != nil)
        #expect(axis?.rawValue == value)
    }

    @Test(arguments: [-1, 5, 10])
    func `init with invalid rawValue returns nil`(value: Int) {
        let axis: Axis<5>? = Axis(value)
        #expect(axis == nil)
    }

    @Test(arguments: [0, 1, 2])
    func `init unchecked creates axis without bounds checking`(value: Int) {
        let axis: Axis<5> = Axis(unchecked: value)
        #expect(axis.rawValue == value)
    }
}

// MARK: - Axis - Dimension-Specific Constants

@Suite("Axis - Dimension-Specific Constants")
struct Axis_DimensionConstantsTests {
    @Test
    func `1D has only primary`() {
        #expect(Axis<1>.primary.rawValue == 0)
    }

    @Test
    func `2D has primary and secondary`() {
        #expect(Axis<2>.primary.rawValue == 0)
        #expect(Axis<2>.secondary.rawValue == 1)
    }

    @Test
    func `3D has primary secondary and tertiary`() {
        #expect(Axis<3>.primary.rawValue == 0)
        #expect(Axis<3>.secondary.rawValue == 1)
        #expect(Axis<3>.tertiary.rawValue == 2)
    }

    @Test
    func `4D has primary secondary tertiary and quaternary`() {
        #expect(Axis<4>.primary.rawValue == 0)
        #expect(Axis<4>.secondary.rawValue == 1)
        #expect(Axis<4>.tertiary.rawValue == 2)
        #expect(Axis<4>.quaternary.rawValue == 3)
    }
}

// MARK: - Axis - Protocol Conformances

@Suite("Axis - Protocol Conformances")
struct Axis_ProtocolTests {
    @Test
    func `Equatable reflexivity`() {
        #expect(Axis<2>.primary == Axis<2>.primary)
        #expect(Axis<3>.tertiary == Axis<3>.tertiary)
    }

    @Test
    func `Equatable symmetry`() {
        #expect(Axis<2>.primary != Axis<2>.secondary)
        #expect(Axis<3>.primary != Axis<3>.tertiary)
    }

    @Test
    func `Hashable produces unique hashes`() {
        let set: Set<Axis<3>> = [.primary, .secondary, .tertiary, .primary]
        #expect(set.count == 3)
    }
}

// MARK: - Axis - Type Safety

@Suite("Axis - Type Safety")
struct Axis_TypeSafetyTests {
    @Test
    func `Axes of different dimensions have same rawValue but different types`() {
        let axis2: Axis<2> = .primary
        let axis3: Axis<3> = .primary

        // Same rawValue
        #expect(axis2.rawValue == axis3.rawValue)
        #expect(axis2.rawValue == 0)

        // But different types - cannot compare directly (compile-time safety)
        // This would not compile: axis2 == axis3
    }

    @Test
    func `Functions accepting specific dimensions enforce type safety`() {
        func process2D(_ axis: Axis<2>) -> Int {
            axis.rawValue
        }

        let axis2: Axis<2> = .secondary
        #expect(process2D(axis2) == 1)

        // This would NOT compile - type safety prevents dimensional mismatch:
        // let axis3: Axis<3> = .secondary
        // process2D(axis3)  // Error: cannot convert Axis<3> to Axis<2>
    }
}

// MARK: - Axis - Enumerable Conformance

@Suite("Axis - Enumerable Conformance")
struct Axis_EnumerableTests {
    @Test
    func `caseCount matches dimension`() {
        #expect(Axis<1>.caseCount == 1)
        #expect(Axis<2>.caseCount == 2)
        #expect(Axis<3>.caseCount == 3)
        #expect(Axis<4>.caseCount == 4)
    }

    @Test
    func `allCases has correct count`() {
        #expect(Axis<1>.allCases.count == 1)
        #expect(Axis<2>.allCases.count == 2)
        #expect(Axis<3>.allCases.count == 3)
        #expect(Axis<4>.allCases.count == 4)
    }

    @Test
    func `caseIndex matches rawValue`() {
        let axis: Axis<3> = .tertiary
        #expect(axis.caseIndex == axis.rawValue)
        #expect(axis.caseIndex == 2)
    }
}
