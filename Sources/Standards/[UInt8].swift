// [UInt8].swift
// swift-standards
//
// Pure Swift byte array utilities
//
// This file contains extensions specific to [UInt8]:
// - Endianness enum (byte order specification)
// - Initializers that create [UInt8] from other types
// - Methods that return [UInt8] or [[UInt8]]
//
// For generic byte collection operations, see:
// - Collection+UInt8.swift (search, trim - any Collection where Element == UInt8)
// - RangeReplaceableCollection+UInt8.swift (append - any RangeReplaceableCollection)

extension [UInt8] {
    /// Byte order for multi-byte integer serialization
    ///
    /// Specifies how multi-byte integers are arranged in memory.
    /// - `little`: Least significant byte first (x86, ARM default)
    /// - `big`: Most significant byte first (network byte order)
    public enum Endianness: Sendable {
        case little
        case big
    }
}

// MARK: - Single Integer Serialization

extension [UInt8] {
    /// Creates a byte array from any fixed-width integer
    ///
    /// - Parameters:
    ///   - value: The integer value to convert
    ///   - endianness: Byte order for the output bytes (defaults to little-endian)
    ///
    /// Example:
    /// ```swift
    /// let int32Bytes = [UInt8](Int32(256), endianness: .little)  // [0, 1, 0, 0]
    /// let int32BytesBE = [UInt8](Int32(256), endianness: .big)   // [0, 0, 1, 0]
    /// let int8Bytes = [UInt8](Int8(42))                          // [42]
    /// ```
    public init<T: FixedWidthInteger>(_ value: T, endianness: Endianness = .little) {
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
    /// Creates a byte array from a collection of fixed-width integers
    ///
    /// - Parameters:
    ///   - values: Collection of integers to convert
    ///   - endianness: Byte order for the output bytes (defaults to little-endian)
    ///
    /// Example:
    /// ```swift
    /// let bytes = [UInt8](serializing: [Int16(1), Int16(2)], endianness: .little)
    /// // [1, 0, 2, 0] (4 bytes total)
    ///
    /// let int32s: [Int32] = [256, 512]
    /// let serialized = [UInt8](serializing: int32s, endianness: .big)
    /// // [0, 0, 1, 0, 0, 0, 2, 0] (8 bytes total)
    /// ```
    public init<C: Collection>(serializing values: C, endianness: Endianness = .little)
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
    /// Creates a byte array from a UTF-8 encoded string
    ///
    /// - Parameter string: The string to convert to UTF-8 bytes
    ///
    /// Example:
    /// ```swift
    /// let bytes = [UInt8](utf8: "Hello")  // [72, 101, 108, 108, 111]
    /// ```
    public init(utf8 string: some StringProtocol) {
        self = Array(string.utf8)
    }
}

// MARK: - Splitting

extension [UInt8] {
    /// Splits the byte array at all occurrences of a delimiter sequence
    ///
    /// - Parameter separator: The byte sequence to split on
    /// - Returns: Array of byte arrays split at the delimiter
    ///
    /// Example:
    /// ```swift
    /// let data: [UInt8] = [1, 2, 0, 0, 3, 4, 0, 0, 5]
    /// let parts = data.split(separator: [0, 0])
    /// // [[1, 2], [3, 4], [5]]
    /// ```
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
    /// Appends a multi-byte integer as bytes with specified endianness
    ///
    /// This method is for multi-byte integers only. Endianness is meaningless for single bytes.
    /// For appending single bytes, use `append(_ value: UInt8)` or `.ascii` constants.
    ///
    /// - Parameters:
    ///   - value: The integer value to append
    ///   - endianness: Byte order for the serialized bytes (defaults to little-endian)
    ///
    /// Example:
    /// ```swift
    /// var buffer: [UInt8] = []
    /// buffer.append(UInt16(0x1234), endianness: .big)  // [0x12, 0x34]
    /// buffer.append(Int32(256), endianness: .little)   // [0, 1, 0, 0]
    /// ```
    public mutating func append(_ value: UInt16, endianness: Endianness = .little) {
        append(contentsOf: value.bytes(endianness: endianness))
    }

    /// Appends a 32-bit integer as bytes with specified endianness
    public mutating func append(_ value: UInt32, endianness: Endianness = .little) {
        append(contentsOf: value.bytes(endianness: endianness))
    }

    /// Appends a 64-bit integer as bytes with specified endianness
    public mutating func append(_ value: UInt64, endianness: Endianness = .little) {
        append(contentsOf: value.bytes(endianness: endianness))
    }

    /// Appends a signed 16-bit integer as bytes with specified endianness
    public mutating func append(_ value: Int16, endianness: Endianness = .little) {
        append(contentsOf: value.bytes(endianness: endianness))
    }

    /// Appends a signed 32-bit integer as bytes with specified endianness
    public mutating func append(_ value: Int32, endianness: Endianness = .little) {
        append(contentsOf: value.bytes(endianness: endianness))
    }

    /// Appends a signed 64-bit integer as bytes with specified endianness
    public mutating func append(_ value: Int64, endianness: Endianness = .little) {
        append(contentsOf: value.bytes(endianness: endianness))
    }

    /// Appends a platform-sized integer as bytes with specified endianness
    public mutating func append(_ value: Int, endianness: Endianness = .little) {
        append(contentsOf: value.bytes(endianness: endianness))
    }

    /// Appends an unsigned platform-sized integer as bytes with specified endianness
    public mutating func append(_ value: UInt, endianness: Endianness = .little) {
        append(contentsOf: value.bytes(endianness: endianness))
    }
}

// MARK: - Joining Byte Arrays

extension [[UInt8]] {
    /// Joins byte arrays with a separator, pre-allocating exact capacity
    ///
    /// Efficiently concatenates an array of byte arrays with a separator between each element.
    /// Pre-calculates the total size needed and reserves capacity to avoid reallocations.
    ///
    /// ## Performance
    ///
    /// This method is O(n) where n is the total number of bytes across all arrays.
    /// It performs exactly one allocation by pre-computing the required capacity.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let lines: [[UInt8]] = [[72, 101, 108, 108, 111], [87, 111, 114, 108, 100]]
    /// let crlf: [UInt8] = [13, 10]
    /// let joined = lines.joined(separator: crlf)
    /// // [72, 101, 108, 108, 111, 13, 10, 87, 111, 114, 108, 100] ("Hello\r\nWorld")
    /// ```
    ///
    /// - Parameter separator: The byte sequence to insert between each element
    /// - Returns: A single byte array with all elements joined by the separator
    @inlinable
    public func joined(separator: [UInt8]) -> [UInt8] {
        guard !isEmpty else { return [] }
        guard count > 1 else { return self[0] }

        // Pre-calculate exact size needed
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

    /// Joins byte arrays without a separator
    ///
    /// Efficiently concatenates an array of byte arrays.
    /// Pre-calculates the total size needed and reserves capacity to avoid reallocations.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let chunks: [[UInt8]] = [[1, 2], [3, 4], [5]]
    /// let flat = chunks.joined()  // [1, 2, 3, 4, 5]
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
