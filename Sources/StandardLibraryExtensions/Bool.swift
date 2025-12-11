// Bool.swift
// swift-standards
//
// Extensions for Swift standard library Bool

extension Bool {
    /// The integer representation of the boolean value (1 for `true`, 0 for `false`).
    ///
    /// ## Example
    ///
    /// ```swift
    /// true.int   // 1
    /// false.int  // 0
    /// ```
    public var int: Int { .init(self) }
}
