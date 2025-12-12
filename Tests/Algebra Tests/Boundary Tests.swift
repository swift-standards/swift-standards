import StandardsTestSupport
import Testing

@testable import Algebra

@Suite("Boundary - Static Functions")
struct Boundary_StaticTests {
    @Test(arguments: Boundary.allCases)
    func `opposite is involution`(boundary: Boundary) {
        #expect(Boundary.opposite(of: Boundary.opposite(of: boundary)) == boundary)
    }

    @Test
    func `opposite swaps values`() {
        #expect(Boundary.opposite(of: .open) == .closed)
        #expect(Boundary.opposite(of: .closed) == .open)
    }
}

@Suite("Boundary - Properties")
struct Boundary_PropertyTests {
    @Test
    func `cases exist`() {
        #expect(Boundary.allCases.count == 2)
        #expect(Boundary.allCases.contains(.open))
        #expect(Boundary.allCases.contains(.closed))
    }

    @Test(arguments: Boundary.allCases)
    func `opposite property equals static function`(boundary: Boundary) {
        #expect(boundary.opposite == Boundary.opposite(of: boundary))
    }

    @Test(arguments: Boundary.allCases)
    func `negation operator works`(boundary: Boundary) {
        #expect(!boundary == boundary.opposite)
    }

    @Test(arguments: Boundary.allCases)
    func `toggled is alias for opposite`(boundary: Boundary) {
        #expect(boundary.toggled == boundary.opposite)
    }

    @Test(arguments: [
        (Boundary.closed, true),
        (Boundary.open, false),
    ])
    func `isInclusive is correct`(boundary: Boundary, expected: Bool) {
        #expect(boundary.isInclusive == expected)
    }

    @Test(arguments: [
        (Boundary.closed, false),
        (Boundary.open, true),
    ])
    func `isExclusive is correct`(boundary: Boundary, expected: Bool) {
        #expect(boundary.isExclusive == expected)
    }

    @Test
    func `Value typealias works`() {
        let paired: Boundary.Value<Double> = .init(.closed, 1.0)
        #expect(paired.first == .closed)
        #expect(paired.second == 1.0)
    }
}
