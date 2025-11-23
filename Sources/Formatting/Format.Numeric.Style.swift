//
//  Format.Numeric.Style.swift
//  swift-standards
//
//  Fluent API for numeric formatting
//

extension Format.Numeric {
    /// Fluent numeric format style with builder pattern
    ///
    /// Provides a chainable API for configuring numeric formatting,
    /// matching Foundation's FormatStyle pattern.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// 42.formatted(.number)  // "42"
    /// 3.14159.formatted(.number.precision(.fractionLength(2)))  // "3.14"
    /// 1234567.formatted(.number.grouping(.always))  // "1,234,567"
    /// ```
    public struct Style: Sendable {
        internal var maximumFractionDigits: Int?
        internal var minimumFractionDigits: Int?
        internal var groupingSeparator: String?
        internal var decimalSeparator: String
        internal var notation: Format.Numeric.Notation
        internal var signDisplayStrategy: Format.Numeric.SignDisplayStrategy
        internal var roundingRule: FloatingPointRoundingRule?
        internal var roundingIncrement: Double?
        internal var decimalSeparatorStrategy: Format.Numeric.DecimalSeparatorStrategy
        internal var scale: Double
        internal var significantDigits: (min: Int?, max: Int?)?
        internal var integerLength: (min: Int?, max: Int?)?

        internal init(
            maximumFractionDigits: Int? = nil,
            minimumFractionDigits: Int? = nil,
            groupingSeparator: String? = nil,
            decimalSeparator: String = ".",
            notation: Format.Numeric.Notation = .automatic,
            signDisplayStrategy: Format.Numeric.SignDisplayStrategy = .automatic,
            roundingRule: FloatingPointRoundingRule? = nil,
            roundingIncrement: Double? = nil,
            decimalSeparatorStrategy: Format.Numeric.DecimalSeparatorStrategy = .automatic,
            scale: Double = 1.0,
            significantDigits: (min: Int?, max: Int?)? = nil,
            integerLength: (min: Int?, max: Int?)? = nil
        ) {
            self.maximumFractionDigits = maximumFractionDigits
            self.minimumFractionDigits = minimumFractionDigits
            self.groupingSeparator = groupingSeparator
            self.decimalSeparator = decimalSeparator
            self.notation = notation
            self.signDisplayStrategy = signDisplayStrategy
            self.roundingRule = roundingRule
            self.roundingIncrement = roundingIncrement
            self.decimalSeparatorStrategy = decimalSeparatorStrategy
            self.scale = scale
            self.significantDigits = significantDigits
            self.integerLength = integerLength
        }
    }
}

// MARK: - Static Entry Point

extension Format.Numeric.Style {
    /// Default numeric style
    ///
    /// Entry point for fluent numeric formatting.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 42.formatted(.number)  // "42"
    /// 100.0.formatted(.number)  // "100"
    /// ```
    public static var number: Format.Numeric.Style {
        Format.Numeric.Style()
    }
}

// MARK: - Precision

// Note: Precision struct and extensions are defined in Format.Numeric.Precision+Extensions.swift

extension Format.Numeric.Style {
    /// Configure precision
    ///
    /// ## Examples
    ///
    /// ```swift
    /// 3.14159.formatted(.number.precision(.fractionLength(2)))      // "3.14"
    /// 42.0.formatted(.number.precision(.fractionLength(2...)))      // "42.00"
    /// 3.14159.formatted(.number.precision(.fractionLength(2...4)))  // "3.1416"
    /// 1234.formatted(.number.precision(.significantDigits(3)))     // "1230"
    /// 42.formatted(.number.precision(.integerLength(4)))            // "0042"
    /// ```
    public func precision(_ precision: Precision) -> Self {
        var copy = self
        copy.minimumFractionDigits = precision.min
        copy.maximumFractionDigits = precision.max
        copy.significantDigits = precision.significantDigits
        copy.integerLength = precision.integerLength
        return copy
    }
}

// MARK: - Grouping

extension Format.Numeric.Style {
    /// Grouping policy for thousands separators
    public enum Grouping {
        /// Always use grouping separator
        case always

        /// Never use grouping separator
        case never
    }

    /// Configure grouping separator
    ///
    /// ## Examples
    ///
    /// ```swift
    /// 1234567.formatted(.number.grouping(.always))                      // "1,234,567"
    /// 1234567.formatted(.number.grouping(.always, separator: "."))     // "1.234.567"
    /// ```
    public func grouping(_ policy: Grouping, separator: String = ",") -> Self {
        var copy = self
        switch policy {
        case .always:
            copy.groupingSeparator = separator
        case .never:
            copy.groupingSeparator = nil
        }
        return copy
    }
}

// MARK: - Decimal Separator Character

extension Format.Numeric.Style {
    /// Configure decimal separator character
    ///
    /// ## Example
    ///
    /// ```swift
    /// 3.14.formatted(.number.decimalSeparator(","))  // "3,14"
    /// ```
    public func decimalSeparator(_ separator: String) -> Self {
        var copy = self
        copy.decimalSeparator = separator
        return copy
    }
}

// MARK: - Formatting

extension Format.Numeric.Style {
    /// Format a floating-point value
    public func format<Value: BinaryFloatingPoint>(_ value: Value) -> String {
        let formatter = Format.Numeric.Clean(
            maximumFractionDigits: maximumFractionDigits,
            minimumFractionDigits: minimumFractionDigits,
            groupingSeparator: groupingSeparator,
            decimalSeparator: decimalSeparator
        )
        return formatter.format(value)
    }

    /// Format an integer value
    public func format<Value: BinaryInteger>(_ value: Value) -> String {
        let formatter = Format.Numeric.Clean(
            maximumFractionDigits: maximumFractionDigits,
            minimumFractionDigits: minimumFractionDigits,
            groupingSeparator: groupingSeparator,
            decimalSeparator: decimalSeparator
        )
        return formatter.format(value)
    }
}

// MARK: - Value Extensions

extension BinaryFloatingPoint {
    /// Formats this floating-point value using the numeric format style.
    ///
    /// - Parameter style: The format style to use
    /// - Returns: A formatted string representation
    ///
    /// ## Example
    ///
    /// ```swift
    /// 3.14159.formatted(.number)  // "3.14159"
    /// 100.0.formatted(.number)    // "100"
    /// ```
    public func formatted(_ style: Format.Numeric.Style) -> String {
        style.format(self)
    }
}

extension BinaryInteger {
    /// Formats this integer value using the numeric format style.
    ///
    /// - Parameter style: The format style to use
    /// - Returns: A formatted string representation
    ///
    /// ## Example
    ///
    /// ```swift
    /// 42.formatted(.number)  // "42"
    /// 1234567.formatted(.number.grouping(.always))  // "1,234,567"
    /// ```
    public func formatted(_ style: Format.Numeric.Style) -> String {
        style.format(self)
    }
}
