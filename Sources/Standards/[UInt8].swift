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

