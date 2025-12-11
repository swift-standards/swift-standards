// Affine+Formatting.swift
// Formatting extensions for Affine types.

public import Algebra
public import Dimension
public import Formatting

// MARK: - Tagged<Index.X.Coordinate, _> + formatted()

extension Tagged where Tag == Index.X.Coordinate, RawValue: BinaryFloatingPoint {
    /// Formats horizontal coordinate using specified format style.
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

// MARK: - Tagged<Index.Y.Coordinate, _> + formatted()

extension Tagged where Tag == Index.Y.Coordinate, RawValue: BinaryFloatingPoint {
    /// Formats vertical coordinate using specified format style.
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

// MARK: - Tagged<Index.Z.Coordinate, _> + formatted()

extension Tagged where Tag == Index.Z.Coordinate, RawValue: BinaryFloatingPoint {
    /// Formats depth coordinate using specified format style.
    @inlinable
    public func formatted<S>(_ format: S) -> S.FormatOutput
    where S: FormatStyle, S.FormatInput: BinaryFloatingPoint {
        format.format(S.FormatInput(value))
    }
}
