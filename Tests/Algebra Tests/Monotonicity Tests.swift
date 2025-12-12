import StandardsTestSupport
import Testing

@testable import Algebra

@Suite("Monotonicity - Static Functions")
struct Monotonicity_StaticTests {
    @Test(arguments: Monotonicity.allCases)
    func `reversed is involution for increasing and decreasing`(monotonicity: Monotonicity) {
        if monotonicity != .constant {
            #expect(Monotonicity.reversed(Monotonicity.reversed(monotonicity)) == monotonicity)
        }
    }

    @Test
    func `reversed swaps values`() {
        #expect(Monotonicity.reversed(.increasing) == .decreasing)
        #expect(Monotonicity.reversed(.decreasing) == .increasing)
        #expect(Monotonicity.reversed(.constant) == .constant)
    }

    @Test(arguments: [
        (Monotonicity.increasing, Monotonicity.increasing, Monotonicity.increasing),
        (Monotonicity.increasing, Monotonicity.decreasing, Monotonicity.decreasing),
        (Monotonicity.decreasing, Monotonicity.decreasing, Monotonicity.increasing),
        (Monotonicity.constant, Monotonicity.increasing, Monotonicity.constant),
    ])
    func `composing is correct`(lhs: Monotonicity, rhs: Monotonicity, expected: Monotonicity) {
        #expect(Monotonicity.composing(lhs, rhs) == expected)
    }
}

@Suite("Monotonicity - Properties")
struct Monotonicity_PropertyTests {
    @Test
    func `cases exist`() {
        #expect(Monotonicity.allCases.count == 3)
        #expect(Monotonicity.allCases.contains(.increasing))
        #expect(Monotonicity.allCases.contains(.decreasing))
        #expect(Monotonicity.allCases.contains(.constant))
    }

    @Test(arguments: Monotonicity.allCases)
    func `reversed property equals static function`(monotonicity: Monotonicity) {
        #expect(monotonicity.reversed == Monotonicity.reversed(monotonicity))
    }

    @Test(arguments: Monotonicity.allCases)
    func `negation operator works`(monotonicity: Monotonicity) {
        #expect(!monotonicity == monotonicity.reversed)
    }

    @Test(arguments: [
        (Monotonicity.increasing, true),
        (Monotonicity.decreasing, false),
        (Monotonicity.constant, false),
    ])
    func `isIncreasing is correct`(monotonicity: Monotonicity, expected: Bool) {
        #expect(monotonicity.isIncreasing == expected)
    }

    @Test(arguments: [
        (Monotonicity.increasing, false),
        (Monotonicity.decreasing, true),
        (Monotonicity.constant, false),
    ])
    func `isDecreasing is correct`(monotonicity: Monotonicity, expected: Bool) {
        #expect(monotonicity.isDecreasing == expected)
    }

    @Test(arguments: [
        (Monotonicity.increasing, false),
        (Monotonicity.decreasing, false),
        (Monotonicity.constant, true),
    ])
    func `isConstant is correct`(monotonicity: Monotonicity, expected: Bool) {
        #expect(monotonicity.isConstant == expected)
    }

    @Test(arguments: [
        (Monotonicity.increasing, true),
        (Monotonicity.constant, true),
        (Monotonicity.decreasing, false),
    ])
    func `isNonDecreasing is correct`(monotonicity: Monotonicity, expected: Bool) {
        #expect(monotonicity.isNonDecreasing == expected)
    }

    @Test(arguments: [
        (Monotonicity.decreasing, true),
        (Monotonicity.constant, true),
        (Monotonicity.increasing, false),
    ])
    func `isNonIncreasing is correct`(monotonicity: Monotonicity, expected: Bool) {
        #expect(monotonicity.isNonIncreasing == expected)
    }

    @Test(arguments: Monotonicity.allCases)
    func `composing property equals static function`(monotonicity: Monotonicity) {
        let other = Monotonicity.increasing
        #expect(monotonicity.composing(other) == Monotonicity.composing(monotonicity, other))
    }

    @Test
    func `Value typealias works`() {
        let paired: Monotonicity.Value<String> = .init(.increasing, "growth")
        #expect(paired.first == .increasing)
        #expect(paired.second == "growth")
    }
}
