// Comparable.swift
// swift-standards
//
// Pure Swift comparable utilities

extension Comparable {
    /// Returns the value constrained to the specified range.
    ///
    /// If the value is within the range, returns it unchanged. If below the minimum, returns the minimum.
    /// If above the maximum, returns the maximum.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 5.clamped(to: 0...10)   // 5
    /// 15.clamped(to: 0...10)  // 10
    /// (-5).clamped(to: 0...10) // 0
    /// ```
    public func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
