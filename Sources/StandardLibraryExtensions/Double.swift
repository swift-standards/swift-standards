// Double.swift
// swift-standards
//
// Extensions for Swift standard library Double

extension Double {
    /// Returns the value rounded to the specified number of decimal places.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 3.14159.rounded(to: 2)  // 3.14
    /// 2.71828.rounded(to: 3)  // 2.718
    /// ```
    public func rounded(to places: Int) -> Double {
        guard places >= 0 else { return self }
        var divisor: Double = 1.0
        for _ in 0..<places {
            divisor *= 10.0
        }
        return (self * divisor).rounded() / divisor
    }
}
