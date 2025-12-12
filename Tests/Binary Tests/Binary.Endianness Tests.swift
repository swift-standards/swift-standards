import Testing

@testable import Binary

@Suite
struct `Binary.Endianness Tests` {
    @Test
    func `Binary.Endianness cases`() {
        let little: Binary.Endianness = .little
        let big: Binary.Endianness = .big
        #expect(little != big)
    }

    @Test
    func `Binary.Endianness opposite`() {
        #expect(Binary.Endianness.little.opposite == .big)
        #expect(Binary.Endianness.big.opposite == .little)
    }

    @Test
    func `Binary.Endianness negation operator`() {
        #expect(!Binary.Endianness.little == .big)
        #expect(!Binary.Endianness.big == .little)
        #expect(!(!Binary.Endianness.little) == .little)
    }

    @Test
    func `Binary.Endianness CaseIterable`() {
        #expect(Binary.Endianness.allCases.count == 2)
        #expect(Binary.Endianness.allCases.contains(.little))
        #expect(Binary.Endianness.allCases.contains(.big))
    }

    @Test
    func `Binary.Endianness network is big`() {
        #expect(Binary.Endianness.network == .big)
    }

    @Test
    func `Binary.Endianness native detection`() {
        // Should be one of the two valid values
        let native = Binary.Endianness.native
        #expect(native == .little || native == .big)
    }
}
