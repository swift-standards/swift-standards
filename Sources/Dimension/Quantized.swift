// Quantized.swift
// Protocol for coordinate spaces with discrete precision.

/// A coordinate space with discrete precision through quantization.
///
/// Quantized spaces ensure all coordinates snap to a discrete grid,
/// eliminating floating-point precision artifacts at boundaries. This is
/// essential for rendering systems where adjacent elements must share
/// exact boundary values.
///
/// ## Mathematical Model
///
/// A quantized space defines a lattice of valid coordinate values:
/// - The **quantum** `q` is the spacing between adjacent grid points
/// - Every coordinate is an integer multiple of `q`: value = tick × q
/// - The **tick** is the integer index of the grid point
///
/// ## Canonical Representation
///
/// For any computed value `v`, quantization produces:
/// 1. `tick = round(v / q)` — the nearest grid point
/// 2. `canonical = tick × q` — the IEEE 754 representation
///
/// This ensures that values at the same grid point have identical bits,
/// enabling exact equality comparison.
///
/// ## Example
///
/// ```swift
/// enum PDFSpace: Quantized {
///     typealias Scalar = Double
///     static var quantum: Double { 0.01 }  // 1/100 point precision
/// }
///
/// // All coordinates in PDFSpace snap to 0.01 increments
/// let x: Coordinate.X<PDFSpace>.Value<Double> = .init(1.234)
/// // x._rawValue == 1.23 (quantized)
/// // Internally computed as: ticks = 123
/// ```
public protocol Quantized {
    associatedtype Scalar: BinaryFloatingPoint

    /// The smallest representable difference in this space.
    ///
    /// All coordinates and displacements are rounded to multiples of this value.
    /// Choose a quantum that:
    /// - Is small enough for required precision
    /// - Avoids excessive tick counts (stay within Int64 range)
    static var quantum: Scalar { get }
}

extension Quantized {
    /// Quantizes a value to the nearest grid point.
    ///
    /// - Parameter value: The value to quantize
    /// - Returns: The nearest grid point value
    @inlinable
    public static func quantize(_ value: Scalar) -> Scalar {
        let ticks = Int64((value / quantum).rounded())
        return Scalar(ticks) * quantum
    }

    /// Returns the quantum converted to the specified floating-point type.
    ///
    /// Enables quantized operators to work with any BinaryFloatingPoint scalar
    /// without requiring a same-type constraint.
    @inlinable
    public static func quantum<T: BinaryFloatingPoint>(as type: T.Type) -> T {
        T(quantum)
    }
}
