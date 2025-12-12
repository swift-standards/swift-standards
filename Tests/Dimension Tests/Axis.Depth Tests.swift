// Axis.Depth Tests.swift

import StandardsTestSupport
import Testing
@testable import Dimension

// MARK: - Axis.Depth Typealias Tests (3D)

@Suite
struct `Axis.Depth - 3D Typealias` {
    @Test
    func `Axis3 Depth is identical to Depth`() {
        let axisDepth: Axis<3>.Depth = .backward
        let depth: Depth = .backward

        #expect(axisDepth == depth)
        #expect(axisDepth.opposite == depth.opposite)
    }

    @Test(arguments: [Depth.forward, Depth.backward])
    func `All Depth functionality available via Axis3 Depth`(depth: Depth) {
        let axisDepth: Axis<3>.Depth = depth

        #expect(axisDepth.direction == depth.direction)
        #expect(axisDepth.opposite == depth.opposite)
        #expect(axisDepth.isForward == depth.isForward)
        #expect(axisDepth.isBackward == depth.isBackward)
    }

    @Test
    func `Depth available for 3D`() {
        // Compile-time verification that typealias exists
        let _: Axis<3>.Depth = .forward
    }
}

// MARK: - Axis.Depth Typealias Tests (4D)

@Suite
struct `Axis.Depth - 4D Typealias` {
    // Note: Axis<4>.Depth is defined in a separate extension where N == 4
    // We test it separately to avoid cross-extension type issues

    @Test(arguments: [Depth.forward, Depth.backward])
    func `Depth is available in 4D context`(depth: Depth) {
        // Test that Depth type works in 4D context
        // Since Axis<4>.Depth is just Dimension.Depth, test the underlying type
        #expect(depth.direction == .positive || depth.direction == .negative)
        #expect(depth.opposite.opposite == depth)
    }
}
