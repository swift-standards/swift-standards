// Radian Tests.swift
// Tests for Radian type (basic structure, arithmetic, conversions)

import StandardsTestSupport
import Testing
import RealModule
@testable import Angle

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
struct `Radian - Basic Structure & Arithmetic` {
    @Test
    func initialization() {
        let angle = Radian(Double.pi / 2)
        #expect(isApprox(angle, Radian(Double.pi / 2)))
    }

    @Test
    func zero() {
        let zero = Radian<Double>.zero
        #expect(zero == Radian(0))
    }

    @Test
    func addition() {
        let angle1: Radian<Double> = Radian(Double.pi / 4)
        let angle2: Radian<Double> = Radian(Double.pi / 4)
        let result = angle1 + angle2
        #expect(isApprox(result, Radian(Double.pi / 2)))
    }

    @Test
    func subtraction() {
        let angle1: Radian<Double> = Radian(Double.pi / 2)
        let angle2: Radian<Double> = Radian(Double.pi / 4)
        let result = angle1 - angle2
        #expect(isApprox(result, Radian(Double.pi / 4)))
    }

    @Test
    func scalarMultiplication() {
        let angle: Radian<Double> = Radian(Double.pi / 4)
        let result = angle * 2.0
        #expect(isApprox(result, Radian(Double.pi / 2)))
    }

    @Test
    func division() {
        let angle: Radian<Double> = Radian(Double.pi)
        let result = angle / 2
        #expect(isApprox(result, Radian(Double.pi / 2)))
    }

    @Test
    func negation() {
        let angle: Radian<Double> = Radian(Double.pi / 4)
        let result = -angle
        #expect(isApprox(result, Radian(-Double.pi / 4)))
    }

    @Test
    func comparison() {
        let angle1: Radian<Double> = Radian(Double.pi / 4)
        let angle2: Radian<Double> = Radian(Double.pi / 2)
        #expect(angle1 < angle2)
        #expect(angle2 > angle1)
    }

    @Test
    func expressibleByFloatLiteral() {
        let angle: Radian<Double> = 1.5
        #expect(angle == Radian(1.5))
    }

    @Test
    func expressibleByIntegerLiteral() {
        let angle: Radian<Double> = 2
        #expect(angle == Radian(2.0))
    }

    @Test
    func conversion() {
        let radians: Radian<Double> = Radian(Double.pi)
        let degrees = radians.degrees
        #expect(isApprox(degrees, Degree(180.0)))
    }

    @Test
    func conversionFromDegrees() {
        let degrees = Degree<Double>(90)
        let radians = Radian(degrees: degrees)
        #expect(isApprox(radians, Radian(Double.pi / 2)))
    }

    @Test
    func hashable() {
        let angle1: Radian<Double> = Radian(Double.pi / 4)
        let angle2: Radian<Double> = Radian(Double.pi / 4)
        #expect(angle1.hashValue == angle2.hashValue)
    }

    @Test
    func equatable() {
        let angle1: Radian<Double> = Radian(Double.pi / 4)
        let angle2: Radian<Double> = Radian(Double.pi / 4)
        #expect(angle1 == angle2)
    }
}
