// Geometry+Formatting.swift
// FormatStyle support for Geometry types.

public import Formatting

// MARK: - Length + formatted()

extension Geometry.Length where Scalar: BinaryFloatingPoint {
    /// Format this length using the given format style.
    ///
    /// - Parameter format: The format style to use
    /// - Returns: The formatted output
    ///
    /// ## Example
    ///
    /// ```swift
    /// let length: Geometry<Double>.Length = 100.5
    /// length.formatted(.number)  // "100.5"
    /// ```
    @inlinable
    public func formatted<S>(_ format: S) -> S.FormatOutput
    where S: FormatStyle, S.FormatInput: BinaryFloatingPoint {
        format.format(S.FormatInput(value))
    }
}
