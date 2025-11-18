import Testing
import Standards

@Suite("FloatingPoint+Formatting Tests")
struct FloatingPointFormattingTests {

    // MARK: - Number Formatting

    @Test("Double formatted as number")
    func doubleNumber() {
        #expect(3.14.formatted(.number) == "3.14")
        #expect(0.0.formatted(.number) == "0.0")
        #expect((-3.14).formatted(.number) == "-3.14")
        #expect(3.14159.formatted(.number) == "3.14159")
    }

    @Test("Float formatted as number")
    func floatNumber() {
        #expect(Float(3.14).formatted(.number) == "3.14")
        #expect(Float(0.0).formatted(.number) == "0.0")
        #expect(Float(-3.14).formatted(.number) == "-3.14")
    }

    // MARK: - Percent Formatting

    @Test("Double formatted as percent")
    func doublePercent() {
        #expect(0.75.formatted(.percent) == "75%")
        #expect(0.5.formatted(.percent) == "50%")
        #expect(1.0.formatted(.percent) == "100%")
        #expect(0.0.formatted(.percent) == "0%")
    }

    @Test("Float formatted as percent")
    func floatPercent() {
        #expect(Float(0.75).formatted(.percent) == "75%")
        #expect(Float(0.5).formatted(.percent) == "50%")
        #expect(Float(1.0).formatted(.percent) == "100%")
    }

    // MARK: - Rounding

    @Test("Number with rounding")
    func numberRounded() {
        #expect(3.7.formatted(.number.rounded()) == "4.0")
        #expect(3.2.formatted(.number.rounded()) == "3.0")
        #expect(3.5.formatted(.number.rounded()) == "4.0")
        #expect((-3.7).formatted(.number.rounded()) == "-4.0")
    }

    @Test("Percent with rounding")
    func percentRounded() {
        #expect(0.755.formatted(.percent.rounded()) == "76%")
        #expect(0.745.formatted(.percent.rounded()) == "75%")
        #expect(0.75.formatted(.percent.rounded()) == "75%")
    }

    // MARK: - Precision

    @Test("Number with precision")
    func numberPrecision() {
        #expect(3.14159.formatted(.number.precision(2)) == "3.14")
        #expect(3.14159.formatted(.number.precision(3)) == "3.142")
        #expect(3.14159.formatted(.number.precision(1)) == "3.1")
        #expect(3.99999.formatted(.number.precision(2)) == "4.0")
    }

    @Test("Percent with precision")
    func percentPrecision() {
        #expect(0.12345.formatted(.percent.precision(2)) == "12.35%")
        #expect(0.755.formatted(.percent.precision(2)) == "75.5%")
        #expect(0.755.formatted(.percent.precision(1)) == "75.5%")
    }

    // MARK: - Chaining

    @Test("Percent with rounding and precision")
    func percentRoundedAndPrecision() {
        // When both rounded and precision are set, rounded applies first to the base value
        // then precision applies to the result
        #expect(0.755.formatted(.percent.precision(2)) == "75.5%")
        #expect(0.755.formatted(.percent.rounded().precision(2)) == "76%")
    }

    @Test("Number with precision and rounding")
    func numberPrecisionAndRounded() {
        // With precision, rounding is applied first
        #expect(3.7.formatted(.number.rounded()) == "4.0")
        #expect(3.7456.formatted(.number.precision(2)) == "3.75")
    }

    // MARK: - Edge Cases

    @Test("Very small numbers")
    func smallNumbers() {
        #expect(0.001.formatted(.percent) == "0%")
        #expect(0.001.formatted(.percent.precision(1)) == "0.1%")
        #expect(0.0001.formatted(.number) == "0.0001")
    }

    @Test("Very large numbers")
    func largeNumbers() {
        #expect(1000000.0.formatted(.number) == "1000000.0")
        #expect(1000.0.formatted(.percent) == "100000%")
    }

    @Test("Zero values")
    func zeroValues() {
        #expect(0.0.formatted(.number) == "0.0")
        #expect(0.0.formatted(.percent) == "0%")
        #expect(0.0.formatted(.number.rounded()) == "0.0")
        #expect(0.0.formatted(.percent.precision(2)) == "0.0%")
    }

    @Test("Negative values")
    func negativeValues() {
        #expect((-0.5).formatted(.percent) == "-50%")
        #expect((-3.14).formatted(.number) == "-3.14")
        #expect((-0.755).formatted(.percent.precision(2)) == "-75.5%")
    }

    // MARK: - Float Specific

    @Test("Float with precision")
    func floatPrecision() {
        #expect(Float(3.14159).formatted(.number.precision(2)) == "3.14")
        #expect(Float(0.12345).formatted(.percent.precision(2)) == "12.35%")
    }

    @Test("Float with rounding")
    func floatRounded() {
        #expect(Float(3.7).formatted(.number.rounded()) == "4.0")
        #expect(Float(0.755).formatted(.percent.rounded()) == "76%")
    }
}
