// Degree Tests.swift
// Tests for Degree type (basic structure, arithmetic, trigonometry, conversions)

import StandardsTestSupport
import Testing
import RealModule
@testable import Angle

@Suite("Degree - Basic Structure & Arithmetic")
struct DegreeBasicTests {
    @Test
    func initialization() {
        let angle = Degree(90)
        #expect(angle.value == 90)
    }

    @Test
    func zero() {
        let zero = Degree.zero
        #expect(zero.value == 0)
    }

    @Test
    func addition() {
        let angle1 = Degree(45)
        let angle2 = Degree(45)
        let result = angle1 + angle2
        #expect(result.value == 90)
    }

    @Test
    func subtraction() {
        let angle1 = Degree(90)
        let angle2 = Degree(45)
        let result = angle1 - angle2
        #expect(result.value == 45)
    }

    @Test
    func multiplication() {
        let angle1 = Degree(45)
        let angle2 = Degree(2)
        let result = angle1 * angle2
        #expect(result.value == 90)
    }

    @Test
    func division() {
        let angle = Degree(180)
        let result = angle / 2.0
        #expect(result.value == 90)
    }

    @Test
    func divisionByDegree() {
        let angle1 = Degree(90)
        let angle2 = Degree(45)
        let result = angle1 / angle2
        #expect(result == 2)
    }

    @Test
    func negation() {
        let angle = Degree(45)
        let result = -angle
        #expect(result.value == -45)
    }

    @Test
    func comparison() {
        let angle1 = Degree(45)
        let angle2 = Degree(90)
        #expect(angle1 < angle2)
        #expect(angle2 > angle1)
    }

    @Test
    func magnitude() {
        let angle = Degree(-45)
        let result = angle.magnitude
        #expect(result.value == 45)
    }

    @Test
    func expressibleByFloatLiteral() {
        let angle: Degree = 45.5
        #expect(angle.value == 45.5)
    }

    @Test
    func expressibleByIntegerLiteral() {
        let angle: Degree = 90
        #expect(angle.value == 90.0)
    }

    @Test
    func hashable() {
        let angle1 = Degree(45)
        let angle2 = Degree(45)
        #expect(angle1.hashValue == angle2.hashValue)
    }

    @Test
    func equatable() {
        let angle1 = Degree(45)
        let angle2 = Degree(45)
        #expect(angle1 == angle2)
    }
}

@Suite("Degree - Conversion")
struct DegreeConversionTests {
    @Test
    func conversionToRadians() {
        let degrees = Degree(180)
        let radians = degrees.radians
        #expect(abs(radians.value - .pi) < 1e-10)
    }

    @Test
    func conversionFromRadians() {
        let radians = Radian(.pi / 2)
        let degrees = Degree(radians: radians)
        #expect(abs(degrees.value - 90.0) < 1e-10)
    }

    @Test(arguments: [
        (Degree(0), 0.0),
        (Degree(90), .pi / 2),
        (Degree(180), .pi),
        (Degree(270), 3 * .pi / 2),
        (Degree(360), 2 * .pi),
    ])
    func `conversion to radians common angles`(testCase: (Degree, Double)) {
        let (degrees, expected) = testCase
        let result = degrees.radians
        #expect(abs(result.value - expected) < 1e-10)
    }

    @Test(arguments: [
        (Radian(0), 0.0),
        (Radian(.pi / 2), 90.0),
        (Radian(.pi), 180.0),
        (Radian(3 * .pi / 2), 270.0),
        (Radian(2 * .pi), 360.0),
    ])
    func `conversion from radians common angles`(testCase: (Radian, Double)) {
        let (radians, expected) = testCase
        let result = Degree(radians: radians)
        #expect(abs(result.value - expected) < 1e-10)
    }

    @Test
    func `round-trip conversion`() {
        let original = Degree(45)
        let radians = original.radians
        let back = Degree(radians: radians)
        #expect(abs(back.value - original.value) < 1e-10)
    }
}

@Suite("Degree - Common Angles")
struct DegreeCommonAnglesTests {
    @Test
    func rightAngle() {
        #expect(Degree.rightAngle.value == 90)
    }

    @Test
    func straight() {
        #expect(Degree.straight.value == 180)
    }

    @Test
    func fullCircle() {
        #expect(Degree.fullCircle.value == 360)
    }

    @Test
    func fortyFive() {
        #expect(Degree.fortyFive.value == 45)
    }

    @Test
    func sixty() {
        #expect(Degree.sixty.value == 60)
    }

    @Test
    func thirty() {
        #expect(Degree.thirty.value == 30)
    }
}

@Suite("Degree - Static Trigonometric Functions")
struct DegreeTrigonometryStaticTests {
    @Test(arguments: [
        (Degree(0), 0.0),
        (Degree(90), 1.0),
        (Degree(180), 0.0),
        (Degree(45), 1.0 / Double.sqrt(2.0)),
        (Degree(30), 0.5),
        (Degree(60), Double.sqrt(3.0) / 2),
    ])
    func `sin of common angles`(testCase: (Degree, Double)) {
        let (angle, expected) = testCase
        #expect(abs(Degree.sin(of: angle) - expected) < 1e-10)
    }

    @Test(arguments: [
        (Degree(0), 1.0),
        (Degree(90), 0.0),
        (Degree(180), -1.0),
        (Degree(45), 1.0 / Double.sqrt(2.0)),
        (Degree(30), Double.sqrt(3.0) / 2),
        (Degree(60), 0.5),
    ])
    func `cos of common angles`(testCase: (Degree, Double)) {
        let (angle, expected) = testCase
        #expect(abs(Degree.cos(of: angle) - expected) < 1e-10)
    }

    @Test(arguments: [
        (Degree(0), 0.0),
        (Degree(45), 1.0),
        (Degree(30), 1.0 / Double.sqrt(3.0)),
        (Degree(60), Double.sqrt(3.0)),
    ])
    func `tan of common angles`(testCase: (Degree, Double)) {
        let (angle, expected) = testCase
        #expect(abs(Degree.tan(of: angle) - expected) < 1e-10)
    }

    @Test
    func `sin of arbitrary angle`() {
        let angle = Degree(30)
        let result = Degree.sin(of: angle)
        let expected = 0.5
        #expect(abs(result - expected) < 1e-10)
    }

    @Test
    func `cos of arbitrary angle`() {
        let angle = Degree(60)
        let result = Degree.cos(of: angle)
        let expected = 0.5
        #expect(abs(result - expected) < 1e-10)
    }

    @Test
    func `tan of arbitrary angle`() {
        let angle = Degree(45)
        let result = Degree.tan(of: angle)
        let expected = 1.0
        #expect(abs(result - expected) < 1e-10)
    }

    @Test
    func `degree trig matches radian trig`() {
        let deg = Degree(30)
        let rad = deg.radians
        #expect(abs(Degree.sin(of: deg) - Radian.sin(of: rad)) < 1e-15)
        #expect(abs(Degree.cos(of: deg) - Radian.cos(of: rad)) < 1e-15)
        #expect(abs(Degree.tan(of: deg) - Radian.tan(of: rad)) < 1e-15)
    }
}

@Suite("Degree - Instance Trigonometric Properties")
struct DegreeTrigonometryInstanceTests {
    @Test
    func `sin property`() {
        let angle = Degree(30)
        let result = angle.sin
        let expected = 0.5
        #expect(abs(result - expected) < 1e-10)
    }

    @Test
    func `cos property`() {
        let angle = Degree(60)
        let result = angle.cos
        let expected = 0.5
        #expect(abs(result - expected) < 1e-10)
    }

    @Test
    func `tan property`() {
        let angle = Degree(45)
        let result = angle.tan
        let expected = 1.0
        #expect(abs(result - expected) < 1e-10)
    }

    @Test
    func `instance sin matches static sin`() {
        let angle = Degree(37.5)
        #expect(abs(angle.sin - Degree.sin(of: angle)) < 1e-15)
    }

    @Test
    func `instance cos matches static cos`() {
        let angle = Degree(37.5)
        #expect(abs(angle.cos - Degree.cos(of: angle)) < 1e-15)
    }

    @Test
    func `instance tan matches static tan`() {
        let angle = Degree(37.5)
        #expect(abs(angle.tan - Degree.tan(of: angle)) < 1e-15)
    }

    @Test
    func `right angle sin`() {
        let result = Degree.rightAngle.sin
        #expect(abs(result - 1.0) < 1e-10)
    }

    @Test
    func `right angle cos`() {
        let result = Degree.rightAngle.cos
        #expect(abs(result) < 1e-10)
    }

    @Test
    func `straight angle sin`() {
        let result = Degree.straight.sin
        #expect(abs(result) < 1e-10)
    }

    @Test
    func `straight angle cos`() {
        let result = Degree.straight.cos
        #expect(abs(result - (-1.0)) < 1e-10)
    }
}
