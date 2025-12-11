// Format.Numeric.SignDisplayStrategy.swift
// Sign display strategies for numeric formatting.

extension Format.Numeric {
    /// Strategy controlling when and how plus/minus signs are displayed.
    ///
    /// Use this to show positive signs explicitly, hide negative signs, or use the default behavior (negative only). Configure whether zero is treated as positive when always showing signs.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 42.formatted(.number.sign(strategy: .always()))     // "+42"
    /// (-42).formatted(.number.sign(strategy: .never))     // "42"
    /// ```
    public enum SignDisplayStrategy: Sendable, Equatable {
        /// Displays minus sign for negatives, no sign for positives (default behavior)
        case automatic

        /// Hides sign for all numbers, even negatives
        case never

        /// Shows sign for all numbers: plus for positives, minus for negatives
        ///
        /// - Parameter includingZero: When `true`, zero displays as "+0"; when `false`, zero has no sign
        case always(includingZero: Bool = false)
    }
}
