import StandardsTestSupport
import Testing

@testable import Algebra

@Suite
struct `Comparison - Static Functions` {
    @Test(arguments: Comparison.allCases)
    func `reversed is involution`(comparison: Comparison) {
        #expect(Comparison.reversed(Comparison.reversed(comparison)) == comparison)
    }

    @Test
    func `reversed swaps cases`() {
        #expect(Comparison.reversed(.less) == .greater)
        #expect(Comparison.reversed(.greater) == .less)
        #expect(Comparison.reversed(.equal) == .equal)
    }
}

@Suite
struct `Comparison - Properties` {
    @Test
    func `cases exist`() {
        #expect(Comparison.allCases.count == 3)
        #expect(Comparison.allCases.contains(.less))
        #expect(Comparison.allCases.contains(.equal))
        #expect(Comparison.allCases.contains(.greater))
    }

    @Test(arguments: Comparison.allCases)
    func `reversed property equals static function`(comparison: Comparison) {
        #expect(comparison.reversed == Comparison.reversed(comparison))
    }

    @Test(arguments: Comparison.allCases)
    func `negation operator works`(comparison: Comparison) {
        #expect(!comparison == comparison.reversed)
    }

    @Test(arguments: [
        (1, 2, Comparison.less),
        (2, 2, Comparison.equal),
        (3, 2, Comparison.greater),
    ])
    func `init from integers is correct`(lhs: Int, rhs: Int, expected: Comparison) {
        #expect(Comparison(lhs, rhs) == expected)
    }

    @Test(arguments: [
        ("a", "b", Comparison.less),
        ("x", "x", Comparison.equal),
    ])
    func `init from strings is correct`(lhs: String, rhs: String, expected: Comparison) {
        #expect(Comparison(lhs, rhs) == expected)
    }

    @Test
    func `boolean properties are correct`() {
        #expect(Comparison.less.isLess == true)
        #expect(Comparison.equal.isEqual == true)
        #expect(Comparison.greater.isGreater == true)
        #expect(Comparison.less.isLessOrEqual == true)
        #expect(Comparison.equal.isLessOrEqual == true)
        #expect(Comparison.greater.isLessOrEqual == false)
    }

    @Test
    func `Value typealias works`() {
        let paired: Comparison.Value<String> = .init(.equal, "match")
        #expect(paired.first == .equal)
        #expect(paired.second == "match")
    }
}
