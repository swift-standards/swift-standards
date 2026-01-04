// Binary.Format.Bytes.Unit.swift
// Individual byte unit definitions.

extension Binary.Format.Bytes {
    /// A single unit of byte measurement.
    ///
    /// Represents units from bytes to petabytes in both decimal (SI) and
    /// binary (IEC) systems. Each unit knows its multiplier and symbols
    /// for both naming conventions.
    public struct Unit: Sendable, Equatable {
        /// The multiplier for this unit relative to bytes.
        public let multiplier: Int

        /// Symbol for decimal (SI) system (e.g., "KB").
        public let decimalSymbol: String

        /// Symbol for binary (IEC) system (e.g., "KiB").
        public let binarySymbol: String

        @usableFromInline
        init(multiplier: Int, decimalSymbol: String, binarySymbol: String) {
            self.multiplier = multiplier
            self.decimalSymbol = decimalSymbol
            self.binarySymbol = binarySymbol
        }
    }
}

// MARK: - Standard Units

extension Binary.Format.Bytes.Unit {
    /// Bytes (B) - base unit.
    public static let bytes = Self(
        multiplier: 1,
        decimalSymbol: "B",
        binarySymbol: "B"
    )

    /// Kilobytes (1,000 bytes) / Kibibytes (1,024 bytes).
    public static let kilobytes = Self(
        multiplier: 1_000,
        decimalSymbol: "KB",
        binarySymbol: "KiB"
    )

    /// Megabytes (1,000,000 bytes) / Mebibytes (1,048,576 bytes).
    public static let megabytes = Self(
        multiplier: 1_000_000,
        decimalSymbol: "MB",
        binarySymbol: "MiB"
    )

    /// Gigabytes (1,000,000,000 bytes) / Gibibytes (1,073,741,824 bytes).
    public static let gigabytes = Self(
        multiplier: 1_000_000_000,
        decimalSymbol: "GB",
        binarySymbol: "GiB"
    )

    /// Terabytes (10^12 bytes) / Tebibytes (2^40 bytes).
    public static let terabytes = Self(
        multiplier: 1_000_000_000_000,
        decimalSymbol: "TB",
        binarySymbol: "TiB"
    )

    /// Petabytes (10^15 bytes) / Pebibytes (2^50 bytes).
    public static let petabytes = Self(
        multiplier: 1_000_000_000_000_000,
        decimalSymbol: "PB",
        binarySymbol: "PiB"
    )
}

// MARK: - Binary-Specific Units

extension Binary.Format.Bytes.Unit {
    /// Kibibytes (1,024 bytes).
    public static let kibibytes = Self(
        multiplier: 1_024,
        decimalSymbol: "KB",
        binarySymbol: "KiB"
    )

    /// Mebibytes (1,048,576 bytes).
    public static let mebibytes = Self(
        multiplier: 1_048_576,
        decimalSymbol: "MB",
        binarySymbol: "MiB"
    )

    /// Gibibytes (1,073,741,824 bytes).
    public static let gibibytes = Self(
        multiplier: 1_073_741_824,
        decimalSymbol: "GB",
        binarySymbol: "GiB"
    )

    /// Tebibytes (1,099,511,627,776 bytes).
    public static let tebibytes = Self(
        multiplier: 1_099_511_627_776,
        decimalSymbol: "TB",
        binarySymbol: "TiB"
    )

    /// Pebibytes (1,125,899,906,842,624 bytes).
    public static let pebibytes = Self(
        multiplier: 1_125_899_906_842_624,
        decimalSymbol: "PB",
        binarySymbol: "PiB"
    )
}
