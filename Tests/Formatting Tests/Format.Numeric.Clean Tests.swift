// Format.Numeric.Clean Tests.swift
// swift-standards
//
// Tests for Format.Numeric.Clean formatter

import Testing
@testable import Formatting

@Suite
struct `Format.Numeric.Clean Tests` {

    // MARK: - Double Formatting

    @Suite
    struct `Double - Basic Formatting` {

        @Test
        func `removes trailing zeros from whole numbers`() {
            #expect(100.0.formatted(.number) == "100")
            #expect(42.0.formatted(.number) == "42")
            #expect(0.0.formatted(.number) == "0")
        }

        @Test
        func `preserves fractional parts`() {
            #expect(3.14.formatted(.number) == "3.14")
            #expect(0.5.formatted(.number) == "0.5")
            #expect(123.25.formatted(.number) == "123.25")
        }

        @Test
        func `removes trailing zeros from fractional parts`() {
            #expect(3.140.formatted(.number) == "3.14")
            #expect(100.500.formatted(.number) == "100.5")
        }

        @Test
        func `handles negative numbers`() {
            #expect((-42.0).formatted(.number) == "-42")
            #expect((-3.14).formatted(.number) == "-3.14")
            #expect((-100.50).formatted(.number) == "-100.5")
        }

        @Test
        func `handles special values`() {
            #expect(Double.nan.formatted(.number) == "NaN")
            #expect(Double.infinity.formatted(.number) == "Infinity")
            #expect((-Double.infinity).formatted(.number) == "-Infinity")
        }
    }

    @Suite
    struct `Double - Precision Control` {

        @Test
        func `maximum fraction digits limits precision`() {
            #expect(3.14159.formatted(.number.precision(.fractionLength(2))) == "3.14")
            #expect(123.456.formatted(.number.precision(.fractionLength(2))) == "123.46")
        }

        @Test
        func `minimum fraction digits pads with zeros`() {
            #expect(42.0.formatted(.number.precision(.fractionLength(2...))) == "42.00")
            #expect(3.1.formatted(.number.precision(.fractionLength(2...))) == "3.10")
            #expect(0.0.formatted(.number.precision(.fractionLength(2...))) == "0.00")
        }

        @Test
        func `minimum and maximum work together`() {
            #expect(3.1.formatted(.number.precision(.fractionLength(2...3))) == "3.10")
            #expect(3.14159.formatted(.number.precision(.fractionLength(2...3))) == "3.142")
        }
    }

    @Suite
    struct `Double - Grouping and Separators` {

        @Test
        func `grouping separator formats large numbers`() {
            #expect(1234567.0.formatted(.number.grouping(.always)) == "1,234,567")
            #expect(1000.0.formatted(.number.grouping(.always)) == "1,000")
            #expect(100.0.formatted(.number.grouping(.always)) == "100")
        }

        @Test
        func `custom decimal separator`() {
            #expect(3.14.formatted(.number.decimalSeparator(",")) == "3,14")
        }

        @Test
        func `european style formatting`() {
            #expect(1234567.89.formatted(
                .number
                    .precision(.fractionLength(...2))
                    .grouping(.always, separator: ".")
                    .decimalSeparator(",")
            ) == "1.234.567,89")
        }
    }

    // MARK: - Float Formatting

    @Suite
    struct `Float - Basic Formatting` {

        @Test
        func `formats float values`() {
            let value: Float = 3.14
            #expect(value.formatted(.number.precision(.fractionLength(...2))) == "3.14")
        }

        @Test
        func `removes trailing zeros from float`() {
            let value: Float = 100.0
            #expect(value.formatted(.number) == "100")
        }

        @Test
        func `handles negative float`() {
            let value: Float = -42.5
            #expect(value.formatted(.number) == "-42.5")
        }
    }

    // MARK: - Integer Formatting

    @Suite
    struct `Int - Basic Formatting` {

        @Test(arguments: [0, 1, 42, 100, 1000, -5, -100])
        func `formats integer values`(value: Int) {
            #expect(value.formatted(.number) == String(value))
        }

        @Test
        func `handles large integers`() {
            #expect(1234567890.formatted(.number) == "1234567890")
            #expect((-1234567890).formatted(.number) == "-1234567890")
        }

        @Test
        func `integer with grouping separator`() {
            #expect(1234567.formatted(.number.grouping(.always)) == "1,234,567")
            #expect(1000.formatted(.number.grouping(.always)) == "1,000")
            #expect(100.formatted(.number.grouping(.always)) == "100")
        }

        @Test
        func `integer with minimum fraction digits`() {
            #expect(42.formatted(.number.precision(.fractionLength(2...))) == "42.00")
            #expect(0.formatted(.number.precision(.fractionLength(2...))) == "0.00")
        }
    }

    @Suite
    struct `Int - All Integer Types` {

        @Test
        func `Int8 formatting`() {
            let value: Int8 = 42
            #expect(value.formatted(.number) == "42")
        }

        @Test
        func `Int16 formatting`() {
            let value: Int16 = 1000
            #expect(value.formatted(.number) == "1000")
        }

        @Test
        func `Int32 formatting`() {
            let value: Int32 = 1234567
            #expect(value.formatted(.number) == "1234567")
        }

        @Test
        func `Int64 formatting`() {
            let value: Int64 = 9876543210
            #expect(value.formatted(.number) == "9876543210")
        }

        @Test
        func `UInt formatting`() {
            let value: UInt = 42
            #expect(value.formatted(.number) == "42")
        }

        @Test
        func `UInt8 formatting`() {
            let value: UInt8 = 255
            #expect(value.formatted(.number) == "255")
        }

        @Test
        func `UInt16 formatting`() {
            let value: UInt16 = 65535
            #expect(value.formatted(.number) == "65535")
        }

        @Test
        func `UInt32 formatting`() {
            let value: UInt32 = 4294967295
            #expect(value.formatted(.number) == "4294967295")
        }

        @Test
        func `UInt64 formatting`() {
            let value: UInt64 = 1234567890123456789
            #expect(value.formatted(.number) == "1234567890123456789")
        }
    }

    // MARK: - Static Convenience

    @Suite
    struct `Static Conveniences` {

        @Test
        func `default formatter available`() {
            #expect(100.0.formatted(.number) == "100")
            #expect(3.14.formatted(.number) == "3.14")
        }
    }

    // MARK: - Real World Examples

    @Suite
    struct `Real World Usage` {

        @Test
        func `SVG coordinate formatting`() {
            // SVG lengths should be clean (100 not 100.0)
            #expect(100.0.formatted(.number) == "100")
            #expect(50.5.formatted(.number) == "50.5")
        }

        @Test
        func `currency display without symbol`() {
            // Show 2 decimal places for money
            #expect(42.5.formatted(.number.precision(.fractionLength(2))) == "42.50")
            #expect(100.0.formatted(.number.precision(.fractionLength(2))) == "100.00")
        }

        @Test
        func `large number with thousands separator`() {
            #expect(1234567.89.formatted(
                .number
                    .precision(.fractionLength(...2))
                    .grouping(.always)
            ) == "1,234,567.89")
        }

        @Test
        func `percentage-like values`() {
            #expect(75.5.formatted(.number.precision(.fractionLength(...1))) == "75.5")
            #expect(100.0.formatted(.number.precision(.fractionLength(...1))) == "100")
        }
    }
}
