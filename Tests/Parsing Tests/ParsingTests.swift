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
}
