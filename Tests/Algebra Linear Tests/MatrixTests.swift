// MatrixTests.swift
// Tests for Linear.Matrix

@testable import Algebra
import Testing
@testable import Algebra_Linear

@Suite("Linear.Matrix Tests")
struct MatrixTests {
    typealias Mat2x2 = Linear<Double>.Matrix2x2
    typealias Mat3x3 = Linear<Double>.Matrix3x3
    typealias Vec2 = Linear<Double>.Vector<2>

    // MARK: - Construction

    @Test("2x2 matrix construction with a,b,c,d")
    func matrix2x2Construction() {
        let m = Mat2x2(a: 1, b: 2, c: 3, d: 4)
        #expect(m.a == 1)
        #expect(m.b == 2)
        #expect(m.c == 3)
        #expect(m.d == 4)
    }

    @Test("Subscript access")
    func subscriptAccess() {
        var m = Mat2x2(a: 1, b: 2, c: 3, d: 4)
        #expect(m[0, 0] == 1)
        #expect(m[0, 1] == 2)
        #expect(m[1, 0] == 3)
        #expect(m[1, 1] == 4)

        m[0, 1] = 10
        #expect(m[0, 1] == 10)
    }

    // MARK: - Identity

    @Test("Identity matrix")
    func identityMatrix() {
        let id = Mat2x2.identity
        #expect(id.a == 1)
        #expect(id.b == 0)
        #expect(id.c == 0)
        #expect(id.d == 1)
    }

    @Test("3x3 identity matrix")
    func identity3x3() {
        let id = Mat3x3.identity
        #expect(id[0, 0] == 1)
        #expect(id[0, 1] == 0)
        #expect(id[1, 1] == 1)
        #expect(id[2, 2] == 1)
    }

    // MARK: - Zero

    @Test("Zero matrix")
    func zeroMatrix() {
        let zero = Mat2x2.zero
        #expect(zero.a == 0)
        #expect(zero.b == 0)
        #expect(zero.c == 0)
        #expect(zero.d == 0)
    }

    // MARK: - Arithmetic

    @Test("Matrix addition")
    func addition() {
        let a = Mat2x2(a: 1, b: 2, c: 3, d: 4)
        let b = Mat2x2(a: 5, b: 6, c: 7, d: 8)
        let sum = a + b
        #expect(sum.a == 6)
        #expect(sum.b == 8)
        #expect(sum.c == 10)
        #expect(sum.d == 12)
    }

    @Test("Matrix subtraction")
    func subtraction() {
        let a = Mat2x2(a: 5, b: 6, c: 7, d: 8)
        let b = Mat2x2(a: 1, b: 2, c: 3, d: 4)
        let diff = a - b
        #expect(diff.a == 4)
        #expect(diff.b == 4)
        #expect(diff.c == 4)
        #expect(diff.d == 4)
    }

    @Test("Scalar multiplication")
    func scalarMultiplication() {
        let m = Mat2x2(a: 1, b: 2, c: 3, d: 4)
        let scaled = m * 2.0
        #expect(scaled.a == 2)
        #expect(scaled.b == 4)
        #expect(scaled.c == 6)
        #expect(scaled.d == 8)
    }

    @Test("Negation")
    func negation() {
        let m = Mat2x2(a: 1, b: -2, c: 3, d: -4)
        let neg = -m
        #expect(neg.a == -1)
        #expect(neg.b == 2)
        #expect(neg.c == -3)
        #expect(neg.d == 4)
    }

    // MARK: - Matrix Multiplication

    @Test("Matrix-vector multiplication")
    func matrixVectorMultiplication() {
        let m = Mat2x2(a: 1, b: 2, c: 3, d: 4)
        let v = Vec2(dx: 1, dy: 1)
        let result = m * v
        #expect(result.dx == 3)  // 1*1 + 2*1
        #expect(result.dy == 7)  // 3*1 + 4*1
    }

    @Test("Matrix-matrix multiplication")
    func matrixMatrixMultiplication() {
        let a = Mat2x2(a: 1, b: 2, c: 3, d: 4)
        let b = Mat2x2(a: 5, b: 6, c: 7, d: 8)
        let result = a.multiplied(by: b)
        // [1 2] * [5 6] = [1*5+2*7  1*6+2*8] = [19 22]
        // [3 4]   [7 8]   [3*5+4*7  3*6+4*8]   [43 50]
        #expect(result.a == 19)
        #expect(result.b == 22)
        #expect(result.c == 43)
        #expect(result.d == 50)
    }

    @Test("Identity multiplication")
    func identityMultiplication() {
        let m = Mat2x2(a: 1, b: 2, c: 3, d: 4)
        let id = Mat2x2.identity
        let result = m.multiplied(by: id)
        #expect(result == m)
    }

    // MARK: - Transpose

    @Test("Transpose")
    func transpose() {
        let m = Mat2x2(a: 1, b: 2, c: 3, d: 4)
        let t = m.transpose
        #expect(t.a == 1)
        #expect(t.b == 3)
        #expect(t.c == 2)
        #expect(t.d == 4)
    }

    // MARK: - Determinant

    @Test("2x2 determinant")
    func determinant2x2() {
        let m = Mat2x2(a: 1, b: 2, c: 3, d: 4)
        #expect(m.determinant == -2)  // 1*4 - 2*3 = -2
    }

    @Test("3x3 determinant")
    func determinant3x3() {
        // | 1 2 3 |
        // | 4 5 6 |
        // | 7 8 9 |
        // det = 1*(5*9-6*8) - 2*(4*9-6*7) + 3*(4*8-5*7) = 1*(-3) - 2*(-6) + 3*(-3) = 0
        var m = Mat3x3.zero
        m[0, 0] = 1; m[0, 1] = 2; m[0, 2] = 3
        m[1, 0] = 4; m[1, 1] = 5; m[1, 2] = 6
        m[2, 0] = 7; m[2, 1] = 8; m[2, 2] = 9
        #expect(m.determinant == 0)
    }

    @Test("3x3 non-singular determinant")
    func determinant3x3NonSingular() {
        // | 1 0 0 |
        // | 0 2 0 |
        // | 0 0 3 |
        // det = 1*2*3 = 6
        var m = Mat3x3.zero
        m[0, 0] = 1
        m[1, 1] = 2
        m[2, 2] = 3
        #expect(m.determinant == 6)
    }

    // MARK: - Inverse

    @Test("2x2 inverse")
    func inverse2x2() {
        let m = Mat2x2(a: 4, b: 7, c: 2, d: 6)
        // det = 4*6 - 7*2 = 10
        // inv = 1/10 * [6 -7; -2 4]
        guard let inv = m.inverse else {
            #expect(Bool(false), "Matrix should be invertible")
            return
        }
        #expect(abs(inv.a - 0.6) < 1e-10)
        #expect(abs(inv.b - (-0.7)) < 1e-10)
        #expect(abs(inv.c - (-0.2)) < 1e-10)
        #expect(abs(inv.d - 0.4) < 1e-10)
    }

    @Test("Singular matrix has no inverse")
    func singularMatrixNoInverse() {
        let m = Mat2x2(a: 1, b: 2, c: 2, d: 4)  // det = 0
        #expect(m.inverse == nil)
    }

    @Test("Inverse * original = identity")
    func inverseMultiplication() {
        let m = Mat2x2(a: 4, b: 7, c: 2, d: 6)
        guard let inv = m.inverse else {
            #expect(Bool(false), "Matrix should be invertible")
            return
        }
        let product = m.multiplied(by: inv)
        #expect(abs(product.a - 1) < 1e-10)
        #expect(abs(product.b) < 1e-10)
        #expect(abs(product.c) < 1e-10)
        #expect(abs(product.d - 1) < 1e-10)
    }

    // MARK: - Trace

    @Test("Trace")
    func trace() {
        let m = Mat2x2(a: 1, b: 2, c: 3, d: 4)
        #expect(m.trace == 5)  // 1 + 4
    }

    @Test("3x3 trace")
    func trace3x3() {
        var m = Mat3x3.zero
        m[0, 0] = 1
        m[1, 1] = 2
        m[2, 2] = 3
        #expect(m.trace == 6)
    }

    // MARK: - Equatable

    @Test("Matrix equality")
    func equality() {
        let a = Mat2x2(a: 1, b: 2, c: 3, d: 4)
        let b = Mat2x2(a: 1, b: 2, c: 3, d: 4)
        let c = Mat2x2(a: 1, b: 2, c: 3, d: 5)
        #expect(a == b)
        #expect(a != c)
    }

    // MARK: - Non-square Matrix

    @Test("Non-square matrix multiplication")
    func nonSquareMultiplication() {
        // 2x3 matrix multiplied by 3x2 gives 2x2
        let m23: Linear<Double>.Matrix<2, 3> = .init(rows: [
            [1, 2, 3],
            [4, 5, 6]
        ])
        let m32: Linear<Double>.Matrix<3, 2> = .init(rows: [
            [1, 2],
            [3, 4],
            [5, 6]
        ])
        let result: Linear<Double>.Matrix<2, 2> = m23.multiplied(by: m32)
        // [1 2 3] * [1 2]   = [1*1+2*3+3*5  1*2+2*4+3*6] = [22 28]
        // [4 5 6]   [3 4]     [4*1+5*3+6*5  4*2+5*4+6*6]   [49 64]
        //           [5 6]
        #expect(result[0, 0] == 22)
        #expect(result[0, 1] == 28)
        #expect(result[1, 0] == 49)
        #expect(result[1, 1] == 64)
    }
}
