// Binary.Format.Bytes.swift
// Formatting for byte counts.

extension Binary.Format {
    /// Format style for converting byte counts to human-readable strings.
    ///
    /// Automatically selects appropriate units (B, KB, MB, GB, etc.) based on
    /// magnitude. Supports both decimal (SI) and binary (IEC) unit systems.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 512.formatted(Binary.Format.bytes)                           // "512 B"
    /// 1500.formatted(Binary.Format.bytes)                          // "1.5 KB"
    /// 1500.formatted(Binary.Format.bytes(.binary))                 // "1.46 KiB"
    /// 1024.formatted(Binary.Format.bytes.precision(0))             // "1 KB"
    /// 1024.formatted(Binary.Format.bytes.notation(.compactName))   // "1.02KB"
    /// ```
    public struct Bytes: Sendable {
        /// The unit system (decimal or binary).
        public let units: Units

        /// The notation style (spaced or compact).
        public let notation: Notation

        /// Number of decimal places to display, or nil for automatic.
        public let precisionDigits: Int?

        /// Whether to include the unit suffix.
        public let includeUnit: Bool

        @usableFromInline
        init(
            units: Units = .decimal,
            notation: Notation = .spaced,
            precisionDigits: Int? = nil,
            includeUnit: Bool = true
        ) {
            self.units = units
            self.notation = notation
            self.precisionDigits = precisionDigits
            self.includeUnit = includeUnit
        }

        /// Creates a byte format with default settings.
        ///
        /// Defaults: decimal units, spaced notation, automatic precision.
        public init() {
            self.units = .decimal
            self.notation = .spaced
            self.precisionDigits = nil
            self.includeUnit = true
        }
    }
}

// MARK: - Static Constructors

extension Binary.Format.Bytes {
    /// Default byte format (decimal units, spaced notation).
    @inlinable
    public static var bytes: Self { .init() }

    /// Creates a format with the specified unit system.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 1024.formatted(Binary.Format.bytes(.decimal))  // "1.02 KB"
    /// 1024.formatted(Binary.Format.bytes(.binary))   // "1 KiB"
    /// ```
    ///
    /// - Parameter units: The unit system to use.
    /// - Returns: A new format configured with the specified units.
    @inlinable
    public static func bytes(_ units: Units) -> Self {
        .init(units: units)
    }
}

// MARK: - Chaining Methods

extension Binary.Format.Bytes {
    /// Returns a format with the specified unit system.
    @inlinable
    public func units(_ units: Units) -> Self {
        .init(
            units: units,
            notation: notation,
            precisionDigits: precisionDigits,
            includeUnit: includeUnit
        )
    }

    /// Returns a format with the specified notation style.
    @inlinable
    public func notation(_ notation: Notation) -> Self {
        .init(
            units: units,
            notation: notation,
            precisionDigits: precisionDigits,
            includeUnit: includeUnit
        )
    }

    /// Returns a format with the specified decimal precision.
    ///
    /// - Parameter digits: Number of decimal places to display.
    @inlinable
    public func precision(_ digits: Int) -> Self {
        .init(
            units: units,
            notation: notation,
            precisionDigits: digits,
            includeUnit: includeUnit
        )
    }

    /// Returns a format that omits the unit suffix.
    @inlinable
    public func withoutUnit() -> Self {
        .init(
            units: units,
            notation: notation,
            precisionDigits: precisionDigits,
            includeUnit: false
        )
    }
}

// MARK: - Format Method

extension Binary.Format.Bytes {
    /// Formats a byte count to a human-readable string.
    ///
    /// - Parameter bytes: The byte count to format.
    /// - Returns: A formatted string representation.
    public func format<T: BinaryInteger>(_ bytes: T) -> String {
        let absBytes = bytes < 0 ? -Int(bytes) : Int(bytes)
        let sign = bytes < 0 ? "-" : ""

        // Select appropriate unit and calculate display value
        let (value, symbol) = selectUnit(for: absBytes)

        // Format the numeric part
        var numericString = formatNumber(value)

        // Apply sign
        numericString = sign + numericString

        // Apply unit if needed
        guard includeUnit else { return numericString }

        return numericString + notation.separator + symbol
    }

    /// Selects the appropriate unit and calculates the display value.
    @usableFromInline
    func selectUnit(for bytes: Int) -> (Double, String) {
        // Unit thresholds in descending order
        let thresholds: [(threshold: Int, symbol: String)]

        switch units {
        case .decimal:
            thresholds = [
                (1_000_000_000_000_000, "PB"),
                (1_000_000_000_000, "TB"),
                (1_000_000_000, "GB"),
                (1_000_000, "MB"),
                (1_000, "KB"),
                (1, "B")
            ]
        case .binary:
            thresholds = [
                (1_125_899_906_842_624, "PiB"),
                (1_099_511_627_776, "TiB"),
                (1_073_741_824, "GiB"),
                (1_048_576, "MiB"),
                (1_024, "KiB"),
                (1, "B")
            ]
        }

        for (threshold, symbol) in thresholds {
            if bytes >= threshold {
                let value = Double(bytes) / Double(threshold)
                return (value, symbol)
            }
        }

        return (Double(bytes), "B")
    }

    /// Formats the numeric value with appropriate precision.
    @usableFromInline
    func formatNumber(_ value: Double) -> String {
        if let precision = precisionDigits {
            return formatWithPrecision(value, precision: precision)
        }

        // Auto-precision: show decimals only when meaningful
        if value == value.rounded() {
            return "\(Int(value))"
        }

        // Default to 2 decimal places, strip trailing zeros
        let formatted = formatWithPrecision(value, precision: 2)
        return stripTrailingZeros(formatted)
    }

    /// Formats a value with specified decimal precision.
    @usableFromInline
    func formatWithPrecision(_ value: Double, precision: Int) -> String {
        guard precision > 0 else {
            return "\(Int(value.rounded()))"
        }

        var multiplier = 1.0
        for _ in 0..<precision {
            multiplier *= 10.0
        }

        let rounded = (value * multiplier).rounded() / multiplier

        // Build the string representation
        let intPart = Int(rounded)
        let fracPart = rounded - Double(intPart)

        if precision == 0 || fracPart == 0 {
            return "\(intPart)"
        }

        // Calculate fractional digits
        var fracValue = fracPart
        var fracString = ""
        for _ in 0..<precision {
            fracValue *= 10
            let digit = Int(fracValue) % 10
            fracString += "\(digit)"
        }

        return "\(intPart).\(fracString)"
    }

    /// Removes trailing zeros after decimal point.
    @usableFromInline
    func stripTrailingZeros(_ string: String) -> String {
        guard string.contains(".") else { return string }

        var result = string
        while result.hasSuffix("0") {
            result.removeLast()
        }
        if result.hasSuffix(".") {
            result.removeLast()
        }
        return result
    }
}

// MARK: - Binary.Format Static Properties

extension Binary.Format {
    /// Default byte format (decimal units, spaced notation).
    @inlinable
    public static var bytes: Bytes { .bytes }

    /// Creates a byte format with the specified unit system.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 1024.formatted(Binary.Format.bytes(.decimal))  // "1.02 KB"
    /// 1024.formatted(Binary.Format.bytes(.binary))   // "1 KiB"
    /// ```
    @inlinable
    public static func bytes(_ units: Bytes.Units) -> Bytes {
        .bytes(units)
    }
}

// MARK: - BinaryInteger Extension

extension BinaryInteger {
    /// Formats this integer as a byte count.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 1024.formatted(Binary.Format.bytes)             // "1.02 KB"
    /// 1024.formatted(Binary.Format.bytes(.binary))    // "1 KiB"
    /// ```
    @inlinable
    public func formatted(_ format: Binary.Format.Bytes) -> String {
        format.format(self)
    }
}
