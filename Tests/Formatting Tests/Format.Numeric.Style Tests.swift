// Format.Numeric.Style Tests.swift
// swift-standards
//
// Comprehensive tests for Foundation-compatible numeric formatting API

import Testing
@testable import Formatting

@Suite
struct `Format.Numeric.Style Tests` {

    // MARK: - Basic Formatting

    @Suite
    struct `Basic Number Formatting` {

        @Test
        func `default number formatting`() {
            #expect(42.formatted(.number) == "42")
            #expect(3.14.formatted(.number) == "3.14")
            #expect((-100).formatted(.number) == "-100")
        }

        @Test
        func `removes trailing zeros`() {
            #expect(100.0.formatted(.number) == "100")
            #expect(42.50.formatted(.number) == "42.5")
        }
    }

    // MARK: - Notation

    @Suite
    struct `Notation Styles` {

        @Test
        func `automatic notation`() {
            #expect(1234.formatted(.number.notation(.automatic)) == "1234")
            #expect(0.00001.formatted(.number.notation(.automatic)) == "0.00001")
        }

        @Test
        func `compact notation`() {
            #expect(1000.formatted(.number.notation(.compactName)) == "1K")
            #expect(1500.formatted(.number.notation(.compactName)) == "1.5K")
            #expect(1000000.formatted(.number.notation(.compactName)) == "1M")
            #expect(1500000.formatted(.number.notation(.compactName)) == "1.5M")
            #expect(1000000000.formatted(.number.notation(.compactName)) == "1B")
        }

        @Test
        func `scientific notation`() {
            #expect(1234.formatted(.number.notation(.scientific)) == "1.234E3")
            #expect(0.00001.formatted(.number.notation(.scientific)) == "1E-5")
            #expect(1000000.formatted(.number.notation(.scientific)) == "1E6")
        }
    }

    // MARK: - Sign Display

    @Suite
    struct `Sign Display` {

        @Test
        func `automatic sign display`() {
            #expect(42.formatted(.number.sign(strategy: .automatic)) == "42")
            #expect((-42).formatted(.number.sign(strategy: .automatic)) == "-42")
            #expect(0.formatted(.number.sign(strategy: .automatic)) == "0")
        }

        @Test
        func `never show signs`() {
            #expect(42.formatted(.number.sign(strategy: .never)) == "42")
            #expect((-42).formatted(.number.sign(strategy: .never)) == "42")
            #expect(0.formatted(.number.sign(strategy: .never)) == "0")
        }

        @Test
        func `always show signs`() {
            #expect(42.formatted(.number.sign(strategy: .always())) == "+42")
            #expect((-42).formatted(.number.sign(strategy: .always())) == "-42")
            #expect(0.formatted(.number.sign(strategy: .always())) == "0")
        }

        @Test
        func `always show signs including zero`() {
            #expect(42.formatted(.number.sign(strategy: .always(includingZero: true))) == "+42")
            #expect((-42).formatted(.number.sign(strategy: .always(includingZero: true))) == "-42")
            #expect(0.formatted(.number.sign(strategy: .always(includingZero: true))) == "+0")
        }
    }

    // MARK: - Grouping

    @Suite
    struct `Grouping` {

        @Test
        func `automatic grouping`() {
            #expect(1234567.formatted(.number.grouping(.automatic)) == "1,234,567")
            #expect(100.formatted(.number.grouping(.automatic)) == "100")
        }

        @Test
        func `never use grouping`() {
            #expect(1234567.formatted(.number.grouping(.never)) == "1234567")
            #expect(1000.formatted(.number.grouping(.never)) == "1000")
        }
    }

    // MARK: - Precision - Significant Digits

    @Suite
    struct `Precision - Significant Digits` {

        @Test
        func `fixed significant digits`() {
            #expect(1234.5678.formatted(.number.precision(.significantDigits(3))) == "1230")
            #expect(0.0012345.formatted(.number.precision(.significantDigits(3))) == "0.00123")
            #expect(123.formatted(.number.precision(.significantDigits(5))) == "123.00")
        }

        @Test
        func `significant digits range`() {
            #expect(1.formatted(.number.precision(.significantDigits(2...4))) == "1.0")
            #expect(12.formatted(.number.precision(.significantDigits(2...4))) == "12")
            #expect(123.formatted(.number.precision(.significantDigits(2...4))) == "123")
            #expect(1234.formatted(.number.precision(.significantDigits(2...4))) == "1234")
        }

        @Test
        func `significant digits minimum`() {
            #expect(1.formatted(.number.precision(.significantDigits(3...))) == "1.00")
            #expect(12.formatted(.number.precision(.significantDigits(3...))) == "12.0")
        }

        @Test
        func `significant digits maximum`() {
            #expect(123.456.formatted(.number.precision(.significantDigits(...3))) == "123")
            #expect(1234.56.formatted(.number.precision(.significantDigits(...3))) == "1230")
        }
    }

    // MARK: - Precision - Fraction Length

    @Suite
    struct `Precision - Fraction Length` {

        @Test
        func `fixed fraction length`() {
            #expect(3.14159.formatted(.number.precision(.fractionLength(2))) == "3.14")
            #expect(42.formatted(.number.precision(.fractionLength(2))) == "42.00")
            #expect(1.5.formatted(.number.precision(.fractionLength(3))) == "1.500")
        }

        @Test
        func `fraction length range`() {
            #expect(3.1.formatted(.number.precision(.fractionLength(2...4))) == "3.10")
            #expect(3.14159.formatted(.number.precision(.fractionLength(2...4))) == "3.1416")
        }

        @Test
        func `fraction length minimum`() {
            #expect(42.formatted(.number.precision(.fractionLength(2...))) == "42.00")
            #expect(3.1.formatted(.number.precision(.fractionLength(2...))) == "3.10")
        }

        @Test
        func `fraction length maximum`() {
            #expect(3.14159.formatted(.number.precision(.fractionLength(...2))) == "3.14")
            #expect(100.999.formatted(.number.precision(.fractionLength(...2))) == "101")
        }
    }

    // MARK: - Precision - Integer Length

    @Suite
    struct `Precision - Integer Length` {

        @Test
        func `fixed integer length`() {
            #expect(42.formatted(.number.precision(.integerLength(4))) == "0042")
            #expect(1234.formatted(.number.precision(.integerLength(6))) == "001234")
        }

        @Test
        func `integer length range`() {
            #expect(1.formatted(.number.precision(.integerLength(2...4))) == "01")
            #expect(12.formatted(.number.precision(.integerLength(2...4))) == "12")
            #expect(1234.formatted(.number.precision(.integerLength(2...4))) == "1234")
        }

        @Test
        func `integer length minimum`() {
            #expect(1.formatted(.number.precision(.integerLength(3...))) == "001")
            #expect(1234.formatted(.number.precision(.integerLength(3...))) == "1234")
        }

        @Test
        func `integer length maximum`() {
            #expect(12345.formatted(.number.precision(.integerLength(...3))) == "12345")  // Doesn't truncate
        }
    }

    // MARK: - Precision - Integer and Fraction

    @Suite
    struct `Precision - Integer and Fraction` {

        @Test
        func `combined integer and fraction length`() {
            #expect(42.5.formatted(.number.precision(.integerAndFractionLength(integer: 4, fraction: 2))) == "0042.50")
            #expect(1.23.formatted(.number.precision(.integerAndFractionLength(integer: 2, fraction: 3))) == "01.230")
        }

        @Test
        func `combined with ranges`() {
            #expect(42.5.formatted(.number.precision(.integerAndFractionLength(integerLimits: 2...4, fractionLimits: 1...3))) == "42.5")
            #expect(1.formatted(.number.precision(.integerAndFractionLength(integerLimits: 2...4, fractionLimits: 1...3))) == "01.0")
        }
    }

    // MARK: - Rounding

    @Suite
    struct `Rounding Rules` {

        @Test
        func `round up`() {
            #expect(1.4.formatted(.number.rounded(rule: .up)) == "2")
            #expect(1.1.formatted(.number.rounded(rule: .up)) == "2")
            #expect((-1.1).formatted(.number.rounded(rule: .up)) == "-1")
        }

        @Test
        func `round down`() {
            #expect(1.9.formatted(.number.rounded(rule: .down)) == "1")
            #expect(1.1.formatted(.number.rounded(rule: .down)) == "1")
            #expect((-1.9).formatted(.number.rounded(rule: .down)) == "-2")
        }

        @Test
        func `round toward zero`() {
            #expect(1.9.formatted(.number.rounded(rule: .towardZero)) == "1")
            #expect((-1.9).formatted(.number.rounded(rule: .towardZero)) == "-1")
        }

        @Test
        func `round away from zero`() {
            #expect(1.1.formatted(.number.rounded(rule: .awayFromZero)) == "2")
            #expect((-1.1).formatted(.number.rounded(rule: .awayFromZero)) == "-2")
        }

        @Test
        func `round to nearest or even`() {
            #expect(1.5.formatted(.number.rounded(rule: .toNearestOrEven)) == "2")
            #expect(2.5.formatted(.number.rounded(rule: .toNearestOrEven)) == "2")
            #expect(3.5.formatted(.number.rounded(rule: .toNearestOrEven)) == "4")
        }

        @Test
        func `round to nearest or away from zero`() {
            #expect(1.5.formatted(.number.rounded(rule: .toNearestOrAwayFromZero)) == "2")
            #expect(2.5.formatted(.number.rounded(rule: .toNearestOrAwayFromZero)) == "3")
        }

        @Test
        func `rounding with increment`() {
            #expect(1.23.formatted(.number.rounded(rule: .toNearestOrAwayFromZero, increment: 0.5)) == "1.0")
            #expect(1.26.formatted(.number.rounded(rule: .toNearestOrAwayFromZero, increment: 0.5)) == "1.5")
            #expect(42.formatted(.number.rounded(rule: .toNearestOrAwayFromZero, increment: 5)) == "40")
        }
    }

    // MARK: - Decimal Separator

    @Suite
    struct `Decimal Separator Display` {

        @Test
        func `automatic decimal separator`() {
            #expect(42.formatted(.number.decimalSeparator(strategy: .automatic)) == "42")
            #expect(42.5.formatted(.number.decimalSeparator(strategy: .automatic)) == "42.5")
        }

        @Test
        func `always show decimal separator`() {
            #expect(42.formatted(.number.decimalSeparator(strategy: .always)) == "42.")
            #expect(42.5.formatted(.number.decimalSeparator(strategy: .always)) == "42.5")
        }
    }

    // MARK: - Scale

    @Suite
    struct `Scale` {

        @Test
        func `scale by factor`() {
            #expect(0.5.formatted(.number.scale(100)) == "50")
            #expect(42.formatted(.number.scale(2)) == "84")
            #expect(100.formatted(.number.scale(0.01)) == "1")
        }

        @Test
        func `scale with precision`() {
            #expect(0.123.formatted(.number.scale(100).precision(.fractionLength(1))) == "12.3")
        }
    }

    // MARK: - Complex Combinations

    @Suite
    struct `Complex Formatting` {

        @Test
        func `percentage style formatting`() {
            #expect(0.42.formatted(.number.scale(100).precision(.fractionLength(0))) == "42")
            #expect(0.425.formatted(.number.scale(100).precision(.fractionLength(1))) == "42.5")
        }

        @Test
        func `compact with precision`() {
            #expect(1500.formatted(.number.notation(.compactName).precision(.fractionLength(2))) == "1.50K")
            #expect(1234567.formatted(.number.notation(.compactName).precision(.fractionLength(1))) == "1.2M")
        }

        @Test
        func `scientific with significant digits`() {
            #expect(1234.5678.formatted(.number.notation(.scientific).precision(.significantDigits(3))) == "1.23E3")
        }

        @Test
        func `grouping with sign display`() {
            #expect(1234567.formatted(.number.grouping(.automatic).sign(strategy: .always())) == "+1,234,567")
            #expect((-1234567).formatted(.number.grouping(.automatic).sign(strategy: .always())) == "-1,234,567")
        }

        @Test
        func `full formatting chain`() {
            #expect(1234.5678.formatted(
                .number
                    .notation(.automatic)
                    .grouping(.automatic)
                    .precision(.fractionLength(2))
                    .sign(strategy: .always())
                    .decimalSeparator(strategy: .always)
            ) == "+1,234.57")
        }
    }

    // MARK: - All Numeric Types

    @Suite
    struct `All Numeric Types Support` {

        @Test
        func `Int types`() {
            let int8: Int8 = 42
            let int16: Int16 = 1000
            let int32: Int32 = 100000
            let int64: Int64 = 1000000

            #expect(int8.formatted(.number) == "42")
            #expect(int16.formatted(.number.grouping(.automatic)) == "1,000")
            #expect(int32.formatted(.number.notation(.compactName)) == "100K")
            #expect(int64.formatted(.number.notation(.compactName)) == "1M")
        }

        @Test
        func `UInt types`() {
            let uint8: UInt8 = 255
            let uint16: UInt16 = 65535
            let uint32: UInt32 = 4294967295

            #expect(uint8.formatted(.number) == "255")
            #expect(uint16.formatted(.number.grouping(.automatic)) == "65,535")
            #expect(uint32.formatted(.number.notation(.compactName)) == "4.3B")
        }

        @Test
        func `Float and Double`() {
            let float: Float = 3.14159
            let double: Double = 2.71828

            #expect(float.formatted(.number.precision(.fractionLength(2))) == "3.14")
            #expect(double.formatted(.number.precision(.significantDigits(3))) == "2.72")
        }
    }
}
