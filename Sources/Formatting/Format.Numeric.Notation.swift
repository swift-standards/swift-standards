//
//  Format.Numeric.Notation.swift
//  swift-standards
//
//  Notation styles for numeric formatting
//

extension Format.Numeric {
    /// Notation style for numeric formatting
    public enum Notation: Sendable {
        /// Automatic notation (default)
        case automatic

        /// Compact notation (1K, 1M, 1B)
        case compactName

        /// Scientific notation (1E3)
        case scientific
    }
}

// MARK: - Style Extension

extension Format.Numeric.Style {
    /// Configure notation style
    ///
    /// ## Examples
    ///
    /// ```swift
    /// 1000.formatted(.number.notation(.compactName))     // "1K"
    /// 1234.formatted(.number.notation(.scientific))      // "1.234E3"
    /// ```
    public func notation(_ notation: Format.Numeric.Notation) -> Self {
        var copy = self
        copy.notation = notation
        return copy
    }
}
