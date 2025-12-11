// Range.swift
// swift-standards
//
// Extensions for Swift standard library Range

extension Range where Bound: Strideable {
    /// Returns the overlapping range between this range and another, or `nil` if they don't overlap.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let a = 1..<5
    /// let b = 3..<7
    /// a.overlap(b)  // 3..<5
    ///
    /// let c = 1..<3
    /// let d = 5..<7
    /// c.overlap(d)  // nil
    /// ```
    public func overlap(_ other: Range<Bound>) -> Range<Bound>? {
        let lower = Swift.max(lowerBound, other.lowerBound)
        let upper = Swift.min(upperBound, other.upperBound)

        guard lower < upper else { return nil }
        return lower..<upper
    }

    /// Returns the range restricted to the specified bounds, or `nil` if completely outside bounds.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let range = 1..<10
    /// range.clamped(to: 3..<7)   // 3..<7
    /// range.clamped(to: 5..<15)  // 5..<10
    /// range.clamped(to: 20..<30) // nil
    /// ```
    public func clamped(to bounds: Range<Bound>) -> Range<Bound>? {
        overlap(bounds)
    }

    /// Splits the range into two ranges at the specified point.
    ///
    /// Returns a tuple containing the lower range (from start to point) and upper range (from point to end).
    /// Returns `nil` if the point is outside the range or at the bounds.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let range = 1..<10
    /// range.split(at: 5)  // (1..<5, 5..<10)
    /// range.split(at: 1)  // nil
    /// range.split(at: 15) // nil
    /// ```
    public func split(at point: Bound) -> (lower: Range<Bound>, upper: Range<Bound>)? {
        guard contains(point), point != lowerBound else { return nil }
        return (lowerBound..<point, point..<upperBound)
    }
}
