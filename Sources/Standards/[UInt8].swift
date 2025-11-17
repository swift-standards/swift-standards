//
//  File.swift
//  swift-standards
//
//  Created by Coen ten Thije Boonkkamp on 17/11/2025.
//

extension [UInt8] {
    /// Creates an array from a Base64 encoded string
    /// - Parameter base64Encoded: Base64 encoded string
    /// - Returns: Decoded bytes, or nil if invalid Base64
    public init?(base64Encoded string: String) {
        let bytes = Array(string.utf8)
        guard !bytes.isEmpty else {
            self = []
            return
        }

        let decodeTable = Self.base64DecodeTable
        var result = [UInt8]()
        result.reserveCapacity((bytes.count * 3) / 4)

        var index = 0
        while index < bytes.count {
            // Skip whitespace
            while index < bytes.count && bytes[index].isBase64Whitespace {
                index += 1
            }
            if index >= bytes.count { break }

            guard index + 3 < bytes.count else { return nil }

            let c1 = decodeTable[Int(bytes[index])]
            let c2 = decodeTable[Int(bytes[index + 1])]
            let c3 = bytes[index + 2] == UInt8.base64PaddingCharacter ? 255 : decodeTable[Int(bytes[index + 2])]
            let c4 = bytes[index + 3] == UInt8.base64PaddingCharacter ? 255 : decodeTable[Int(bytes[index + 3])]

            guard c1 != 255 && c2 != 255 else { return nil }

            let b1 = (c1 << 2) | (c2 >> 4)
            result.append(b1)

            if c3 != 255 {
                let b2 = ((c2 & 0x0F) << 4) | (c3 >> 2)
                result.append(b2)

                if c4 != 255 {
                    let b3 = ((c3 & 0x03) << 6) | c4
                    result.append(b3)
                }
            }

            index += 4
        }

        self = result
    }
}

extension [UInt8] {
    /// Byte order for multi-byte integer serialization
    public enum Endianness {
        case little
        case big
    }
}

extension [UInt8] {
    /// Creates a byte array from an Int
    /// - Parameters:
    ///   - value: The integer value to convert
    ///   - endianness: Byte order for the output bytes (defaults to little-endian)
    public init(_ value: Int, endianness: Endianness = .little) {
        let converted: Int
        switch endianness {
        case .little:
            converted = value.littleEndian
        case .big:
            converted = value.bigEndian
        }
        self = Swift.withUnsafeBytes(of: converted) { Array($0) }
    }

    /// Creates a byte array from an Int8
    /// - Parameters:
    ///   - value: The integer value to convert
    ///   - endianness: Byte order (ignored for single-byte integers)
    public init(_ value: Int8, endianness: Endianness = .little) {
        self = Swift.withUnsafeBytes(of: value) { Array($0) }
    }

    /// Creates a byte array from an Int16
    /// - Parameters:
    ///   - value: The integer value to convert
    ///   - endianness: Byte order for the output bytes (defaults to little-endian)
    public init(_ value: Int16, endianness: Endianness = .little) {
        let converted: Int16
        switch endianness {
        case .little:
            converted = value.littleEndian
        case .big:
            converted = value.bigEndian
        }
        self = Swift.withUnsafeBytes(of: converted) { Array($0) }
    }

    /// Creates a byte array from an Int32
    /// - Parameters:
    ///   - value: The integer value to convert
    ///   - endianness: Byte order for the output bytes (defaults to little-endian)
    public init(_ value: Int32, endianness: Endianness = .little) {
        let converted: Int32
        switch endianness {
        case .little:
            converted = value.littleEndian
        case .big:
            converted = value.bigEndian
        }
        self = Swift.withUnsafeBytes(of: converted) { Array($0) }
    }

    /// Creates a byte array from an Int64
    /// - Parameters:
    ///   - value: The integer value to convert
    ///   - endianness: Byte order for the output bytes (defaults to little-endian)
    public init(_ value: Int64, endianness: Endianness = .little) {
        let converted: Int64
        switch endianness {
        case .little:
            converted = value.littleEndian
        case .big:
            converted = value.bigEndian
        }
        self = Swift.withUnsafeBytes(of: converted) { Array($0) }
    }

    /// Creates a byte array from a UInt
    /// - Parameters:
    ///   - value: The integer value to convert
    ///   - endianness: Byte order for the output bytes (defaults to little-endian)
    public init(_ value: UInt, endianness: Endianness = .little) {
        let converted: UInt
        switch endianness {
        case .little:
            converted = value.littleEndian
        case .big:
            converted = value.bigEndian
        }
        self = Swift.withUnsafeBytes(of: converted) { Array($0) }
    }

    /// Creates a byte array from a UInt16
    /// - Parameters:
    ///   - value: The integer value to convert
    ///   - endianness: Byte order for the output bytes (defaults to little-endian)
    public init(_ value: UInt16, endianness: Endianness = .little) {
        let converted: UInt16
        switch endianness {
        case .little:
            converted = value.littleEndian
        case .big:
            converted = value.bigEndian
        }
        self = Swift.withUnsafeBytes(of: converted) { Array($0) }
    }

    /// Creates a byte array from a UInt32
    /// - Parameters:
    ///   - value: The integer value to convert
    ///   - endianness: Byte order for the output bytes (defaults to little-endian)
    public init(_ value: UInt32, endianness: Endianness = .little) {
        let converted: UInt32
        switch endianness {
        case .little:
            converted = value.littleEndian
        case .big:
            converted = value.bigEndian
        }
        self = Swift.withUnsafeBytes(of: converted) { Array($0) }
    }

    /// Creates a byte array from a UInt64
    /// - Parameters:
    ///   - value: The integer value to convert
    ///   - endianness: Byte order for the output bytes (defaults to little-endian)
    public init(_ value: UInt64, endianness: Endianness = .little) {
        let converted: UInt64
        switch endianness {
        case .little:
            converted = value.littleEndian
        case .big:
            converted = value.bigEndian
        }
        self = Swift.withUnsafeBytes(of: converted) { Array($0) }
    }
}

extension [UInt8] {
    /// Creates a byte array from a collection of Int values
    /// - Parameters:
    ///   - values: Collection of integers to convert
    ///   - endianness: Byte order for the output bytes
    public init<C: Collection>(serializing values: C, endianness: Endianness = .little) where C.Element == Int {
        var result: [UInt8] = []
        result.reserveCapacity(values.count * MemoryLayout<Int>.size)
        for value in values {
            result.append(contentsOf: [UInt8](value, endianness: endianness))
        }
        self = result
    }

    /// Creates a byte array from a collection of Int8 values
    /// - Parameters:
    ///   - values: Collection of integers to convert
    ///   - endianness: Byte order (ignored for single-byte integers)
    public init<C: Collection>(serializing values: C, endianness: Endianness = .little) where C.Element == Int8 {
        var result: [UInt8] = []
        result.reserveCapacity(values.count * MemoryLayout<Int8>.size)
        for value in values {
            result.append(contentsOf: [UInt8](value, endianness: endianness))
        }
        self = result
    }

    /// Creates a byte array from a collection of Int16 values
    /// - Parameters:
    ///   - values: Collection of integers to convert
    ///   - endianness: Byte order for the output bytes (defaults to little-endian)
    public init<C: Collection>(serializing values: C, endianness: Endianness = .little) where C.Element == Int16 {
        var result: [UInt8] = []
        result.reserveCapacity(values.count * MemoryLayout<Int16>.size)
        for value in values {
            result.append(contentsOf: [UInt8](value, endianness: endianness))
        }
        self = result
    }

    /// Creates a byte array from a collection of Int32 values
    /// - Parameters:
    ///   - values: Collection of integers to convert
    ///   - endianness: Byte order for the output bytes (defaults to little-endian)
    public init<C: Collection>(serializing values: C, endianness: Endianness = .little) where C.Element == Int32 {
        var result: [UInt8] = []
        result.reserveCapacity(values.count * MemoryLayout<Int32>.size)
        for value in values {
            result.append(contentsOf: [UInt8](value, endianness: endianness))
        }
        self = result
    }

    /// Creates a byte array from a collection of Int64 values
    /// - Parameters:
    ///   - values: Collection of integers to convert
    ///   - endianness: Byte order for the output bytes (defaults to little-endian)
    public init<C: Collection>(serializing values: C, endianness: Endianness = .little) where C.Element == Int64 {
        var result: [UInt8] = []
        result.reserveCapacity(values.count * MemoryLayout<Int64>.size)
        for value in values {
            result.append(contentsOf: [UInt8](value, endianness: endianness))
        }
        self = result
    }

    /// Creates a byte array from a collection of UInt values
    /// - Parameters:
    ///   - values: Collection of integers to convert
    ///   - endianness: Byte order for the output bytes (defaults to little-endian)
    public init<C: Collection>(serializing values: C, endianness: Endianness = .little) where C.Element == UInt {
        var result: [UInt8] = []
        result.reserveCapacity(values.count * MemoryLayout<UInt>.size)
        for value in values {
            result.append(contentsOf: [UInt8](value, endianness: endianness))
        }
        self = result
    }

    /// Creates a byte array from a collection of UInt16 values
    /// - Parameters:
    ///   - values: Collection of integers to convert
    ///   - endianness: Byte order for the output bytes (defaults to little-endian)
    public init<C: Collection>(serializing values: C, endianness: Endianness = .little) where C.Element == UInt16 {
        var result: [UInt8] = []
        result.reserveCapacity(values.count * MemoryLayout<UInt16>.size)
        for value in values {
            result.append(contentsOf: [UInt8](value, endianness: endianness))
        }
        self = result
    }

    /// Creates a byte array from a collection of UInt32 values
    /// - Parameters:
    ///   - values: Collection of integers to convert
    ///   - endianness: Byte order for the output bytes (defaults to little-endian)
    public init<C: Collection>(serializing values: C, endianness: Endianness = .little) where C.Element == UInt32 {
        var result: [UInt8] = []
        result.reserveCapacity(values.count * MemoryLayout<UInt32>.size)
        for value in values {
            result.append(contentsOf: [UInt8](value, endianness: endianness))
        }
        self = result
    }

    /// Creates a byte array from a collection of UInt64 values
    /// - Parameters:
    ///   - values: Collection of integers to convert
    ///   - endianness: Byte order for the output bytes (defaults to little-endian)
    public init<C: Collection>(serializing values: C, endianness: Endianness = .little) where C.Element == UInt64 {
        var result: [UInt8] = []
        result.reserveCapacity(values.count * MemoryLayout<UInt64>.size)
        for value in values {
            result.append(contentsOf: [UInt8](value, endianness: endianness))
        }
        self = result
    }
}

extension [UInt8] {
    /// Creates an array from a hexadecimal encoded string
    /// - Parameter hexEncoded: Hexadecimal encoded string
    /// - Returns: Decoded bytes, or nil if invalid hex
    public init?(hexEncoded string: String) {
        let bytes = Array(string.utf8)
        guard !bytes.isEmpty else {
            self = []
            return
        }

        // Skip optional "0x" prefix
        var startIndex = 0
        if bytes.count >= 2 && bytes[0] == 0x30 && (bytes[1] == 0x78 || bytes[1] == 0x58) {
            startIndex = 2
        }

        // Filter out whitespace
        let hexBytes = bytes[startIndex...].filter { !$0.isHexWhitespace }

        // Hex encoding must have even number of characters
        guard hexBytes.count % 2 == 0 else { return nil }

        let decodeTable = Self.hexDecodeTable
        var result = [UInt8]()
        result.reserveCapacity(hexBytes.count / 2)

        var index = hexBytes.startIndex
        while index < hexBytes.endIndex {
            let highIdx = hexBytes.index(after: index)
            guard highIdx < hexBytes.endIndex else { return nil }

            let high = decodeTable[Int(hexBytes[index])]
            let low = decodeTable[Int(hexBytes[highIdx])]

            guard high != 255 && low != 255 else { return nil }

            result.append((high << 4) | low)
            index = hexBytes.index(after: highIdx)
        }

        self = result
    }
}

extension [UInt8] {
    package static let base64EncodeTable: [UInt8] = Array(
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".utf8
    )

    /// Pre-computed decode table for Base64 decoding (255 = invalid)
    package static let base64DecodeTable: [UInt8] = {
        var table = [UInt8](repeating: 255, count: 256)
        for (index, char) in base64EncodeTable.enumerated() {
            table[Int(char)] = UInt8(index)
        }
        return table
    }()
}

extension [UInt8] {
    /// Hexadecimal encode table (lowercase)
    package static let hexEncodeTable: [UInt8] = Array(
        "0123456789abcdef".utf8
    )

    /// Hexadecimal encode table (uppercase)
    package static let hexEncodeTableUppercase: [UInt8] = Array(
        "0123456789ABCDEF".utf8
    )

    /// Pre-computed decode table for hexadecimal decoding (255 = invalid)
    package static let hexDecodeTable: [UInt8] = {
        var table = [UInt8](repeating: 255, count: 256)

        // 0-9
        for char in UInt8(ascii: "0")...UInt8(ascii: "9") {
            table[Int(char)] = char - UInt8(ascii: "0")
        }

        // a-f
        for char in UInt8(ascii: "a")...UInt8(ascii: "f") {
            table[Int(char)] = 10 + (char - UInt8(ascii: "a"))
        }

        // A-F
        for char in UInt8(ascii: "A")...UInt8(ascii: "F") {
            table[Int(char)] = 10 + (char - UInt8(ascii: "A"))
        }

        return table
    }()
}
