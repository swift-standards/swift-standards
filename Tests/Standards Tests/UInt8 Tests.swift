import Testing
@testable import Standards

// Tests for Base64 and Hex functionality (non-ASCII standards functionality)

@Suite
struct `UInt8 - isHexWhitespace` {

    @Test(arguments: [0x20, 0x09, 0x0A, 0x0D])
    func `Hex whitespace bytes are recognized`(byte: UInt8) {
        #expect(byte.isHexWhitespace)
    }
}

@Suite
struct `UInt8 - isBase64Whitespace` {

    @Test(arguments: [0x20, 0x09, 0x0A, 0x0D])
    func `Base64 whitespace bytes are recognized`(byte: UInt8) {
        #expect(byte.isBase64Whitespace)
    }
}

@Suite
struct `UInt8 - base64PaddingCharacter` {

    @Test
    func `Base64 padding character is equals sign`() {
        #expect(UInt8.base64PaddingCharacter == UInt8(ascii: "="))
    }

    @Test
    func `Base64 padding character is 0x3D`() {
        #expect(UInt8.base64PaddingCharacter == 0x3D)
    }
}
