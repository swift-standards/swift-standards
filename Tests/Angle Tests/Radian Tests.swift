// Radian Tests.swift
// Tests for Radian type (basic structure, arithmetic, conversions)

import StandardsTestSupport
import Testing
import RealModule
@testable import Angle

@Suite("Radian - Basic Structure & Arithmetic")
struct RadianTests {
    @Test
    func initialization() {
        let angle = Radian(.pi / 2)
        #expect(angle.value == .pi / 2)
    }

    @Test
    func zero() {
        let zero = Radian.zero
        #expect(zero.value == 0)
    }

    @Test
    func addition() {
        let angle1 = Radian(.pi / 4)
        let angle2 = Radian(.pi / 4)
        let result = angle1 + angle2
        #expect(abs(result.value - .pi / 2) < 1e-10)
    }

    @Test
    func subtraction() {
        let angle1 = Radian(.pi / 2)
        let angle2 = Radian(.pi / 4)
        let result = angle1 - angle2
        #expect(abs(result.value - .pi / 4) < 1e-10)
    }

    @Test
    func multiplication() {
        let angle1 = Radian(.pi / 4)
        let angle2 = Radian(2)
        let result = angle1 * angle2
        #expect(abs(result.value - .pi / 2) < 1e-10)
    }

    @Test
    func division() {
        let angle = Radian(.pi)
        let result = angle / 2
        #expect(abs(result.value - .pi / 2) < 1e-10)
    }

    @Test
    func negation() {
        let angle = Radian(.pi / 4)
        let result = -angle
        #expect(abs(result.value - (-.pi / 4)) < 1e-10)
    }

    @Test
    func comparison() {
        let angle1 = Radian(.pi / 4)
        let angle2 = Radian(.pi / 2)
        #expect(angle1 < angle2)
        #expect(angle2 > angle1)
    }

    @Test
    func magnitude() {
        let angle = Radian(-.pi / 4)
        let result = angle.magnitude
        #expect(abs(result.value - .pi / 4) < 1e-10)
    }

    @Test
    func expressibleByFloatLiteral() {
        let angle: Radian = 1.5
        #expect(angle.value == 1.5)
    }

    @Test
    func expressibleByIntegerLiteral() {
        let angle: Radian = 2
        #expect(angle.value == 2.0)
    }

    @Test
    func conversion() {
        let radians = Radian(.pi)
        let degrees = radians.degrees
        #expect(abs(degrees.value - 180.0) < 1e-10)
    }

    @Test
    func conversionFromDegrees() {
        let degrees = Degree(90)
        let radians = Radian(degrees: degrees)
        #expect(abs(radians.value - .pi / 2) < 1e-10)
    }

    @Test
    func hashable() {
        let angle1 = Radian(.pi / 4)
        let angle2 = Radian(.pi / 4)
        #expect(angle1.hashValue == angle2.hashValue)
    }

    @Test
    func equatable() {
        let angle1 = Radian(.pi / 4)
        let angle2 = Radian(.pi / 4)
        #expect(angle1 == angle2)
    }
}
