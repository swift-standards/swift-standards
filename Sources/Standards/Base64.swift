// Base64.swift
// swift-standards
//
// Pure Swift Base64 encoding/decoding
// Implements RFC 4648 Base64 encoding

extension String {
    /// Creates a Base64 encoded string from bytes
    /// - Parameter base64Encoding: The bytes to encode
    public init(base64Encoding bytes: [UInt8]) {
        guard !bytes.isEmpty else {
            self = ""
            return
        }

        var result = [UInt8]()
        result.reserveCapacity(((bytes.count + 2) / 3) * 4)

        var index = 0
        while index < bytes.count {
            let b1 = bytes[index]
            let b2 = index + 1 < bytes.count ? bytes[index + 1] : 0
            let b3 = index + 2 < bytes.count ? bytes[index + 2] : 0

            let c1 = (b1 >> 2) & 0x3F
            let c2 = ((b1 << 4) | (b2 >> 4)) & 0x3F
            let c3 = ((b2 << 2) | (b3 >> 6)) & 0x3F
            let c4 = b3 & 0x3F

            result.append([UInt8].base64EncodeTable[Int(c1)])
            result.append([UInt8].base64EncodeTable[Int(c2)])

            if index + 1 < bytes.count {
                result.append([UInt8].base64EncodeTable[Int(c3)])
            } else {
                result.append(UInt8.base64PaddingCharacter)
            }

            if index + 2 < bytes.count {
                result.append([UInt8].base64EncodeTable[Int(c4)])
            } else {
                result.append(UInt8.base64PaddingCharacter)
            }

            index += 3
        }

        self = String(decoding: result, as: UTF8.self)
    }
}

