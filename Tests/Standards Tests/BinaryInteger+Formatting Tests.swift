import Testing
import Standards

@Suite("BinaryInteger+Formatting Tests")
struct BinaryIntegerFormattingTests {

    // MARK: - Decimal/Number Formatting

    @Test("Int formatted as number")
    func intNumber() {
        #expect(42.formatted(.number) == "42")
        #expect((-42).formatted(.number) == "-42")
        #expect(0.formatted(.number) == "0")
    }

    @Test("UInt formatted as number")
    func uintNumber() {
        #expect(UInt(42).formatted(.number) == "42")
        #expect(UInt(0).formatted(.number) == "0")
        #expect(UInt(255).formatted(.number) == "255")
    }

    @Test("Int8 formatted as number")
    func int8Number() {
        #expect(Int8(42).formatted(.number) == "42")
        #expect(Int8(-42).formatted(.number) == "-42")
        #expect(Int8(127).formatted(.number) == "127")
    }

    @Test("UInt8 formatted as number")
    func uint8Number() {
        #expect(UInt8(42).formatted(.number) == "42")
        #expect(UInt8(255).formatted(.number) == "255")
        #expect(UInt8(0).formatted(.number) == "0")
    }

    // MARK: - Hexadecimal Formatting

    @Test("Int formatted as hex")
    func intHex() {
        #expect(255.formatted(.hex) == "0xff")
        #expect(0.formatted(.hex) == "0x0")
        #expect(16.formatted(.hex) == "0x10")
        #expect((-255).formatted(.hex) == "-0xff")
    }

    @Test("Int formatted as hex uppercase")
    func intHexUppercase() {
        #expect(255.formatted(.hex.uppercase()) == "0xFF")
        #expect(0.formatted(.hex.uppercase()) == "0x0")
        #expect(16.formatted(.hex.uppercase()) == "0x10")
        #expect((-255).formatted(.hex.uppercase()) == "-0xFF")
    }

    @Test("UInt8 formatted as hex")
    func uint8Hex() {
        #expect(UInt8(255).formatted(.hex) == "0xff")
        #expect(UInt8(0).formatted(.hex) == "0x0")
        #expect(UInt8(16).formatted(.hex) == "0x10")
    }

    // MARK: - Binary Formatting

    @Test("Int formatted as binary")
    func intBinary() {
        #expect(42.formatted(.binary) == "0b101010")
        #expect(0.formatted(.binary) == "0b0")
        #expect(7.formatted(.binary) == "0b111")
        #expect((-42).formatted(.binary) == "-0b101010")
    }

    @Test("UInt formatted as binary")
    func uintBinary() {
        #expect(UInt(42).formatted(.binary) == "0b101010")
        #expect(UInt(0).formatted(.binary) == "0b0")
        #expect(UInt(255).formatted(.binary) == "0b11111111")
    }

    // MARK: - Octal Formatting

    @Test("Int formatted as octal")
    func intOctal() {
        #expect(255.formatted(.octal) == "0o377")
        #expect(8.formatted(.octal) == "0o10")
        #expect(0.formatted(.octal) == "0o0")
        #expect((-255).formatted(.octal) == "-0o377")
    }

    @Test("UInt8 formatted as octal")
    func uint8Octal() {
        #expect(UInt8(255).formatted(.octal) == "0o377")
        #expect(UInt8(8).formatted(.octal) == "0o10")
        #expect(UInt8(0).formatted(.octal) == "0o0")
    }

    // MARK: - Sign Display Strategy

    @Test("Number with always sign strategy")
    func alwaysSign() {
        #expect(42.formatted(.number.sign(strategy: .always)) == "+42")
        #expect(0.formatted(.number.sign(strategy: .always)) == "+0")
        #expect((-42).formatted(.number.sign(strategy: .always)) == "-42")
    }

    @Test("Number with automatic sign strategy")
    func automaticSign() {
        #expect(42.formatted(.number.sign(strategy: .automatic)) == "42")
        #expect(0.formatted(.number.sign(strategy: .automatic)) == "0")
        #expect((-42).formatted(.number.sign(strategy: .automatic)) == "-42")
    }

    @Test("Hex with sign strategy")
    func hexWithSign() {
        #expect(42.formatted(.hex.sign(strategy: .always)) == "+0x2a")
        #expect((-42).formatted(.hex.sign(strategy: .always)) == "-0x2a")
    }

    // MARK: - Chaining

    @Test("Hex uppercase with sign")
    func hexUppercaseWithSign() {
        #expect(255.formatted(.hex.uppercase().sign(strategy: .always)) == "+0xFF")
        #expect((-255).formatted(.hex.uppercase().sign(strategy: .always)) == "-0xFF")
    }

    @Test("Sign with uppercase")
    func signWithUppercase() {
        #expect(255.formatted(.hex.sign(strategy: .always).uppercase()) == "+0xFF")
        #expect((-255).formatted(.hex.sign(strategy: .always).uppercase()) == "-0xFF")
    }

    // MARK: - Various Integer Types

    @Test("Int16 formatted")
    func int16() {
        #expect(Int16(1000).formatted(.number) == "1000")
        #expect(Int16(1000).formatted(.hex) == "0x3e8")
        #expect(Int16(-1000).formatted(.number) == "-1000")
    }

    @Test("Int32 formatted")
    func int32() {
        #expect(Int32(100000).formatted(.number) == "100000")
        #expect(Int32(100000).formatted(.hex) == "0x186a0")
    }

    @Test("Int64 formatted")
    func int64() {
        #expect(Int64(1000000000).formatted(.number) == "1000000000")
        #expect(Int64(1000000000).formatted(.hex) == "0x3b9aca00")
    }

    @Test("UInt16 formatted")
    func uint16() {
        #expect(UInt16(65535).formatted(.number) == "65535")
        #expect(UInt16(65535).formatted(.hex) == "0xffff")
        #expect(UInt16(65535).formatted(.hex.uppercase()) == "0xFFFF")
    }

    @Test("UInt32 formatted")
    func uint32() {
        #expect(UInt32(4294967295).formatted(.number) == "4294967295")
        #expect(UInt32(255).formatted(.hex) == "0xff")
    }

    @Test("UInt64 formatted")
    func uint64() {
        #expect(UInt64(18446744073709551615).formatted(.number) == "18446744073709551615")
        #expect(UInt64(255).formatted(.binary) == "0b11111111")
    }
}
