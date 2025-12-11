// Numeric.swift
// swift-standards
//
// Extensions for Swift standard library Numeric protocol

extension Sequence where Element: Numeric {
    /// Returns the product of all elements in the sequence.
    ///
    /// ## Example
    ///
    /// ```swift
    /// [1, 2, 3, 4, 5].product()  // 120
    /// [2, 3, 4].product()        // 24
    /// [].product()               // 1
    /// ```
    public func product() -> Element {
        reduce(1, *)
    }
}

extension Sequence where Element: BinaryInteger {
    /// Returns the arithmetic mean of all elements, or `nil` for empty sequences.
    ///
    /// ## Example
    ///
    /// ```swift
    /// [1, 2, 3, 4, 5].mean()  // 3
    /// [10, 20, 30].mean()     // 20
    /// [].mean()               // nil
    /// ```
    public func mean() -> Element? {
        let elements = Array(self)
        guard !elements.isEmpty else { return nil }
        return elements.reduce(.zero, +) / Element(elements.count)
    }
}

extension Sequence where Element: BinaryFloatingPoint {
    /// Returns the arithmetic mean of all elements, or `nil` for empty sequences.
    ///
    /// ## Example
    ///
    /// ```swift
    /// [1.0, 2.0, 3.0, 4.0, 5.0].mean()  // 3.0
    /// [10.5, 20.5, 30.5].mean()         // 20.5
    /// [].mean()                         // nil
    /// ```
    public func mean() -> Element? {
        var sum: Element = 0
        var count: Element = 0

        for element in self {
            sum += element
            count += 1
        }

        guard count > 0 else { return nil }
        return sum / count
    }
}
