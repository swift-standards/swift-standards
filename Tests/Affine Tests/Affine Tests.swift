// Affine Tests.swift
// Tests for Affine.swift coordinate type aliases

import Testing

@testable import Affine
@testable import Algebra

@Suite("Affine Coordinate Tests")
struct AffineTests {
    typealias X = Affine<Double, Void>.X
    typealias Y = Affine<Double, Void>.Y
    typealias Z = Affine<Double, Void>.Z
    typealias Dx = Affine<Double, Void>.Dx
    typealias Dy = Affine<Double, Void>.Dy
    typealias Dz = Affine<Double, Void>.Dz

    // MARK: - X Coordinate Tests

    @Suite("X Coordinate")
    struct XCoordinateTests {
        @Test("X construction")
        func construction() {
            let x = X(3.0)
            #expect(x.value == 3.0)
        }

        @Test("X from integer literal")
        func fromIntegerLiteral() {
            let x: X = 5
            #expect(x.value == 5.0)
        }

        @Test("X from float literal")
        func fromFloatLiteral() {
            let x: X = 3.14
            #expect(x.value == 3.14)
        }

        @Test("X zero")
        func zero() {
            let x = X.zero
            #expect(x.value == 0)
        }

        @Test("X addition")
        func addition() {
            let a = X(3)
            let b = X(4)
            let sum = a + b
            #expect(sum.value == 7)
        }

        @Test("X subtraction")
        func subtraction() {
            let a = X(7)
            let b = X(4)
            let diff = a - b
            #expect(diff.value == 3)
        }

        @Test("X negation")
        func negation() {
            let x = X(3)
            let neg = -x
            #expect(neg.value == -3)
        }

        @Test("X scalar multiplication")
        func scalarMultiplication() {
            let x = X(3)
            let scaled = x * 2.0
            #expect(scaled.value == 6)
        }

        @Test("X scalar division")
        func scalarDivision() {
            let x = X(6)
            let scaled = x / 2.0
            #expect(scaled.value == 3)
        }

        @Test("X * X returns scalar")
        func squared() {
            let x = X(3)
            let squared: Double = x * x
            #expect(squared == 9)
        }

        @Test("X comparison")
        func comparison() {
            let a = X(3)
            let b = X(5)
            #expect(a < b)
            #expect(b > a)
            #expect(a <= a)
        }

        @Test("X equality")
        func equality() {
            let a = X(3)
            let b = X(3)
            let c = X(4)
            #expect(a == b)
            #expect(a != c)
        }

        @Test("X map")
        func map() throws {
            let x = X(3.0)
            let doubled: Affine<Int, Void>.X = try x.map { Int($0 * 2) }
            #expect(doubled.value == 6)
        }
    }

    // MARK: - Y Coordinate Tests

    @Suite("Y Coordinate")
    struct YCoordinateTests {
        @Test("Y construction")
        func construction() {
            let y = Y(4.0)
            #expect(y.value == 4.0)
        }

        @Test("Y from integer literal")
        func fromIntegerLiteral() {
            let y: Y = 5
            #expect(y.value == 5.0)
        }

        @Test("Y from float literal")
        func fromFloatLiteral() {
            let y: Y = 2.71
            #expect(y.value == 2.71)
        }

        @Test("Y zero")
        func zero() {
            let y = Y.zero
            #expect(y.value == 0)
        }

        @Test("Y addition")
        func addition() {
            let a = Y(3)
            let b = Y(4)
            let sum = a + b
            #expect(sum.value == 7)
        }

        @Test("Y subtraction")
        func subtraction() {
            let a = Y(7)
            let b = Y(4)
            let diff = a - b
            #expect(diff.value == 3)
        }

        @Test("Y negation")
        func negation() {
            let y = Y(3)
            let neg = -y
            #expect(neg.value == -3)
        }

        @Test("Y scalar multiplication")
        func scalarMultiplication() {
            let y = Y(3)
            let scaled = y * 2.0
            #expect(scaled.value == 6)
        }

        @Test("Y scalar division")
        func scalarDivision() {
            let y = Y(6)
            let scaled = y / 2.0
            #expect(scaled.value == 3)
        }

        @Test("Y * Y returns scalar")
        func squared() {
            let y = Y(4)
            let squared: Double = y * y
            #expect(squared == 16)
        }

        @Test("Y comparison")
        func comparison() {
            let a = Y(3)
            let b = Y(5)
            #expect(a < b)
            #expect(b > a)
            #expect(a <= a)
        }

        @Test("Y equality")
        func equality() {
            let a = Y(3)
            let b = Y(3)
            let c = Y(4)
            #expect(a == b)
            #expect(a != c)
        }

        @Test("Y map")
        func map() throws {
            let y = Y(4.0)
            let doubled: Affine<Int, Void>.Y = try y.map { Int($0 * 2) }
            #expect(doubled.value == 8)
        }
    }

    // MARK: - Z Coordinate Tests

    @Suite("Z Coordinate")
    struct ZCoordinateTests {
        @Test("Z construction")
        func construction() {
            let z = Z(5.0)
            #expect(z.value == 5.0)
        }

        @Test("Z zero")
        func zero() {
            let z = Z.zero
            #expect(z.value == 0)
        }

        @Test("Z equality")
        func equality() {
            let a = Z(3)
            let b = Z(3)
            let c = Z(4)
            #expect(a == b)
            #expect(a != c)
        }
    }
}
