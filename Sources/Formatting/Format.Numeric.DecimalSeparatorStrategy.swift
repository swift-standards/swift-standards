//
//  Format.Numeric.DecimalSeparatorStrategy.swift
//  swift-standards
//
//  Decimal separator display strategies
//

extension Format.Numeric {
    /// Decimal separator display strategy
    public enum DecimalSeparatorStrategy: Sendable {
        /// Show decimal separator only when needed (default)
        case automatic

        /// Always show decimal separator
        case always
    }
}

// MARK: - Style Extension

extension Format.Numeric.Style {
    /// Configure decimal separator display strategy
    ///
    /// ## Example
    ///
    /// ```swift
    /// 42.formatted(.number.decimalSeparator(strategy: .always))    // "42."
    /// 42.5.formatted(.number.decimalSeparator(strategy: .always))  // "42.5"
    /// ```
    public func decimalSeparator(strategy: Format.Numeric.DecimalSeparatorStrategy) -> Self {
        var copy = self
        copy.decimalSeparatorStrategy = strategy
        return copy
    }
}
