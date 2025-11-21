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

// String.ASCII.LineEnding tests have been moved to swift-incits-4-1986
// Percent encoding tests have been moved to swift-rfc-3986
// Hex encoding tests have been moved to swift-rfc-4648
// Base64 encoding tests have been moved to swift-rfc-4648
