// Binary.Mask.swift
// Type-safe bitmask for alignment operations.

extension Binary {
    /// A bitmask for alignment operations (Int-based).
    ///
    /// For type-safe operations on typed positions, prefer using
    /// `Binary.Alignment.mask<Carrier>()` or `Binary.Shift.mask<Carrier>()`
    /// which compute masks in the carrier's ring.
    ///
    /// This type is retained for simple Int-based use cases.
    ///
    /// ## Relationship with Alignment
    ///
    /// For alignment `2^shift`, the mask is `(2^shift) - 1`:
    /// - Alignment 4096 → Mask 0xFFF (4095)
    /// - Alignment 512 → Mask 0x1FF (511)
    ///
    /// ## Example
    ///
    /// ```swift
    /// let mask = Binary.Mask.page4096
    /// let offset = 5000 & mask.rawValue      // 904 (offset within page)
    /// let aligned = 5000 & ~mask.rawValue    // 4096 (page start)
    /// ```
    public struct Mask: Sendable, Equatable, Hashable {
        /// The mask value (all 1s up to alignment - 1).
        public let rawValue: Int

        /// Creates a mask from a raw value.
        @inlinable
        public init(_ rawValue: Int) {
            self.rawValue = rawValue
        }
    }
}

// MARK: - Initializers from Alignment/Shift

extension Binary.Mask {
    /// Creates a mask from an alignment.
    ///
    /// The mask is `(2^shift) - 1` computed in Int.
    ///
    /// - Precondition: `alignment.shift < Int.bitWidth`
    @inlinable
    public init(_ alignment: Binary.Alignment) {
        precondition(Int(alignment.shift.rawValue) < Int.bitWidth, "Shift exceeds Int bit width")
        self.rawValue = alignment.mask(as: Int.self)
    }

    /// Creates a mask from a shift count.
    ///
    /// The mask is `(1 << shift) - 1` computed in Int.
    ///
    /// - Precondition: `shift < Int.bitWidth`
    @inlinable
    public init(_ shift: Binary.Shift) {
        precondition(Int(shift.rawValue) < Int.bitWidth, "Shift exceeds Int bit width")
        self.rawValue = shift.mask(as: Int.self)
    }
}

// MARK: - Common Values

extension Binary.Mask {
    /// No mask (alignment 1).
    public static let zero = Binary.Mask(0)

    /// 1-bit mask (alignment 2).
    public static let bit1 = Binary.Mask(0x1)

    /// 2-bit mask (alignment 4).
    public static let bit2 = Binary.Mask(0x3)

    /// 3-bit mask (alignment 8).
    public static let bit3 = Binary.Mask(0x7)

    /// 9-bit mask (alignment 512, legacy sector).
    public static let sector512 = Binary.Mask(0x1FF)

    /// 12-bit mask (alignment 4096, x86 page).
    public static let page4096 = Binary.Mask(0xFFF)

    /// 14-bit mask (alignment 16384, Apple Silicon page).
    public static let page16384 = Binary.Mask(0x3FFF)
}

// MARK: - Derived Values

extension Binary.Mask {
    /// The alignment corresponding to this mask.
    ///
    /// Computes `mask + 1`, which must be a power of 2.
    ///
    /// - Returns: The alignment, or `nil` if `mask + 1` is not a power of 2.
    @inlinable
    public var alignment: Binary.Alignment? {
        Binary.Alignment(validating: rawValue + 1)
    }

    /// The shift count corresponding to this mask.
    ///
    /// Uses `popcount(mask)` (number of 1 bits) as the shift.
    /// This is only correct if the mask is of the form `(2^n) - 1`.
    @inlinable
    public var shift: Binary.Shift? {
        let count = rawValue.nonzeroBitCount
        guard count <= Int(Binary.Shift.maxValue) else { return nil }
        return Binary.Shift(unchecked: UInt8(count))
    }

    /// The inverted mask for rounding down.
    @inlinable
    public var inverted: Int {
        ~rawValue
    }
}

// MARK: - Comparable

extension Binary.Mask: Comparable {
    @inlinable
    public static func < (lhs: Binary.Mask, rhs: Binary.Mask) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

// MARK: - CustomStringConvertible

extension Binary.Mask: CustomStringConvertible {
    public var description: String {
        String(rawValue, radix: 16, uppercase: true)
    }
}
