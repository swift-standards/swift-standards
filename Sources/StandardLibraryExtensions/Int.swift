// Int.swift
// swift-standards
//
// Extensions for Swift standard library Int

extension Int {
    /// Creates an integer from a boolean value (1 for `true`, 0 for `false`).
    ///
    /// ## Example
    ///
    /// ```swift
    /// Int(true)   // 1
    /// Int(false)  // 0
    /// ```
    public init(_ bool: Bool) {
        self = bool ? 1 : 0
    }
}
