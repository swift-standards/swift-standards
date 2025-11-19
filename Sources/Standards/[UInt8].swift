// [UInt8].swift
// swift-standards
//
// Pure Swift byte array utilities

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
    public init<C: Collection>(serializing values: C, endianness: Endianness = .little)
    where C.Element == Int {
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
    public init<C: Collection>(serializing values: C, endianness: Endianness = .little)
    where C.Element == Int8 {
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
    public init<C: Collection>(serializing values: C, endianness: Endianness = .little)
    where C.Element == Int16 {
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
    public init<C: Collection>(serializing values: C, endianness: Endianness = .little)
    where C.Element == Int32 {
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
    public init<C: Collection>(serializing values: C, endianness: Endianness = .little)
    where C.Element == Int64 {
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
    public init<C: Collection>(serializing values: C, endianness: Endianness = .little)
    where C.Element == UInt {
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
    public init<C: Collection>(serializing values: C, endianness: Endianness = .little)
    where C.Element == UInt16 {
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
    public init<C: Collection>(serializing values: C, endianness: Endianness = .little)
    where C.Element == UInt32 {
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
    public init<C: Collection>(serializing values: C, endianness: Endianness = .little)
    where C.Element == UInt64 {
        var result: [UInt8] = []
        result.reserveCapacity(values.count * MemoryLayout<UInt64>.size)
        for value in values {
            result.append(contentsOf: [UInt8](value, endianness: endianness))
        }
        self = result
    }
}

// MARK: - String Conversions
extension [UInt8] {
    /// Creates a byte array from a UTF-8 encoded string
    /// - Parameter string: The string to convert to UTF-8 bytes
    ///
    /// Example:
    /// ```swift
    /// let bytes = [UInt8](utf8: "Hello")  // [72, 101, 108, 108, 111]
    /// ```
    public init(utf8 string: String) {
        self = Array(string.utf8)
    }
}

// MARK: - Subsequence Search and Splitting
extension [UInt8] {
    /// Finds the first occurrence of a byte subsequence
    /// - Parameter needle: The byte sequence to search for
    /// - Returns: Index of the first occurrence, or nil if not found
    public func firstIndex(of needle: [UInt8]) -> Int? {
        guard !needle.isEmpty else { return startIndex }
        guard needle.count <= count else { return nil }

        for i in 0...(count - needle.count) {
            if self[i..<i + needle.count].elementsEqual(needle) {
                return i
            }
        }

        return nil
    }

    /// Finds the last occurrence of a byte subsequence
    /// - Parameter needle: The byte sequence to search for
    /// - Returns: Index of the last occurrence, or nil if not found
    public func lastIndex(of needle: [UInt8]) -> Int? {
        guard !needle.isEmpty else { return endIndex }
        guard needle.count <= count else { return nil }

        for i in stride(from: count - needle.count, through: 0, by: -1) {
            if self[i..<i + needle.count].elementsEqual(needle) {
                return i
            }
        }

        return nil
    }

    /// Checks if the byte array contains a subsequence
    /// - Parameter needle: The byte sequence to search for
    /// - Returns: True if the subsequence is found, false otherwise
    public func contains(_ needle: [UInt8]) -> Bool {
        firstIndex(of: needle) != nil
    }

    /// Splits the byte array at all occurrences of a delimiter sequence
    /// - Parameter separator: The byte sequence to split on
    /// - Returns: Array of byte arrays split at the delimiter
    public func split(separator: [UInt8]) -> [[UInt8]] {
        guard !separator.isEmpty else { return [self] }

        var result: [[UInt8]] = []
        var start = 0

        while start < count {
            // Check if there's enough bytes left for the separator
            guard start + separator.count <= count else {
                result.append(Array(self[start...]))
                break
            }

            // Search for separator starting from current position
            var found = false
            for i in start...(count - separator.count) {
                if self[i..<i + separator.count].elementsEqual(separator) {
                    result.append(Array(self[start..<i]))
                    start = i + separator.count
                    found = true
                    break
                }
            }

            if !found {
                result.append(Array(self[start...]))
                break
            }
        }

        return result
    }
}

// MARK: - Mutation Helpers
extension [UInt8] {
    /// Appends a UTF-8 string as bytes
    /// - Parameter string: The string to append as UTF-8 bytes
    public mutating func append(utf8 string: String) {
        append(contentsOf: string.utf8)
    }

    /// Appends a single byte
    /// - Parameter value: The byte value to append
    ///
    /// This overload exists to avoid ambiguity with the generic FixedWidthInteger method.
    /// For UInt8, we can append directly without endianness conversion.
    public mutating func append(_ value: UInt8) {
        append(contentsOf: CollectionOfOne(value))
    }

    /// Appends an integer as bytes with specified endianness
    /// - Parameters:
    ///   - value: The integer value to append
    ///   - endianness: Byte order for the serialized bytes (defaults to little-endian)
    public mutating func append<T: FixedWidthInteger>(
        _ value: T,
        endianness: Endianness = .little
    ) {
        append(contentsOf: value.bytes(endianness: endianness))
    }
}
