// Linear+Formatting.swift
// Formatting extensions for Linear displacement types.

public import Dimension
public import Formatting

// MARK: - Tagged<Index.X.Displacement, _> + formatted()

extension Tagged where Tag == Index.X.Displacement, RawValue: BinaryFloatingPoint {
    /// Formats this X-displacement using the given format style.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let dx: Linear<Double>.Dx = .init(72.5)
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
    /// Formats this Y-displacement using the given format style.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let dy: Linear<Double>.Dy = .init(144.0)
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
    /// Formats this Z-displacement using the given format style.
    @inlinable
    public func formatted<S>(_ format: S) -> S.FormatOutput
    where S: FormatStyle, S.FormatInput: BinaryFloatingPoint {
        format.format(S.FormatInput(value))
    }
}

// MARK: - Tagged<Index.W.Displacement, _> + formatted()

extension Tagged where Tag == Index.W.Displacement, RawValue: BinaryFloatingPoint {
    /// Formats this W-displacement using the given format style.
    @inlinable
    public func formatted<S>(_ format: S) -> S.FormatOutput
    where S: FormatStyle, S.FormatInput: BinaryFloatingPoint {
        format.format(S.FormatInput(value))
    }
}

// MARK: - Tagged<Index.Magnitude, _> + formatted()

extension Tagged where Tag == Index.Magnitude, RawValue: BinaryFloatingPoint {
    /// Formats this magnitude using the given format style.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let length: Linear<Double>.Magnitude = .init(100.5)
    /// length.formatted(.number)  // "100.5"
    /// ```
    @inlinable
    public func formatted<S>(_ format: S) -> S.FormatOutput
    where S: FormatStyle, S.FormatInput: BinaryFloatingPoint {
        format.format(S.FormatInput(value))
    }
}
