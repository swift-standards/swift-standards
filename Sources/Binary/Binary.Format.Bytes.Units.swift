// Binary.Format.Bytes.Units.swift
// Unit system selection for byte formatting.

extension Binary.Format.Bytes {
    /// The unit system for byte formatting.
    ///
    /// Choose between decimal (SI) units using base 1000, or binary (IEC)
    /// units using base 1024.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 1000.formatted(Binary.Format.bytes(.decimal))  // "1 KB"
    /// 1024.formatted(Binary.Format.bytes(.binary))   // "1 KiB"
    /// ```
    public enum Units: Sendable, Equatable {
        /// Decimal (SI) units: KB, MB, GB, TB, PB (base 1000).
        ///
        /// Standard units used in most consumer contexts, networking,
        /// and storage marketing.
        case decimal

        /// Binary (IEC) units: KiB, MiB, GiB, TiB, PiB (base 1024).
        ///
        /// Precise units for computing contexts where powers of 2 matter,
        /// following IEC 80000-13 standard.
        case binary

        /// The base multiplier for this unit system.
        @inlinable
        public var base: Int {
            switch self {
            case .decimal: return 1000
            case .binary: return 1024
            }
        }

        /// Returns the appropriate symbol for a unit in this system.
        @inlinable
        public func symbol(for unit: Unit) -> String {
            switch self {
            case .decimal: return unit.decimalSymbol
            case .binary: return unit.binarySymbol
            }
        }
    }
}
