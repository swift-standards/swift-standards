// Binary.Alignment.swift
// Type-safe power-of-2 alignment value.

extension Binary {
    /// A power-of-2 alignment value.
    ///
    /// Alignment values are used for memory mapping, Direct I/O, and block device
    /// operations where offsets and lengths must be multiples of a power of 2.
    ///
    /// ## Invariant
    ///
    /// The raw value is always a power of 2 (1, 2, 4, 8, 16, ...).
    ///
    /// ## Example
    ///
    /// ```swift
    /// let pageSize = Binary.Alignment(4096)!
    /// pageSize.isAligned(8192)   // true
    /// pageSize.isAligned(1000)   // false
    /// pageSize.alignUp(1000)     // 4096
    /// pageSize.alignDown(5000)   // 4096
    /// ```
    public struct Alignment: Sendable, Equatable, Hashable {
        /// The alignment value (always a power of 2).
        public let rawValue: Int
        
        /// Creates an alignment, validating that it is a power of 2.
        ///
        /// - Parameter rawValue: The alignment value. Must be a power of 2.
        /// - Returns: `nil` if the value is not a positive power of 2.
        @inlinable
        public init?(_ rawValue: Int) {
            guard rawValue > 0, rawValue & (rawValue - 1) == 0 else {
                return nil
            }
            self.rawValue = rawValue
        }
    }
}

extension Binary.Alignment {
    /// Creates an alignment without validation.
    ///
    /// - Parameter rawValue: The alignment value. Must be a power of 2.
    /// - Precondition: `rawValue` must be a positive power of 2.
    @inlinable
    public init(
        __unchecked: Void,
        _ rawValue: Int
    ) {
        self.rawValue = rawValue
    }

    /// Creates an alignment from a shift count.
    ///
    /// Computes `2^shift`.
    ///
    /// - Parameter shift: The shift count (log2 of alignment).
    @inlinable
    public init(_ shift: Binary.Shift) {
        self.rawValue = 1 << shift.rawValue
    }
}

extension Binary.Alignment {
    
    // MARK: - Common Values
    
    /// 1-byte alignment (no alignment requirement).
    public static let byte = Binary.Alignment(__unchecked: (), 1)
    
    /// 2-byte alignment.
    public static let halfWord = Binary.Alignment(__unchecked: (), 2)
    
    /// 4-byte alignment.
    public static let word = Binary.Alignment(__unchecked: (), 4)
    
    /// 8-byte alignment.
    public static let doubleWord = Binary.Alignment(__unchecked: (), 8)
    
    /// 16-byte alignment.
    public static let quadWord = Binary.Alignment(__unchecked: (), 16)
    
    /// 512-byte alignment (legacy disk sector).
    public static let sector512 = Binary.Alignment(__unchecked: (), 512)
    
    /// 4096-byte alignment (modern SSD sector, x86 page).
    public static let page4096 = Binary.Alignment(__unchecked: (), 4096)
    
    /// 16384-byte alignment (Apple Silicon page).
    public static let page16384 = Binary.Alignment(__unchecked: (), 16384)
}

extension Binary.Alignment {
    // MARK: - Alignment Operations
    
    /// Checks if a value is aligned.
    ///
    /// - Parameter value: The value to check.
    /// - Returns: `true` if the value is a multiple of this alignment.
    @inlinable
    public func isAligned<S: BinaryInteger>(_ value: S) -> Bool {
        Int(value) & (rawValue - 1) == 0
    }
    
    /// Rounds a value down to the nearest alignment boundary.
    ///
    /// - Parameter value: The value to align.
    /// - Returns: The largest aligned value ≤ the input.
    @inlinable
    public func alignDown<S: BinaryInteger>(_ value: S) -> S {
        S(Int(value) & ~(rawValue - 1))
    }
    
    /// Rounds a value up to the nearest alignment boundary.
    ///
    /// - Parameter value: The value to align.
    /// - Returns: The smallest aligned value ≥ the input.
    @inlinable
    public func alignUp<S: BinaryInteger>(_ value: S) -> S {
        S((Int(value) + rawValue - 1) & ~(rawValue - 1))
    }
    
    /// The bitmask for extracting the offset within an aligned block.
    ///
    /// For alignment `a`, this is `a - 1`.
    @inlinable
    public var mask: Binary.Mask {
        Binary.Mask(rawValue - 1)
    }
    
    /// The shift count (log2 of alignment).
    ///
    /// For alignment 4096, this is 12.
    @inlinable
    public var shift: Binary.Shift {
        Binary.Shift(rawValue.trailingZeroBitCount)
    }
}

// MARK: - Comparable

extension Binary.Alignment: Comparable {
    @inlinable
    public static func < (lhs: Binary.Alignment, rhs: Binary.Alignment) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

// MARK: - CustomStringConvertible

extension Binary.Alignment: CustomStringConvertible {
    public var description: String {
        "\(rawValue)"
    }
}
