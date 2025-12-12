// Bit.Order.swift
// Bit significance order within a byte.

public import Algebra
public import Dimension

/// Bit significance order within a byte.
///
/// Defines which bit is considered "first" when processing bits within a byte
/// or serializing bit streams. Use this for bit-level protocol implementations
/// and hardware interfaces.
///
/// ## Example
///
/// ```swift
/// let byte: UInt8 = 0b10110010
///
/// // MSB first: process bits 7→6→5→4→3→2→1→0
/// // LSB first: process bits 0→1→2→3→4→5→6→7
/// ```
extension Bit {
    public enum Order: Sendable, Hashable, Codable, CaseIterable {
        /// Most significant bit first (bit 7 → bit 0).
        ///
        /// Common in network protocols and human-readable binary representations.
        case msb

        /// Least significant bit first (bit 0 → bit 7).
        ///
        /// Common in some hardware interfaces and compression algorithms.
        case lsb
    }
}

extension Bit.Order {
    /// Alias for `.msb` - most significant bit first.
    @inlinable
    public static var `most significant bit first`: Self { .msb }

    /// Alias for `.lsb` - least significant bit first.
    @inlinable
    public static var `least significant bit first`: Self { .lsb }
}

// MARK: - Opposite

extension Bit.Order {
    /// The opposite bit order.
    ///
    /// Returns `.lsb` for `.msb` and vice versa.
    @inlinable
    public static func opposite(_ order: Bit.Order) -> Bit.Order {
        switch order {
        case .msb: return .lsb
        case .lsb: return .msb
        }
    }

    /// The opposite bit order.
    ///
    /// Returns `.lsb` for `.msb` and vice versa.
    @inlinable
    public var opposite: Bit.Order {
        Self.opposite(self)
    }

    /// Returns the opposite bit order.
    ///
    /// Equivalent to the `opposite` property.
    @inlinable
    public static prefix func ! (value: Bit.Order) -> Bit.Order {
        opposite(value)
    }
}

// MARK: - Tagged Value

extension Bit.Order {
    /// A value tagged with its bit order.
    ///
    /// Use this to explicitly track bit order alongside data.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let bitstream: Bit.Order.Value<[UInt8]> = .init(.msb, data)
    /// ```
    public typealias Value<Payload> = Tagged<Bit.Order, Payload>
}
