// Linear+Formatting.swift
// Formatting extensions for Linear displacement types.

public import Dimension
public import Formatting

// MARK: - Tagged<Index.X.Displacement, _> + formatted()

extension Tagged where Tag == Index.X.Displacement, RawValue: BinaryFloatingPoint {
    /// Format this X displacement using the given format style.
    ///
    /// - Parameter format: The format style to use
    /// - Returns: The formatted output
    ///
    /// ## Example
    ///
    /// ```swift
    /// let dx: Linear<Double>.Dx = 72.5
    /// dx.formatted(.number)  // "72.5"
    /// ```
    @inlinable
    public func formatted<S>(_ format: S) -> S.FormatOutput
    where S: FormatStyle, S.FormatInput: BinaryFloatingPoint {
        format.format(S.FormatInput(value))
    }
}

// MARK: - Tagged<Index.Y.Displacement, _> + formatted()

extension Tagged where Tag == Index.Y.Displacement, RawValue: BinaryFloatingPoint {
    /// Format this Y displacement using the given format style.
    ///
    /// - Parameter format: The format style to use
    /// - Returns: The formatted output
    ///
    /// ## Example
    ///
    /// ```swift
    /// let dy: Linear<Double>.Dy = 144.0
    /// dy.formatted(.number)  // "144"
    /// ```
    @inlinable
    public func formatted<S>(_ format: S) -> S.FormatOutput
    where S: FormatStyle, S.FormatInput: BinaryFloatingPoint {
        format.format(S.FormatInput(value))
    }
}

// MARK: - Tagged<Index.Z.Displacement, _> + formatted()

extension Tagged where Tag == Index.Z.Displacement, RawValue: BinaryFloatingPoint {
    /// Format this Z displacement using the given format style.
    ///
    /// - Parameter format: The format style to use
    /// - Returns: The formatted output
    @inlinable
    public func formatted<S>(_ format: S) -> S.FormatOutput
    where S: FormatStyle, S.FormatInput: BinaryFloatingPoint {
        format.format(S.FormatInput(value))
    }
}

// MARK: - Tagged<Index.W.Displacement, _> + formatted()

extension Tagged where Tag == Index.W.Displacement, RawValue: BinaryFloatingPoint {
    /// Format this W displacement using the given format style.
    ///
    /// - Parameter format: The format style to use
    /// - Returns: The formatted output
    @inlinable
    public func formatted<S>(_ format: S) -> S.FormatOutput
    where S: FormatStyle, S.FormatInput: BinaryFloatingPoint {
        format.format(S.FormatInput(value))
    }
}
