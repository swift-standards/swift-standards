// Affine+Formatting.swift
// Formatting extensions for Affine types.

public import Algebra
public import Formatting

// MARK: - Tagged<Algebra.X, _> + formatted()

extension Tagged where Tag == Algebra.X, RawValue: BinaryFloatingPoint {
    /// Format this X coordinate using the given format style.
    ///
    /// - Parameter format: The format style to use
    /// - Returns: The formatted output
    ///
    /// ## Example
    ///
    /// ```swift
    /// let x: Affine<Double>.X = 72.5
    /// x.formatted(.number)  // "72.5"
    /// x.formatted(.number.precision(.fractionLength(2)))  // "72.50"
    /// ```
    @inlinable
    public func formatted<S>(_ format: S) -> S.FormatOutput
    where S: FormatStyle, S.FormatInput: BinaryFloatingPoint {
        format.format(S.FormatInput(value))
    }
}

// MARK: - Tagged<Algebra.Y, _> + formatted()

extension Tagged where Tag == Algebra.Y, RawValue: BinaryFloatingPoint {
    /// Format this Y coordinate using the given format style.
    ///
    /// - Parameter format: The format style to use
    /// - Returns: The formatted output
    ///
    /// ## Example
    ///
    /// ```swift
    /// let y: Affine<Double>.Y = 144.0
    /// y.formatted(.number)  // "144"
    /// ```
    @inlinable
    public func formatted<S>(_ format: S) -> S.FormatOutput
    where S: FormatStyle, S.FormatInput: BinaryFloatingPoint {
        format.format(S.FormatInput(value))
    }
}

// MARK: - Tagged<Algebra.Z, _> + formatted()

extension Tagged where Tag == Algebra.Z, RawValue: BinaryFloatingPoint {
    /// Format this Z coordinate using the given format style.
    ///
    /// - Parameter format: The format style to use
    /// - Returns: The formatted output
    @inlinable
    public func formatted<S>(_ format: S) -> S.FormatOutput
    where S: FormatStyle, S.FormatInput: BinaryFloatingPoint {
        format.format(S.FormatInput(value))
    }
}
