// Endianness.swift
// Byte order for multi-byte integer serialization.

public import Algebra
public import Dimension

/// Byte order for multi-byte integer serialization.
///
/// Defines how multi-byte values are arranged in memory. Use this when
/// serializing or deserializing integers to ensure correct interpretation
/// across different platforms and network protocols.
///
/// ## Example
///
/// ```swift
/// let value: UInt16 = 0x1234
///
/// let network = value.bytes(endianness: .big)
/// // [0x12, 0x34] - Most significant byte first
///
/// let native = value.bytes(endianness: .little)
/// // [0x34, 0x12] - Least significant byte first (most modern CPUs)
/// ```
extension Binary {
    public enum Endianness: Sendable, Hashable, Codable, CaseIterable {
        /// Least significant byte first.
        ///
        /// Standard order for x86, ARM, and most modern CPUs.
        case little

        /// Most significant byte first.
        ///
        /// Network byte order standard for TCP/IP and other network protocols.
        case big
    }
}

// MARK: - Opposite

extension Binary.Endianness {
    /// The opposite byte order.
    ///
    /// Returns `.big` for `.little` and vice versa.
    @inlinable
    public var opposite: Binary.Endianness {
        switch self {
        case .little: return .big
        case .big: return .little
        }
    }

    /// Returns the opposite byte order.
    ///
    /// Equivalent to the `opposite` property.
    @inlinable
    public static prefix func ! (value: Binary.Endianness) -> Binary.Endianness {
        value.opposite
    }
}

// MARK: - Platform Detection

extension Binary.Endianness {
    /// The native byte order of the current platform.
    ///
    /// Returns `.little` on x86, ARM, and most modern CPUs.
    /// Returns `.big` on big-endian systems.
    @inlinable
    public static var native: Binary.Endianness {
        #if _endian(little)
            return .little
        #else
            return .big
        #endif
    }

    /// Network byte order.
    ///
    /// Always returns `.big` (most significant byte first), which is the
    /// standard for TCP/IP and most network protocols.
    @inlinable
    public static var network: Binary.Endianness { .big }
}

// MARK: - Tagged Value

extension Binary.Endianness {
    /// A value tagged with its byte order.
    ///
    /// Use this to explicitly track endianness alongside byte data.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let packet: Binary.Endianness.Value<[UInt8]> = .init(.big, [0x12, 0x34])
    /// ```
    public typealias Value<Payload> = Tagged<Binary.Endianness, Payload>
}
