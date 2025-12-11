// Format.Numeric.swift
// Namespace for numeric formatting functionality.

/// Namespace containing numeric formatting configuration types.
///
/// Use this namespace to access notation styles, sign display strategies, and decimal separator options for numeric formatting. These types configure how numbers are formatted when using `.formatted()`.
///
/// ## Example
///
/// ```swift
/// 1000.formatted(.number.notation(.compactName))  // "1K"
/// 42.formatted(.number.sign(strategy: .always()))  // "+42"
/// ```
extension Format {
    public enum Numeric {}
}
