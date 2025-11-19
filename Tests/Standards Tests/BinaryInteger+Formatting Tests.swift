import Testing
import Standards

@Suite("BinaryInteger+Formatting Tests")
struct BinaryIntegerFormattingTests {

    // MARK: - Binary Formatting

    @Test("Binary formatting")
    func binaryFormatting() {
        #expect(5.formatted(.binary) == "0b101")
        #expect(0.formatted(.binary) == "0b0")
        #expect(42.formatted(.binary) == "0b101010")
        #expect(UInt8(255).formatted(.binary) == "0b11111111")
    }

    @Test("Binary with sign strategy")
    func binaryWithSign() {
        #expect(5.formatted(.binary.sign(strategy: .always)) == "+0b101")
        #expect((-5).formatted(.binary.sign(strategy: .always)) == "-0b101")
    }

    // MARK: - Octal Formatting

    @Test("Octal formatting")
    func octalFormatting() {
        #expect(8.formatted(.octal) == "0o10")
        #expect(0.formatted(.octal) == "0o0")
        #expect(64.formatted(.octal) == "0o100")
        #expect(UInt8(255).formatted(.octal) == "0o377")
    }

    @Test("Octal with sign strategy")
    func octalWithSign() {
        #expect(8.formatted(.octal.sign(strategy: .always)) == "+0o10")
        #expect((-8).formatted(.octal.sign(strategy: .always)) == "-0o10")
    }

    // MARK: - Decimal Formatting

    @Test("Decimal formatting")
    func decimalFormatting() {
        #expect(42.formatted(.decimal) == "42")
        #expect(0.formatted(.decimal) == "0")
        #expect((-42).formatted(.decimal) == "-42")
    }

    @Test("Decimal with sign strategy")
    func decimalWithSign() {
        #expect(42.formatted(.decimal.sign(strategy: .always)) == "+42")
        #expect((-42).formatted(.decimal.sign(strategy: .always)) == "-42")
        #expect(0.formatted(.decimal.sign(strategy: .always)) == "+0")
    }

    @Test("Decimal with zero padding")
    func decimalWithPadding() {
        #expect(5.formatted(.decimal.zeroPadded(width: 3)) == "005")
        #expect(42.formatted(.decimal.zeroPadded(width: 4)) == "0042")
        #expect(123.formatted(.decimal.zeroPadded(width: 2)) == "123")  // No truncation
    }
}
