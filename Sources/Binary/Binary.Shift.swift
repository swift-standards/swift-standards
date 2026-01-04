// Binary.Shift.swift
// Type-safe bit shift count.

extension Binary {
    /// A bit shift count (exponent for power-of-2 values).
    ///
    /// Shift values represent the number of bit positions to shift,
    /// which is equivalent to log2 of the corresponding alignment.
    ///
    /// ## Relationship with Alignment
    ///
    /// - `alignment = 2^shift`
    /// - `shift = log2(alignment)`
    ///
    /// ## Example
    ///
    /// ```swift
    /// let shift = Binary.Shift(12)           // 12 bits
    /// let alignment = shift.alignment        // 4096 (2^12)
    ///
    /// let value = 1 << shift.rawValue        // 4096
    /// ```
    public struct Shift: Sendable, Equatable, Hashable {
        /// The shift count (number of bit positions).
        public let rawValue: Int

        /// Creates a shift count.
        ///
        /// - Parameter rawValue: The number of bit positions.
        @inlinable
        public init(_ rawValue: Int) {
            self.rawValue = rawValue
        }
    }
}

extension Binary.Shift {

    // MARK: - Common Values

    /// No shift (2^0 = 1).
    public static let zero = Binary.Shift(0)

    /// 1-bit shift (2^1 = 2).
    public static let one = Binary.Shift(1)

    /// 9-bit shift (2^9 = 512, legacy sector).
    public static let sector512 = Binary.Shift(9)

    /// 12-bit shift (2^12 = 4096, x86 page).
    public static let page4096 = Binary.Shift(12)

    /// 14-bit shift (2^14 = 16384, Apple Silicon page).
    public static let page16384 = Binary.Shift(14)
}

extension Binary.Shift {

    // MARK: - Alignment Conversion

    /// The alignment value corresponding to this shift.
    ///
    /// Computes `2^shift`.
    @inlinable
    public var alignment: Binary.Alignment {
        Binary.Alignment(__unchecked: (), 1 << rawValue)
    }
}

// MARK: - Comparable

extension Binary.Shift: Comparable {
    @inlinable
    public static func < (lhs: Binary.Shift, rhs: Binary.Shift) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

// MARK: - Arithmetic

extension Binary.Shift {
    /// Adds two shifts (equivalent to multiplying alignments).
    @inlinable
    public static func + (lhs: Binary.Shift, rhs: Binary.Shift) -> Binary.Shift {
        Binary.Shift(lhs.rawValue + rhs.rawValue)
    }

    /// Subtracts two shifts (equivalent to dividing alignments).
    @inlinable
    public static func - (lhs: Binary.Shift, rhs: Binary.Shift) -> Binary.Shift {
        Binary.Shift(lhs.rawValue - rhs.rawValue)
    }
}

// MARK: - CustomStringConvertible

extension Binary.Shift: CustomStringConvertible {
    public var description: String {
        "\(rawValue)"
    }
}
