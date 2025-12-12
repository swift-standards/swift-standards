// Axis.Vertical Tests.swift

import StandardsTestSupport
import Testing
@testable import Dimension

// MARK: - Axis.Vertical Typealias Tests

@Suite("Axis.Vertical - Typealias")
struct AxisVertical_TypealiasTests {
    @Test
    func `Axis2 Vertical is identical to Vertical`() {
        let axisVert: Axis<2>.Vertical = .downward
        let vert: Vertical = .downward

        #expect(axisVert == vert)
        #expect(axisVert.opposite == vert.opposite)
    }

    @Test(arguments: [Vertical.upward, Vertical.downward])
    func `All Vertical functionality available via Axis2 Vertical`(vertical: Vertical) {
        let axisVert: Axis<2>.Vertical = vertical

        #expect(axisVert.direction == vertical.direction)
        #expect(axisVert.opposite == vertical.opposite)
        #expect(axisVert.isUpward == vertical.isUpward)
        #expect(axisVert.isDownward == vertical.isDownward)
    }

    @Test
    func `Vertical available for 2D`() {
        // Compile-time verification that typealias exists
        let _: Axis<2>.Vertical = .upward
    }
}
