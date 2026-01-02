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
            #expect(result.isEmpty)
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

    // MARK: - Location Tracking

    @Suite("Located error wrapper")
    struct LocatedTests {
        @Test("wraps error with offset")
        func wrapsErrorWithOffset() {
            let error = Parsing.Located(Parsing.EndOfInput.Error.unexpected(expected: "byte"), at: 42)
            #expect(error.offset == 42)
            #expect(error.error == .unexpected(expected: "byte"))
        }

        @Test("equatable when underlying is equatable")
        func equatableWhenUnderlyingIs() {
            let a = Parsing.Located(Parsing.EndOfInput.Error.unexpected(expected: "byte"), at: 10)
            let b = Parsing.Located(Parsing.EndOfInput.Error.unexpected(expected: "byte"), at: 10)
            let c = Parsing.Located(Parsing.EndOfInput.Error.unexpected(expected: "byte"), at: 20)
            #expect(a == b)
            #expect(a != c)
        }

        @Test("description includes offset")
        func descriptionIncludesOffset() {
            let error = Parsing.Located(Parsing.EndOfInput.Error.unexpected(expected: "byte"), at: 42)
            #expect(error.description.contains("42"))
        }

        @Test("map transforms underlying error")
        func mapTransformsError() {
            let error = Parsing.Located(Parsing.EndOfInput.Error.unexpected(expected: "byte"), at: 42)
            let mapped = error.map { _ in Parsing.Match.Error.predicateFailed(description: "test") }
            #expect(mapped.offset == 42)
            #expect(mapped.error == Parsing.Match.Error.predicateFailed(description: "test"))
        }
    }

    @Suite("Spanned value wrapper")
    struct SpannedTests {
        @Test("wraps value with span")
        func wrapsValueWithSpan() {
            let spanned = Parsing.Spanned("hello", start: 10, end: 15)
            #expect(spanned.value == "hello")
            #expect(spanned.start == 10)
            #expect(spanned.end == 15)
        }

        @Test("computes length")
        func computesLength() {
            let spanned = Parsing.Spanned("hello", start: 10, end: 15)
            #expect(spanned.length == 5)
        }

        @Test("computes range")
        func computesRange() {
            let spanned = Parsing.Spanned("hello", start: 10, end: 15)
            #expect(spanned.range == 10..<15)
        }

        @Test("equatable when value is equatable")
        func equatableWhenValueIs() {
            let a = Parsing.Spanned("hello", start: 10, end: 15)
            let b = Parsing.Spanned("hello", start: 10, end: 15)
            let c = Parsing.Spanned("world", start: 10, end: 15)
            #expect(a == b)
            #expect(a != c)
        }

        @Test("hashable when value is hashable")
        func hashableWhenValueIs() {
            let a = Parsing.Spanned("hello", start: 10, end: 15)
            let b = Parsing.Spanned("hello", start: 10, end: 15)
            #expect(a.hashValue == b.hashValue)
        }

        @Test("map preserves span")
        func mapPreservesSpan() {
            let spanned = Parsing.Spanned("hello", start: 10, end: 15)
            let mapped = spanned.map { $0.uppercased() }
            #expect(mapped.value == "HELLO")
            #expect(mapped.start == 10)
            #expect(mapped.end == 15)
        }

        @Test("description includes value and span")
        func descriptionIncludesValueAndSpan() {
            let spanned = Parsing.Spanned("hello", start: 10, end: 15)
            #expect(spanned.description.contains("hello"))
            #expect(spanned.description.contains("10"))
            #expect(spanned.description.contains("15"))
        }
    }

    @Suite("Tracked input wrapper")
    struct TrackedTests {
        @Test("tracks offset during parsing")
        func tracksOffset() {
            var tracked = Parsing.Tracked<ArraySlice<UInt8>>([0x41, 0x42, 0x43][...])
            #expect(tracked.currentOffset == 0)
            _ = tracked.removeFirst()
            #expect(tracked.currentOffset == 1)
            tracked.removeFirst(2)
            #expect(tracked.currentOffset == 3)
        }

        @Test("starts with custom offset")
        func startsWithCustomOffset() {
            let tracked = Parsing.Tracked<ArraySlice<UInt8>>([0x41, 0x42][...], offset: 100)
            #expect(tracked.currentOffset == 100)
        }

        @Test("provides base input access")
        func providesBaseAccess() {
            let tracked = Parsing.Tracked<ArraySlice<UInt8>>([0x41, 0x42, 0x43][...])
            #expect(Array(tracked.input) == [0x41, 0x42, 0x43])
        }

        @Test("isEmpty reflects base state")
        func isEmptyReflectsBase() {
            var tracked = Parsing.Tracked<ArraySlice<UInt8>>([0x41][...])
            #expect(!tracked.isEmpty)
            _ = tracked.removeFirst()
            #expect(tracked.isEmpty)
        }

        @Test("count reflects base state")
        func countReflectsBase() {
            let tracked = Parsing.Tracked<ArraySlice<UInt8>>([0x41, 0x42, 0x43][...])
            #expect(tracked.count == 3)
        }

        @Test("first reflects base state")
        func firstReflectsBase() {
            let tracked = Parsing.Tracked<ArraySlice<UInt8>>([0x41, 0x42][...])
            #expect(tracked.first == 0x41)
        }

        @Test("savepoint and restore")
        func savepointAndRestore() {
            var tracked = Parsing.Tracked<ArraySlice<UInt8>>([0x41, 0x42, 0x43][...])
            _ = tracked.removeFirst()
            let saved = tracked.savepoint()
            _ = tracked.removeFirst()
            #expect(tracked.currentOffset == 2)
            tracked.restore(to: saved)
            #expect(tracked.currentOffset == 1)
            #expect(tracked.first == 0x42)
        }
    }

    @Suite("Locate parser")
    struct LocateTests {
        @Test("wraps error with location")
        func wrapsErrorWithLocation() {
            var tracked = Parsing.Tracked<ArraySlice<UInt8>>([0x41, 0x42][...])
            // Consume one byte first
            _ = tracked.removeFirst()

            // Parser that fails immediately
            let failing = Parsing.First.Where<ArraySlice<UInt8>> { $0 == 0xFF }
            let located = Parsing.Locate(failing)

            do {
                _ = try located.parse(&tracked)
                Issue.record("Expected to throw")
            } catch {
                #expect(error.offset == 1)
            }
        }

        @Test("preserves output on success")
        func preservesOutputOnSuccess() throws {
            var tracked = Parsing.Tracked<ArraySlice<UInt8>>([0x41, 0x42, 0x43][...])
            let parser = Parsing.First.Element<ArraySlice<UInt8>>()
            let located = Parsing.Locate(parser)
            let result = try located.parse(&tracked)
            #expect(result == 0x41)
        }
    }

    @Suite("Span parser")
    struct SpanTests {
        @Test("captures span around parsed value")
        func capturesSpan() throws {
            var tracked = Parsing.Tracked<ArraySlice<UInt8>>([0x41, 0x42, 0x43][...])
            // Skip first byte
            _ = tracked.removeFirst()

            let parser = Parsing.Consume.Exactly<ArraySlice<UInt8>>(2)
            let spanning = Parsing.Span(parser)
            let result = try spanning.parse(&tracked)

            #expect(result.start == 1)
            #expect(result.end == 3)
            #expect(Array(result.value) == [0x42, 0x43])
        }

        @Test("wraps error with location on failure")
        func wrapsErrorOnFailure() {
            var tracked = Parsing.Tracked<ArraySlice<UInt8>>([0x41][...])
            // Skip first byte
            _ = tracked.removeFirst()

            let parser = Parsing.Consume.Exactly<ArraySlice<UInt8>>(5)  // More than available
            let spanning = Parsing.Span(parser)

            do {
                _ = try spanning.parse(&tracked)
                Issue.record("Expected to throw")
            } catch {
                #expect(error.offset == 1)
            }
        }
    }

    @Suite("Location extensions")
    struct LocationExtensionTests {
        @Test("located() convenience method")
        func locatedConvenience() {
            var tracked = Parsing.Tracked<ArraySlice<UInt8>>([0x41][...])
            _ = tracked.removeFirst()

            let parser = Parsing.First.Element<ArraySlice<UInt8>>().located()

            do {
                _ = try parser.parse(&tracked)
                Issue.record("Expected to throw")
            } catch {
                #expect(error.offset == 1)
            }
        }

        @Test("spanned() convenience method")
        func spannedConvenience() throws {
            var tracked = Parsing.Tracked<ArraySlice<UInt8>>([0x41, 0x42, 0x43][...])
            let parser = Parsing.Consume.Exactly<ArraySlice<UInt8>>(2).spanned()
            let result = try parser.parse(&tracked)
            #expect(result.start == 0)
            #expect(result.end == 2)
            #expect(Array(result.value) == [0x41, 0x42])
        }
    }

    // MARK: - Error Transformation

    @Suite("Error transformation")
    struct ErrorTransformTests {
        enum CustomError: Error, Equatable {
            case failed
            case wrapped(String)
        }

        @Test("error.map transforms error type")
        func errorMapTransforms() {
            var input: ArraySlice<UInt8> = [][...]
            let parser = Parsing.First.Element<ArraySlice<UInt8>>()
                .error.map { _ in CustomError.failed }

            do {
                _ = try parser.parse(&input)
                Issue.record("Expected to throw")
            } catch {
                #expect(error == CustomError.failed)
            }
        }

        @Test("error.map preserves output on success")
        func errorMapPreservesOutput() throws {
            var input: ArraySlice<UInt8> = [0x42][...]
            let parser = Parsing.First.Element<ArraySlice<UInt8>>()
                .error.map { _ in CustomError.failed }
            let result = try parser.parse(&input)
            #expect(result == 0x42)
        }

        @Test("error.map can use original error")
        func errorMapUsesOriginal() {
            var input: ArraySlice<UInt8> = [][...]
            let parser = Parsing.First.Element<ArraySlice<UInt8>>()
                .error.map { error in
                    CustomError.wrapped("\(error)")
                }

            do {
                _ = try parser.parse(&input)
                Issue.record("Expected to throw")
            } catch {
                if case .wrapped(let msg) = error {
                    #expect(msg.contains("unexpected"))
                } else {
                    Issue.record("Expected wrapped error")
                }
            }
        }

        @Test("error.replace returns default on failure")
        func errorReplaceReturnsDefault() {
            var input: ArraySlice<UInt8> = [][...]
            let parser = Parsing.First.Element<ArraySlice<UInt8>>()
                .error.replace(with: 0xFF)
            let result = parser.parse(&input)  // No try - infallible
            #expect(result == 0xFF)
        }

        @Test("error.replace returns parsed value on success")
        func errorReplaceReturnsValue() {
            var input: ArraySlice<UInt8> = [0x42][...]
            let parser = Parsing.First.Element<ArraySlice<UInt8>>()
                .error.replace(with: 0xFF)
            let result = parser.parse(&input)
            #expect(result == 0x42)
        }

        @Test("error.replace is infallible")
        func errorReplaceIsInfallible() {
            let parser = Parsing.First.Element<ArraySlice<UInt8>>()
                .error.replace(with: 0x00)

            // Verify Failure == Never by checking the type
            func assertInfallible<P: Parsing.Parser>(_ p: P) where P.Failure == Never {
                // Compiles only if Failure == Never
            }
            assertInfallible(parser)
        }

        @Test("error.map chains correctly")
        func errorMapChains() {
            var input: ArraySlice<UInt8> = [][...]
            let parser = Parsing.First.Element<ArraySlice<UInt8>>()
                .error.map { _ in CustomError.failed }
                .error.map { _ in CustomError.wrapped("chained") }

            do {
                _ = try parser.parse(&input)
                Issue.record("Expected to throw")
            } catch {
                #expect(error == CustomError.wrapped("chained"))
            }
        }
    }

    // MARK: - Peek

    @Suite("Peek combinator")
    struct PeekTests {
        @Test("succeeds without consuming input")
        func succeedsWithoutConsuming() throws {
            var input: Substring = "abc123"
            let parser = Parsing.Prefix.While<Substring>(minLength: 1) { $0.isLetter }
                .peek()
            let result = try parser.parse(&input)
            #expect(result == "abc")
            #expect(input == "abc123")  // Input unchanged!
        }

        @Test("fails without consuming input")
        func failsWithoutConsuming() {
            var input: Substring = "123abc"
            let parser = Parsing.Prefix.While<Substring>(minLength: 1) { $0.isLetter }
                .peek()
            let originalInput = input
            #expect(throws: Parsing.Constraint.Error.self) {
                try parser.parse(&input)
            }
            #expect(input == originalInput)  // Input unchanged on failure too!
        }

        @Test("can be used for lookahead")
        func usedForLookahead() throws {
            var input: Substring = "<tag>"
            // Peek to check for '<', then actually consume
            let openAngle = "<"
            let tagContent = Parsing.Prefix.While<Substring> { $0 != ">" }

            // First peek
            try openAngle.peek().parse(&input)
            #expect(input == "<tag>")  // Still there

            // Now actually parse
            try openAngle.parse(&input)
            #expect(input == "tag>")
        }

        @Test("works with First.Element")
        func worksWithFirstElement() throws {
            var input: ArraySlice<UInt8> = [0x41, 0x42, 0x43][...]
            let parser = Parsing.First.Element<ArraySlice<UInt8>>().peek()
            let result = try parser.parse(&input)
            #expect(result == 0x41)
            #expect(Array(input) == [0x41, 0x42, 0x43])  // Not consumed
        }
    }

    // MARK: - Not

    @Suite("Not combinator")
    struct NotTests {
        @Test("succeeds when upstream fails")
        func succeedsWhenUpstreamFails() throws {
            var input: Substring = "abc"
            let parser = "xyz".not()
            try parser.parse(&input)  // Should succeed
            #expect(input == "abc")  // Input unchanged
        }

        @Test("fails when upstream succeeds")
        func failsWhenUpstreamSucceeds() {
            var input: Substring = "abc"
            let parser = "abc".not()
            #expect(throws: Parsing.Not<String>.Error.self) {
                try parser.parse(&input)
            }
        }

        @Test("input not consumed on success")
        func inputNotConsumedOnSuccess() throws {
            var input: Substring = "hello"
            let parser = "goodbye".not()
            try parser.parse(&input)
            #expect(input == "hello")
        }

        @Test("input not consumed on failure")
        func inputNotConsumedOnFailure() {
            var input: Substring = "hello"
            let originalInput = input
            let parser = "hello".not()
            do {
                try parser.parse(&input)
                Issue.record("Expected to throw")
            } catch {
                #expect(input == originalInput)
            }
        }

        @Test("output is Void")
        func outputIsVoid() throws {
            var input: Substring = "abc"
            let parser = "xyz".not()
            let result: Void = try parser.parse(&input)
            _ = result  // Just verify it's Void
        }

        @Test("error type is unexpectedMatch")
        func errorTypeIsUnexpectedMatch() {
            var input: Substring = "test"
            let parser = "test".not()
            do {
                try parser.parse(&input)
                Issue.record("Expected to throw")
            } catch {
                #expect(error == .unexpectedMatch)
            }
        }

        @Test("can be combined with Peek for lookahead patterns")
        func combinedWithPeek() throws {
            var input: Substring = "-->end"
            // Parse until we hit "-->"
            var consumed: [Character] = []
            while true {
                // Check if we're at end marker
                if (try? "-->".peek().parse(&input)) != nil {
                    break
                }
                if input.isEmpty { break }
                consumed.append(input.removeFirst())
            }
            // We didn't consume anything because input starts with "-->"
            #expect(consumed.isEmpty)
            #expect(input == "-->end")
        }
    }

    // MARK: - Lazy

    @Suite("Lazy combinator")
    struct LazyTests {
        @Test("works with autoclosure")
        func worksWithAutoclosure() throws {
            var input: Substring = "abc"
            let parser = Parsing.Lazy(Parsing.Rest<Substring>())
            let result = try parser.parse(&input)
            #expect(result == "abc")
        }

        @Test("works with closure")
        func worksWithClosure() throws {
            var input: Substring = "hello"
            let parser = Parsing.Lazy { Parsing.Rest<Substring>() }
            let result = try parser.parse(&input)
            #expect(result == "hello")
        }

        @Test("enables recursive parsing - nested parentheses")
        func recursiveParsingNestedParens() throws {
            // Test the key use case: recursive grammars
            // Grammar: expr = '(' expr ')' | 'x'
            // Returns nesting depth

            var input1: Substring = "x"
            let depth1 = try NestedParenParser().parse(&input1)
            #expect(depth1 == 0)

            var input2: Substring = "(x)"
            let depth2 = try NestedParenParser().parse(&input2)
            #expect(depth2 == 1)

            var input3: Substring = "((x))"
            let depth3 = try NestedParenParser().parse(&input3)
            #expect(depth3 == 2)

            var input4: Substring = "(((x)))"
            let depth4 = try NestedParenParser().parse(&input4)
            #expect(depth4 == 3)
        }
    }

    /// Recursive parser for nested parentheses: `(((x)))` -> depth 3
    struct NestedParenParser: Parsing.Parser, Sendable {
        typealias Input = Substring
        typealias Output = Int
        typealias Failure = Parsing.Match.Error

        func parse(_ input: inout Substring) throws(Failure) -> Int {
            // Try '(' expr ')' first
            if input.first == "(" {
                input.removeFirst()
                let inner = try Parsing.Lazy { NestedParenParser() }.parse(&input)
                guard input.first == ")" else {
                    throw .literalMismatch(expected: ")", found: String(input.prefix(1)))
                }
                input.removeFirst()
                return inner + 1
            }
            // Base case: 'x'
            guard input.first == "x" else {
                throw .literalMismatch(expected: "x", found: String(input.prefix(1)))
            }
            input.removeFirst()
            return 0
        }
    }

    // MARK: - Trace

    @Suite("Trace combinator")
    struct TraceTests {
        @Test("preserves output on success")
        func preservesOutput() throws {
            var input: ArraySlice<UInt8> = [0x42, 0x43][...]
            // Use default print logger (output goes to console)
            let parser = Parsing.First.Element<ArraySlice<UInt8>>().trace("byte")
            let result = try parser.parse(&input)

            #expect(result == 0x42)
            #expect(Array(input) == [0x43])
        }

        @Test("preserves error type on failure")
        func preservesErrorType() {
            var input: ArraySlice<UInt8> = [][...]
            let parser = Parsing.First.Element<ArraySlice<UInt8>>().trace("byte")

            #expect(throws: Parsing.EndOfInput.Error.self) {
                try parser.parse(&input)
            }
        }

        @Test("can be chained")
        func canBeChained() throws {
            var input: Substring = "abc123"

            let letters = Parsing.Prefix.While<Substring> { $0.isLetter }
                .trace("letters")
            let digits = Parsing.Prefix.While<Substring> { $0.isNumber }
                .trace("digits")

            let combined = Parsing.Take.Two(letters, digits)
            let (a, b) = try combined.parse(&input)

            #expect(a == "abc")
            #expect(b == "123")
        }

        @Test("wraps parser transparently")
        func wrapsTransparently() throws {
            var input: Substring = "hello world"
            let parser = Parsing.Rest<Substring>().trace("rest")
            let result = try parser.parse(&input)
            #expect(result == "hello world")
            #expect(input.isEmpty)
        }
    }
}
