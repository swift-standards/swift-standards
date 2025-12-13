// Radian+Trigonometry Tests.swift
// Tests for Radian trigonometric functions and constants

import Affine
import StandardsTestSupport
import Testing
import RealModule
@testable import Angle
@_spi(Internal) @testable import Dimension

@Suite
struct `Radian - Static Trigonometric Functions` {
    @Test(arguments: [
        (Radian<Double>.zero, 0.0),
        (Radian<Double>.halfPi, 1.0),
        (Radian(Double.pi), 0.0),
        (Radian<Double>.quarterPi, 1.0 / Double.sqrt(2.0)),
        (Radian<Double>(-Double.pi / 2), -1.0),
    ] as [(Radian<Double>, Double)])
    func `sin of common angles`(testCase: (Radian<Double>, Double)) {
        let (angle, expected) = testCase
        #expect(abs(Radian.sin(of: angle).value - expected) < 1e-10)
    }

    @Test(arguments: [
        (Radian<Double>.zero, 1.0),
        (Radian<Double>.halfPi, 0.0),
        (Radian(Double.pi), -1.0),
        (Radian<Double>.quarterPi, 1.0 / Double.sqrt(2.0)),
        (Radian<Double>(-Double.pi / 2), 0.0),
    ] as [(Radian<Double>, Double)])
    func `cos of common angles`(testCase: (Radian<Double>, Double)) {
        let (angle, expected) = testCase
        #expect(abs(Radian.cos(of: angle).value - expected) < 1e-10)
    }

    @Test(arguments: [
        (Radian<Double>.zero, 0.0),
        (Radian<Double>.quarterPi, 1.0),
        (Radian<Double>(-Double.pi / 4), -1.0),
    ] as [(Radian<Double>, Double)])
    func `tan of common angles`(testCase: (Radian<Double>, Double)) {
        let (angle, expected) = testCase
        let result = Radian.tan(of: angle)
        #expect(abs(result.value - expected) < 1e-10)
    }

    @Test
    func `tan of pi over 2`() {
        // tan(π/2) is very large due to floating-point precision
        let result = Radian.tan(of: Radian<Double>.halfPi)
        #expect(result.value.isInfinite || result.value > 1e10)
    }

    @Test
    func `sin of arbitrary angle`() {
        let angle: Radian<Double> = Radian(0.5)
        let result = Radian.sin(of: angle)
        let expected = Double.sin(0.5)
        #expect(abs(result.value - expected) < 1e-10)
    }

    @Test
    func `cos of arbitrary angle`() {
        let angle: Radian<Double> = Radian(0.5)
        let result = Radian.cos(of: angle)
        let expected = Double.cos(0.5)
        #expect(abs(result.value - expected) < 1e-10)
    }

    @Test
    func `tan of arbitrary angle`() {
        let angle: Radian<Double> = Radian(0.5)
        let result = Radian.tan(of: angle)
        let expected = Double.tan(0.5)
        #expect(abs(result.value - expected) < 1e-10)
    }
}

@Suite
struct `Radian - Instance Trigonometric Properties` {
    @Test
    func `sin property`() {
        let angle = Radian(Double.pi / 6)
        let result = angle.sin
        let expected = 0.5
        #expect(abs(result.value - expected) < 1e-10)
    }

    @Test
    func `cos property`() {
        let angle = Radian(Double.pi / 3)
        let result = angle.cos
        let expected = 0.5
        #expect(abs(result.value - expected) < 1e-10)
    }

    @Test
    func `tan property`() {
        let angle = Radian(Double.pi / 4)
        let result = angle.tan
        let expected = 1.0
        #expect(abs(result.value - expected) < 1e-10)
    }

    @Test
    func `instance sin matches static sin`() {
        let angle: Radian<Double> = Radian(0.7)
        let sinVal = angle.sin
        let staticSin = Radian.sin(of: angle)
        #expect(abs(sinVal.value - staticSin.value) < 1e-15)
    }

    @Test
    func `instance cos matches static cos`() {
        let angle: Radian<Double> = Radian(0.7)
        let cosVal = angle.cos
        let staticCos = Radian.cos(of: angle)
        #expect(abs(cosVal.value - staticCos.value) < 1e-15)
    }

    @Test
    func `instance tan matches static tan`() {
        let angle: Radian<Double> = Radian(0.7)
        let tanVal = angle.tan
        let staticTan = Radian.tan(of: angle)
        #expect(abs(tanVal.value - staticTan.value) < 1e-15)
    }
}

@Suite
struct `Radian - Inverse Trigonometric Functions` {
    @Test(arguments: [
        (0.0, 0.0),
        (1.0, Double.pi / 2),
        (-1.0, -Double.pi / 2),
        (0.5, Double.pi / 6),
    ])
    func asin(testCase: (Double, Double)) {
        let (value, expected) = testCase
        let result = Radian<Double>.asin(Scale(value))
        #expect(abs(result.value - expected) < 1e-10)
    }

    @Test(arguments: [
        (1.0, 0.0),
        (0.0, Double.pi / 2),
        (-1.0, Double.pi),
        (0.5, Double.pi / 3),
    ])
    func acos(testCase: (Double, Double)) {
        let (value, expected) = testCase
        let result = Radian<Double>.acos(Scale(value))
        #expect(abs(result.value - expected) < 1e-10)
    }

    @Test(arguments: [
        (0.0, 0.0),
        (1.0, Double.pi / 4),
        (-1.0, -Double.pi / 4),
    ])
    func atan(testCase: (Double, Double)) {
        let (value, expected) = testCase
        let result = Radian<Double>.atan(Scale(value))
        #expect(abs(result.value - expected) < 1e-10)
    }

    @Test(arguments: [
        (0.0, 0.0, 0.0),
        (1.0, 1.0, Double.pi / 4),
        (1.0, 0.0, Double.pi / 2),
        (0.0, 1.0, 0.0),
        (-1.0, 1.0, -Double.pi / 4),
    ])
    func atan2(testCase: (Double, Double, Double)) {
        let (y, x, expected) = testCase
        // Use displacement types as required by atan2
        typealias Dy = Displacement.Y<Void>.Value<Double>
        typealias Dx = Displacement.X<Void>.Value<Double>
        let result = Radian<Double>.atan2(y: Dy(y), x: Dx(x))
        #expect(abs(result.value - expected) < 1e-10)
    }

    @Test
    func `asin range`() {
        let result = Radian<Double>.asin(Scale(0.7))
        #expect(result.value >= -Double.pi / 2 && result.value <= Double.pi / 2)
    }

    @Test
    func `acos range`() {
        let result = Radian<Double>.acos(Scale(0.7))
        #expect(result.value >= 0 && result.value <= Double.pi)
    }

    @Test
    func `atan range`() {
        let result = Radian<Double>.atan(Scale(2.0))
        #expect(result.value > -Double.pi / 2 && result.value < Double.pi / 2)
    }

    @Test
    func `atan2 range`() {
        typealias Dy = Displacement.Y<Void>.Value<Double>
        typealias Dx = Displacement.X<Void>.Value<Double>
        let result = Radian<Double>.atan2(y: Dy(3.0), x: Dx(4.0))
        #expect(result.value > 0 && result.value <= Double.pi)
    }

    @Test
    func `round-trip sin-asin`() {
        let value: Scale<1, Double> = Scale(0.5)
        let angle = Radian<Double>.asin(value)
        let result = Radian.sin(of: angle)
        #expect(abs(result.value - value.value) < 1e-10)
    }

    @Test
    func `round-trip cos-acos`() {
        let value: Scale<1, Double> = Scale(0.5)
        let angle = Radian<Double>.acos(value)
        let result = Radian.cos(of: angle)
        #expect(abs(result.value - value.value) < 1e-10)
    }

    @Test
    func `round-trip tan-atan`() {
        let value: Scale<1, Double> = Scale(1.0)
        let angle = Radian<Double>.atan(value)
        let result = Radian.tan(of: angle)
        #expect(abs(result.value - value.value) < 1e-10)
    }
}

@Suite
struct `Radian - Constants` {
    @Test
    func pi() {
        let piValue: Radian<Double> = .pi
        #expect(abs(piValue.value - Double.pi) < 1e-15)
    }

    @Test
    func twoPi() {
        #expect(abs(Radian<Double>.twoPi.value - 2 * Double.pi) < 1e-15)
    }

    @Test
    func halfPi() {
        #expect(abs(Radian<Double>.halfPi.value - Double.pi / 2) < 1e-15)
    }

    @Test
    func quarterPi() {
        #expect(abs(Radian<Double>.quarterPi.value - Double.pi / 4) < 1e-15)
    }

    @Test(arguments: [
        (1.0, Double.pi),
        (2.0, Double.pi / 2),
        (3.0, Double.pi / 3),
        (4.0, Double.pi / 4),
    ])
    func `pi over n`(testCase: (Double, Double)) {
        let (n, expected) = testCase
        let result = Radian<Double>.pi(over: n)
        #expect(abs(result.value - expected) < 1e-10)
    }

    @Test(arguments: [
        (1.0, Double.pi),
        (2.0, 2 * Double.pi),
        (1.5, 1.5 * Double.pi),
        (0.5, 0.5 * Double.pi),
    ])
    func `pi times n`(testCase: (Double, Double)) {
        let (n, expected) = testCase
        let result = Radian<Double>.pi(times: n)
        #expect(abs(result.value - expected) < 1e-10)
    }
}

@Suite
struct `Radian - Normalization (Static)` {
    @Test(arguments: [
        (Radian<Double>(0), Radian<Double>(0)),
        (Radian<Double>(Double.pi), Radian<Double>(Double.pi)),
        (Radian<Double>(2 * Double.pi), Radian<Double>(0)),
        (Radian<Double>(3 * Double.pi), Radian<Double>(Double.pi)),
        (Radian<Double>(-Double.pi / 2), Radian<Double>(3 * Double.pi / 2)),
    ] as [(Radian<Double>, Radian<Double>)])
    func `normalized to 0-2π range`(testCase: (Radian<Double>, Radian<Double>)) {
        let (angle, expected) = testCase
        let result = Radian.normalized(angle)
        #expect(abs(result.value - expected.value) < 1e-10)
    }

    @Test
    func `normalized is in valid range`() {
        let angle: Radian<Double> = Radian(100)
        let result = Radian.normalized(angle)
        #expect(result.value >= 0 && result.value < 2 * Double.pi)
    }

    @Test
    func `normalized negative angle`() {
        let angle: Radian<Double> = Radian(-10)
        let result = Radian.normalized(angle)
        #expect(result.value >= 0 && result.value < 2 * Double.pi)
    }

    @Test
    func `normalized zero stays zero`() {
        let angle: Radian<Double> = Radian(0)
        let result = Radian.normalized(angle)
        #expect(abs(result.value) < 1e-15)
    }

    @Test
    func `normalized preserves angle in range`() {
        let angle = Radian(Double.pi / 3)
        let result = Radian.normalized(angle)
        #expect(abs(result.value - Double.pi / 3) < 1e-15)
    }
}

@Suite
struct `Radian - Normalization (Instance)` {
    @Test
    func `normalized property`() {
        let angle = Radian(3 * Double.pi)
        let result = angle.normalized
        #expect(abs(result.value - Double.pi) < 1e-10)
    }

    @Test
    func `instance normalized matches static normalized`() {
        let angle: Radian<Double> = Radian(100)
        #expect(abs(angle.normalized.value - Radian.normalized(angle).value) < 1e-15)
    }

    @Test
    func `normalized property is in valid range`() {
        let angle: Radian<Double> = Radian(100)
        let result = angle.normalized
        #expect(result.value >= 0 && result.value < 2 * Double.pi)
    }
}
