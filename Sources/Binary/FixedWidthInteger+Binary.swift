// FixedWidthInteger+Binary.swift
// Bit and byte operations for fixed-width integers.

// MARK: - Bit Rotation

extension FixedWidthInteger {
    /// Rotates bits left by the specified count.
    ///
    /// Performs a circular left shift, preserving all bits. Unlike a standard left shift
    /// which fills vacated positions with zeros, rotation wraps bits from the left end
    /// to the right end.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let x: UInt8 = 0b11010011  // Binary: 11010011
    /// let rotated = UInt8.rotateLeft(x, by: 2)
    /// // 0b01001111  // Binary: 01001111
    /// ```
    ///
    /// - Parameters:
    ///   - value: The value to rotate
    ///   - count: Number of positions to rotate left
    /// - Returns: The value with bits rotated left
    @inlinable
    public static func rotateLeft(_ value: Self, by count: Int) -> Self {
        let shift = count % Self.bitWidth
        guard shift != 0 else { return value }

        return (value << shift) | (value >> (Self.bitWidth - shift))
    }

    /// Rotates bits left by the specified count.
    ///
    /// Performs a circular left shift, preserving all bits. Unlike a standard left shift
    /// which fills vacated positions with zeros, rotation wraps bits from the left end
    /// to the right end.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let x: UInt8 = 0b11010011  // Binary: 11010011
    /// let rotated = x.rotateLeft(by: 2)
    /// // 0b01001111  // Binary: 01001111
    /// ```
    ///
    /// - Parameter count: Number of positions to rotate left
    /// - Returns: The value with bits rotated left
    @inlinable
    public func rotateLeft(by count: Int) -> Self {
        Self.rotateLeft(self, by: count)
    }

    /// Rotates bits right by the specified count.
    ///
    /// Performs a circular right shift, preserving all bits. Unlike a standard right shift
    /// which fills vacated positions with zeros or sign bits, rotation wraps bits from
    /// the right end to the left end.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let x: UInt8 = 0b11010011  // Binary: 11010011
    /// let rotated = UInt8.rotateRight(x, by: 2)
    /// // 0b11110100  // Binary: 11110100
    /// ```
    ///
    /// - Parameters:
    ///   - value: The value to rotate
    ///   - count: Number of positions to rotate right
    /// - Returns: The value with bits rotated right
    @inlinable
    public static func rotateRight(_ value: Self, by count: Int) -> Self {
        let shift = count % Self.bitWidth
        guard shift != 0 else { return value }

        return (value >> shift) | (value << (Self.bitWidth - shift))
    }

    /// Rotates bits right by the specified count.
    ///
    /// Performs a circular right shift, preserving all bits. Unlike a standard right shift
    /// which fills vacated positions with zeros or sign bits, rotation wraps bits from
    /// the right end to the left end.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let x: UInt8 = 0b11010011  // Binary: 11010011
    /// let rotated = x.rotateRight(by: 2)
    /// // 0b11110100  // Binary: 11110100
    /// ```
    ///
    /// - Parameter count: Number of positions to rotate right
    /// - Returns: The value with bits rotated right
    @inlinable
    public func rotateRight(by count: Int) -> Self {
        Self.rotateRight(self, by: count)
    }

    /// Reverses the order of all bits.
    ///
    /// Reflects the bit pattern, swapping bit positions from ends to middle.
    /// Useful in FFT algorithms, cryptography, and binary protocol implementations.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let x: UInt8 = 0b11010011  // Binary: 11010011
    /// let reversed = UInt8.reverseBits(x)
    /// // 0b11001011  // Binary: 11001011
    /// ```
    ///
    /// - Parameter value: The value to reverse
    /// - Returns: The value with all bits in reversed order
    @inlinable
    public static func reverseBits(_ value: Self) -> Self {
        var result: Self = 0
        var workingValue = value

        for _ in 0..<Self.bitWidth {
            result <<= 1
            result |= workingValue & 1
            workingValue >>= 1
        }

        return result
    }

    /// Reverses the order of all bits.
    ///
    /// Reflects the bit pattern, swapping bit positions from ends to middle.
    /// Useful in FFT algorithms, cryptography, and binary protocol implementations.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let x: UInt8 = 0b11010011  // Binary: 11010011
    /// let reversed = x.reverseBits()
    /// // 0b11001011  // Binary: 11001011
    /// ```
    ///
    /// - Returns: The value with all bits in reversed order
    @inlinable
    public func reverseBits() -> Self {
        Self.reverseBits(self)
    }
}

// MARK: - Byte Serialization

extension FixedWidthInteger {
    /// Converts the integer to a byte array.
    ///
    /// Serializes the integer to bytes using the specified byte order.
    /// Use this for portable binary representation across different platforms.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let x: UInt16 = 0x1234
    ///
    /// let bigEndian = UInt16.bytes(x, endianness: .big)
    /// // [0x12, 0x34]
    ///
    /// let littleEndian = UInt16.bytes(x, endianness: .little)
    /// // [0x34, 0x12]
    /// ```
    ///
    /// - Parameters:
    ///   - value: The integer value to serialize
    ///   - endianness: Byte order for the output (defaults to little-endian)
    /// - Returns: Array of bytes representing the integer
    @inlinable
    public static func bytes(_ value: Self, endianness: Binary.Endianness = .little) -> [UInt8] {
        let converted: Self
        switch endianness {
        case .little:
            converted = value.littleEndian
        case .big:
            converted = value.bigEndian
        }

        return Swift.withUnsafeBytes(of: converted) { Array($0) }
    }

    /// Converts the integer to a byte array.
    ///
    /// Serializes the integer to bytes using the specified byte order.
    /// Use this for portable binary representation across different platforms.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let x: UInt16 = 0x1234
    ///
    /// let bigEndian = x.bytes(endianness: .big)
    /// // [0x12, 0x34]
    ///
    /// let littleEndian = x.bytes(endianness: .little)
    /// // [0x34, 0x12]
    /// ```
    ///
    /// - Parameter endianness: Byte order for the output (defaults to little-endian)
    /// - Returns: Array of bytes representing the integer
    @inlinable
    public func bytes(endianness: Binary.Endianness = .little) -> [UInt8] {
        Self.bytes(self, endianness: endianness)
    }

    /// Creates an integer from a byte array.
    ///
    /// Deserializes bytes to an integer using the specified byte order.
    /// Returns `nil` if the byte count doesn't match the integer's size.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let bytes: [UInt8] = [0x12, 0x34, 0x56, 0x78]
    /// let value = UInt32(bytes: bytes, endianness: .big)
    /// // 0x12345678
    ///
    /// let tooFewBytes: [UInt8] = [0x12, 0x34]
    /// let invalid = UInt32(bytes: tooFewBytes, endianness: .big)
    /// // nil
    /// ```
    ///
    /// - Parameters:
    ///   - bytes: Byte array to deserialize (must be exactly the size of the integer type)
    ///   - endianness: Byte order of the input (defaults to little-endian)
    @inlinable
    public init?(bytes: [UInt8], endianness: Binary.Endianness = .little) {
        guard bytes.count == MemoryLayout<Self>.size else { return nil }

        let value = bytes.withUnsafeBytes { $0.load(as: Self.self) }

        switch endianness {
        case .little:
            self = Self(littleEndian: value)
        case .big:
            self = Self(bigEndian: value)
        }
    }
}

// MARK: - Array Deserialization

extension Array where Element: FixedWidthInteger {
    /// Creates an array of integers from a flat byte collection.
    ///
    /// Deserializes a sequence of bytes into an array of integers. The byte count
    /// must be a multiple of the integer size. Returns `nil` if the byte count
    /// is not evenly divisible.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let bytes: [UInt8] = [0x01, 0x00, 0x02, 0x00]
    /// let values = [UInt16](bytes: bytes, endianness: .little)
    /// // [1, 2]
    ///
    /// let oddBytes: [UInt8] = [0x01, 0x00, 0x02]
    /// let invalid = [UInt16](bytes: oddBytes)
    /// // nil (3 bytes is not a multiple of 2)
    /// ```
    ///
    /// - Parameters:
    ///   - bytes: Collection of bytes representing multiple integers
    ///   - endianness: Byte order of the input (defaults to little-endian)
    @inlinable
    public init?<C: Collection>(bytes: C, endianness: Binary.Endianness = .little)
    where C.Element == UInt8 {
        let elementSize = MemoryLayout<Element>.size
        guard bytes.count % elementSize == 0 else { return nil }

        var result: [Element] = []
        result.reserveCapacity(bytes.count / elementSize)

        let byteArray: [UInt8] = .init(bytes)
        for i in stride(from: 0, to: byteArray.count, by: elementSize) {
            let chunk: [UInt8] = .init(byteArray[i..<i + elementSize])
            guard let element = Element(bytes: chunk, endianness: endianness) else {
                return nil
            }
            result.append(element)
        }

        self = result
    }
}
