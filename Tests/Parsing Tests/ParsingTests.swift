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
            #expect(throws: Parsing.Error.self) {
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
            #expect(throws: Parsing.Error.self) {
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
            #expect(throws: Parsing.Error.self) {
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
            let parser = Parsing.Many.Simple<Parsing.Prefix.While<Substring>>(
                atLeast: 0
            ) {
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
        @Test("error includes message")
        func errorIncludesMessage() {
            let error = Parsing.Error("Test error message")
            #expect(error.message == "Test error message")
        }

        @Test("unexpectedEnd factory creates proper error")
        func unexpectedEndFactory() {
            let error = Parsing.Error.unexpectedEnd(expected: "digit")
            #expect(error.message.contains("digit"))
        }
    }

    @Suite("Printer protocol")
    struct PrinterTests {
        /// A simple printer that prepends bytes to an array.
        struct BytesPrinter: Parsing.Printer {
            let bytes: [UInt8]

            func print(_ output: Void, into input: inout [UInt8]) throws(Parsing.Error) {
                input.insert(contentsOf: bytes, at: input.startIndex)
            }
        }

        @Test("prints into existing buffer")
        func printsIntoBuffer() throws {
            var buffer: [UInt8] = [0x04, 0x05]
            let printer = BytesPrinter(bytes: [0x01, 0x02, 0x03])
            try printer.print((), into: &buffer)
            #expect(buffer == [0x01, 0x02, 0x03, 0x04, 0x05])
        }

        @Test("convenience method returns new input")
        func convenienceReturnsInput() throws {
            let printer = BytesPrinter(bytes: [0x41, 0x42, 0x43])
            let result = try printer.print(())
            #expect(result == [0x41, 0x42, 0x43])
        }

        /// A printer that prints an integer as ASCII digits.
        struct IntPrinter: Parsing.Printer {
            func print(_ output: Int, into input: inout [UInt8]) throws(Parsing.Error) {
                let digits = Array(String(output).utf8)
                input.insert(contentsOf: digits, at: input.startIndex)
            }
        }

        @Test("prints integer value")
        func printsInteger() throws {
            let printer = IntPrinter()
            let result = try printer.print(42)
            #expect(result == Array("42".utf8))
        }
    }

    @Suite("ParserPrinter round-trip")
    struct ParserPrinterTests {
        /// A simple parser-printer for a single byte.
        struct SingleByte: Parsing.ParserPrinter {
            typealias Input = ArraySlice<UInt8>
            typealias Output = UInt8

            func parse(_ input: inout ArraySlice<UInt8>) throws(Parsing.Error) -> UInt8 {
                guard let first = input.first else {
                    throw Parsing.Error.unexpectedEnd(expected: "byte")
                }
                input = input.dropFirst()
                return first
            }

            func print(_ output: UInt8, into input: inout ArraySlice<UInt8>) throws(Parsing.Error) {
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
}
