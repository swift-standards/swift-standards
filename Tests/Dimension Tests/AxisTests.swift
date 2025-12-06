// AxisTests.swift

import Testing
@testable import Dimension

// MARK: - Axis Tests

@Suite
struct AxisTests {
    @Test
    func `Axis 1D primary only`() {
        #expect(Axis<1>.primary.rawValue == 0)
        #expect(Axis<1>.allCases.count == 1)
    }

    @Test
    func `Axis 2D primary secondary`() {
        #expect(Axis<2>.primary.rawValue == 0)
        #expect(Axis<2>.secondary.rawValue == 1)
        #expect(Axis<2>.allCases.count == 2)
    }

    @Test
    func `Axis 3D primary secondary tertiary`() {
        #expect(Axis<3>.primary.rawValue == 0)
        #expect(Axis<3>.secondary.rawValue == 1)
        #expect(Axis<3>.tertiary.rawValue == 2)
        #expect(Axis<3>.allCases.count == 3)
    }

    @Test
    func `Axis 4D includes quaternary`() {
        #expect(Axis<4>.primary.rawValue == 0)
        #expect(Axis<4>.secondary.rawValue == 1)
        #expect(Axis<4>.tertiary.rawValue == 2)
        #expect(Axis<4>.quaternary.rawValue == 3)
        #expect(Axis<4>.allCases.count == 4)
    }

    @Test
    func `Axis perpendicular 2D only`() {
        #expect(Axis<2>.primary.perpendicular == .secondary)
        #expect(Axis<2>.secondary.perpendicular == .primary)
    }

    @Test
    func `Axis init bounds checking`() {
        #expect(Axis<1>(0) != nil)
        #expect(Axis<1>(1) == nil)

        #expect(Axis<2>(0) != nil)
        #expect(Axis<2>(1) != nil)
        #expect(Axis<2>(2) == nil)
        #expect(Axis<2>(-1) == nil)

        #expect(Axis<3>(2) != nil)
        #expect(Axis<3>(3) == nil)

        #expect(Axis<4>(3) != nil)
        #expect(Axis<4>(4) == nil)
    }

    @Test
    func `Axis Equatable`() {
        #expect(Axis<2>.primary == Axis<2>.primary)
        #expect(Axis<2>.primary != Axis<2>.secondary)
        #expect(Axis<3>.tertiary == Axis<3>.tertiary)
    }

    @Test
    func `Axis Hashable`() {
        let set: Set<Axis<3>> = [.primary, .secondary, .tertiary, .primary]
        #expect(set.count == 3)
    }
}

// MARK: - Axis.Direction Tests

@Suite
struct AxisDirectionTests {
    @Test
    func `Direction cases`() {
        let positive: Axis<2>.Direction = .positive
        let negative: Axis<2>.Direction = .negative
        #expect(positive != negative)
    }

    @Test
    func `Direction opposite`() {
        #expect(Axis<2>.Direction.positive.opposite == .negative)
        #expect(Axis<2>.Direction.negative.opposite == .positive)
    }

    @Test
    func `Direction sign Int`() {
        #expect(Axis<2>.Direction.positive.sign == 1)
        #expect(Axis<2>.Direction.negative.sign == -1)
    }

    @Test
    func `Direction signDouble`() {
        #expect(Axis<2>.Direction.positive.signDouble == 1.0)
        #expect(Axis<2>.Direction.negative.signDouble == -1.0)
    }

    @Test
    func `Direction CaseIterable`() {
        #expect(Axis<2>.Direction.allCases.count == 2)
        #expect(Axis<2>.Direction.allCases.contains(.positive))
        #expect(Axis<2>.Direction.allCases.contains(.negative))
    }

    @Test
    func `Direction is nested but independent of N`() {
        // Direction should behave identically regardless of which Axis<N> it's accessed from
        let dir2: Axis<2>.Direction = .positive
        let dir3: Axis<3>.Direction = .positive

        // They have the same raw behavior even if Swift considers them different types
        #expect(dir2.sign == dir3.sign)
        #expect(dir2.opposite.sign == dir3.opposite.sign)
    }
}

// MARK: - Type System Tests

@Suite
struct AxisTypeSystemTests {
    /// Direction is dimension-independent - same type across all Axis<N>.
    ///
    /// Mathematically, direction along an axis is just a sign (±1), which is
    /// the same concept regardless of the dimension of the space.
    @Test
    func `Direction is same type across all dimensions`() {
        let dir2: Axis<2>.Direction = .positive
        let dir3: Axis<3>.Direction = .positive
        let dir4: Axis<4>.Direction = .negative

        // These ARE the same type (via typealias to Direction)
        #expect(dir2 == dir3)
        #expect(dir2 != dir4)

        // Can use Direction directly
        let dir: Direction = .positive
        #expect(dir == dir2)
        #expect(dir == dir3)
    }

    /// Axis<N> types are distinct across dimensions - this is correct behavior.
    ///
    /// An axis in 2D space is fundamentally different from an axis in 3D space.
    /// Axis<2> has 2 possible values, Axis<3> has 3, etc.
    @Test
    func `Axis types are distinct across dimensions`() {
        let axis2: Axis<2> = .primary
        let axis3: Axis<3> = .primary

        // They have the same rawValue...
        #expect(axis2.rawValue == axis3.rawValue)

        // ...but are not directly comparable (this would not compile):
        // let same: Bool = (axis2 == axis3)  // Error: different types

        // This is the INTENDED behavior - dimensional safety
    }

    @Test
    func `Function accepting Axis of specific dimension`() {
        // This demonstrates type safety - you can't pass Axis<3> where Axis<2> is expected
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
