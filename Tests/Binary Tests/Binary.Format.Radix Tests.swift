import Binary
import Testing

@Suite
struct `Binary.Format.Radix Tests` {

    // MARK: - Base-2 Formatting

    @Test
    func `Base2 formatting without prefix`() {
        #expect(5.formatted(Binary.Format.base2) == "101")
        #expect(0.formatted(Binary.Format.base2) == "0")
        #expect(42.formatted(Binary.Format.base2) == "101010")
        #expect(UInt8(255).formatted(Binary.Format.base2) == "11111111")
    }

    @Test
    func `Base2 formatting with prefix`() {
        #expect(5.formatted(Binary.Format.base2.prefix) == "0b101")
        #expect(0.formatted(Binary.Format.base2.prefix) == "0b0")
        #expect(42.formatted(Binary.Format.base2.prefix) == "0b101010")
        #expect(UInt8(255).formatted(Binary.Format.base2.prefix) == "0b11111111")
    }

    @Test
    func `Bits alias`() {
        #expect(5.formatted(Binary.Format.bits) == "101")
        #expect(255.formatted(Binary.Format.bits) == "11111111")
    }

    @Test
    func `Base2 with sign strategy`() {
        #expect(5.formatted(Binary.Format.base2.prefix.sign(.always)) == "+0b101")
        #expect((-5).formatted(Binary.Format.base2.prefix.sign(.always)) == "-0b101")
    }

    // MARK: - Octal Formatting

    @Test
    func `Octal formatting without prefix`() {
        #expect(8.formatted(Binary.Format.octal) == "10")
        #expect(0.formatted(Binary.Format.octal) == "0")
        #expect(64.formatted(Binary.Format.octal) == "100")
        #expect(UInt8(255).formatted(Binary.Format.octal) == "377")
    }

    @Test
    func `Octal formatting with prefix`() {
        #expect(8.formatted(Binary.Format.octal.prefix) == "0o10")
        #expect(0.formatted(Binary.Format.octal.prefix) == "0o0")
        #expect(64.formatted(Binary.Format.octal.prefix) == "0o100")
        #expect(UInt8(255).formatted(Binary.Format.octal.prefix) == "0o377")
    }

    @Test
    func `Octal with sign strategy`() {
        #expect(8.formatted(Binary.Format.octal.prefix.sign(.always)) == "+0o10")
        #expect((-8).formatted(Binary.Format.octal.prefix.sign(.always)) == "-0o10")
    }

    // MARK: - Hexadecimal Formatting

    @Test
    func `Hex formatting without prefix`() {
        #expect(255.formatted(Binary.Format.hex) == "ff")
        #expect(0.formatted(Binary.Format.hex) == "0")
        #expect(16.formatted(Binary.Format.hex) == "10")
        #expect(UInt8(255).formatted(Binary.Format.hex) == "ff")
    }

    @Test
    func `Hex formatting with prefix`() {
        #expect(255.formatted(Binary.Format.hex.prefix) == "0xff")
        #expect(0.formatted(Binary.Format.hex.prefix) == "0x0")
        #expect(16.formatted(Binary.Format.hex.prefix) == "0x10")
    }

    // MARK: - Decimal Formatting

    @Test
    func `Decimal formatting`() {
        #expect(42.formatted(Binary.Format.decimal) == "42")
        #expect(0.formatted(Binary.Format.decimal) == "0")
        #expect((-42).formatted(Binary.Format.decimal) == "-42")
    }

    @Test
    func `Decimal with sign strategy`() {
        #expect(42.formatted(Binary.Format.decimal.sign(.always)) == "+42")
        #expect((-42).formatted(Binary.Format.decimal.sign(.always)) == "-42")
        #expect(0.formatted(Binary.Format.decimal.sign(.always)) == "+0")
    }

    @Test
    func `Decimal with zero padding`() {
        #expect(5.formatted(Binary.Format.decimal.zeroPadded(width: 3)) == "005")
        #expect(42.formatted(Binary.Format.decimal.zeroPadded(width: 4)) == "0042")
        #expect(123.formatted(Binary.Format.decimal.zeroPadded(width: 2)) == "123")  // No truncation
    }

    // MARK: - Number Alias

    @Test
    func `Number alias`() {
        #expect(42.formatted(Binary.Format.number) == "42")
    }
}
