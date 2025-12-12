// ===----------------------------------------------------------------------===//
//
// Copyright (c) 2025 Coen ten Thije Boonkkamp
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of project contributors
//
// SPDX-License-Identifier: Apache-2.0
//
// ===----------------------------------------------------------------------===//

/// A coordinate space that defines discrete precision through quantization.
///
/// Quantized spaces ensure that all coordinates snap to a discrete grid,
/// eliminating floating-point precision artifacts at boundaries. This is
/// essential for rendering systems where adjacent elements must share
/// exact boundary values.
///
/// ## Mathematical Properties
///
/// For a quantized space with quantum `q`:
/// - All coordinates are multiples of `q`
/// - `quantize(x) = round(x / q) × q`
/// - Adjacent boundaries align exactly: if `a` and `b` are quantized,
///   then `a + (b - a) = b` with no floating-point error
///
/// ## Example
///
/// ```swift
/// enum PDFUserSpace: Quantized {
///     typealias Scalar = Double
///     static var quantum: Double { 0.01 }  // 1/100 point precision
/// }
/// ```
public protocol Quantized {
    associatedtype Scalar: BinaryFloatingPoint

    /// The smallest representable difference in this space.
    ///
    /// All coordinates and displacements are rounded to multiples of this value.
    static var quantum: Scalar { get }
}

extension Quantized {
    /// Quantizes a value to the nearest grid point in this space.
    @inlinable
    public static func quantize(_ value: Scalar) -> Scalar {
        (value / quantum).rounded() * quantum
    }

    /// Returns the quantum converted to the specified floating-point type.
    ///
    /// This enables quantized operators to work with any BinaryFloatingPoint scalar
    /// without requiring a same-type constraint between the operator's Scalar and Space.Scalar.
    @inlinable
    public static func quantum<T: BinaryFloatingPoint>(as type: T.Type) -> T {
        T(quantum)
    }
}

// MARK: - Quantized Displacement Tag Protocol

/// Marker protocol for displacement tags in quantized spaces.
///
/// This protocol enables static method operators for displacement arithmetic
/// that win over AdditiveArithmetic's operators.
public protocol QuantizedDisplacementTag {
    associatedtype Space: Quantized
}

