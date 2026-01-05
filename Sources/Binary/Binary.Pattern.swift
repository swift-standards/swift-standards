// Binary.Pattern.swift
// Carrier-dependent bit-pattern operations.

extension Binary {
    /// Namespace for carrier-dependent bit-pattern operations.
    ///
    /// `Pattern` provides types for working with bitmasks and bitfields in a
    /// specific fixed-width unsigned integer ring. All operations are well-defined
    /// within the ring Z/2^w where w = `Carrier.bitWidth`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// typealias Pattern32 = Binary.Pattern<UInt32>
    /// let flags: Pattern32.Mask = .lowBits(8)  // 0x000000FF
    /// ```
    ///
    /// - Parameter Carrier: The fixed-width unsigned integer type for bit operations.
    public enum Pattern<Carrier: FixedWidthInteger & UnsignedInteger & Sendable> {}
}

// MARK: - Mask

extension Binary.Pattern {
    /// A bitmask in the carrier ring.
    ///
    /// Masks represent bit patterns for selection, filtering, or field extraction.
    /// All operations are well-defined within the ring Z/2^w.
    ///
    /// ## Ring Laws
    ///
    /// - `a & b` — intersection (meet)
    /// - `a | b` — union (join)
    /// - `~a` — complement in Z/2^w
    ///
    /// ## Example
    ///
    /// ```swift
    /// typealias Mask32 = Binary.Pattern<UInt32>.Mask
    /// let low8 = Mask32.lowBits(8)      // 0x000000FF
    /// let high24 = ~low8                 // 0xFFFFFF00
    /// let combined = low8 | .lowBits(16) // 0x0000FFFF
    /// ```
    public struct Mask: Sendable, Equatable, Hashable {
        /// The raw bitmask value.
        public let rawValue: Carrier

        /// Creates a mask from a raw value.
        @inlinable
        public init(_ rawValue: Carrier) {
            self.rawValue = rawValue
        }

        /// The zero mask (no bits set).
        @inlinable
        public static var zero: Self { Self(0) }

        /// The all-ones mask (all bits set).
        @inlinable
        public static var allOnes: Self { Self(~0) }

        /// Creates a mask with `n` low bits set.
        ///
        /// - Parameter n: The number of low bits to set.
        /// - Precondition: `n >= 0`
        /// - Returns: `0` if `n == 0`, all ones if `n >= bitWidth`,
        ///   otherwise `(1 << n) - 1`.
        ///
        /// ## Example
        ///
        /// ```swift
        /// Mask.lowBits(0)   // 0x00000000
        /// Mask.lowBits(8)   // 0x000000FF
        /// Mask.lowBits(32)  // 0xFFFFFFFF (for UInt32)
        /// ```
        @inlinable
        public static func lowBits(_ n: Int) -> Self {
            precondition(n >= 0, "n must be non-negative")
            if n == 0 { return Self(0) }
            if n >= Carrier.bitWidth { return Self(~0) }
            return Self((Carrier(1) &<< n) &- 1)
        }

        /// Creates a mask with `n` high bits set.
        ///
        /// - Parameter n: The number of high bits to set.
        /// - Precondition: `n >= 0`
        /// - Returns: `0` if `n == 0`, all ones if `n >= bitWidth`,
        ///   otherwise the top n bits set.
        @inlinable
        public static func highBits(_ n: Int) -> Self {
            precondition(n >= 0, "n must be non-negative")
            if n == 0 { return Self(0) }
            if n >= Carrier.bitWidth { return Self(~0) }
            return Self(~((Carrier(1) &<< (Carrier.bitWidth - n)) &- 1))
        }

        /// Creates a mask with a single bit set at the given position.
        ///
        /// - Parameter position: The bit position (0 = LSB).
        /// - Precondition: `0 <= position < bitWidth`
        @inlinable
        public static func bit(_ position: Int) -> Self {
            precondition(position >= 0 && position < Carrier.bitWidth, "Bit position out of bounds")
            return Self(Carrier(1) &<< position)
        }
    }
}

// MARK: - Mask Operators

extension Binary.Pattern.Mask {
    /// Bitwise AND (intersection).
    @inlinable
    public static func & (lhs: Self, rhs: Self) -> Self {
        Self(lhs.rawValue & rhs.rawValue)
    }

    /// Bitwise OR (union).
    @inlinable
    public static func | (lhs: Self, rhs: Self) -> Self {
        Self(lhs.rawValue | rhs.rawValue)
    }

    /// Bitwise XOR (symmetric difference).
    @inlinable
    public static func ^ (lhs: Self, rhs: Self) -> Self {
        Self(lhs.rawValue ^ rhs.rawValue)
    }

    /// Bitwise NOT (complement).
    @inlinable
    public static prefix func ~ (mask: Self) -> Self {
        Self(~mask.rawValue)
    }
}

// MARK: - Mask Queries

extension Binary.Pattern.Mask {
    /// Returns `true` if all bits in `other` are set in this mask.
    @inlinable
    public func contains(_ other: Self) -> Bool {
        (rawValue & other.rawValue) == other.rawValue
    }

    /// Returns `true` if any bits in `other` are set in this mask.
    @inlinable
    public func intersects(_ other: Self) -> Bool {
        (rawValue & other.rawValue) != 0
    }

    /// The number of bits set in this mask.
    @inlinable
    public var popcount: Int {
        rawValue.nonzeroBitCount
    }

    /// Returns `true` if no bits are set.
    @inlinable
    public var isEmpty: Bool {
        rawValue == 0
    }
}

// MARK: - CustomStringConvertible

extension Binary.Pattern.Mask: CustomStringConvertible {
    public var description: String {
        "0x" + String(rawValue, radix: 16, uppercase: true)
    }
}

// MARK: - Platform Aliases

/// 8-bit pattern operations.
public typealias Pattern8 = Binary.Pattern<UInt8>

/// 16-bit pattern operations.
public typealias Pattern16 = Binary.Pattern<UInt16>

/// 32-bit pattern operations.
public typealias Pattern32 = Binary.Pattern<UInt32>

/// 64-bit pattern operations.
public typealias Pattern64 = Binary.Pattern<UInt64>

/// Word-sized pattern operations (platform-dependent).
public typealias PatternWord = Binary.Pattern<UInt>
