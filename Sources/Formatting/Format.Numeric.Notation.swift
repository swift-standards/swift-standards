// Format.Numeric.Notation.swift
// Notation styles for numeric formatting.

extension Format.Numeric {
    /// Notation style controlling how numbers are represented.
    ///
    /// Choose between automatic decimal representation, compact notation with suffixes (K, M, B), or scientific notation with exponents. Use this to make large numbers more readable or to display values in scientific format.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 1000.formatted(.number.notation(.compactName))   // "1K"
    /// 1234.formatted(.number.notation(.scientific))    // "1.234E3"
    /// ```
    public enum Notation: Sendable, Equatable {
        /// Standard decimal representation without abbreviation
        case automatic

        /// Abbreviates large numbers with K, M, or B suffix
        ///
        /// Examples: 1,000 → "1K", 1,000,000 → "1M", 1,000,000,000 → "1B"
        case compactName

        /// Displays numbers in scientific notation with exponent
        ///
        /// Examples: 1234 → "1.234E3", 0.00123 → "1.23E-3"
        case scientific
    }
}
