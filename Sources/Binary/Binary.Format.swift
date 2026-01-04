// Binary.Format.swift
// Namespace for binary data formatting.

public import Formatting

extension Binary {
    /// Namespace for binary data formatting.
    ///
    /// Provides format styles for representing binary data as strings:
    /// - Byte counts: human-readable sizes (KB, MB, GB)
    /// - Radix representations: binary, octal, hexadecimal
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Byte count formatting
    /// 1024.formatted(Binary.Format.bytes)              // "1.02 KB"
    /// 1024.formatted(Binary.Format.bytes(.binary))     // "1 KiB"
    ///
    /// // Radix formatting
    /// 255.formatted(Binary.Format.hex)                 // "ff"
    /// 255.formatted(Binary.Format.bits)                // "11111111"
    /// ```
    public enum Format {}
}
