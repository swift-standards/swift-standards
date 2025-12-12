// Axis.Horizontal Tests.swift

import StandardsTestSupport
import Testing
@testable import Dimension

// MARK: - Axis.Horizontal Typealias Tests

@Suite("Axis.Horizontal - Typealias")
struct AxisHorizontal_TypealiasTests {
    @Test
    func `Axis2 Horizontal is identical to Horizontal`() {
        let axisHoriz: Axis<2>.Horizontal = .leftward
        let horiz: Horizontal = .leftward

        #expect(axisHoriz == horiz)
        #expect(axisHoriz.opposite == horiz.opposite)
    }

    @Test(arguments: [Horizontal.rightward, Horizontal.leftward])
    func `All Horizontal functionality available via Axis2 Horizontal`(horizontal: Horizontal) {
        let axisHoriz: Axis<2>.Horizontal = horizontal

        #expect(axisHoriz.direction == horizontal.direction)
        #expect(axisHoriz.opposite == horizontal.opposite)
        #expect(axisHoriz.isRightward == horizontal.isRightward)
        #expect(axisHoriz.isLeftward == horizontal.isLeftward)
    }

    @Test
    func `Horizontal available for 2D`() {
        // Compile-time verification that typealias exists
        let _: Axis<2>.Horizontal = .rightward
    }
}
