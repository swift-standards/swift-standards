import StandardsTestSupport
import Testing

@testable import Algebra

@Suite("Bound - Static Functions")
struct Bound_StaticTests {
    @Test(arguments: Bound.allCases)
    func `opposite is involution`(bound: Bound) {
        #expect(Bound.opposite(of: Bound.opposite(of: bound)) == bound)
    }

    @Test
    func `opposite swaps values`() {
        #expect(Bound.opposite(of: .lower) == .upper)
        #expect(Bound.opposite(of: .upper) == .lower)
    }
}

@Suite("Bound - Properties")
struct Bound_PropertyTests {
    @Test
    func `cases exist`() {
        #expect(Bound.allCases.count == 2)
        #expect(Bound.allCases.contains(.lower))
        #expect(Bound.allCases.contains(.upper))
    }

    @Test(arguments: Bound.allCases)
    func `opposite property equals static function`(bound: Bound) {
        #expect(bound.opposite == Bound.opposite(of: bound))
    }

    @Test(arguments: Bound.allCases)
    func `negation operator works`(bound: Bound) {
        #expect(!bound == bound.opposite)
    }

    @Test
    func `aliases are correct`() {
        #expect(Bound.min == .lower)
        #expect(Bound.max == .upper)
        #expect(Bound.left == .lower)
        #expect(Bound.right == .upper)
    }

    @Test
    func `Value typealias works`() {
        let paired: Bound.Value<Int> = .init(.lower, 0)
        #expect(paired.first == .lower)
        #expect(paired.second == 0)
    }
}
