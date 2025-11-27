//
//  RangeReplaceableCollection+UInt8.swift
//  swift-standards
//
//  Mutation helpers for byte collections
//

// MARK: - Byte Mutation Helpers

extension RangeReplaceableCollection where Element == UInt8 {
    /// Appends a UTF-8 string as bytes
    ///
    /// - Parameter string: The string to append as UTF-8 bytes
    ///
    /// Example:
    /// ```swift
    /// var buffer: [UInt8] = []
    /// buffer.append(utf8: "Hello")  // [72, 101, 108, 108, 111]
    /// ```
    public mutating func append(utf8 string: some StringProtocol) {
        append(contentsOf: string.utf8)
    }

    /// Appends a single byte
    ///
    /// - Parameter value: The byte value to append
    ///
    /// Example:
    /// ```swift
    /// var buffer: [UInt8] = []
    /// buffer.append(UInt8(0x41))     // [65]
    /// buffer.append(.ascii.solidus)  // [65, 47]
    /// ```
    public mutating func append(_ value: UInt8) {
        append(contentsOf: CollectionOfOne(value))
    }
}

// MARK: - Multi-byte Integer Append (specific to [UInt8])
//
// The multi-byte append with endianness is kept in [UInt8].swift
// because generalizing it requires complex type constraints.
// For RangeReplaceableCollection<UInt8>, use:
//   buffer.append(contentsOf: value.bytes(endianness: .big))
