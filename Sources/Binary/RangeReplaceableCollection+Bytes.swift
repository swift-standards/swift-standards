// RangeReplaceableCollection+Bytes.swift
// Mutation helpers for byte collections.

// MARK: - Byte Mutation Helpers

extension RangeReplaceableCollection<UInt8> {
    /// Appends a UTF-8 encoded string as bytes.
    ///
    /// Converts the string to UTF-8 and appends the bytes to the collection.
    /// Use this for building byte buffers from text content.
    ///
    /// ## Example
    ///
    /// ```swift
    /// var buffer: [UInt8] = []
    /// buffer.append(utf8: "Hello")
    /// // buffer is now [72, 101, 108, 108, 111]
    /// ```
    ///
    /// - Parameter string: The string to append as UTF-8 bytes
    public mutating func append(utf8 string: some StringProtocol) {
        append(contentsOf: string.utf8)
    }

    /// Appends a single byte to the collection.
    ///
    /// ## Example
    ///
    /// ```swift
    /// var buffer: [UInt8] = []
    /// buffer.append(0x41)
    /// // buffer is now [65]
    /// ```
    ///
    /// - Parameter value: The byte value to append
    public mutating func append(_ value: UInt8) {
        append(contentsOf: CollectionOfOne(value))
    }
}
