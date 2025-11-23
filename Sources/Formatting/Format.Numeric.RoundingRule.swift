//
//  Format.Numeric.RoundingRule.swift
//  swift-standards
//
//  Rounding rules for numeric formatting
//

// MARK: - Style Extension

extension Format.Numeric.Style {
    /// Configure rounding rule
    ///
    /// ## Examples
    ///
    /// ```swift
    /// 1.5.formatted(.number.rounded(rule: .up))                                    // "2"
    /// 1.5.formatted(.number.rounded(rule: .toNearestOrEven))                       // "2"
    /// 1.23.formatted(.number.rounded(rule: .toNearestOrAwayFromZero, increment: 0.5))  // "1.0"
    /// ```
    public func rounded(rule: FloatingPointRoundingRule, increment: Double? = nil) -> Self {
        var copy = self
        copy.roundingRule = rule
        copy.roundingIncrement = increment
        return copy
    }
}
