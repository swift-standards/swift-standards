// Format.Numeric.DecimalSeparatorStrategy.swift
// Decimal separator display strategies for numeric formatting.

extension Format.Numeric {
    /// Strategy controlling when the decimal separator is displayed.
    ///
    /// Use this to force the decimal point to appear even for whole numbers, or to only show it when fractional digits are present. Useful for maintaining consistent formatting in tables or UI displays.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 42.formatted(.number.decimalSeparator(strategy: .always))    // "42."
    /// 42.5.formatted(.number.decimalSeparator(strategy: .always))  // "42.5"
    /// ```
    public enum DecimalSeparatorStrategy: Sendable, Equatable {
        /// Displays decimal point only when fractional digits exist (default behavior)
        case automatic

        /// Forces decimal point to display even for whole numbers
        case always
    }
}
