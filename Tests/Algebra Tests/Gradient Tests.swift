import StandardsTestSupport
import Testing

@testable import Algebra

@Suite
struct `Gradient - Static Functions` {
    @Test(arguments: Gradient.allCases)
    func `opposite is involution`(gradient: Gradient) {
        #expect(Gradient.opposite(of: Gradient.opposite(of: gradient)) == gradient)
    }

    @Test
    func `opposite swaps values`() {
        #expect(Gradient.opposite(of: .ascending) == .descending)
        #expect(Gradient.opposite(of: .descending) == .ascending)
    }
}

@Suite
struct `Gradient - Properties` {
    @Test
    func `cases exist`() {
        #expect(Gradient.allCases.count == 2)
        #expect(Gradient.allCases.contains(.ascending))
        #expect(Gradient.allCases.contains(.descending))
    }

    @Test(arguments: Gradient.allCases)
    func `opposite property equals static function`(gradient: Gradient) {
        #expect(gradient.opposite == Gradient.opposite(of: gradient))
    }

    @Test(arguments: Gradient.allCases)
    func `negation operator works`(gradient: Gradient) {
        #expect(!gradient == gradient.opposite)
    }

    @Test
    func `aliases are correct`() {
        #expect(Gradient.rising == .ascending)
        #expect(Gradient.falling == .descending)
        #expect(Gradient.up == .ascending)
        #expect(Gradient.down == .descending)
    }

    @Test
    func `Value typealias works`() {
        let paired: Gradient.Value<Double> = .init(.ascending, 0.5)
        #expect(paired.first == .ascending)
        #expect(paired.second == 0.5)
    }
}
