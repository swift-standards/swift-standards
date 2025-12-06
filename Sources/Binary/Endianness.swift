// Endianness.swift
// Byte order for multi-byte integer serialization.

/// Byte order for multi-byte integer serialization.
///
/// Specifies how multi-byte integers are arranged in memory.
///
/// ## Cases
///
/// - `little`: Least significant byte first (x86, ARM default, most modern CPUs)
/// - `big`: Most significant byte first (network byte order, big-endian systems)
///
/// ## Mathematical Background
///
/// Endianness is isomorphic to `Bool` and forms a Z₂ group under the
/// `opposite` operation. It classifies byte orderings into two equivalence
/// classes.
///
/// ## Usage
///
/// ```swift
/// let bytes = value.bytes(endianness: .big)    // Network byte order
/// let value = UInt32(bytes: data, endianness: .little)  // Native order
/// ```
///
/// ## Tagged Values
///
/// Use `Endianness.Value<S>` to pair byte data with its endianness:
///
/// ```swift
/// let packet: Endianness.Value<[UInt8]> = .init(tag: .big, value: bytes)
/// ```
///
public enum Endianness: Sendable, Hashable, Codable, CaseIterable {
    /// Least significant byte first (x86, ARM, most modern CPUs).
    case little

    /// Most significant byte first (network byte order).
    case big
}

// MARK: - Opposite

extension Endianness {
    /// The opposite byte order.
    @inlinable
    public var opposite: Endianness {
        switch self {
        case .little: return .big
        case .big: return .little
        }
    }

    /// Returns the opposite byte order.
    @inlinable
    public static prefix func ! (value: Endianness) -> Endianness {
        value.opposite
    }
}

// MARK: - Platform Detection

extension Endianness {
    /// The native byte order of the current platform.
    ///
    /// Returns `.little` on little-endian systems (most modern CPUs)
    /// and `.big` on big-endian systems.
    @inlinable
    public static var native: Endianness {
        #if _endian(little)
        return .little
        #else
        return .big
        #endif
    }

    /// Network byte order (always big-endian).
    ///
    /// Standard byte order for network protocols (TCP/IP, etc.).
    @inlinable
    public static var network: Endianness { .big }
}

// MARK: - Tagged Value

public import Algebra

extension Endianness {
    /// A value paired with its byte order.
    public typealias Value<Payload> = Tagged<Endianness, Payload>
}
