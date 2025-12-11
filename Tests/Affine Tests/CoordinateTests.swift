// CoordinateTests.swift
// Tests for Affine.X and Affine.Y

import Testing

@testable import Affine
@testable import Algebra

@Suite("Affine Coordinate Tests")
struct CoordinateTests {
    typealias X = Affine<Double, Void>.X
    typealias Y = Affine<Double, Void>.Y

    // MARK: - X Construction

    @Test("X construction")
    func xConstruction() {
        let x = X(3.0)
        #expect(x.value == 3.0)
    }

    @Test("X from integer literal")
    func xFromIntegerLiteral() {
        let x: X = 5
        #expect(x.value == 5.0)
    }

    @Test("X from float literal")
    func xFromFloatLiteral() {
        let x: X = 3.14
        #expect(x.value == 3.14)
    }

    // MARK: - Y Construction

    @Test("Y construction")
    func yConstruction() {
        let y = Y(4.0)
        #expect(y.value == 4.0)
    }

    @Test("Y from integer literal")
    func yFromIntegerLiteral() {
        let y: Y = 5
        #expect(y.value == 5.0)
    }

    @Test("Y from float literal")
    func yFromFloatLiteral() {
        let y: Y = 2.71
        #expect(y.value == 2.71)
    }

    // MARK: - Zero

    @Test("X zero")
    func xZero() {
        let x = X.zero
        #expect(x.value == 0)
    }

    @Test("Y zero")
    func yZero() {
        let y = Y.zero
        #expect(y.value == 0)
    }

    // MARK: - Arithmetic

    @Test("X addition")
    func xAddition() {
        let a = X(3)
        let b = X(4)
        let sum = a + b
        #expect(sum.value == 7)
    }

    @Test("Y addition")
    func yAddition() {
        let a = Y(3)
        let b = Y(4)
        let sum = a + b
        #expect(sum.value == 7)
    }

    @Test("X subtraction")
    func xSubtraction() {
        let a = X(7)
        let b = X(4)
        let diff = a - b
        #expect(diff.value == 3)
    }

    @Test("Y subtraction")
    func ySubtraction() {
        let a = Y(7)
        let b = Y(4)
        let diff = a - b
        #expect(diff.value == 3)
    }

    @Test("X negation")
    func xNegation() {
        let x = X(3)
        let neg = -x
        #expect(neg.value == -3)
    }

    @Test("Y negation")
    func yNegation() {
        let y = Y(3)
        let neg = -y
        #expect(neg.value == -3)
    }

    @Test("X scalar multiplication")
    func xScalarMultiplication() {
        let x = X(3)
        let scaled = x * 2.0
        #expect(scaled.value == 6)
    }

    @Test("Y scalar multiplication")
    func yScalarMultiplication() {
        let y = Y(3)
        let scaled = y * 2.0
        #expect(scaled.value == 6)
    }

    @Test("X scalar division")
    func xScalarDivision() {
        let x = X(6)
        let scaled = x / 2.0
        #expect(scaled.value == 3)
    }

    @Test("Y scalar division")
    func yScalarDivision() {
        let y = Y(6)
        let scaled = y / 2.0
        #expect(scaled.value == 3)
    }

    // MARK: - Squared (Distance Calculations)

    @Test("X * X returns scalar")
    func xTimesX() {
        let x = X(3)
        let squared: Double = x * x
        #expect(squared == 9)
    }

    @Test("Y * Y returns scalar")
    func yTimesY() {
        let y = Y(4)
        let squared: Double = y * y
        #expect(squared == 16)
    }

    // Note: X * Y cross-axis multiplication is only defined for displacements (Dx * Dy),
    // not for coordinates. Coordinates represent positions, not magnitudes that can be multiplied.

    // MARK: - Comparison

    @Test("X comparison")
    func xComparison() {
        let a = X(3)
        let b = X(5)
        #expect(a < b)
        #expect(b > a)
        #expect(a <= a)
    }

    @Test("Y comparison")
    func yComparison() {
        let a = Y(3)
        let b = Y(5)
        #expect(a < b)
        #expect(b > a)
        #expect(a <= a)
    }

    // MARK: - Equatable

    @Test("X equality")
    func xEquality() {
        let a = X(3)
        let b = X(3)
        let c = X(4)
        #expect(a == b)
        #expect(a != c)
    }

    @Test("Y equality")
    func yEquality() {
        let a = Y(3)
        let b = Y(3)
        let c = Y(4)
        #expect(a == b)
        #expect(a != c)
    }

    // MARK: - Map

    @Test("X map")
    func xMap() throws {
        let x = X(3.0)
        let doubled: Affine<Int, Void>.X = try x.map { Int($0 * 2) }
        #expect(doubled.value == 6)
    }

    @Test("Y map")
    func yMap() throws {
        let y = Y(4.0)
        let doubled: Affine<Int, Void>.Y = try y.map { Int($0 * 2) }
        #expect(doubled.value == 8)
    }
}
