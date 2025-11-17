// UInt8.swift
// swift-standards
//
// Pure Swift UInt8 utilities

// ASCII-specific functionality has been moved to swift-incits-4-1986

extension UInt8 {
    @inlinable
    package static var base64PaddingCharacter: UInt8 { UInt8(ascii: "=") }

    @usableFromInline
    package var isBase64Whitespace: Bool {
        self == 0x20 || self == 0x09 || self == 0x0A || self == 0x0D
    }

    @inlinable
    package var isHexWhitespace: Bool {
        self == 0x20 || self == 0x09 || self == 0x0A || self == 0x0D
    }
}
