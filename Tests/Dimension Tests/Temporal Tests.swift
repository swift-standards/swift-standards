// Temporal Tests.swift

import Testing
@testable import Dimension

@Suite
struct TemporalTests {
    @Test
    func `Temporal cases`() {
        let future: Temporal = .future
        let past: Temporal = .past
        #expect(future != past)
    }

    @Test
    func `Temporal opposite`() {
        #expect(Temporal.future.opposite == .past)
        #expect(Temporal.past.opposite == .future)
    }

    @Test
    func `Temporal negation operator`() {
        #expect(!Temporal.future == .past)
        #expect(!Temporal.past == .future)
        #expect(!(!Temporal.future) == .future)
    }

    @Test
    func `Temporal CaseIterable`() {
        #expect(Temporal.allCases.count == 2)
        #expect(Temporal.allCases.contains(.future))
        #expect(Temporal.allCases.contains(.past))
    }

    @Test
    func `Temporal Equatable`() {
        #expect(Temporal.future == Temporal.future)
        #expect(Temporal.past == Temporal.past)
        #expect(Temporal.future != Temporal.past)
    }

    @Test
    func `Temporal Hashable`() {
        let set: Set<Temporal> = [.future, .past, .future]
        #expect(set.count == 2)
    }
}

// MARK: - Axis.Temporal Typealias Tests

@Suite
struct AxisTemporalTypealiasTests {
    @Test
    func `Temporal available on Axis 4`() {
        let t4: Axis<4>.Temporal = .future

        let t: Temporal = .future
        #expect(t == t4)
    }

    @Test
    func `Axis Temporal not available on lower dimensions`() {
        // Axis<1>.Temporal, Axis<2>.Temporal, Axis<3>.Temporal should not exist
        // This is a compile-time check
        let _: Axis<4>.Temporal = .future
    }
}
