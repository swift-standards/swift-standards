// RawRepresentable+Format.swift
// Generic formatting support for all integer-backed types.

extension RawRepresentable where RawValue: BinaryInteger {
    /// Formats this value's raw integer as a human-readable byte count.
    ///
    /// Works automatically for any `RawRepresentable` type with an integer raw value.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Any RawRepresentable with integer rawValue works:
    /// someOffset.formatted(Binary.Format.bytes)           // "4.1 KB"
    /// someLength.formatted(Binary.Format.bytes(.binary))  // "4 KiB"
    /// ```
    @inlinable
    public func formatted(_ format: Binary.Format.Bytes) -> String {
        format.format(rawValue)
    }

    /// Formats this value's raw integer in the specified radix.
    ///
    /// Works automatically for any `RawRepresentable` type with an integer raw value.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Any RawRepresentable with integer rawValue works:
    /// someOffset.formatted(Binary.Format.hex.prefix)  // "0x1000"
    /// somePerms.formatted(Binary.Format.octal)        // "755"
    /// someValue.formatted(Binary.Format.bits)         // "11111111"
    /// ```
    @inlinable
    public func formatted(_ format: Binary.Format.Radix) -> String {
        format.format(rawValue)
    }
}
