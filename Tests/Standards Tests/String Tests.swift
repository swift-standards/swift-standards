import Testing
@testable import Standards

// Tests for non-ASCII string functionality that remains in swift-standards
// (Percent encoding, CaseInsensitive, LineEnding, Base64, Hex encoding)

// MARK: - String.CaseInsensitive

@Suite
struct `String.CaseInsensitive - Equality` {

    @Test
    func `Same strings are equal`() {
        let a = "hello".caseInsensitive
        let b = "hello".caseInsensitive
        #expect(a == b)
    }

    @Test
    func `Different case strings are equal`() {
        let a = "hello".caseInsensitive
        let b = "HELLO".caseInsensitive
        #expect(a == b)
    }

    @Test
    func `Mixed case strings are equal`() {
        let a = "HeLLo".caseInsensitive
        let b = "hEllO".caseInsensitive
        #expect(a == b)
    }
}

@Suite
struct `String.CaseInsensitive - Hashing` {

    @Test
    func `Same case strings have same hash`() {
        let a = "hello".caseInsensitive
        let b = "hello".caseInsensitive
        #expect(a.hashValue == b.hashValue)
    }

    @Test
    func `Different case strings have same hash`() {
        let a = "hello".caseInsensitive
        let b = "HELLO".caseInsensitive
        #expect(a.hashValue == b.hashValue)
    }
}

// MARK: - String.LineEnding

@Suite
struct `String - LineEnding enum` {

    @Test
    func `LF string value`() {
        #expect(String.LineEnding.lf.rawValue == "\n")
    }

    @Test
    func `CR string value`() {
        #expect(String.LineEnding.cr.rawValue == "\r")
    }

    @Test
    func `CRLF string value`() {
        #expect(String.LineEnding.crlf.rawValue == "\r\n")
    }
}

@Suite
struct `String - normalized(to:) with LF` {

    @Test
    func `CRLF to LF`() {
        let input = "line1\r\nline2\r\nline3"
        let result = input.normalized(to: .lf)
        #expect(result == "line1\nline2\nline3")
    }

    @Test
    func `CR to LF`() {
        let input = "line1\rline2\rline3"
        let result = input.normalized(to: .lf)
        #expect(result == "line1\nline2\nline3")
    }
}

// MARK: - Percent Encoding

@Suite
struct `String - percentEncoded` {

    @Test
    func `Encode known characters produces expected output`() {
        let input = "hello world"
        let allowed: Set<Character> = ["h", "e", "l", "o"]
        let result = input.percentEncoded(allowing: allowed)
        #expect(result.contains("%"))
    }

    @Test
    func `Encode empty string`() {
        let result = "".percentEncoded(allowing: [])
        #expect(result == "")
    }
}

@Suite
struct `String - percentDecoded` {

    @Test
    func `Decode known percent-encoded strings`() {
        let input = "hello%20world"
        let result = input.percentDecoded()
        #expect(result == "hello world")
    }

    @Test
    func `Decode empty string`() {
        let result = "".percentDecoded()
        #expect(result == "")
    }
}

// MARK: - Hex Encoding

@Suite
struct `String - init(hexEncoding:)` {

    @Test
    func `Encode known bytes produces expected output`() {
        let bytes: [UInt8] = [0x48, 0x65, 0x6C, 0x6C, 0x6F]
        let result = String(hexEncoding: bytes)
        #expect(result == "48656c6c6f")
    }

    @Test
    func `Encode empty bytes`() {
        let result = String(hexEncoding: [])
        #expect(result == "")
    }
}

// MARK: - Base64 Encoding

@Suite
struct `String - init(base64Encoding:)` {

    @Test
    func `Encode produces expected Base64 output`() {
        let bytes: [UInt8] = [0x48, 0x65, 0x6C, 0x6C, 0x6F]
        let result = String(base64Encoding: bytes)
        #expect(result == "SGVsbG8=")
    }

    @Test
    func `Encode empty bytes`() {
        let result = String(base64Encoding: [])
        #expect(result == "")
    }
}
