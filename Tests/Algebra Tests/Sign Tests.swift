import StandardsTestSupport
import Testing

@testable import Algebra

@Suite
struct `Sign - Static Functions` {
    @Test(arguments: Sign.allCases)
    func `negated is involution`(sign: Sign) {
        #expect(Sign.negated(Sign.negated(sign)) == sign)
    }

    @Test
    func `negated swaps values`() {
        #expect(Sign.negated(.positive) == .negative)
        #expect(Sign.negated(.negative) == .positive)
        #expect(Sign.negated(.zero) == .zero)
    }

    @Test(arguments: [
        (Sign.positive, Sign.positive, Sign.positive),
        (Sign.positive, Sign.negative, Sign.negative),
        (Sign.negative, Sign.negative, Sign.positive),
        (Sign.zero, Sign.positive, Sign.zero),
        (Sign.positive, Sign.zero, Sign.zero),
    ])
    func `multiplying is correct`(lhs: Sign, rhs: Sign, expected: Sign) {
        #expect(Sign.multiplying(lhs, rhs) == expected)
    }
}

@Suite
struct `Sign - Properties` {
    @Test
    func `cases exist`() {
        #expect(Sign.allCases.count == 3)
        #expect(Sign.allCases.contains(.positive))
        #expect(Sign.allCases.contains(.negative))
        #expect(Sign.allCases.contains(.zero))
    }

    @Test(arguments: Sign.allCases)
    func `negated property equals static function`(sign: Sign) {
        #expect(sign.negated == Sign.negated(sign))
    }

    @Test(arguments: Sign.allCases)
    func `negation operator works`(sign: Sign) {
        #expect(-sign == sign.negated)
    }

    @Test(arguments: [
        (42, Sign.positive),
        (-42, Sign.negative),
        (0, Sign.zero),
    ])
    func `init from integer is correct`(value: Int, expected: Sign) {
        #expect(Sign(value) == expected)
    }

    @Test(arguments: [
        (3.14, Sign.positive),
        (-3.14, Sign.negative),
        (0.0, Sign.zero),
    ])
    func `init from floating point is correct`(value: Double, expected: Sign) {
        #expect(Sign(value) == expected)
    }

    @Test(arguments: Sign.allCases)
    func `multiplying property equals static function`(sign: Sign) {
        let other = Sign.positive
        #expect(sign.multiplying(other) == Sign.multiplying(sign, other))
    }

    @Test
    func `Value typealias works`() {
        let paired: Sign.Value<Double> = .init(.positive, 3.14)
        #expect(paired.first == .positive)
        #expect(paired.second == 3.14)
    }
}
