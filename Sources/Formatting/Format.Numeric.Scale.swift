//
//  Format.Numeric.Scale.swift
//  swift-standards
//
//  Scale multiplier for numeric formatting
//

// MARK: - Style Extension

extension Format.Numeric.Style {
    /// Scale the number by a factor before formatting
    ///
    /// Useful for percentage formatting (multiply by 100) or unit conversions.
    ///
    /// ## Examples
    ///
    /// ```swift
    /// 0.42.formatted(.number.scale(100))                               // "42"
    /// 0.425.formatted(.number.scale(100).precision(.fractionLength(1)))  // "42.5"
    /// ```
    public func scale(_ factor: Double) -> Self {
        var copy = self
        copy.scale = factor
        return copy
    }
}
