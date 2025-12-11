// Binary.swift
// Bit and byte level operations.

/// Namespace for bit and byte-level operations and types.
///
/// Provides utilities for binary data manipulation including byte serialization,
/// bit operations, endianness handling, and streaming serialization protocols.
///
/// ## Example
///
/// ```swift
/// let bytes = UInt32(0x12345678).bytes(endianness: .big)
/// // [0x12, 0x34, 0x56, 0x78]
/// ```
public enum Binary {}
