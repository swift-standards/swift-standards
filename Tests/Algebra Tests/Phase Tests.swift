import StandardsTestSupport
import Testing

@testable import Algebra

@Suite("Phase - Static Functions")
struct Phase_StaticTests {
    @Test(arguments: Phase.allCases)
    func `opposite is 180 degree rotation`(phase: Phase) {
        #expect(Phase.opposite(of: Phase.opposite(of: phase)) == phase)
    }

    @Test
    func `opposite values are correct`() {
        #expect(Phase.opposite(of: .zero) == .half)
        #expect(Phase.opposite(of: .quarter) == .threeQuarter)
        #expect(Phase.opposite(of: .half) == .zero)
        #expect(Phase.opposite(of: .threeQuarter) == .quarter)
    }

    @Test(arguments: Phase.allCases)
    func `rotated is 90 degree counterclockwise`(phase: Phase) {
        let next = Phase.next(of: phase)
        #expect(Phase.next(of: Phase.next(of: Phase.next(of: Phase.next(of: phase)))) == phase)
    }

    @Test(arguments: [
        (Phase.zero, Phase.zero, Phase.zero),
        (Phase.zero, Phase.quarter, Phase.quarter),
        (Phase.quarter, Phase.quarter, Phase.half),
        (Phase.half, Phase.half, Phase.zero),
    ])
    func `composed is correct`(lhs: Phase, rhs: Phase, expected: Phase) {
        #expect(Phase.composed(lhs, with: rhs) == expected)
    }

    @Test(arguments: Phase.allCases)
    func `inverse reverses rotation`(phase: Phase) {
        let inverse = Phase.inverse(of: phase)
        #expect(Phase.composed(phase, with: inverse) == .zero)
    }
}

@Suite("Phase - Properties")
struct Phase_PropertyTests {
    @Test
    func `cases exist`() {
        #expect(Phase.allCases.count == 4)
        #expect(Phase.allCases.contains(.zero))
        #expect(Phase.allCases.contains(.quarter))
        #expect(Phase.allCases.contains(.half))
        #expect(Phase.allCases.contains(.threeQuarter))
    }

    @Test(arguments: Phase.allCases)
    func `opposite property equals static function`(phase: Phase) {
        #expect(phase.opposite == Phase.opposite(of: phase))
    }

    @Test(arguments: Phase.allCases)
    func `negation operator works`(phase: Phase) {
        #expect(!phase == phase.opposite)
    }

    @Test
    func `next forms cyclic group`() {
        #expect(Phase.zero.next == .quarter)
        #expect(Phase.quarter.next == .half)
        #expect(Phase.half.next == .threeQuarter)
        #expect(Phase.threeQuarter.next == .zero)
    }

    @Test
    func `previous is inverse of next`() {
        #expect(Phase.zero.previous == .threeQuarter)
        #expect(Phase.quarter.previous == .zero)
        #expect(Phase.half.previous == .quarter)
        #expect(Phase.threeQuarter.previous == .half)
    }

    @Test(arguments: Phase.allCases)
    func `four rotations return to start`(phase: Phase) {
        var current = phase
        for _ in 0..<4 {
            current = current.next
        }
        #expect(current == phase)
    }

    @Test(arguments: Phase.allCases)
    func `composed property equals static function`(phase: Phase) {
        let other = Phase.quarter
        #expect(phase.composed(with: other) == Phase.composed(phase, with: other))
    }

    @Test(arguments: Phase.allCases)
    func `inverse property equals static function`(phase: Phase) {
        #expect(phase.inverse == Phase.inverse(of: phase))
    }

    @Test(arguments: [
        (Phase.zero, 0),
        (Phase.quarter, 90),
        (Phase.half, 180),
        (Phase.threeQuarter, 270),
    ])
    func `degrees is correct`(phase: Phase, expected: Int) {
        #expect(phase.degrees == expected)
    }

    @Test
    func `Value typealias works`() {
        let paired: Phase.Value<Int> = .init(.quarter, 90)
        #expect(paired.first == .quarter)
        #expect(paired.second == 90)
    }
}
