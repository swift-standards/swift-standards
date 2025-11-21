// MARK: - Int Zero-Padding Utilities

extension Int {
    /// Fast two-digit zero-padded formatting (00-99)
    ///
    /// Formats integers from 0-99 with leading zeros.
    /// Uses arithmetic instead of conditionals for better performance.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 5.zeroPaddedTwoDigits()   // "05"
    /// 42.zeroPaddedTwoDigits()  // "42"
    /// ```
    ///
    /// - Returns: Two-character string with leading zero if needed
    public func zeroPaddedTwoDigits() -> String {
        let tens = self / 10
        let ones = self % 10
        return "\(tens)\(ones)"
    }

    /// Fast four-digit zero-padded formatting (0000-9999)
    ///
    /// Formats integers from 0-9999 with leading zeros.
    /// Uses arithmetic instead of conditionals for better performance.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 42.zeroPaddedFourDigits()    // "0042"
    /// 2024.zeroPaddedFourDigits()  // "2024"
    /// ```
    ///
    /// - Returns: Four-character string with leading zeros if needed
    public func zeroPaddedFourDigits() -> String {
        let thousands = self / 1000
        let hundreds = (self % 1000) / 100
        let tens = (self % 100) / 10
        let ones = self % 10
        return "\(thousands)\(hundreds)\(tens)\(ones)"
    }
}
