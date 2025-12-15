//
//  File.swift
//  swift-standards
//
//  Created by Coen ten Thije Boonkkamp on 14/12/2025.
//
public import Algebra
public import Dimension

// MARK: - Vector × Scale (Uniform Scaling)

/// Scales a vector uniformly by a dimensionless scale factor.
@inlinable
public func * <Scalar: FloatingPoint, Space, let N: Int>(
    lhs: Linear<Scalar, Space>.Vector<N>,
    rhs: Scale<1, Scalar>
) -> Linear<Scalar, Space>.Vector<N> {
    var result = lhs.components
    for i in 0..<N {
        result[i] = lhs.components[i] * rhs.value
    }
    return Linear<Scalar, Space>.Vector<N>(result)
}

/// Scales a vector uniformly by a dimensionless scale factor (commutative).
@inlinable
public func * <Scalar: FloatingPoint, Space, let N: Int>(
    lhs: Scale<1, Scalar>,
    rhs: Linear<Scalar, Space>.Vector<N>
) -> Linear<Scalar, Space>.Vector<N> {
    var result = rhs.components
    for i in 0..<N {
        result[i] = lhs.value * rhs.components[i]
    }
    return Linear<Scalar, Space>.Vector<N>(result)
}

/// Divides a vector uniformly by a dimensionless scale factor.
@inlinable
public func / <Scalar: FloatingPoint, Space, let N: Int>(
    lhs: Linear<Scalar, Space>.Vector<N>,
    rhs: Scale<1, Scalar>
) -> Linear<Scalar, Space>.Vector<N> {
    var result = lhs.components
    for i in 0..<N {
        result[i] = lhs.components[i] / rhs.value
    }
    return Linear<Scalar, Space>.Vector<N>(result)
}

// MARK: - Matrix-Vector Multiplication

extension Linear.Matrix where Scalar: AdditiveArithmetic & Numeric {
    /// Multiplies the matrix by a column vector.
    @inlinable
    public static func * (lhs: borrowing Self, rhs: Linear.Vector<Columns>) -> Linear.Vector<Rows> {
        var result = InlineArray<Rows, Scalar>(repeating: .zero)
        for i in 0..<Rows {
            var sum: Scalar = .zero
            for j in 0..<Columns {
                sum += lhs[i, j] * rhs.components[j]
            }
            result[i] = sum
        }
        return Linear.Vector<Rows>(result)
    }
}

// MARK: - Matrix-Matrix Multiplication

extension Linear.Matrix where Scalar: AdditiveArithmetic & Numeric {
    /// Multiplies this matrix by another matrix.
    @inlinable
    public func multiplied<let P: Int>(by rhs: Linear.Matrix<Columns, P>) -> Linear.Matrix<Rows, P>
    {
        var result = InlineArray<Rows, InlineArray<P, Scalar>>(
            repeating: InlineArray(repeating: .zero)
        )
        for i in 0..<Rows {
            for j in 0..<P {
                var sum: Scalar = .zero
                for k in 0..<Columns {
                    sum += self[i, k] * rhs[k, j]
                }
                result[i][j] = sum
            }
        }
        return Linear.Matrix<Rows, P>(rows: result)
    }

    /// Multiplies two matrices.
    @inlinable
    public static func * <let P: Int>(
        lhs: Self,
        rhs: Linear.Matrix<Columns, P>
    ) -> Linear.Matrix<Rows, P> {
        lhs.multiplied(by: rhs)
    }
}

// MARK: - Scalar Multiplication (Intentionally Omitted)

// Note: Raw scalar multiplication (Matrix * Scalar) is intentionally not provided.
//
// This codebase maintains type safety by using typed wrappers like Scale<1, Scalar>
// instead of raw scalars for scaling operations. This ensures:
//
// 1. Dimensional correctness: Scale factors are explicitly typed, preventing
//    accidental mixing of dimensioned quantities with dimensionless scalars.
//
// 2. Consistency with vectors: Linear.Vector also restricts scalar multiplication
//    to internal use, exposing only typed scaling via Scale<1, Scalar>.
//
// 3. Semantic clarity: To scale a transformation matrix, compose it with a
//    scale matrix via Matrix.scale(_:) rather than element-wise multiplication.
//
// If you need element-wise scalar multiplication for numerical computation,
// use the map(_:) method: matrix.map { $0 * scalar }

extension Linear.Matrix where Rows == 2, Columns == 2, Scalar: FloatingPoint {
    /// Multiplies the 2×2 matrix by a typed 2D vector, preserving coordinate types.
    ///
    /// This operator handles the dimensional analysis internally, allowing matrix elements
    /// (which are dimensionless) to transform typed displacement components.
    @inlinable
    public static func * (
        lhs: Self,
        rhs: Linear<Scalar, Space>.Vector<2>
    ) -> Linear<Scalar, Space>.Vector<2> {
        let x = lhs.a * rhs.dx._rawValue + lhs.b * rhs.dy._rawValue
        let y = lhs.c * rhs.dx._rawValue + lhs.d * rhs.dy._rawValue
        return Linear<Scalar, Space>.Vector(dx: .init(x), dy: .init(y))
    }
}

// MARK: - Scalar Multiplication (internal for mathematical operations)

extension Linear.Vector where Scalar: FloatingPoint {
    /// Scales the vector by a scalar multiplier (internal).
    @inlinable
    internal static func * (lhs: borrowing Self, rhs: Scalar) -> Self {
        var result = lhs.components
        for i in 0..<N {
            result[i] = lhs.components[i] * rhs
        }
        return Self(result)
    }

    /// Divides the vector by a scalar divisor (internal).
    @inlinable
    internal static func / (lhs: borrowing Self, rhs: Scalar) -> Self {
        var result = lhs.components
        for i in 0..<N {
            result[i] = lhs.components[i] / rhs
        }
        return Self(result)
    }
}

// MARK: - Negation

extension Linear.Matrix where Scalar: SignedNumeric {
    /// Negates the matrix (flips all element signs).
    @inlinable
    public static prefix func - (value: borrowing Self) -> Self {
        var result = value.rows
        for i in 0..<Rows {
            for j in 0..<Columns {
                result[i][j] = -value.rows[i][j]
            }
        }
        return Self(rows: result)
    }
}

// MARK: - Addition / Subtraction

extension Linear.Matrix where Scalar: AdditiveArithmetic {
    /// Adds two matrices element-wise.
    @inlinable
    public static func + (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        var result = lhs.rows
        for i in 0..<Rows {
            for j in 0..<Columns {
                result[i][j] = lhs.rows[i][j] + rhs.rows[i][j]
            }
        }
        return Self(rows: result)
    }

    /// Subtracts two matrices element-wise.
    @inlinable
    public static func - (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        var result = lhs.rows
        for i in 0..<Rows {
            for j in 0..<Columns {
                result[i][j] = lhs.rows[i][j] - rhs.rows[i][j]
            }
        }
        return Self(rows: result)
    }
}

// MARK: - Negation (SignedNumeric)

extension Linear.Vector where Scalar: SignedNumeric {
    /// Negates the vector (flips direction).
    @inlinable
    @_disfavoredOverload
    public static prefix func - (value: borrowing Self) -> Self {
        var result = value.components
        for i in 0..<N {
            result[i] = -value.components[i]
        }
        return Self(result)
    }
}

// MARK: - AdditiveArithmetic

extension Linear.Vector where Scalar: AdditiveArithmetic {
    /// Adds two vectors component-wise.
    @inlinable
    @_disfavoredOverload
    public static func + (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        var result = lhs.components
        for i in 0..<N {
            result[i] = lhs.components[i] + rhs.components[i]
        }
        return Self(result)
    }

    /// Subtracts two vectors component-wise.
    @inlinable
    @_disfavoredOverload
    public static func - (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        var result = lhs.components
        for i in 0..<N {
            result[i] = lhs.components[i] - rhs.components[i]
        }
        return Self(result)
    }
}

// MARK: - Dot Product

/// Computes the dot product of two vectors.
///
/// The dot product is the sum of component-wise products, returning a scalar.
/// Geometrically, it equals |a| × |b| × cos(θ) where θ is the angle between vectors.
///
/// - Returns: The scalar dot product.
@inlinable
public func dot<Scalar: Numeric, Space, let N: Int>(
    _ lhs: Linear<Scalar, Space>.Vector<N>,
    _ rhs: Linear<Scalar, Space>.Vector<N>
) -> Scalar {
    var sum: Scalar = .zero
    for i in 0..<N {
        sum += lhs.components[i] * rhs.components[i]
    }
    return sum
}

/// Computes the dot product of two 2D vectors using typed components.
@inlinable
public func dot<Scalar: Numeric, Space>(
    _ lhs: Linear<Scalar, Space>.Vector<2>,
    _ rhs: Linear<Scalar, Space>.Vector<2>
) -> Scalar {
    lhs.dx._rawValue * rhs.dx._rawValue + lhs.dy._rawValue * rhs.dy._rawValue
}

// MARK: - Cross Product (2D)

/// Computes the 2D cross product (perpendicular dot product).
///
/// For 2D vectors, the cross product returns a scalar representing the
/// signed area of the parallelogram formed by the two vectors.
/// Positive if rhs is counterclockwise from lhs, negative if clockwise.
///
/// - Returns: The signed scalar area.
@inlinable
public func cross<Scalar: Numeric, Space>(
    _ lhs: Linear<Scalar, Space>.Vector<2>,
    _ rhs: Linear<Scalar, Space>.Vector<2>
) -> Scalar {
    lhs.dx._rawValue * rhs.dy._rawValue - lhs.dy._rawValue * rhs.dx._rawValue
}
