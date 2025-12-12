import StandardsTestSupport
import Testing

@testable import Algebra

@Suite("Bit - Static Functions")
struct Bit_StaticTests {
    @Test(arguments: Bit.allCases)
    func `flipped is involution`(bit: Bit) {
        #expect(Bit.flipped(Bit.flipped(bit)) == bit)
    }

    @Test
    func `flipped swaps values`() {
        #expect(Bit.flipped(.zero) == .one)
        #expect(Bit.flipped(.one) == .zero)
    }

    @Test(arguments: [
        (Bit.one, Bit.one, Bit.one),
        (Bit.one, Bit.zero, Bit.zero),
        (Bit.zero, Bit.one, Bit.zero),
        (Bit.zero, Bit.zero, Bit.zero),
    ])
    func `and is correct`(lhs: Bit, rhs: Bit, expected: Bit) {
        #expect(Bit.and(lhs, rhs) == expected)
    }

    @Test(arguments: [
        (Bit.one, Bit.one, Bit.one),
        (Bit.one, Bit.zero, Bit.one),
        (Bit.zero, Bit.one, Bit.one),
        (Bit.zero, Bit.zero, Bit.zero),
    ])
    func `or is correct`(lhs: Bit, rhs: Bit, expected: Bit) {
        #expect(Bit.or(lhs, rhs) == expected)
    }

    @Test(arguments: [
        (Bit.one, Bit.one, Bit.zero),
        (Bit.one, Bit.zero, Bit.one),
        (Bit.zero, Bit.one, Bit.one),
        (Bit.zero, Bit.zero, Bit.zero),
    ])
    func `xor is correct`(lhs: Bit, rhs: Bit, expected: Bit) {
        #expect(Bit.xor(lhs, rhs) == expected)
    }
}

@Suite("Bit - Properties")
struct Bit_PropertyTests {
    @Test
    func `cases exist`() {
        #expect(Bit.allCases.count == 2)
        #expect(Bit.allCases.contains(.zero))
        #expect(Bit.allCases.contains(.one))
    }

    @Test(arguments: Bit.allCases)
    func `flipped property equals static function`(bit: Bit) {
        #expect(bit.flipped == Bit.flipped(bit))
    }

    @Test(arguments: Bit.allCases)
    func `negation operator works`(bit: Bit) {
        #expect(!bit == bit.flipped)
    }

    @Test(arguments: [
        (false, Bit.zero),
        (true, Bit.one),
    ])
    func `init from bool is correct`(value: Bool, expected: Bit) {
        #expect(Bit(value) == expected)
    }

    @Test(arguments: [
        (Bit.zero, false),
        (Bit.one, true),
    ])
    func `boolValue is correct`(bit: Bit, expected: Bool) {
        #expect(bit.boolValue == expected)
    }

    @Test(arguments: [
        (Bit.zero, UInt8(0)),
        (Bit.one, UInt8(1)),
    ])
    func `value is correct`(bit: Bit, expected: UInt8) {
        #expect(bit == expected)
    }

    @Test(arguments: Bit.allCases)
    func `toggled is alias for flipped`(bit: Bit) {
        #expect(bit.toggled == bit.flipped)
    }

    @Test
    func `Value typealias works`() {
        let paired: Bit.Value<String> = .init(.one, "set")
        #expect(paired.first == .one)
        #expect(paired.second == "set")
    }
}
