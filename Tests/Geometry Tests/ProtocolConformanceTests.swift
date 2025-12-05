// ProtocolConformanceTests.swift
// Tests for protocol conformances added to scalar wrappers and other types.

import Testing
@testable import Geometry

// MARK: - Strideable Tests

@Suite("Strideable Conformance Tests")
struct StrideableTests {
    @Test("X is Strideable")
    func xStrideable() {
        let x: Geometry<Double>.X = 10
        let next = x.advanced(by: 5)
        #expect(next == 15)
        #expect(x.distance(to: next) == 5)
    }

    @Test("Y is Strideable")
    func yStrideable() {
        let y: Geometry<Double>.Y = 20
        let next = y.advanced(by: 10)
        #expect(next == 30)
        #expect(y.distance(to: next) == 10)
    }

    @Test("Width is Strideable")
    func widthStrideable() {
        let w: Geometry<Double>.Width = 100
        let next = w.advanced(by: 50)
        #expect(next == 150)
        #expect(w.distance(to: next) == 50)
    }

    @Test("Height is Strideable")
    func heightStrideable() {
        let h: Geometry<Double>.Height = 200
        let next = h.advanced(by: 100)
        #expect(next == 300)
        #expect(h.distance(to: next) == 100)
    }

    @Test("Length is Strideable")
    func lengthStrideable() {
        let len: Geometry<Double>.Length = 50
        let next = len.advanced(by: 25)
        #expect(next == 75)
        #expect(len.distance(to: next) == 25)
    }

    @Test("Depth is Strideable")
    func depthStrideable() {
        let d: Geometry<Double>.Depth = 30
        let next = d.advanced(by: 15)
        #expect(next == 45)
        #expect(d.distance(to: next) == 15)
    }

    @Test("Dimension is Strideable")
    func dimensionStrideable() {
        let dim: Geometry<Double>.Dimension = 40
        let next = dim.advanced(by: 20)
        #expect(next == 60)
        #expect(dim.distance(to: next) == 20)
    }

    @Test("X stride sequence")
    func xStrideSequence() {
        var values: [Geometry<Double>.X] = []
        for x in stride(from: Geometry<Double>.X(0), to: Geometry<Double>.X(5), by: 1) {
            values.append(x)
        }
        #expect(values.count == 5)
        #expect(values[0] == 0)
        #expect(values[4] == 4)
    }

    @Test("Width stride through")
    func widthStrideThrough() {
        var values: [Geometry<Double>.Width] = []
        for w in stride(from: Geometry<Double>.Width(0), through: Geometry<Double>.Width(10), by: 2) {
            values.append(w)
        }
        #expect(values.count == 6)
        #expect(values.last == 10)
    }
}

// MARK: - Size AdditiveArithmetic Tests

@Suite("Size AdditiveArithmetic Tests")
struct SizeAdditiveArithmeticTests {
    @Test("Size addition")
    func sizeAddition() {
        let a: Geometry<Double>.Size<2> = .init(width: 100, height: 200)
        let b: Geometry<Double>.Size<2> = .init(width: 50, height: 100)
        let sum = a + b
        #expect(sum.width == 150)
        #expect(sum.height == 300)
    }

    @Test("Size subtraction")
    func sizeSubtraction() {
        let a: Geometry<Double>.Size<2> = .init(width: 100, height: 200)
        let b: Geometry<Double>.Size<2> = .init(width: 30, height: 50)
        let diff = a - b
        #expect(diff.width == 70)
        #expect(diff.height == 150)
    }

    @Test("Size zero")
    func sizeZero() {
        let zero: Geometry<Double>.Size<2> = .zero
        #expect(zero.width == 0)
        #expect(zero.height == 0)
    }

    @Test("Size negation")
    func sizeNegation() {
        let size: Geometry<Double>.Size<2> = .init(width: 100, height: 200)
        let neg = -size
        #expect(neg.width == -100)
        #expect(neg.height == -200)
    }

    @Test("Size scalar multiplication")
    func sizeScalarMultiplication() {
        let size: Geometry<Double>.Size<2> = .init(width: 100, height: 200)
        let scaled = size * 2
        #expect(scaled.width == 200)
        #expect(scaled.height == 400)

        let scaled2 = 3 * size
        #expect(scaled2.width == 300)
        #expect(scaled2.height == 600)
    }

    @Test("Size scalar division")
    func sizeScalarDivision() {
        let size: Geometry<Double>.Size<2> = .init(width: 100, height: 200)
        let divided = size / 2
        #expect(divided.width == 50)
        #expect(divided.height == 100)
    }

    @Test("Size 3D addition")
    func size3DAddition() {
        let a: Geometry<Double>.Size<3> = .init(width: 10, height: 20, depth: 30)
        let b: Geometry<Double>.Size<3> = .init(width: 5, height: 10, depth: 15)
        let sum = a + b
        #expect(sum.width == 15)
        #expect(sum.height == 30)
        #expect(sum.depth == 45)
    }
}

// MARK: - EdgeInsets AdditiveArithmetic Tests

@Suite("EdgeInsets AdditiveArithmetic Tests")
struct EdgeInsetsAdditiveArithmeticTests {
    @Test("EdgeInsets addition")
    func edgeInsetsAddition() {
        let a: Geometry<Double>.EdgeInsets = .init(top: 10, leading: 20, bottom: 30, trailing: 40)
        let b: Geometry<Double>.EdgeInsets = .init(top: 5, leading: 10, bottom: 15, trailing: 20)
        let sum = a + b
        #expect(sum.top == 15)
        #expect(sum.leading == 30)
        #expect(sum.bottom == 45)
        #expect(sum.trailing == 60)
    }

    @Test("EdgeInsets subtraction")
    func edgeInsetsSubtraction() {
        let a: Geometry<Double>.EdgeInsets = .init(top: 10, leading: 20, bottom: 30, trailing: 40)
        let b: Geometry<Double>.EdgeInsets = .init(top: 5, leading: 10, bottom: 15, trailing: 20)
        let diff = a - b
        #expect(diff.top == 5)
        #expect(diff.leading == 10)
        #expect(diff.bottom == 15)
        #expect(diff.trailing == 20)
    }

    @Test("EdgeInsets zero")
    func edgeInsetsZero() {
        let zero: Geometry<Double>.EdgeInsets = .zero
        #expect(zero.top == 0)
        #expect(zero.leading == 0)
        #expect(zero.bottom == 0)
        #expect(zero.trailing == 0)
    }

    @Test("EdgeInsets combined equals addition")
    func edgeInsetsCombined() {
        let a: Geometry<Double>.EdgeInsets = .init(top: 10, leading: 20, bottom: 30, trailing: 40)
        let b: Geometry<Double>.EdgeInsets = .init(top: 5, leading: 10, bottom: 15, trailing: 20)
        let combined: Geometry<Double>.EdgeInsets = .combined(a, b)
        let sum = a + b
        #expect(combined == sum)
    }
}

// MARK: - Scalar Wrapper Operator Tests

@Suite("Scalar Wrapper Operators")
struct ScalarWrapperOperatorTests {
    @Test("X multiplication and division")
    func xOperators() {
        let x: Geometry<Double>.X = 10
        let xTimes2: Geometry<Double>.X = x * 2.0
        let twoTimesX: Geometry<Double>.X = 2.0 * x
        #expect(xTimes2 == 20)
        #expect(twoTimesX == 20)
        #expect((x / 2) == 5)
        #expect((-x) == -10)
    }

    @Test("Y multiplication and division")
    func yOperators() {
        let y: Geometry<Double>.Y = 10
        let yTimes2: Geometry<Double>.Y = y * 2.0
        let twoTimesY: Geometry<Double>.Y = 2.0 * y
        #expect(yTimes2 == 20)
        #expect(twoTimesY == 20)
        #expect((y / 2) == 5)
        #expect((-y) == -10)
    }

    @Test("Width multiplication and division")
    func widthOperators() {
        let w: Geometry<Double>.Width = 10
        #expect((w * 2) == 20)
        #expect((2 * w) == 20)
        #expect((w / 2) == 5)
        #expect((-w) == -10)
    }

    @Test("Height multiplication and division")
    func heightOperators() {
        let h: Geometry<Double>.Height = 10
        #expect((h * 2) == 20)
        #expect((2 * h) == 20)
        #expect((h / 2) == 5)
        #expect((-h) == -10)
    }

    @Test("Length multiplication and division")
    func lengthOperators() {
        let len: Geometry<Double>.Length = 10
        #expect((len * 2) == 20)
        #expect((2 * len) == 20)
        #expect((len / 2) == 5)
        #expect((-len) == -10)
    }

    @Test("Depth multiplication and division")
    func depthOperators() {
        let d: Geometry<Double>.Depth = 10
        #expect((d * 2) == 20)
        #expect((2 * d) == 20)
        #expect((d / 2) == 5)
        #expect((-d) == -10)
    }

    @Test("Dimension multiplication and division")
    func dimensionOperators() {
        let dim: Geometry<Double>.Dimension = 10
        #expect((dim * 2) == 20)
        #expect((2 * dim) == 20)
        #expect((dim / 2) == 5)
        #expect((-dim) == -10)
    }

    @Test("Dimension map")
    func dimensionMap() {
        let dim: Geometry<Double>.Dimension = 10
        let mapped = dim.map { $0 * 3 + 1 }
        #expect(mapped == 31)
    }
}
