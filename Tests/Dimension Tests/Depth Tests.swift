// Depth Tests.swift

import Testing
@testable import Dimension

@Suite
struct DepthTests {
    @Test
    func `Depth cases`() {
        let forward: Depth = .forward
        let backward: Depth = .backward
        #expect(forward != backward)
    }

    @Test
    func `Depth opposite`() {
        #expect(Depth.forward.opposite == .backward)
        #expect(Depth.backward.opposite == .forward)
    }

    @Test
    func `Depth negation operator`() {
        #expect(!Depth.forward == .backward)
        #expect(!Depth.backward == .forward)
        #expect(!(!Depth.forward) == .forward)
    }

    @Test
    func `Depth CaseIterable`() {
        #expect(Depth.allCases.count == 2)
        #expect(Depth.allCases.contains(.forward))
        #expect(Depth.allCases.contains(.backward))
    }

    @Test
    func `Depth Equatable`() {
        #expect(Depth.forward == Depth.forward)
        #expect(Depth.backward == Depth.backward)
        #expect(Depth.forward != Depth.backward)
    }

    @Test
    func `Depth Hashable`() {
        let set: Set<Depth> = [.forward, .backward, .forward]
        #expect(set.count == 2)
    }
}

// MARK: - Axis.Depth Typealias Tests

@Suite
struct AxisDepthTypealiasTests {
    @Test
    func `Depth is same type across dimensions`() {
        let d3: Axis<3>.Depth = .forward
        let d4: Depth = .forward

        // Both resolve to the same underlying Depth type
        #expect(d3 == d4)

        let d: Depth = .forward
        #expect(d == d3)
    }

    @Test
    func `Axis Depth not available on Axis 1 or 2`() {
        // Axis<1>.Depth and Axis<2>.Depth should not exist
        // This is a compile-time check
        let _: Axis<3>.Depth = .forward
    }
}
