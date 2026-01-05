// Binary.Error.swift
// Domain-scoped error type for Binary operations.

extension Binary {
    /// A structured error from Binary operations.
    ///
    /// Uses typed throws (`throws(Binary.Error)`) to provide compile-time
    /// exhaustiveness checking when handling errors.
    ///
    /// ## Error Categories
    ///
    /// - `negative`: A value that must be non-negative was negative.
    /// - `bounds`: An index or position was out of valid range.
    /// - `invariant`: A required invariant was violated.
    /// - `bit`: A bit operation parameter was invalid.
    ///
    /// ## Example
    ///
    /// ```swift
    /// do {
    ///     let count = try Binary.Count(-1)
    /// } catch .negative(let e) {
    ///     print("\(e.field) was \(e.value)")
    /// }
    /// ```
    public enum Error: Swift.Error, Sendable, Equatable {
        /// A value that must be non-negative was negative.
        case negative(Negative)

        /// An index or position was out of valid range.
        case bounds(Bounds)

        /// A required invariant was violated.
        case invariant(Invariant)

        /// A bit operation parameter was invalid.
        case bit(Bit)
    }
}

// MARK: - CustomStringConvertible

extension Binary.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .negative(let e): return e.description
        case .bounds(let e): return e.description
        case .invariant(let e): return e.description
        case .bit(let e): return e.description
        }
    }
}
