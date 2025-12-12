import Testing

@testable import Binary

@Suite
struct `Bit.Order Tests` {
    @Test
    func `Bit.Order cases`() {
        let msb: Bit.Order = .msb
        let lsb: Bit.Order = .lsb
        #expect(msb != lsb)
    }

    @Test
    func `Bit.Order opposite`() {
        #expect(Bit.Order.msb.opposite == .lsb)
        #expect(Bit.Order.lsb.opposite == .msb)
    }

    @Test
    func `Bit.Order negation operator`() {
        #expect(!Bit.Order.msb == .lsb)
        #expect(!Bit.Order.lsb == .msb)
    }

    @Test
    func `Bit.Order CaseIterable`() {
        #expect(Bit.Order.allCases.count == 2)
        #expect(Bit.Order.allCases.contains(.msb))
        #expect(Bit.Order.allCases.contains(.lsb))
    }

    @Test
    func `Bit.Order aliases`() {
        #expect(Bit.Order.`most significant bit first` == .msb)
        #expect(Bit.Order.`least significant bit first` == .lsb)
    }
}
