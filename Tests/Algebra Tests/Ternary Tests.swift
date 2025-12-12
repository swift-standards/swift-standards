import StandardsTestSupport
import Testing

@testable import Algebra

@Suite("Ternary - Static Functions")
struct Ternary_StaticTests {
    @Test(arguments: Ternary.allCases)
    func `negated is involution`(ternary: Ternary) {
        #expect(Ternary.negated(Ternary.negated(ternary)) == ternary)
    }

    @Test
    func `negated swaps values`() {
        #expect(Ternary.negated(.negative) == .positive)
        #expect(Ternary.negated(.positive) == .negative)
        #expect(Ternary.negated(.zero) == .zero)
    }

    @Test(arguments: [
        (Ternary.positive, Ternary.positive, Ternary.positive),
        (Ternary.positive, Ternary.negative, Ternary.negative),
        (Ternary.negative, Ternary.negative, Ternary.positive),
        (Ternary.zero, Ternary.positive, Ternary.zero),
    ])
    func `multiplying is correct`(lhs: Ternary, rhs: Ternary, expected: Ternary) {
        #expect(Ternary.multiplying(lhs, rhs) == expected)
    }
}

@Suite("Ternary - Properties")
struct Ternary_PropertyTests {
    @Test
    func `cases exist`() {
        #expect(Ternary.allCases.count == 3)
        #expect(Ternary.allCases.contains(.negative))
        #expect(Ternary.allCases.contains(.zero))
        #expect(Ternary.allCases.contains(.positive))
    }

    @Test(arguments: Ternary.allCases)
    func `negated property equals static function`(ternary: Ternary) {
        #expect(ternary.negated == Ternary.negated(ternary))
    }

    @Test(arguments: Ternary.allCases)
    func `negation operator works`(ternary: Ternary) {
        #expect(-ternary == ternary.negated)
    }

    @Test(arguments: [
        (Ternary.negative, -1),
        (Ternary.zero, 0),
        (Ternary.positive, 1),
    ])
    func `intValue is correct`(ternary: Ternary, expected: Int) {
        #expect(ternary.intValue == expected)
    }

    @Test(arguments: [
        (Sign.negative, Ternary.negative),
        (Sign.zero, Ternary.zero),
        (Sign.positive, Ternary.positive),
    ])
    func `init from Sign is correct`(sign: Sign, expected: Ternary) {
        #expect(Ternary(sign) == expected)
    }

    @Test(arguments: Ternary.allCases)
    func `multiplying property equals static function`(ternary: Ternary) {
        let other = Ternary.positive
        #expect(ternary.multiplying(other) == Ternary.multiplying(ternary, other))
    }

    @Test
    func `Value typealias works`() {
        let paired: Ternary.Value<Double> = .init(.positive, 1.0)
        #expect(paired.first == .positive)
        #expect(paired.second == 1.0)
    }
}
