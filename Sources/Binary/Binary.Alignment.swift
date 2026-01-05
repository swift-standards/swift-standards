// Binary.Alignment.swift
// Type-safe power-of-2 alignment (exponent-backed).

extension Binary {
    /// A power-of-2 alignment value (exponent-backed).
    ///
    /// Alignment is stored as an exponent (shift count), with magnitude
    /// computed per carrier type. This eliminates Int-width portability
    /// issues and enables correct operation across all fixed-width scalars.
    ///
    /// ## Storage
    ///
    /// Stores only `shift: Binary.Shift` (the exponent). Magnitude (`2^shift`)
    /// is computed on demand in the caller's chosen carrier type.
    ///
    /// ## API Pattern
    ///
    /// - **Primary**: `init(shift:)` or `init(magnitude:) throws`
    /// - **Constants**: Pre-validated static constants for common values
    /// - **Operations**: All alignment ops compute in the operand's ring
    ///
    /// ## Example
    ///
    /// ```swift
    /// let page = Binary.Alignment.page4096
    /// page.isAligned(position)           // computes in position's scalar ring
    /// page.alignUp(position)             // computes in position's scalar ring
    ///
    /// // Get magnitude in specific carrier
    /// let mag: UInt64 = page.magnitude() // 4096
    /// ```
    public struct Alignment: Sendable, Equatable, Hashable {
        /// The shift count (exponent). Magnitude is `2^shift`.
        public let shift: Binary.Shift
    }
}

// MARK: - Error

extension Binary.Alignment {
    /// Error from Alignment operations.
    public enum Error: Swift.Error, Sendable, Equatable {
        /// The value was not a power of 2.
        case notPowerOfTwo(Int)

        /// The shift exceeds the carrier's bit width.
        case shiftExceedsBitWidth(shift: UInt8, bitWidth: Int)
    }
}

extension Binary.Alignment.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notPowerOfTwo(let value):
            return "alignment must be a power of 2 (was \(value))"
        case .shiftExceedsBitWidth(let shift, let bitWidth):
            return "shift \(shift) exceeds carrier bit width \(bitWidth)"
        }
    }
}

// MARK: - Initializers

extension Binary.Alignment {
    /// Creates an alignment from a magnitude (power of 2).
    ///
    /// - Parameter magnitude: The alignment value. Must be a positive power of 2.
    /// - Throws: `Binary.Alignment.Error.notPowerOfTwo` if invalid.
    @inlinable
    public init(
        _ magnitude: Int
    ) throws(Binary.Alignment.Error) {
        guard magnitude > 0, magnitude & (magnitude - 1) == 0 else {
            throw .notPowerOfTwo(magnitude)
        }
        // Safe: magnitude is power of 2 > 0, so trailingZeroBitCount is in valid range
        self.shift = Binary.Shift(unchecked: UInt8(magnitude.trailingZeroBitCount))
    }
}

// MARK: - Unchecked Initializer (Internal)

extension Binary.Alignment {
    /// Creates an alignment without validation (internal use).
    @usableFromInline
    internal init(uncheckedShift: UInt8) {
        self.shift = Binary.Shift(unchecked: uncheckedShift)
    }
}

// MARK: - Common Values

extension Binary.Alignment {
    /// 1-byte alignment (no alignment requirement).
    public static let byte = Binary.Alignment(uncheckedShift: 0)
    public static let `1` = Binary.Alignment(uncheckedShift: 0)

    /// 2-byte alignment.
    public static let halfWord = Binary.Alignment(uncheckedShift: 1)
    public static let `2` = Binary.Alignment(uncheckedShift: 1)

    /// 4-byte alignment.
    public static let word = Binary.Alignment(uncheckedShift: 2)
    public static let `4` = Binary.Alignment(uncheckedShift: 2)

    /// 8-byte alignment.
    public static let doubleWord = Binary.Alignment(uncheckedShift: 3)
    public static let `8` = Binary.Alignment(uncheckedShift: 3)

    /// 16-byte alignment.
    public static let quadWord = Binary.Alignment(uncheckedShift: 4)
    public static let `16` = Binary.Alignment(uncheckedShift: 4)

    /// 512-byte alignment (legacy disk sector).
    public static let sector512 = Binary.Alignment(uncheckedShift: 9)
    public static let `512` = Binary.Alignment(uncheckedShift: 9)

    /// 1024-byte alignment.
    public static let `1024` = Binary.Alignment(uncheckedShift: 10)

    /// 4096-byte alignment (modern SSD sector, x86 page).
    public static let page4096 = Binary.Alignment(uncheckedShift: 12)
    public static let `4096` = Binary.Alignment(uncheckedShift: 12)

    /// 8192-byte alignment.
    public static let `8192` = Binary.Alignment(uncheckedShift: 13)

    /// 16384-byte alignment (Apple Silicon page).
    public static let page16384 = Binary.Alignment(uncheckedShift: 14)
    public static let `16384` = Binary.Alignment(uncheckedShift: 14)
}

// MARK: - Magnitude Access

extension Binary.Alignment {
    /// The alignment magnitude in the specified carrier type.
    ///
    /// Computes `2^shift` in the carrier ring.
    ///
    /// - Precondition: `shift < Carrier.bitWidth`
    @inlinable
    public func magnitude<Carrier: FixedWidthInteger>(
        as _: Carrier.Type = Carrier.self
    ) -> Carrier {
        shift.magnitude(as: Carrier.self)
    }

    /// The bitmask for extracting offset within an aligned block.
    ///
    /// Computes `(2^shift) - 1` in the carrier ring.
    ///
    /// - Precondition: `shift < Carrier.bitWidth`
    @inlinable
    public func mask<Carrier: FixedWidthInteger>(
        as _: Carrier.Type = Carrier.self
    ) -> Carrier {
        shift.mask(as: Carrier.self)
    }

    /// Validates that this alignment is usable with the given carrier type.
    ///
    /// - Throws: `Binary.Alignment.Error.shiftExceedsBitWidth` if shift >= bit width.
    @inlinable
    public func validated<Carrier: FixedWidthInteger>(
        for _: Carrier.Type
    ) throws(Binary.Alignment.Error) -> Self {
        guard Int(shift.rawValue) < Carrier.bitWidth else {
            throw .shiftExceedsBitWidth(shift: shift.rawValue, bitWidth: Carrier.bitWidth)
        }
        return self
    }
}

// MARK: - Typed Position Operations

extension Binary.Alignment {
    /// Checks if a typed position is aligned.
    ///
    /// Computes the alignment check in the position's scalar ring.
    ///
    /// - Precondition: `shift < Scalar.bitWidth`
    @inlinable
    public func isAligned<Scalar: FixedWidthInteger, Space>(
        _ value: Binary.Position<Scalar, Space>
    ) -> Bool {
        let mask: Scalar = shift.mask()
        return value._rawValue & mask == 0
    }

    /// Rounds a typed position up to the nearest alignment boundary.
    ///
    /// Computes the alignment in the position's scalar ring using overflow-safe operators.
    ///
    /// - Precondition: `shift < Scalar.bitWidth`
    @inlinable
    public func alignUp<Scalar: FixedWidthInteger, Space>(
        _ value: Binary.Position<Scalar, Space>
    ) -> Binary.Position<Scalar, Space> {
        let mask: Scalar = shift.mask()
        return Binary.Position((value._rawValue &+ mask) & ~mask)
    }

    /// Rounds a typed position down to the nearest alignment boundary.
    ///
    /// Computes the alignment in the position's scalar ring using overflow-safe operators.
    ///
    /// - Precondition: `shift < Scalar.bitWidth`
    @inlinable
    public func alignDown<Scalar: FixedWidthInteger, Space>(
        _ value: Binary.Position<Scalar, Space>
    ) -> Binary.Position<Scalar, Space> {
        let mask: Scalar = shift.mask()
        return Binary.Position(value._rawValue & ~mask)
    }
}

// MARK: - Typed Position Operations (Throwing)

extension Binary.Alignment {
    /// Checks if a typed position is aligned, with shift validation.
    ///
    /// - Throws: `Binary.Alignment.Error.shiftExceedsBitWidth` if shift >= scalar bit width.
    @inlinable
    public func isAlignedThrowing<Scalar: FixedWidthInteger, Space>(
        _ value: Binary.Position<Scalar, Space>
    ) throws(Binary.Alignment.Error) -> Bool {
        guard Int(shift.rawValue) < Scalar.bitWidth else {
            throw .shiftExceedsBitWidth(shift: shift.rawValue, bitWidth: Scalar.bitWidth)
        }
        let mask: Scalar = shift.mask()
        return value._rawValue & mask == 0
    }

    /// Rounds a typed position up, with shift validation.
    ///
    /// - Throws: `Binary.Alignment.Error.shiftExceedsBitWidth` if shift >= scalar bit width.
    @inlinable
    public func alignUpThrowing<Scalar: FixedWidthInteger, Space>(
        _ value: Binary.Position<Scalar, Space>
    ) throws(Binary.Alignment.Error) -> Binary.Position<Scalar, Space> {
        guard Int(shift.rawValue) < Scalar.bitWidth else {
            throw .shiftExceedsBitWidth(shift: shift.rawValue, bitWidth: Scalar.bitWidth)
        }
        let mask: Scalar = shift.mask()
        return Binary.Position((value._rawValue &+ mask) & ~mask)
    }

    /// Rounds a typed position down, with shift validation.
    ///
    /// - Throws: `Binary.Alignment.Error.shiftExceedsBitWidth` if shift >= scalar bit width.
    @inlinable
    public func alignDownThrowing<Scalar: FixedWidthInteger, Space>(
        _ value: Binary.Position<Scalar, Space>
    ) throws(Binary.Alignment.Error) -> Binary.Position<Scalar, Space> {
        guard Int(shift.rawValue) < Scalar.bitWidth else {
            throw .shiftExceedsBitWidth(shift: shift.rawValue, bitWidth: Scalar.bitWidth)
        }
        let mask: Scalar = shift.mask()
        return Binary.Position(value._rawValue & ~mask)
    }
}

// MARK: - Pointer Operations

extension Binary.Alignment {
    /// Checks if a pointer is aligned.
    ///
    /// - Parameter pointer: The pointer to check.
    /// - Returns: `true` if the pointer address is a multiple of this alignment.
    @inlinable
    public func isAligned(_ pointer: UnsafeRawPointer) -> Bool {
        let address = UInt(bitPattern: pointer)
        let mask: UInt = shift.mask()
        return address & mask == 0
    }
}

// MARK: - Comparable

extension Binary.Alignment: Comparable {
    @inlinable
    public static func < (lhs: Binary.Alignment, rhs: Binary.Alignment) -> Bool {
        lhs.shift < rhs.shift
    }
}

// MARK: - CustomStringConvertible

extension Binary.Alignment: CustomStringConvertible {
    public var description: String {
        let mag: Int = magnitude()
        return "\(mag)"
    }
}
