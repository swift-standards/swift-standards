// UInt8.Serializable.swift
// swift-standards
//
// Streaming byte serialization protocol
//
// This protocol defines the fundamental abstraction for types that can
// serialize themselves into byte buffers. Unlike buffered serialization
// (which returns `[UInt8]`), streaming serialization writes directly into
// a caller-provided buffer, enabling:
//
// - Zero-copy composition of nested structures
// - Efficient memory usage for large documents
// - Progressive output (start writing before computation completes)
// - Compatibility with diverse buffer types (Data, ByteBuffer, etc.)
//
// ## Design Philosophy
//
// The protocol is intentionally minimal:
// - Single requirement: `serialize(_:into:)`
// - No context parameter (values are self-describing)
// - No associated error type (serialization is infallible for valid values)
// - Buffer-agnostic via `RangeReplaceableCollection`
//
// ## Category Theory
//
// Streaming serialization is a natural transformation:
// - **Domain**: Self (structured value)
// - **Codomain**: Mutation of Buffer (byte sequence)
//
// The `inout Buffer` pattern represents the state monad:
// serialize: Self → (Buffer → Buffer)
//
// Composition of streaming types corresponds to monad sequencing:
// parent.serialize ≡ writeOpen >> children.map(serialize) >> writeClose

extension UInt8 {
    /// Protocol for types that serialize to byte streams
    ///
    /// Conforming types can write their byte representation directly into
    /// any `RangeReplaceableCollection` of `UInt8`, enabling efficient
    /// composition and streaming output.
    ///
    /// ## Use Cases
    ///
    /// - HTML document streaming (server-side rendering)
    /// - Large structured data (JSON, XML, protocol buffers)
    /// - Compositional serialization (nested DOM-like structures)
    /// - HTTP chunked transfer encoding
    /// - Template rendering engines
    ///
    /// ## Example
    ///
    /// ```swift
    /// struct HTMLDiv: UInt8.Serializable {
    ///     let className: String?
    ///     let children: [any UInt8.Serializable]
    ///
    ///     static func serialize<Buffer: RangeReplaceableCollection>(
    ///         _ div: Self,
    ///         into buffer: inout Buffer
    ///     ) where Buffer.Element == UInt8 {
    ///         buffer.append(contentsOf: "<div".utf8)
    ///         if let className = div.className {
    ///             buffer.append(contentsOf: " class=\"".utf8)
    ///             buffer.append(contentsOf: className.utf8)
    ///             buffer.append(UInt8(ascii: "\""))
    ///         }
    ///         buffer.append(UInt8(ascii: ">"))
    ///
    ///         for child in div.children {
    ///             child.serialize(into: &buffer)
    ///         }
    ///
    ///         buffer.append(contentsOf: "</div>".utf8)
    ///     }
    /// }
    /// ```
    ///
    /// ## Buffer Types
    ///
    /// The generic constraint allows writing to:
    /// - `[UInt8]` — Standard byte array
    /// - `ContiguousArray<UInt8>` — Cache-friendly contiguous storage
    /// - Custom buffers conforming to `RangeReplaceableCollection`
    ///
    /// For `Data` or `ByteBuffer`, use their native append methods after
    /// serializing to `[UInt8]`, or create a thin adapter type.
    ///
    /// ## Composition
    ///
    /// Streaming types compose naturally:
    ///
    /// ```swift
    /// struct Document: UInt8.Serializable {
    ///     let header: Header      // also UInt8.Serializable
    ///     let body: Body          // also UInt8.Serializable
    ///
    ///     static func serialize<Buffer: RangeReplaceableCollection>(
    ///         _ doc: Self,
    ///         into buffer: inout Buffer
    ///     ) where Buffer.Element == UInt8 {
    ///         doc.header.serialize(into: &buffer)
    ///         doc.body.serialize(into: &buffer)
    ///     }
    /// }
    /// ```
    public protocol Serializable: Sendable {
        /// Serialize this value into a byte buffer
        ///
        /// Writes the byte representation of this value into the provided buffer.
        /// Implementations should append bytes without clearing existing content.
        ///
        /// ## Implementation Requirements
        ///
        /// - MUST append bytes to buffer (not replace)
        /// - MUST NOT throw (serialization is infallible for valid values)
        /// - SHOULD be deterministic (same value produces same bytes)
        ///
        /// ## Example Implementation
        ///
        /// ```swift
        /// extension MyType: UInt8.Serializable {
        ///     static func serialize<Buffer: RangeReplaceableCollection>(
        ///         _ value: Self,
        ///         into buffer: inout Buffer
        ///     ) where Buffer.Element == UInt8 {
        ///         buffer.append(contentsOf: value.data.utf8)
        ///     }
        /// }
        /// ```
        ///
        /// - Parameters:
        ///   - serializable: The value to serialize
        ///   - buffer: The buffer to append bytes to
        static func serialize<Buffer: RangeReplaceableCollection>(
            _ serializable: Self,
            into buffer: inout Buffer
        ) where Buffer.Element == UInt8
    }
}

// MARK: - Convenience Extensions

extension UInt8.Serializable {
    /// Serialize to a new byte array
    ///
    /// Convenience property that creates a new buffer and serializes into it.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let address: IPv4.Address = "192.168.1.1"
    /// let bytes = address.bytes  // [UInt8]
    /// ```
    ///
    /// ## Performance Note
    ///
    /// Each call allocates a new array. For repeated serialization,
    /// prefer `serialize(into:)` with a reusable buffer.
    @inlinable
    public var bytes: [UInt8] {
        var buffer: [UInt8] = []
        Self.serialize(self, into: &buffer)
        return buffer
    }

    /// Serialize this value into a byte buffer (instance method)
    ///
    /// Convenience method that delegates to the static `serialize(_:into:)`.
    /// Appends the byte representation of this value to the provided buffer.
    ///
    /// ## Example
    ///
    /// ```swift
    /// var buffer: [UInt8] = []
    /// header.serialize(into: &buffer)
    /// body.serialize(into: &buffer)
    /// footer.serialize(into: &buffer)
    /// ```
    ///
    /// - Parameter buffer: The buffer to append bytes to
    @inlinable
    public func serialize<Buffer: RangeReplaceableCollection>(
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        Self.serialize(self, into: &buffer)
    }
}

// MARK: - Static Returning Convenience

extension UInt8.Serializable {
    /// Serialize to a new collection (static method)
    ///
    /// Creates a new buffer of the inferred type and serializes into it.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let bytes: [UInt8] = MyType.serialize(value)
    /// let contiguous: ContiguousArray<UInt8> = MyType.serialize(value)
    /// ```
    ///
    /// - Parameter serializable: The value to serialize
    /// - Returns: A new collection containing the serialized bytes
    @inlinable
    public static func serialize<Bytes: RangeReplaceableCollection>(
        _ serializable: Self
    ) -> Bytes where Bytes.Element == UInt8 {
        var buffer = Bytes()
        Self.serialize(serializable, into: &buffer)
        return buffer
    }
}

extension RangeReplaceableCollection where Element == UInt8 {
    @inlinable
    public mutating func append<Serializable: UInt8.Serializable>(
        _ serializable: Serializable
    ) {
        Serializable.serialize(serializable, into: &self)
    }
}

// MARK: - Collection Initializers

extension Array where Element == UInt8 {
    /// Create a byte array from a serializable value
    ///
    /// ## Example
    ///
    /// ```swift
    /// let bytes = [UInt8](mySerializableValue)
    /// ```
    ///
    /// - Parameter serializable: The value to serialize
    @inlinable
    public init<S: UInt8.Serializable>(_ serializable: S) {
        self = []
        S.serialize(serializable, into: &self)
    }
}

extension ContiguousArray where Element == UInt8 {
    /// Create a contiguous byte array from a serializable value
    ///
    /// ## Example
    ///
    /// ```swift
    /// let bytes = ContiguousArray<UInt8>(mySerializableValue)
    /// ```
    ///
    /// - Parameter serializable: The value to serialize
    @inlinable
    public init<S: UInt8.Serializable>(_ serializable: S) {
        self = []
        S.serialize(serializable, into: &self)
    }
}

// MARK: - String Conversion

extension StringProtocol {
    /// Create a string from a serializable value's UTF-8 output
    ///
    /// Serializes the value and interprets the bytes as UTF-8.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let html: HTMLDocument = ...
    /// let string = String(html)
    /// ```
    ///
    /// - Parameter value: The serializable value to convert
    @inlinable
    public init<T: UInt8.Serializable>(_ value: T) {
        self = Self(decoding: value.bytes, as: UTF8.self)
    }
}

// MARK: - RawRepresentable Default Implementations

extension UInt8.Serializable where Self: RawRepresentable, Self.RawValue: StringProtocol {
    /// Default implementation for string-backed types
    ///
    /// Automatically provided for types where RawValue conforms to StringProtocol.
    /// Writes the raw value as UTF-8 bytes directly into the buffer.
    ///
    /// ## Example
    ///
    /// ```swift
    /// enum Status: String, UInt8.Serializable {
    ///     case ok = "OK"
    ///     case error = "ERROR"
    /// }
    /// // Status.ok.bytes == [79, 75] ("OK" in UTF-8)
    /// ```
    @inlinable
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ serializable: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        buffer.append(contentsOf: serializable.rawValue.utf8)
    }
}

extension UInt8.Serializable where Self: RawRepresentable, Self.RawValue == [UInt8] {
    /// Default implementation for byte-array-backed types
    ///
    /// Automatically provided for types where RawValue is [UInt8].
    /// Appends the raw value directly (identity transformation).
    ///
    /// ## Example
    ///
    /// ```swift
    /// struct Checksum: RawRepresentable, UInt8.Serializable {
    ///     let rawValue: [UInt8]
    /// }
    /// ```
    @inlinable
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ serializable: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        buffer.append(contentsOf: serializable.rawValue)
    }
}
