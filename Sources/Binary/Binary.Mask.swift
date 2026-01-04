// Binary.Mask.swift
// Type-safe bitmask for alignment operations.

extension Binary {
    /// A bitmask for alignment operations.
    ///
    /// Masks are used to extract the offset within an aligned block
    /// or to round values to alignment boundaries.
    ///
    /// ## Relationship with Alignment
    ///
    /// For alignment `a`, the mask is `a - 1`:
    /// - Alignment 4096 → Mask 0xFFF (4095)
    /// - Alignment 512 → Mask 0x1FF (511)
    ///
    /// ## Operations
    ///
    /// - `value & mask` → offset within aligned block
    /// - `value & ~mask` → round down to alignment boundary
    ///
    /// ## Example
    ///
    /// ```swift
    /// let mask = Binary.Alignment.page4096.mask
    /// let offset = 5000 & mask.rawValue      // 904 (offset within page)
    /// let aligned = 5000 & ~mask.rawValue    // 4096 (page start)
    /// ```
    public struct Mask: Sendable, Equatable, Hashable {
        /// The mask value (all 1s up to alignment - 1).
        public let rawValue: Int

        /// Creates a mask from a raw value.
        ///
        /// - Parameter rawValue: The mask value.
        @inlinable
        public init(_ rawValue: Int) {
            self.rawValue = rawValue
        }
    }
}

extension Binary.Mask {

    /// Creates a mask from an alignment.
    ///
    /// The mask is `alignment - 1`.
    ///
    /// - Parameter alignment: The alignment value.
    @inlinable
    public init(_ alignment: Binary.Alignment) {
        self.rawValue = alignment.rawValue - 1
    }

    /// Creates a mask from a shift count.
    ///
    /// The mask is `(1 << shift) - 1`.
    ///
    /// - Parameter shift: The shift count.
    @inlinable
    public init(_ shift: Binary.Shift) {
        self.rawValue = (1 << shift.rawValue) - 1
    }
}

extension Binary.Mask {

    // MARK: - Common Values

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

extension Binary.Mask {

    // MARK: - Derived Values

    /// The alignment corresponding to this mask.
    ///
    /// Computes `mask + 1`.
    @inlinable
    public var alignment: Binary.Alignment {
        Binary.Alignment(__unchecked: (), rawValue + 1)
    }

    /// The shift count corresponding to this mask.
    ///
    /// Computes `popcount(mask)` (number of 1 bits).
    @inlinable
    public var shift: Binary.Shift {
        Binary.Shift(rawValue.nonzeroBitCount)
    }

    /// The inverted mask for rounding down.
    @inlinable
    public var inverted: Int {
        ~rawValue
    }
}

extension Binary.Mask {

    // MARK: - Mask Operations

    /// Extracts the offset within an aligned block.
    ///
    /// - Parameter value: The value to mask.
    /// - Returns: `value & mask`
    @inlinable
    public func offset<S: BinaryInteger>(_ value: S) -> S {
        S(Int(value) & rawValue)
    }

    /// Checks if a value is aligned (offset is zero).
    ///
    /// - Parameter value: The value to check.
    /// - Returns: `true` if `value & mask == 0`
    @inlinable
    public func isAligned<S: BinaryInteger>(_ value: S) -> Bool {
        Int(value) & rawValue == 0
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
