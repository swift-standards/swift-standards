// ClosedRange.swift
// swift-standards
//
// Extensions for Swift standard library ClosedRange

extension ClosedRange where Bound: Strideable {
    /// Returns the overlapping range between this range and another, or `nil` if they don't overlap.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let a = 1...5
    /// let b = 3...7
    /// a.overlap(b)  // 3...5
    ///
    /// let c = 1...3
    /// let d = 5...7
    /// c.overlap(d)  // nil
    /// ```
    public func overlap(_ other: ClosedRange<Bound>) -> ClosedRange<Bound>? {
        let lower = Swift.max(lowerBound, other.lowerBound)
        let upper = Swift.min(upperBound, other.upperBound)

        guard lower <= upper else { return nil }
        return lower...upper
    }

    /// Returns the range restricted to the specified bounds, or `nil` if completely outside bounds.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let range = 1...10
    /// range.clamped(to: 3...7)   // 3...7
    /// range.clamped(to: 5...15)  // 5...10
    /// range.clamped(to: 20...30) // nil
    /// ```
    public func clamped(to bounds: ClosedRange<Bound>) -> ClosedRange<Bound>? {
        overlap(bounds)
    }
}
