// Array+Bytes.swift
// Byte array utilities.

// MARK: - Single Integer Serialization

extension [UInt8] {
    /// Creates a byte array from a fixed-width integer.
    ///
    /// Serializes the integer to bytes using the specified byte order.
    /// Use this for converting integers to their binary representation.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let littleEndian = [UInt8](Int32(256), endianness: .little)
    /// // [0, 1, 0, 0]
    ///
    /// let bigEndian = [UInt8](Int32(256), endianness: .big)
    /// // [0, 0, 1, 0]
    /// ```
    ///
    /// - Parameters:
    ///   - value: The integer value to serialize
    ///   - endianness: Byte order for the output (defaults to little-endian)
    public init<T: FixedWidthInteger>(_ value: T, endianness: Binary.Endianness = .little) {
        let converted: T
        switch endianness {
        case .little:
            converted = value.littleEndian
        case .big:
            converted = value.bigEndian
        }
        self = Swift.withUnsafeBytes(of: converted) { Array($0) }
    }
}

// MARK: - Collection Serialization

extension [UInt8] {
    /// Creates a byte array by serializing a collection of integers.
    ///
    /// Serializes each integer in sequence using the specified byte order.
    /// The resulting array contains all integers concatenated together.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let bytes = [UInt8](serializing: [Int16(1), Int16(2)], endianness: .little)
    /// // [1, 0, 2, 0] (4 bytes total: 2 bytes per Int16)
    /// ```
    ///
    /// - Parameters:
    ///   - values: Collection of integers to serialize
    ///   - endianness: Byte order for the output (defaults to little-endian)
    public init<C: Collection>(serializing values: C, endianness: Binary.Endianness = .little)
    where C.Element: FixedWidthInteger {
        var result: [UInt8] = []
        result.reserveCapacity(values.count * MemoryLayout<C.Element>.size)
        for value in values {
            result.append(contentsOf: [UInt8](value, endianness: endianness))
        }
        self = result
    }
}

// MARK: - String Conversions

extension [UInt8] {
    /// Creates a byte array from a UTF-8 encoded string.
    ///
    /// Converts the string to UTF-8 and returns the byte representation.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let bytes = [UInt8](utf8: "Hello")
    /// // [72, 101, 108, 108, 111]
    /// ```
    ///
    /// - Parameter string: The string to encode as UTF-8 bytes
    public init(utf8 string: some StringProtocol) {
        self = Array(string.utf8)
    }
}

// MARK: - Splitting

extension [UInt8] {
    /// Splits the byte array at each occurrence of a delimiter sequence.
    ///
    /// Returns an array of subarrays separated by the delimiter.
    /// The delimiter itself is not included in the results.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let data: [UInt8] = [1, 2, 0, 0, 3, 4, 0, 0, 5]
    /// let parts = data.split(separator: [0, 0])
    /// // [[1, 2], [3, 4], [5]]
    /// ```
    ///
    /// - Parameter separator: The byte sequence to split on
    /// - Returns: Array of byte arrays separated by the delimiter
    public func split(separator: [UInt8]) -> [[UInt8]] {
        guard !separator.isEmpty else { return [self] }

        var result: [[UInt8]] = []
        var start = 0

        while start < count {
            guard start + separator.count <= count else {
                result.append(Array(self[start...]))
                break
            }

            var found = false
            for i in start...(count - separator.count)
            where self[i..<i + separator.count].elementsEqual(separator) {
                result.append(Array(self[start..<i]))
                start = i + separator.count
                found = true
                break
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
    /// Appends a 16-bit unsigned integer as bytes.
    ///
    /// - Parameters:
    ///   - value: The value to append
    ///   - endianness: Byte order for serialization (defaults to little-endian)
    public mutating func append(_ value: UInt16, endianness: Binary.Endianness = .little) {
        append(contentsOf: value.bytes(endianness: endianness))
    }

    /// Appends a 32-bit unsigned integer as bytes.
    ///
    /// - Parameters:
    ///   - value: The value to append
    ///   - endianness: Byte order for serialization (defaults to little-endian)
    public mutating func append(_ value: UInt32, endianness: Binary.Endianness = .little) {
        append(contentsOf: value.bytes(endianness: endianness))
    }

    /// Appends a 64-bit unsigned integer as bytes.
    ///
    /// - Parameters:
    ///   - value: The value to append
    ///   - endianness: Byte order for serialization (defaults to little-endian)
    public mutating func append(_ value: UInt64, endianness: Binary.Endianness = .little) {
        append(contentsOf: value.bytes(endianness: endianness))
    }

    /// Appends a 16-bit signed integer as bytes.
    ///
    /// - Parameters:
    ///   - value: The value to append
    ///   - endianness: Byte order for serialization (defaults to little-endian)
    public mutating func append(_ value: Int16, endianness: Binary.Endianness = .little) {
        append(contentsOf: value.bytes(endianness: endianness))
    }

    /// Appends a 32-bit signed integer as bytes.
    ///
    /// - Parameters:
    ///   - value: The value to append
    ///   - endianness: Byte order for serialization (defaults to little-endian)
    public mutating func append(_ value: Int32, endianness: Binary.Endianness = .little) {
        append(contentsOf: value.bytes(endianness: endianness))
    }

    /// Appends a 64-bit signed integer as bytes.
    ///
    /// - Parameters:
    ///   - value: The value to append
    ///   - endianness: Byte order for serialization (defaults to little-endian)
    public mutating func append(_ value: Int64, endianness: Binary.Endianness = .little) {
        append(contentsOf: value.bytes(endianness: endianness))
    }

    /// Appends a platform-sized signed integer as bytes.
    ///
    /// - Parameters:
    ///   - value: The value to append
    ///   - endianness: Byte order for serialization (defaults to little-endian)
    public mutating func append(_ value: Int, endianness: Binary.Endianness = .little) {
        append(contentsOf: value.bytes(endianness: endianness))
    }

    /// Appends a platform-sized unsigned integer as bytes.
    ///
    /// - Parameters:
    ///   - value: The value to append
    ///   - endianness: Byte order for serialization (defaults to little-endian)
    public mutating func append(_ value: UInt, endianness: Binary.Endianness = .little) {
        append(contentsOf: value.bytes(endianness: endianness))
    }
}

// MARK: - Joining Byte Arrays

extension [[UInt8]] {
    /// Joins byte arrays with a separator.
    ///
    /// Efficiently concatenates all byte arrays with the separator inserted between
    /// each element. Pre-allocates exact capacity for optimal performance.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let parts: [[UInt8]] = [[1, 2], [3, 4], [5]]
    /// let joined = parts.joined(separator: [0, 0])
    /// // [1, 2, 0, 0, 3, 4, 0, 0, 5]
    /// ```
    ///
    /// - Parameter separator: The byte sequence to insert between elements
    /// - Returns: A single byte array with all elements joined by the separator
    @inlinable
    public func joined(separator: [UInt8]) -> [UInt8] {
        guard !isEmpty else { return [] }
        guard count > 1 else { return self[0] }

        let totalBytes = reduce(0) { $0 + $1.count }
        let totalSeparators = separator.count * (count - 1)
        let totalCapacity = totalBytes + totalSeparators

        var result: [UInt8] = []
        result.reserveCapacity(totalCapacity)

        var isFirst = true
        for element in self {
            if !isFirst {
                result.append(contentsOf: separator)
            }
            result.append(contentsOf: element)
            isFirst = false
        }

        return result
    }

    /// Joins byte arrays without a separator.
    ///
    /// Efficiently concatenates all byte arrays into a single array.
    /// Pre-allocates exact capacity for optimal performance.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let parts: [[UInt8]] = [[1, 2], [3, 4], [5]]
    /// let joined = parts.joined()
    /// // [1, 2, 3, 4, 5]
    /// ```
    ///
    /// - Returns: A single byte array with all elements concatenated
    @inlinable
    public func joined() -> [UInt8] {
        guard !isEmpty else { return [] }
        guard count > 1 else { return self[0] }

        let totalBytes = reduce(0) { $0 + $1.count }

        var result: [UInt8] = []
        result.reserveCapacity(totalBytes)

        for element in self {
            result.append(contentsOf: element)
        }

        return result
    }
}
