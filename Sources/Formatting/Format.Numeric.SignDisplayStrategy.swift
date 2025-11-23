//
//  Format.Numeric.SignDisplayStrategy.swift
//  swift-standards
//
//  Sign display strategies for numeric formatting
//

extension Format.Numeric {
    /// Sign display strategy
    public enum SignDisplayStrategy: Sendable {
        /// Show sign for negative numbers only (default)
        case automatic

        /// Never show sign
        case never

        /// Always show sign
        case always(includingZero: Bool = false)
    }
}

// MARK: - Style Extension

extension Format.Numeric.Style {
    /// Configure sign display
    ///
    /// ## Examples
    ///
    /// ```swift
    /// 42.formatted(.number.sign(strategy: .always()))                      // "+42"
    /// (-42).formatted(.number.sign(strategy: .always()))                   // "-42"
    /// 0.formatted(.number.sign(strategy: .always(includingZero: true)))    // "+0"
    /// ```
    public func sign(strategy: Format.Numeric.SignDisplayStrategy) -> Self {
        var copy = self
        copy.signDisplayStrategy = strategy
        return copy
    }
}
