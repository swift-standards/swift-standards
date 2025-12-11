// Linear.Matrix.swift
// A general M×N matrix with compile-time dimensions.

extension Linear {
    /// A general M×N matrix with compile-time known dimensions.
    ///
    /// `Matrix` represents a linear map from an N-dimensional vector space
    /// to an M-dimensional vector space. In category theory terms, this is
    /// a morphism in the category **Vect** of vector spaces.
    ///
    /// Uses Swift 6.2 integer generic parameters (SE-0452) for type-safe
    /// dimension checking at compile time.
    ///
    /// ## Storage
    ///
    /// Elements are stored as rows, where each row is an InlineArray:
    /// ```
    /// rows[0] = | a00  a01  ... a0(N-1) |
    /// rows[1] = | a10  a11  ... a1(N-1) |
    /// ...
    /// ```
    ///
    /// ## Example
    ///
    /// ```swift
    /// let m: Linear<Double>.Matrix<2, 3> = .init(rows: [
    ///     [1, 2, 3],
    ///     [4, 5, 6]
    /// ])
    /// let v: Linear<Double>.Vector<3> = .init(dx: 1, dy: 2, dz: 3)
    /// let result = m * v  // Vector<2>
    /// ```
    public struct Matrix<let Rows: Int, let Columns: Int> {
        /// The matrix elements stored as rows
        public var rows: InlineArray<Rows, InlineArray<Columns, Scalar>>

        /// Create a matrix from rows
        @inlinable
        public init(rows: consuming InlineArray<Rows, InlineArray<Columns, Scalar>>) {
            self.rows = rows
        }
    }
}

extension Linear.Matrix: Sendable where Scalar: Sendable {}

// MARK: - Subscript

extension Linear.Matrix {
    /// Access element at (row, column)
    @inlinable
    public subscript(row: Int, column: Int) -> Scalar {
        get { rows[row][column] }
        set { rows[row][column] = newValue }
    }

    /// Access a row
    @inlinable
    public subscript(row row: Int) -> InlineArray<Columns, Scalar> {
        get { rows[row] }
        set { rows[row] = newValue }
    }
}

// MARK: - Equatable

extension Linear.Matrix: Equatable where Scalar: Equatable {
    @inlinable
    public static func == (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        for i in 0..<Rows {
            for j in 0..<Columns {
                if lhs.rows[i][j] != rhs.rows[i][j] {
                    return false
                }
            }
        }
        return true
    }
}

// MARK: - Hashable

extension Linear.Matrix: Hashable where Scalar: Hashable {
    @inlinable
    public func hash(into hasher: inout Hasher) {
        for i in 0..<Rows {
            for j in 0..<Columns {
                hasher.combine(rows[i][j])
            }
        }
    }
}

// MARK: - Typealiases

extension Linear {
    /// A 2×2 square matrix
    public typealias Matrix2x2 = Matrix<2, 2>

    /// A 3×3 square matrix
    public typealias Matrix3x3 = Matrix<3, 3>

    /// A 4×4 square matrix
    public typealias Matrix4x4 = Matrix<4, 4>
}

// MARK: - Zero Matrix

extension Linear.Matrix where Scalar: AdditiveArithmetic {
    /// The zero matrix (all elements are zero)
    @inlinable
    public static var zero: Self {
        Self(rows: InlineArray(repeating: InlineArray(repeating: .zero)))
    }
}

// MARK: - Identity (Square Matrices)

extension Linear.Matrix where Rows == Columns, Scalar: AdditiveArithmetic & ExpressibleByIntegerLiteral {
    /// The identity matrix
    @inlinable
    public static var identity: Self {
        var rows = InlineArray<Rows, InlineArray<Columns, Scalar>>(
            repeating: InlineArray(repeating: .zero)
        )
        for i in 0..<Rows {
            rows[i][i] = 1
        }
        return Self(rows: rows)
    }
}

// MARK: - Addition / Subtraction

extension Linear.Matrix where Scalar: AdditiveArithmetic {
    /// Add two matrices
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

    /// Subtract two matrices
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

// MARK: - Scalar Multiplication

extension Linear.Matrix where Scalar: Numeric {
    /// Scale matrix by a scalar
    @inlinable
    public static func * (lhs: borrowing Self, rhs: Scalar) -> Self {
        var result = lhs.rows
        for i in 0..<Rows {
            for j in 0..<Columns {
                result[i][j] = lhs.rows[i][j] * rhs
            }
        }
        return Self(rows: result)
    }

    /// Scale matrix by a scalar
    @inlinable
    public static func * (lhs: Scalar, rhs: borrowing Self) -> Self {
        rhs * lhs
    }
}

// MARK: - Negation

extension Linear.Matrix where Scalar: SignedNumeric {
    /// Negate matrix
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

// MARK: - Transpose

extension Linear.Matrix {
    /// The transpose of the matrix
    @inlinable
    public var transpose: Linear.Matrix<Columns, Rows> {
        var result = InlineArray<Columns, InlineArray<Rows, Scalar>>(
            repeating: InlineArray(repeating: rows[0][0])
        )
        for i in 0..<Rows {
            for j in 0..<Columns {
                result[j][i] = rows[i][j]
            }
        }
        return Linear.Matrix<Columns, Rows>(rows: result)
    }
}

// MARK: - Matrix-Vector Multiplication

extension Linear.Matrix where Scalar: AdditiveArithmetic & Numeric {
    /// Multiply matrix by a column vector
    ///
    /// - Parameter vector: A vector with `Columns` components
    /// - Returns: A vector with `Rows` components
    @inlinable
    public static func * (lhs: borrowing Self, rhs: Linear.Vector<Columns>) -> Linear.Vector<Rows> {
        var result = InlineArray<Rows, Scalar>(repeating: .zero)
        for i in 0..<Rows {
            var sum: Scalar = .zero
            for j in 0..<Columns {
                sum = sum + lhs[i, j] * rhs.components[j]
            }
            result[i] = sum
        }
        return Linear.Vector<Rows>(result)
    }
}

// MARK: - Matrix-Matrix Multiplication

extension Linear.Matrix where Scalar: AdditiveArithmetic & Numeric {
    /// Multiply two matrices
    ///
    /// - Parameter rhs: A matrix with dimensions `Columns × P`
    /// - Returns: A matrix with dimensions `Rows × P`
    @inlinable
    public func multiplied<let P: Int>(by rhs: Linear.Matrix<Columns, P>) -> Linear.Matrix<Rows, P> {
        var result = InlineArray<Rows, InlineArray<P, Scalar>>(
            repeating: InlineArray(repeating: .zero)
        )
        for i in 0..<Rows {
            for j in 0..<P {
                var sum: Scalar = .zero
                for k in 0..<Columns {
                    sum = sum + self[i, k] * rhs[k, j]
                }
                result[i][j] = sum
            }
        }
        return Linear.Matrix<Rows, P>(rows: result)
    }
}

// MARK: - Square Matrix Operations

extension Linear.Matrix where Rows == Columns, Scalar: AdditiveArithmetic {
    /// The trace (sum of diagonal elements)
    @inlinable
    public var trace: Scalar {
        var sum: Scalar = .zero
        for i in 0..<Rows {
            sum = sum + self[i, i]
        }
        return sum
    }
}

// MARK: - 2×2 Square Matrix Operations

extension Linear.Matrix where Rows == 2, Columns == 2 {
    /// Element (0,0) - standard notation: a
    @inlinable
    public var a: Scalar {
        get { rows[0][0] }
        set { rows[0][0] = newValue }
    }

    /// Element (0,1) - standard notation: b
    @inlinable
    public var b: Scalar {
        get { rows[0][1] }
        set { rows[0][1] = newValue }
    }

    /// Element (1,0) - standard notation: c
    @inlinable
    public var c: Scalar {
        get { rows[1][0] }
        set { rows[1][0] = newValue }
    }

    /// Element (1,1) - standard notation: d
    @inlinable
    public var d: Scalar {
        get { rows[1][1] }
        set { rows[1][1] = newValue }
    }

    /// Create a 2×2 matrix with standard notation
    ///
    /// ```
    /// | a  b |
    /// | c  d |
    /// ```
    @inlinable
    public init(a: Scalar, b: Scalar, c: Scalar, d: Scalar) {
        self.init(rows: [[a, b], [c, d]])
    }
}

extension Linear.Matrix where Rows == 2, Columns == 2, Scalar: Numeric {
    /// The determinant of the 2×2 matrix
    @inlinable
    public var determinant: Scalar {
        a * d - b * c
    }
}

extension Linear.Matrix where Rows == 2, Columns == 2, Scalar: FloatingPoint {
    /// The inverse of the 2×2 matrix, or nil if singular
    @inlinable
    public var inverse: Self? {
        let det = determinant
        guard det != 0 else { return nil }
        let invDet: Scalar = 1 / det
        return Self(
            a: d * invDet,
            b: -b * invDet,
            c: -c * invDet,
            d: a * invDet
        )
    }
}

// MARK: - 3×3 Square Matrix Operations

extension Linear.Matrix where Rows == 3, Columns == 3, Scalar: Numeric {
    /// The determinant of the 3×3 matrix
    @inlinable
    public var determinant: Scalar {
        let a = self[0, 0], b = self[0, 1], c = self[0, 2]
        let d = self[1, 0], e = self[1, 1], f = self[1, 2]
        let g = self[2, 0], h = self[2, 1], i = self[2, 2]

        // Break up expression for type-checker
        let cofactor0 = e * i - f * h
        let cofactor1 = d * i - f * g
        let cofactor2 = d * h - e * g

        return a * cofactor0 - b * cofactor1 + c * cofactor2
    }
}

// MARK: - Functorial Map

extension Linear.Matrix {
    /// Transform each element using the given closure
    @inlinable
    public func map<Result, E: Error>(
        _ transform: (Scalar) throws(E) -> Result
    ) throws(E) -> Linear<Result>.Matrix<Rows, Columns> {
        var result = InlineArray<Rows, InlineArray<Columns, Result>>(
            repeating: InlineArray(repeating: try transform(rows[0][0]))
        )
        for i in 0..<Rows {
            for j in 0..<Columns {
                result[i][j] = try transform(rows[i][j])
            }
        }
        return Linear<Result>.Matrix<Rows, Columns>(rows: result)
    }
}
