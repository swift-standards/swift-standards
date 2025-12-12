// Radian+Trigonometry Tests.swift
// Tests for Radian trigonometric functions and constants

import StandardsTestSupport
import Testing
import RealModule
@testable import Angle

@Suite("Radian - Static Trigonometric Functions")
struct RadianTrigonometryStaticTests {
    @Test(arguments: [
        (Radian.zero, 0.0),
        (Radian.halfPi, 1.0),
        (Radian.pi, 0.0),
        (Radian.quarterPi, 1.0 / Double.sqrt(2.0)),
        (Radian(-.pi / 2), -1.0),
    ])
    func `sin of common angles`(testCase: (Radian, Double)) {
        let (angle, expected) = testCase
        #expect(abs(Radian.sin(of: angle) - expected) < 1e-10)
    }

    @Test(arguments: [
        (Radian.zero, 1.0),
        (Radian.halfPi, 0.0),
        (Radian.pi, -1.0),
        (Radian.quarterPi, 1.0 / Double.sqrt(2.0)),
        (Radian(-.pi / 2), 0.0),
    ])
    func `cos of common angles`(testCase: (Radian, Double)) {
        let (angle, expected) = testCase
        #expect(abs(Radian.cos(of: angle) - expected) < 1e-10)
    }

    @Test(arguments: [
        (Radian.zero, 0.0),
        (Radian.quarterPi, 1.0),
        (Radian(-.pi / 4), -1.0),
    ])
    func `tan of common angles`(testCase: (Radian, Double)) {
        let (angle, expected) = testCase
        let result = Radian.tan(of: angle)
        #expect(abs(result - expected) < 1e-10)
    }

    @Test
    func `tan of pi over 2`() {
        // tan(π/2) is very large due to floating-point precision
        let result = Radian.tan(of: Radian.halfPi)
        #expect(result.isInfinite || result > 1e10)
    }

    @Test
    func `sin of arbitrary angle`() {
        let angle = Radian(0.5)
        let result = Radian.sin(of: angle)
        let expected = Double.sin(0.5)
        #expect(abs(result - expected) < 1e-10)
    }

    @Test
    func `cos of arbitrary angle`() {
        let angle = Radian(0.5)
        let result = Radian.cos(of: angle)
        let expected = Double.cos(0.5)
        #expect(abs(result - expected) < 1e-10)
    }

    @Test
    func `tan of arbitrary angle`() {
        let angle = Radian(0.5)
        let result = Radian.tan(of: angle)
        let expected = Double.tan(0.5)
        #expect(abs(result - expected) < 1e-10)
    }
}

@Suite("Radian - Instance Trigonometric Properties")
struct RadianTrigonometryInstanceTests {
    @Test
    func `sin property`() {
        let angle = Radian(.pi / 6)
        let result = angle.sin
        let expected = 0.5
        #expect(abs(result - expected) < 1e-10)
    }

    @Test
    func `cos property`() {
        let angle = Radian(.pi / 3)
        let result = angle.cos
        let expected = 0.5
        #expect(abs(result - expected) < 1e-10)
    }

    @Test
    func `tan property`() {
        let angle = Radian(.pi / 4)
        let result = angle.tan
        let expected = 1.0
        #expect(abs(result - expected) < 1e-10)
    }

    @Test
    func `instance sin matches static sin`() {
        let angle = Radian(0.7)
        #expect(abs(angle.sin - Radian.sin(of: angle)) < 1e-15)
    }

    @Test
    func `instance cos matches static cos`() {
        let angle = Radian(0.7)
        #expect(abs(angle.cos - Radian.cos(of: angle)) < 1e-15)
    }

    @Test
    func `instance tan matches static tan`() {
        let angle = Radian(0.7)
        #expect(abs(angle.tan - Radian.tan(of: angle)) < 1e-15)
    }
}

@Suite("Radian - Inverse Trigonometric Functions")
struct RadianInverseTrigonometryTests {
    @Test(arguments: [
        (0.0, 0.0),
        (1.0, .pi / 2),
        (-1.0, -.pi / 2),
        (0.5, .pi / 6),
    ])
    func asin(testCase: (Double, Double)) {
        let (value, expected) = testCase
        let result = Radian.asin(value)
        #expect(abs(result.value - expected) < 1e-10)
    }

    @Test(arguments: [
        (1.0, 0.0),
        (0.0, .pi / 2),
        (-1.0, .pi),
        (0.5, .pi / 3),
    ])
    func acos(testCase: (Double, Double)) {
        let (value, expected) = testCase
        let result = Radian.acos(value)
        #expect(abs(result.value - expected) < 1e-10)
    }

    @Test(arguments: [
        (0.0, 0.0),
        (1.0, .pi / 4),
        (-1.0, -.pi / 4),
    ])
    func atan(testCase: (Double, Double)) {
        let (value, expected) = testCase
        let result = Radian.atan(value)
        #expect(abs(result.value - expected) < 1e-10)
    }

    @Test(arguments: [
        (0.0, 0.0, 0.0),
        (1.0, 1.0, .pi / 4),
        (1.0, 0.0, .pi / 2),
        (0.0, 1.0, 0.0),
        (-1.0, 1.0, -.pi / 4),
    ])
    func atan2(testCase: (Double, Double, Double)) {
        let (y, x, expected) = testCase
        let result = Radian.atan2(y: y, x: x)
        #expect(abs(result.value - expected) < 1e-10)
    }

    @Test
    func `asin range`() {
        let result = Radian.asin(0.7)
        #expect(result.value >= -.pi / 2 && result.value <= .pi / 2)
    }

    @Test
    func `acos range`() {
        let result = Radian.acos(0.7)
        #expect(result.value >= 0 && result.value <= .pi)
    }

    @Test
    func `atan range`() {
        let result = Radian.atan(2.0)
        #expect(result.value > -.pi / 2 && result.value < .pi / 2)
    }

    @Test
    func `atan2 range`() {
        let result = Radian.atan2(y: 3.0, x: 4.0)
        #expect(result.value > 0 && result.value <= .pi)
    }

    @Test
    func `round-trip sin-asin`() {
        let value = 0.5
        let angle = Radian.asin(value)
        let result = Radian.sin(of: angle)
        #expect(abs(result - value) < 1e-10)
    }

    @Test
    func `round-trip cos-acos`() {
        let value = 0.5
        let angle = Radian.acos(value)
        let result = Radian.cos(of: angle)
        #expect(abs(result - value) < 1e-10)
    }

    @Test
    func `round-trip tan-atan`() {
        let value = 1.0
        let angle = Radian.atan(value)
        let result = Radian.tan(of: angle)
        #expect(abs(result - value) < 1e-10)
    }
}

@Suite("Radian - Constants")
struct RadianConstantsTests {
    @Test
    func pi() {
        #expect(abs(Radian.pi.value - Double.pi) < 1e-15)
    }

    @Test
    func twoPi() {
        #expect(abs(Radian.twoPi.value - 2 * Double.pi) < 1e-15)
    }

    @Test
    func halfPi() {
        #expect(abs(Radian.halfPi.value - Double.pi / 2) < 1e-15)
    }

    @Test
    func quarterPi() {
        #expect(abs(Radian.quarterPi.value - Double.pi / 4) < 1e-15)
    }

    @Test(arguments: [
        (1.0, Double.pi),
        (2.0, Double.pi / 2),
        (3.0, Double.pi / 3),
        (4.0, Double.pi / 4),
    ])
    func `pi over n`(testCase: (Double, Double)) {
        let (n, expected) = testCase
        let result = Radian.pi(over: n)
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
        let result = Radian.pi(times: n)
        #expect(abs(result.value - expected) < 1e-10)
    }
}

@Suite("Radian - Normalization (Static)")
struct RadianNormalizationStaticTests {
    @Test(arguments: [
        (Radian(0), Radian(0)),
        (Radian(.pi), Radian(.pi)),
        (Radian(2 * .pi), Radian(0)),
        (Radian(3 * .pi), Radian(.pi)),
        (Radian(-.pi / 2), Radian(3 * .pi / 2)),
    ])
    func `normalized to 0-2π range`(testCase: (Radian, Radian)) {
        let (angle, expected) = testCase
        let result = Radian.normalized(angle)
        #expect(abs(result.value - expected.value) < 1e-10)
    }

    @Test
    func `normalized is in valid range`() {
        let angle = Radian(100)
        let result = Radian.normalized(angle)
        #expect(result.value >= 0 && result.value < 2 * .pi)
    }

    @Test
    func `normalized negative angle`() {
        let angle = Radian(-10)
        let result = Radian.normalized(angle)
        #expect(result.value >= 0 && result.value < 2 * .pi)
    }

    @Test
    func `normalized zero stays zero`() {
        let angle = Radian(0)
        let result = Radian.normalized(angle)
        #expect(abs(result.value) < 1e-15)
    }

    @Test
    func `normalized preserves angle in range`() {
        let angle = Radian(.pi / 3)
        let result = Radian.normalized(angle)
        #expect(abs(result.value - .pi / 3) < 1e-15)
    }
}

@Suite("Radian - Normalization (Instance)")
struct RadianNormalizationInstanceTests {
    @Test
    func `normalized property`() {
        let angle = Radian(3 * .pi)
        let result = angle.normalized
        #expect(abs(result.value - .pi) < 1e-10)
    }

    @Test
    func `instance normalized matches static normalized`() {
        let angle = Radian(100)
        #expect(abs(angle.normalized.value - Radian.normalized(angle).value) < 1e-15)
    }

    @Test
    func `normalized property is in valid range`() {
        let angle = Radian(100)
        let result = angle.normalized
        #expect(result.value >= 0 && result.value < 2 * .pi)
    }
}
