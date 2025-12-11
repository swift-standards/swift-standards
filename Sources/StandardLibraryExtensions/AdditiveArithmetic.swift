// AdditiveArithmetic.swift
// swift-standards
//
// Extensions for Swift standard library AdditiveArithmetic protocol

extension Sequence where Element: AdditiveArithmetic {
    /// Returns the sum of all elements in the sequence.
    ///
    /// ## Example
    ///
    /// ```swift
    /// [1, 2, 3, 4, 5].sum()  // 15
    /// [].sum()               // 0
    /// ```
    public func sum() -> Element {
        reduce(.zero, +)
    }
}
