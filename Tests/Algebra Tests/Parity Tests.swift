import StandardsTestSupport
import Testing

@testable import Algebra

@Suite("Parity - Static Functions")
struct Parity_StaticTests {
    @Test(arguments: Parity.allCases)
    func `opposite is involution`(parity: Parity) {
        #expect(Parity.opposite(of: Parity.opposite(of: parity)) == parity)
    }

    @Test
    func `opposite swaps cases`() {
        #expect(Parity.opposite(of: .even) == .odd)
        #expect(Parity.opposite(of: .odd) == .even)
    }

    @Test(arguments: [
        (Parity.even, Parity.even, Parity.even),
        (Parity.odd, Parity.odd, Parity.even),
        (Parity.even, Parity.odd, Parity.odd),
        (Parity.odd, Parity.even, Parity.odd),
    ])
    func `adding is correct`(lhs: Parity, rhs: Parity, expected: Parity) {
        #expect(Parity.adding(lhs, rhs) == expected)
    }

    @Test(arguments: [
        (Parity.even, Parity.even, Parity.even),
        (Parity.odd, Parity.odd, Parity.odd),
        (Parity.even, Parity.odd, Parity.even),
        (Parity.odd, Parity.even, Parity.even),
    ])
    func `multiplying is correct`(lhs: Parity, rhs: Parity, expected: Parity) {
        #expect(Parity.multiplying(lhs, rhs) == expected)
    }
}

@Suite("Parity - Properties")
struct Parity_PropertyTests {
    @Test
    func `cases exist`() {
        #expect(Parity.allCases.count == 2)
        #expect(Parity.allCases.contains(.even))
        #expect(Parity.allCases.contains(.odd))
    }

    @Test(arguments: Parity.allCases)
    func `opposite property equals static function`(parity: Parity) {
        #expect(parity.opposite == Parity.opposite(of: parity))
    }

    @Test(arguments: Parity.allCases)
    func `negation operator works`(parity: Parity) {
        #expect(!parity == parity.opposite)
    }

    @Test(arguments: [
        (0, Parity.even),
        (1, Parity.odd),
        (2, Parity.even),
        (-1, Parity.odd),
        (-2, Parity.even),
        (42, Parity.even),
        (43, Parity.odd),
    ])
    func `init from integer is correct`(value: Int, expected: Parity) {
        #expect(Parity(value) == expected)
    }

    @Test
    func `Value typealias works`() {
        let paired: Parity.Value<Int> = .init(.even, 42)
        #expect(paired.first == .even)
        #expect(paired.second == 42)
    }
}
