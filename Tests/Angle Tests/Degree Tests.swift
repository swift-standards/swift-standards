// Degree Tests.swift
// Tests for Degree type (basic structure, arithmetic, trigonometry, conversions)

import StandardsTestSupport
import Testing
import RealModule
@testable import Dimension
@Suite
struct `Degree - Basic Structure & Arithmetic` {
    @Test
    func initialization() {
        let angle: Degree<Double> = Degree(90)
        #expect(angle == Degree(90))
    }

    @Test
    func zero() {
        let zero = Degree<Double>.zero
        #expect(zero == Degree(0))
    }

    @Test
    func addition() {
        let angle1: Degree<Double> = Degree(45)
        let angle2: Degree<Double> = Degree(45)
        let result = angle1 + angle2
        #expect(result == Degree(90))
    }

    @Test
    func subtraction() {
        let angle1: Degree<Double> = Degree(90)
        let angle2: Degree<Double> = Degree(45)
        let result = angle1 - angle2
        #expect(result == Degree(45))
    }

    @Test
    func scalarMultiplication() {
        let angle: Degree<Double> = Degree(45)
        let result = angle * 2.0
        #expect(result == Degree(90))
    }

    @Test
    func scalarDivision() {
        let angle: Degree<Double> = Degree(180)
        let result = angle / 2.0
        #expect(result == Degree(90))
    }

    @Test
    func negation() {
        let angle: Degree<Double> = Degree(45)
        let result = -angle
        #expect(result == Degree(-45))
    }

    @Test
    func comparison() {
        let angle1: Degree<Double> = Degree(45)
        let angle2: Degree<Double> = Degree(90)
        #expect(angle1 < angle2)
        #expect(angle2 > angle1)
    }

    @Test
    func magnitude() {
        let angle: Degree<Double> = Degree(-45)
        #expect(angle.magnitude == Degree(45))
        #expect(abs(angle) == Degree(45))  // Also test abs() free function
    }

    @Test
    func expressibleByFloatLiteral() {
        let angle: Degree<Double> = 45.5
        #expect(angle == Degree(45.5))
    }

    @Test
    func expressibleByIntegerLiteral() {
        let angle: Degree<Double> = 90
        #expect(angle == Degree(90.0))
    }

    @Test
    func hashable() {
        let angle1: Degree<Double> = Degree(45)
        let angle2: Degree<Double> = Degree(45)
        #expect(angle1.hashValue == angle2.hashValue)
    }

    @Test
    func equatable() {
        let angle1: Degree<Double> = Degree(45)
        let angle2: Degree<Double> = Degree(45)
        #expect(angle1 == angle2)
    }
}

// Helper for approximate Radian comparisons
private func isApprox(_ a: Radian<Double>, _ b: Radian<Double>, tol: Double = 1e-10) -> Bool {
    let diff = a - b
    return diff > Radian(-tol) && diff < Radian(tol)
}

// Helper for approximate Degree comparisons
private func isApprox(_ a: Degree<Double>, _ b: Degree<Double>, tol: Double = 1e-10) -> Bool {
    let diff = a - b
    return diff > Degree(-tol) && diff < Degree(tol)
}

@Suite
struct `Degree - Conversion` {
    @Test
    func conversionToRadians() {
        let degrees: Degree<Double> = 180
        let radians = degrees.radians
        #expect(isApprox(radians, Radian(Double.pi)))
    }

    @Test
    func conversionFromRadians() {
        let radians = Radian(Double.pi / 2)
        let degrees = Degree(radians: radians)
        #expect(isApprox(degrees, Degree(90.0)))
    }

    @Test(arguments: [
        (Degree<Double>(0), Radian<Double>(0)),
        (Degree<Double>(90), Radian<Double>(Double.pi / 2)),
        (Degree<Double>(180), Radian<Double>(Double.pi)),
        (Degree<Double>(270), Radian<Double>(3 * Double.pi / 2)),
        (Degree<Double>(360), Radian<Double>(2 * Double.pi)),
    ] as [(Degree<Double>, Radian<Double>)])
    func `conversion to radians common angles`(testCase: (Degree<Double>, Radian<Double>)) {
        let (degrees, expected) = testCase
        let result = degrees.radians
        #expect(isApprox(result, expected))
    }

    @Test(arguments: [
        (Radian<Double>(0), Degree<Double>(0)),
        (Radian<Double>(Double.pi / 2), Degree<Double>(90)),
        (Radian<Double>(Double.pi), Degree<Double>(180)),
        (Radian<Double>(3 * Double.pi / 2), Degree<Double>(270)),
        (Radian<Double>(2 * Double.pi), Degree<Double>(360)),
    ] as [(Radian<Double>, Degree<Double>)])
    func `conversion from radians common angles`(testCase: (Radian<Double>, Degree<Double>)) {
        let (radians, expected) = testCase
        let result = Degree(radians: radians)
        #expect(isApprox(result, expected))
    }

    @Test
    func `round-trip conversion`() {
        let original: Degree<Double> = Degree(45)
        let radians = original.radians
        let back = Degree(radians: radians)
        #expect(isApprox(back, original))
    }
}

@Suite
struct `Degree - Common Angles` {
    @Test
    func rightAngle() {
        #expect(Degree<Double>.rightAngle == Degree(90))
    }

    @Test
    func straight() {
        #expect(Degree<Double>.straight == Degree(180))
    }

    @Test
    func fullCircle() {
        #expect(Degree<Double>.fullCircle == Degree(360))
    }

    @Test
    func fortyFive() {
        #expect(Degree<Double>.fortyFive == Degree(45))
    }

    @Test
    func sixty() {
        #expect(Degree<Double>.sixty == Degree(60))
    }

    @Test
    func thirty() {
        #expect(Degree<Double>.thirty == Degree(30))
    }
}

@Suite
struct `Degree - Trigonometric Functions` {
    @Test(arguments: [
        (Degree<Double>(0), 0.0),
        (Degree<Double>(90), 1.0),
        (Degree<Double>(180), 0.0),
        (Degree<Double>(45), 1.0 / Double.sqrt(2.0)),
        (Degree<Double>(30), 0.5),
        (Degree<Double>(60), Double.sqrt(3.0) / 2),
    ] as [(Degree<Double>, Double)])
    func `sin of common angles`(testCase: (Degree<Double>, Double)) {
        let (angle, expected) = testCase
        #expect(abs(angle.sin.value - expected) < 1e-10)
    }

    @Test(arguments: [
        (Degree<Double>(0), 1.0),
        (Degree<Double>(90), 0.0),
        (Degree<Double>(180), -1.0),
        (Degree<Double>(45), 1.0 / Double.sqrt(2.0)),
        (Degree<Double>(30), Double.sqrt(3.0) / 2),
        (Degree<Double>(60), 0.5),
    ] as [(Degree<Double>, Double)])
    func `cos of common angles`(testCase: (Degree<Double>, Double)) {
        let (angle, expected) = testCase
        #expect(abs(angle.cos.value - expected) < 1e-10)
    }

    @Test(arguments: [
        (Degree<Double>(0), 0.0),
        (Degree<Double>(45), 1.0),
        (Degree<Double>(30), 1.0 / Double.sqrt(3.0)),
        (Degree<Double>(60), Double.sqrt(3.0)),
    ] as [(Degree<Double>, Double)])
    func `tan of common angles`(testCase: (Degree<Double>, Double)) {
        let (angle, expected) = testCase
        #expect(abs(angle.tan.value - expected) < 1e-10)
    }

    @Test
    func `degree trig matches radian trig`() {
        let deg: Degree<Double> = Degree(30)
        let rad = deg.radians
        #expect(abs(deg.sin.value - rad.sin.value) < 1e-15)
        #expect(abs(deg.cos.value - rad.cos.value) < 1e-15)
        #expect(abs(deg.tan.value - rad.tan.value) < 1e-15)
    }
}

@Suite
struct `Degree - Trigonometric Special Angles` {
    @Test
    func `right angle sin`() {
        let result = Degree<Double>.rightAngle.sin
        #expect(abs(result.value - 1.0) < 1e-10)
    }

    @Test
    func `right angle cos`() {
        let result = Degree<Double>.rightAngle.cos
        #expect(abs(result.value) < 1e-10)
    }

    @Test
    func `straight angle sin`() {
        let result = Degree<Double>.straight.sin
        #expect(abs(result.value) < 1e-10)
    }

    @Test
    func `straight angle cos`() {
        let result = Degree<Double>.straight.cos
        #expect(abs(result.value - (-1.0)) < 1e-10)
    }
}
