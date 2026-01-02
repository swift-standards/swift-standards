//
//  ParsingTests.swift
//  swift-standards
//
//  Tests for the Parsing module.
//

import Testing
import Parsing

@Suite("Parsing")
struct ParsingTests {

    @Suite("First parser")
    struct FirstTests {
        @Test("parses single element")
        func parsesSingleElement() throws {
            var input: ArraySlice<UInt8> = [0x41, 0x42, 0x43][...]
            let parser = Parsing.First.Element<ArraySlice<UInt8>>()
            let result = try parser.parse(&input)
            #expect(result == 0x41)
            #expect(Array(input) == [0x42, 0x43])
        }

        @Test("fails on empty input")
        func failsOnEmpty() {
            var input: ArraySlice<UInt8> = [][...]
            let parser = Parsing.First.Element<ArraySlice<UInt8>>()
            #expect(throws: Parsing.EndOfInput.Error.self) {
                try parser.parse(&input)
            }
        }
    }

    @Suite("Prefix parser")
    struct PrefixTests {
        @Test("parses while predicate holds")
        func parsesWhilePredicate() throws {
            var input: Substring = "abc123def"
            let parser = Parsing.Prefix.While<Substring> { $0.isLetter }
            let result = try parser.parse(&input)
            #expect(result == "abc")
            #expect(input == "123def")
        }

        @Test("returns empty when predicate immediately fails")
        func returnsEmptyOnImmediateFail() throws {
            var input: Substring = "123abc"
            let parser = Parsing.Prefix.While<Substring> { $0.isLetter }
            let result = try parser.parse(&input)
            #expect(result == "")
            #expect(input == "123abc")
        }

        @Test("respects minimum length")
        func respectsMinLength() {
            var input: Substring = "ab123"
            let parser = Parsing.Prefix.While<Substring>(minLength: 5) { $0.isLetter }
            #expect(throws: Parsing.Constraint.Error.self) {
                try parser.parse(&input)
            }
        }
    }

    @Suite("Map combinator")
    struct MapTests {
        @Test("transforms output")
        func transformsOutput() throws {
            var input: Substring = "abc123"
            let parser = Parsing.Prefix.While<Substring> { $0.isLetter }
                .map { $0.uppercased() }
            let result = try parser.parse(&input)
            #expect(result == "ABC")
        }
    }

    @Suite("Consume parser")
    struct ConsumeTests {
        @Test("takes exact count")
        func takesExactCount() throws {
            var input: Substring = "abcdef"
            let parser = Parsing.Consume.Exactly<Substring>(3)
            let result = try parser.parse(&input)
            #expect(result == "abc")
            #expect(input == "def")
        }

        @Test("fails if not enough elements")
        func failsIfNotEnough() {
            var input: Substring = "ab"
            let parser = Parsing.Consume.Exactly<Substring>(5)
            #expect(throws: Parsing.Constraint.Error.self) {
                try parser.parse(&input)
            }
        }
    }

    @Suite("Rest parser")
    struct RestTests {
        @Test("consumes all remaining input")
        func consumesAll() throws {
            var input: Substring = "hello world"
            let parser = Parsing.Rest<Substring>()
            let result = try parser.parse(&input)
            #expect(result == "hello world")
            #expect(input.isEmpty)
        }
    }

    @Suite("Many parser")
    struct ManyTests {
        @Test("parses zero or more")
        func parsesZeroOrMore() throws {
            var input: Substring = "aaa"
            let parser = Parsing.Many.Simple {
                Parsing.Prefix.While<Substring>(minLength: 1) { $0 == "a" }
            }
            let result = try parser.parse(&input)
            // Each 'a' is parsed as a separate prefix of length 1
            #expect(result.count >= 1)
        }
    }

    @Suite("Take.Two sequential composition")
    struct TakeTwoTests {
        @Test("combines two parsers")
        func combinesTwoParsers() throws {
            var input: Substring = "abc123"
            let letters = Parsing.Prefix.While<Substring> { $0.isLetter }
            let digits = Parsing.Prefix.While<Substring> { $0.isNumber }
            let combined = Parsing.Take.Two(letters, digits)

            let (a, b) = try combined.parse(&input)
            #expect(a == "abc")
            #expect(b == "123")
            #expect(input.isEmpty)
        }
    }

    @Suite("Error handling")
    struct ErrorTests {
        @Test("EndOfInput.Error contains expected description")
        func endOfInputError() {
            let error = Parsing.EndOfInput.Error.unexpected(expected: "digit")
            if case .unexpected(let expected) = error {
                #expect(expected == "digit")
            }
        }

        @Test("Match.Error contains mismatch info")
        func matchError() {
            let error = Parsing.Match.Error.literalMismatch(expected: "foo", found: "bar")
            if case .literalMismatch(let expected, let found) = error {
                #expect(expected == "foo")
                #expect(found == "bar")
            }
        }
    }

    @Suite("Printer protocol")
    struct PrinterTests {
        /// A simple printer that prepends bytes to an array.
        struct BytesPrinter: Parsing.Printer {
            typealias Failure = Never
            let bytes: [UInt8]

            func print(_ output: Void, into input: inout [UInt8]) {
                input.insert(contentsOf: bytes, at: input.startIndex)
            }
        }

        @Test("prints into existing buffer")
        func printsIntoBuffer() {
            var buffer: [UInt8] = [0x04, 0x05]
            let printer = BytesPrinter(bytes: [0x01, 0x02, 0x03])
            printer.print((), into: &buffer)
            #expect(buffer == [0x01, 0x02, 0x03, 0x04, 0x05])
        }

        @Test("convenience method returns new input")
        func convenienceReturnsInput() {
            let printer = BytesPrinter(bytes: [0x41, 0x42, 0x43])
            let result = printer.print(())
            #expect(result == [0x41, 0x42, 0x43])
        }

        /// A printer that prints an integer as ASCII digits.
        struct IntPrinter: Parsing.Printer {
            typealias Failure = Never

            func print(_ output: Int, into input: inout [UInt8]) {
                let digits = Array(String(output).utf8)
                input.insert(contentsOf: digits, at: input.startIndex)
            }
        }

        @Test("prints integer value")
        func printsInteger() {
            let printer = IntPrinter()
            let result = printer.print(42)
            #expect(result == Array("42".utf8))
        }
    }

    @Suite("ParserPrinter round-trip")
    struct ParserPrinterTests {
        /// A simple parser-printer for a single byte.
        struct SingleByte: Parsing.ParserPrinter {
            typealias Input = ArraySlice<UInt8>
            typealias Output = UInt8
            typealias Failure = Parsing.EndOfInput.Error

            func parse(_ input: inout ArraySlice<UInt8>) throws(Failure) -> UInt8 {
                guard let first = input.first else {
                    throw .unexpected(expected: "byte")
                }
                input = input.dropFirst()
                return first
            }

            func print(_ output: UInt8, into input: inout ArraySlice<UInt8>) {
                input.insert(output, at: input.startIndex)
            }
        }

        @Test("parse then print recovers input")
        func parseThenPrint() throws {
            let parserPrinter = SingleByte()
            var input: ArraySlice<UInt8> = [0x42][...]

            // Parse
            let parsed = try parserPrinter.parse(&input)
            #expect(parsed == 0x42)
            #expect(input.isEmpty)

            // Print back
            try parserPrinter.print(parsed, into: &input)
            #expect(Array(input) == [0x42])
        }

        @Test("print then parse recovers value")
        func printThenParse() throws {
            let parserPrinter = SingleByte()
            var input: ArraySlice<UInt8> = [][...]

            // Print
            try parserPrinter.print(0x42, into: &input)
            #expect(Array(input) == [0x42])

            // Parse back
            let parsed = try parserPrinter.parse(&input)
            #expect(parsed == 0x42)
        }

        @Test("conforms to ParserPrinter protocol")
        func conformsToProtocol() throws {
            // Verify SingleByte can be used where ParserPrinter is expected
            func roundTrip<PP: Parsing.ParserPrinter>(
                _ pp: PP,
                value: PP.Output
            ) throws -> PP.Output where PP.Input == ArraySlice<UInt8> {
                var buffer: ArraySlice<UInt8> = [][...]
                try pp.print(value, into: &buffer)
                return try pp.parse(&buffer)
            }

            let result = try roundTrip(SingleByte(), value: 0x99)
            #expect(result == 0x99)
        }
    }

    // MARK: - Built-in ParserPrinter Tests

    @Suite("Literal ParserPrinter")
    struct LiteralParserPrinterTests {
        @Test("round-trip bytes with array literal")
        func roundTripBytes() throws {
            let literal: [UInt8] = [0x48, 0x69] // "Hi"

            // Print
            var buffer: ArraySlice<UInt8> = [][...]
            try literal.print((), into: &buffer)
            #expect(Array(buffer) == [0x48, 0x69])

            // Parse back
            var input = buffer
            try literal.parse(&input)
            #expect(input.isEmpty)
        }

        @Test("round-trip string with Parsing.Literal")
        func roundTripString() throws {
            let literal: Parsing.Literal<ArraySlice<UInt8>> = "Hello"

            var buffer: ArraySlice<UInt8> = [][...]
            try literal.print((), into: &buffer)
            #expect(Array(buffer) == Array("Hello".utf8))
        }

        @Test("round-trip string literal for Substring")
        func roundTripStringForSubstring() throws {
            let literal = "Hello"

            // Print
            var buffer: Substring = ""
            try literal.print((), into: &buffer)
            #expect(buffer == "Hello")

            // Parse back
            var input = buffer
            try literal.parse(&input)
            #expect(input.isEmpty)
        }
    }

    @Suite("First.Element ParserPrinter")
    struct FirstElementParserPrinterTests {
        @Test("round-trip single element")
        func roundTripElement() throws {
            let parser = Parsing.First.Element<ArraySlice<UInt8>>()

            // Print
            var buffer: ArraySlice<UInt8> = [][...]
            try parser.print(0x42, into: &buffer)
            #expect(Array(buffer) == [0x42])

            // Parse back
            var input = buffer
            let result = try parser.parse(&input)
            #expect(result == 0x42)
            #expect(input.isEmpty)
        }
    }

    @Suite("Rest ParserPrinter")
    struct RestParserPrinterTests {
        @Test("round-trip all content")
        func roundTripAll() throws {
            let rest = Parsing.Rest<ArraySlice<UInt8>>()
            let content: ArraySlice<UInt8> = [0x01, 0x02, 0x03][...]

            // Print
            var buffer: ArraySlice<UInt8> = [][...]
            try rest.print(content, into: &buffer)
            #expect(Array(buffer) == [0x01, 0x02, 0x03])

            // Parse back
            var input = buffer
            let result = try rest.parse(&input)
            #expect(Array(result) == [0x01, 0x02, 0x03])
        }
    }

    @Suite("End ParserPrinter")
    struct EndParserPrinterTests {
        @Test("prints nothing")
        func printsNothing() throws {
            let end = Parsing.End<ArraySlice<UInt8>>()

            var buffer: ArraySlice<UInt8> = [0x01, 0x02][...]
            try end.print((), into: &buffer)
            // End should not modify the buffer
            #expect(Array(buffer) == [0x01, 0x02])
        }
    }

    @Suite("Take.Two ParserPrinter")
    struct TakeTwoParserPrinterTests {
        @Test("round-trip pair")
        func roundTripPair() throws {
            let first = Parsing.First.Element<ArraySlice<UInt8>>()
            let second = Parsing.First.Element<ArraySlice<UInt8>>()
            let combined = Parsing.Take.Two(first, second)

            // Print pair (prints in reverse: second then first)
            var buffer: ArraySlice<UInt8> = [][...]
            try combined.print((0x41, 0x42), into: &buffer)
            #expect(Array(buffer) == [0x41, 0x42])

            // Parse back
            var input = buffer
            let (a, b) = try combined.parse(&input)
            #expect(a == 0x41)
            #expect(b == 0x42)
        }
    }

    @Suite("Skip.First ParserPrinter")
    struct SkipFirstParserPrinterTests {
        @Test("round-trip with prefix literal")
        func roundTripWithPrefix() throws {
            let parser = Parsing.Skip.First([0x3A], Parsing.First.Element<ArraySlice<UInt8>>())

            // Print (should print value then prefix)
            var buffer: ArraySlice<UInt8> = [][...]
            try parser.print(0x42, into: &buffer)
            #expect(Array(buffer) == [0x3A, 0x42])

            // Parse back
            var input = buffer
            let result = try parser.parse(&input)
            #expect(result == 0x42)
        }
    }

    @Suite("Skip.Second ParserPrinter")
    struct SkipSecondParserPrinterTests {
        @Test("round-trip with suffix literal")
        func roundTripWithSuffix() throws {
            let parser = Parsing.Skip.Second(Parsing.First.Element<ArraySlice<UInt8>>(), [0x3B])

            // Print (should print suffix then value)
            var buffer: ArraySlice<UInt8> = [][...]
            try parser.print(0x42, into: &buffer)
            #expect(Array(buffer) == [0x42, 0x3B])

            // Parse back
            var input = buffer
            let result = try parser.parse(&input)
            #expect(result == 0x42)
        }
    }

    @Suite("Many.Simple ParserPrinter")
    struct ManySimpleParserPrinterTests {
        @Test("round-trip array")
        func roundTripArray() throws {
            let many = Parsing.Many.Simple {
                Parsing.First.Element<ArraySlice<UInt8>>()
            }

            // Print
            var buffer: ArraySlice<UInt8> = [][...]
            try many.print([0x01, 0x02, 0x03], into: &buffer)
            #expect(Array(buffer) == [0x01, 0x02, 0x03])

            // Parse back
            var input = buffer
            let result = try many.parse(&input)
            #expect(result == [0x01, 0x02, 0x03])
        }

        @Test("validates minimum count")
        func validatesMinimum() throws {
            let many = Parsing.Many.Simple(3...) {
                Parsing.First.Element<ArraySlice<UInt8>>()
            }

            var buffer: ArraySlice<UInt8> = [][...]
            #expect(throws: Parsing.Many.Error.self) {
                try many.print([0x01, 0x02], into: &buffer)
            }
        }
    }

    @Suite("OneOf.Two ParserPrinter")
    struct OneOfTwoParserPrinterTests {
        @Test("prints with first matching printer")
        func printsFirstMatch() throws {
            // Outside builders, need explicit [UInt8] type
            let literalA: [UInt8] = [0x41]
            let literalB: [UInt8] = [0x42]
            let oneOf = Parsing.OneOf.Two(literalA, literalB)

            // Both print Void, so first should succeed
            var buffer: ArraySlice<UInt8> = [][...]
            try oneOf.print((), into: &buffer)
            #expect(Array(buffer) == [0x41])
        }
    }

    @Suite("Complex ParserPrinter composition")
    struct ComplexParserPrinterTests {
        @Test("key-value pair round-trip")
        func keyValueRoundTrip() throws {
            // Format: "key:value" where key and value are single bytes
            let byte = Parsing.First.Element<ArraySlice<UInt8>>()
            let keyValue = Parsing.Take.Two(
                Parsing.Skip.Second(byte, [0x3A]),  // key followed by ":"
                byte
            )

            // Print
            var buffer: ArraySlice<UInt8> = [][...]
            try keyValue.print((0x4B, 0x56), into: &buffer)  // K:V
            #expect(Array(buffer) == [0x4B, 0x3A, 0x56])

            // Parse back
            var input = buffer
            let (key, value) = try keyValue.parse(&input)
            #expect(key == 0x4B)
            #expect(value == 0x56)
        }

        @Test("list with separator round-trip")
        func listWithSeparatorRoundTrip() throws {
            let list = Parsing.Many.Separated(1...) {
                Parsing.First.Element<ArraySlice<UInt8>>()
            } separator: {
                [0x2C]  // Comma as array literal
            }

            // Print
            var buffer: ArraySlice<UInt8> = [][...]
            try list.print([0x41, 0x42, 0x43], into: &buffer)  // A,B,C
            #expect(Array(buffer) == [0x41, 0x2C, 0x42, 0x2C, 0x43])

            // Parse back
            var input = buffer
            let result = try list.parse(&input)
            #expect(result == [0x41, 0x42, 0x43])
        }
    }
}
