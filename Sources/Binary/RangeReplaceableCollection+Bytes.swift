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
    /// RangeReplaceableCollection.append(utf8: "Hello", to: &buffer)
    /// // buffer is now [72, 101, 108, 108, 111]
    /// ```
    ///
    /// - Parameters:
    ///   - string: The string to append as UTF-8 bytes
    ///   - buffer: The buffer to append to
    @inlinable
    public static func append<S: StringProtocol, Buffer: RangeReplaceableCollection>(
        utf8 string: S,
        to buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        buffer.append(contentsOf: string.utf8)
    }

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
    @inlinable
    public mutating func append(utf8 string: some StringProtocol) {
        Self.append(utf8: string, to: &self)
    }

    /// Appends a single byte to the collection.
    ///
    /// ## Example
    ///
    /// ```swift
    /// var buffer: [UInt8] = []
    /// RangeReplaceableCollection.append(0x41, to: &buffer)
    /// // buffer is now [65]
    /// ```
    ///
    /// - Parameters:
    ///   - value: The byte value to append
    ///   - buffer: The buffer to append to
    @inlinable
    public static func append<Buffer: RangeReplaceableCollection>(
        _ value: UInt8,
        to buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        buffer.append(contentsOf: CollectionOfOne(value))
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
    @inlinable
    public mutating func append(_ value: UInt8) {
        Self.append(value, to: &self)
    }
}
