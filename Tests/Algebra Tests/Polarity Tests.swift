import StandardsTestSupport
import Testing

@testable import Algebra

@Suite
struct `Polarity - Static Functions` {
    @Test(arguments: Polarity.allCases)
    func `opposite is involution for positive and negative`(polarity: Polarity) {
        if polarity != .neutral {
            #expect(Polarity.opposite(of: Polarity.opposite(of: polarity)) == polarity)
        }
    }

    @Test
    func `opposite swaps values`() {
        #expect(Polarity.opposite(of: .positive) == .negative)
        #expect(Polarity.opposite(of: .negative) == .positive)
        #expect(Polarity.opposite(of: .neutral) == .neutral)
    }
}

@Suite
struct `Polarity - Properties` {
    @Test
    func `cases exist`() {
        #expect(Polarity.allCases.count == 3)
        #expect(Polarity.allCases.contains(.positive))
        #expect(Polarity.allCases.contains(.negative))
        #expect(Polarity.allCases.contains(.neutral))
    }

    @Test(arguments: Polarity.allCases)
    func `opposite property equals static function`(polarity: Polarity) {
        #expect(polarity.opposite == Polarity.opposite(of: polarity))
    }

    @Test(arguments: Polarity.allCases)
    func `negation operator works`(polarity: Polarity) {
        #expect(!polarity == polarity.opposite)
    }

    @Test(arguments: [
        (Polarity.positive, true),
        (Polarity.negative, true),
        (Polarity.neutral, false),
    ])
    func `isCharged is correct`(polarity: Polarity, expected: Bool) {
        #expect(polarity.isCharged == expected)
    }

    @Test(arguments: [
        (Polarity.positive, true),
        (Polarity.negative, false),
        (Polarity.neutral, false),
    ])
    func `isPositive is correct`(polarity: Polarity, expected: Bool) {
        #expect(polarity.isPositive == expected)
    }

    @Test(arguments: [
        (Polarity.positive, false),
        (Polarity.negative, true),
        (Polarity.neutral, false),
    ])
    func `isNegative is correct`(polarity: Polarity, expected: Bool) {
        #expect(polarity.isNegative == expected)
    }

    @Test(arguments: [
        (Polarity.positive, false),
        (Polarity.negative, false),
        (Polarity.neutral, true),
    ])
    func `isNeutral is correct`(polarity: Polarity, expected: Bool) {
        #expect(polarity.isNeutral == expected)
    }

    @Test
    func `Value typealias works`() {
        let paired: Polarity.Value<Int> = .init(.positive, 1)
        #expect(paired.first == .positive)
        #expect(paired.second == 1)
    }
}
