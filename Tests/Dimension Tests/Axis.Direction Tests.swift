// Axis.Direction Tests.swift

import StandardsTestSupport
import Testing
@testable import Dimension

// MARK: - Axis.Direction Typealias Tests

@Suite("Axis.Direction - Typealias")
struct AxisDirection_TypealiasTests {
    @Test
    func `Direction is same type across all dimensions`() {
        let dir1: Axis<1>.Direction = .positive
        let dir2: Axis<2>.Direction = .positive
        let dir3: Axis<3>.Direction = .positive
        let dir4: Axis<4>.Direction = .positive

        // All resolve to the same Direction type
        #expect(dir1 == dir2)
        #expect(dir2 == dir3)
        #expect(dir3 == dir4)
    }

    @Test
    func `Axis Direction is identical to Direction`() {
        let axisDir: Axis<3>.Direction = .negative
        let dir: Direction = .negative

        #expect(axisDir == dir)
        #expect(axisDir.opposite == dir.opposite)
    }

    @Test(arguments: [Direction.positive, Direction.negative])
    func `All Direction functionality available via Axis Direction`(direction: Direction) {
        let axisDir: Axis<2>.Direction = direction

        #expect(axisDir.sign == direction.sign)
        #expect(axisDir.opposite == direction.opposite)
        #expect(axisDir.direction == direction.direction)
    }
}
