// Linear.Matrix.swift
// A general M×N matrix with compile-time dimensions.

public import Dimension
public import RealModule

extension Linear {
    /// An M×N matrix with compile-time dimension checking.
    ///
    /// Represents a linear transformation from N-dimensional to M-dimensional space. Use it for transformations, coordinate systems, or solving linear systems.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let m = Linear<Double>.Matrix<2, 3>(rows: [[1, 2, 3], [4, 5, 6]])
    /// let v = Linear<Double>.Vector<3, Space>(dx: .init(1), dy: .init(2), dz: .init(3))
    /// let result = m * v  // Vector<2> with values [14, 32]
    /// ```
    public struct Matrix<let Rows: Int, let Columns: Int> {
        /// The matrix elements stored as rows.
        public var rows: InlineArray<Rows, InlineArray<Columns, Scalar>>

        /// Creates a matrix from row data.
        @inlinable
        public init(rows: consuming InlineArray<Rows, InlineArray<Columns, Scalar>>) {
            self.rows = rows
        }
    }
}

extension Linear.Matrix: Sendable where Scalar: Sendable {}

// MARK: - Subscript

extension Linear.Matrix {
    /// Accesses the element at the given row and column.
    @inlinable
    public subscript(row: Int, column: Int) -> Scalar {
        get { rows[row][column] }
        set { rows[row][column] = newValue }
    }

    /// Accesses an entire row by index.
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
    /// A 2×2 square matrix.
    public typealias Matrix2x2 = Matrix<2, 2>

    /// A 3×3 square matrix.
    public typealias Matrix3x3 = Matrix<3, 3>

    /// A 4×4 square matrix.
    public typealias Matrix4x4 = Matrix<4, 4>
}

// MARK: - Zero Matrix

extension Linear.Matrix where Scalar: AdditiveArithmetic {
    /// The zero matrix (all elements are zero).
    @inlinable
    public static var zero: Self {
        Self(rows: InlineArray(repeating: InlineArray(repeating: .zero)))
    }
}

// MARK: - Identity (Square Matrices)

extension Linear.Matrix
where Rows == Columns, Scalar: AdditiveArithmetic & ExpressibleByIntegerLiteral {
    /// The identity matrix (ones on diagonal, zeros elsewhere).
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

// MARK: - Transpose

extension Linear.Matrix {
    /// The transpose of the matrix (rows become columns).
    @inlinable
    public static func transpose(_ matrix: Self) -> Linear.Matrix<Columns, Rows> {
        var result = InlineArray<Columns, InlineArray<Rows, Scalar>>(
            repeating: InlineArray(repeating: matrix.rows[0][0])
        )
        for i in 0..<Rows {
            for j in 0..<Columns {
                result[j][i] = matrix.rows[i][j]
            }
        }
        return Linear.Matrix<Columns, Rows>(rows: result)
    }

    /// The transpose of the matrix (rows become columns).
    @inlinable
    public var transpose: Linear.Matrix<Columns, Rows> {
        Self.transpose(self)
    }
}

// MARK: - Square Matrix Operations

extension Linear.Matrix where Rows == Columns, Scalar: AdditiveArithmetic {
    /// The trace (sum of diagonal elements).
    @inlinable
    public static func trace(_ matrix: Self) -> Scalar {
        var sum: Scalar = .zero
        for i in 0..<Rows {
            sum += matrix[i, i]
        }
        return sum
    }

    /// The trace (sum of diagonal elements).
    @inlinable
    public var trace: Scalar {
        Self.trace(self)
    }
}

// MARK: - 2×2 Square Matrix Operations

extension Linear.Matrix where Rows == 2, Columns == 2 {
    /// Element at position (0,0).
    @inlinable
    public var a: Scalar {
        get { rows[0][0] }
        set { rows[0][0] = newValue }
    }

    /// Element at position (0,1).
    @inlinable
    public var b: Scalar {
        get { rows[0][1] }
        set { rows[0][1] = newValue }
    }

    /// Element at position (1,0).
    @inlinable
    public var c: Scalar {
        get { rows[1][0] }
        set { rows[1][0] = newValue }
    }

    /// Element at position (1,1).
    @inlinable
    public var d: Scalar {
        get { rows[1][1] }
        set { rows[1][1] = newValue }
    }

    /// Creates a 2×2 matrix from individual elements.
    ///
    /// Constructs the matrix `[[a, b], [c, d]]`.
    @inlinable
    public init(a: Scalar, b: Scalar, c: Scalar, d: Scalar) {
        self.init(rows: [[a, b], [c, d]])
    }
}

extension Linear.Matrix where Rows == 2, Columns == 2, Scalar: Numeric {
    /// The determinant of the 2×2 matrix.
    @inlinable
    public static func determinant(_ matrix: Self) -> Scalar {
        matrix.a * matrix.d - matrix.b * matrix.c
    }

    /// The determinant of the 2×2 matrix.
    @inlinable
    public var determinant: Scalar {
        Self.determinant(self)
    }
}

extension Linear.Matrix where Rows == 2, Columns == 2, Scalar: FloatingPoint {
    /// Whether the matrix is invertible (determinant is non-zero).
    @inlinable
    public static func isInvertible(_ matrix: Self) -> Bool {
        determinant(matrix) != 0
    }

    /// Whether the matrix is invertible (determinant is non-zero).
    @inlinable
    public var isInvertible: Bool {
        Self.isInvertible(self)
    }

    /// The inverse of the matrix, or `nil` if singular.
    @inlinable
    public static func inverse(_ matrix: Self) -> Self? {
        let det = determinant(matrix)
        guard det != 0 else { return nil }
        let invDet: Scalar = 1 / det
        return Self(
            a: matrix.d * invDet,
            b: -matrix.b * invDet,
            c: -matrix.c * invDet,
            d: matrix.a * invDet
        )
    }

    /// The inverse of the matrix, or `nil` if singular.
    @inlinable
    public var inverse: Self? {
        Self.inverse(self)
    }
}

// MARK: - 2×2 Codable

#if Codable
    extension Linear.Matrix: Codable where Rows == 2, Columns == 2, Scalar: Codable {
        private enum CodingKeys: String, CodingKey {
            case a, b, c, d
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let a = try container.decode(Scalar.self, forKey: .a)
            let b = try container.decode(Scalar.self, forKey: .b)
            let c = try container.decode(Scalar.self, forKey: .c)
            let d = try container.decode(Scalar.self, forKey: .d)
            self.init(a: a, b: b, c: c, d: d)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(a, forKey: .a)
            try container.encode(b, forKey: .b)
            try container.encode(c, forKey: .c)
            try container.encode(d, forKey: .d)
        }
    }
#endif

// MARK: - 2×2 Factory Methods

extension Linear.Matrix
where Rows == 2, Columns == 2, Scalar: FloatingPoint & ExpressibleByIntegerLiteral {
    /// Creates a uniform scaling matrix.
    @inlinable
    public static func scale(_ factor: Scale<1, Scalar>) -> Self {
        Self(a: factor.value, b: 0, c: 0, d: factor.value)
    }

    /// Creates a non-uniform scaling matrix.
    @inlinable
    public static func scale(x: Scalar, y: Scalar) -> Self {
        Self(a: x, b: 0, c: 0, d: y)
    }

    /// Creates a shear matrix.
    @inlinable
    public static func shear(x: Scalar, y: Scalar) -> Self {
        Self(a: 1, b: x, c: y, d: 1)
    }
}

// MARK: - 2×2 Rotation Factory (cos/sin)

extension Linear.Matrix
where Rows == 2, Columns == 2, Scalar: SignedNumeric & ExpressibleByIntegerLiteral {
    /// Creates a rotation matrix from cosine and sine values.
    @inlinable
    public static func rotation(cos: Scalar, sin: Scalar) -> Self {
        Self(a: cos, b: -sin, c: sin, d: cos)
    }
}

// MARK: - 2×2 Rotation Factory (Angle)
extension Linear.Matrix where Rows == 2, Columns == 2, Scalar: Real & BinaryFloatingPoint {
    /// Creates a rotation matrix from an angle in radians.
    @inlinable
    public static func rotation(_ angle: Radian<Scalar>) -> Self {
        let c = angle.cos.value
        let s = angle.sin.value
        return Self(a: c, b: -s, c: s, d: c)
    }

    /// Creates a rotation matrix from an angle in degrees.
    @inlinable
    public static func rotation(_ angle: Degree<Scalar>) -> Self {
        rotation(angle.radians)
    }
}

// MARK: - 2×2 Decomposition

extension Linear.Matrix where Rows == 2, Columns == 2, Scalar == Double {
    /// Extracts the rotation angle from the matrix.
    ///
    /// Exact for pure rotations; approximates the rotational component if scale or shear is present.
    @inlinable
    public static func rotationAngle(_ matrix: Self) -> Radian<Scalar> {
        Radian(Scalar.atan2(y: matrix.c, x: matrix.a))
    }

    /// Extracts the rotation angle from the matrix.
    ///
    /// Exact for pure rotations; approximates the rotational component if scale or shear is present.
    @inlinable
    public var rotationAngle: Radian<Scalar> {
        Self.rotationAngle(self)
    }
}

extension Linear.Matrix where Rows == 2, Columns == 2, Scalar: FloatingPoint {
    /// Extracts the scale factors from the matrix.
    ///
    /// Returns approximate scale along X and Y axes if shear is present.
    @inlinable
    public static func scaleFactors(_ matrix: Self) -> (x: Scalar, y: Scalar) {
        let sx = (matrix.a * matrix.a + matrix.c * matrix.c).squareRoot()
        let sy = (matrix.b * matrix.b + matrix.d * matrix.d).squareRoot()
        return (sx, sy)
    }

    /// Extracts the scale factors from the matrix.
    ///
    /// Returns approximate scale along X and Y axes if shear is present.
    @inlinable
    public var scaleFactors: (x: Scalar, y: Scalar) {
        Self.scaleFactors(self)
    }
}

// MARK: - 3×3 Square Matrix Operations

extension Linear.Matrix where Rows == 3, Columns == 3, Scalar: Numeric {
    /// The determinant of the 3×3 matrix.
    @inlinable
    public static func determinant(_ matrix: Self) -> Scalar {
        let a = matrix[0, 0]
        let b = matrix[0, 1]
        let c = matrix[0, 2]
        let d = matrix[1, 0]
        let e = matrix[1, 1]
        let f = matrix[1, 2]
        let g = matrix[2, 0]
        let h = matrix[2, 1]
        let i = matrix[2, 2]

        // Break up expression for type-checker
        let cofactor0 = e * i - f * h
        let cofactor1 = d * i - f * g
        let cofactor2 = d * h - e * g

        return a * cofactor0 - b * cofactor1 + c * cofactor2
    }

    /// The determinant of the 3×3 matrix.
    @inlinable
    public var determinant: Scalar {
        Self.determinant(self)
    }
}

// MARK: - Functorial Map

extension Linear.Matrix {
    /// Transforms each element and returns a new matrix.
    @inlinable
    public func map<Result, E: Error>(
        _ transform: (Scalar) throws(E) -> Result
    ) throws(E) -> Linear<Result, Space>.Matrix<Rows, Columns> {
        var result = InlineArray<Rows, InlineArray<Columns, Result>>(
            repeating: InlineArray(repeating: try transform(rows[0][0]))
        )
        for i in 0..<Rows {
            for j in 0..<Columns {
                result[i][j] = try transform(rows[i][j])
            }
        }
        return Linear<Result, Space>.Matrix<Rows, Columns>(rows: result)
    }
}
