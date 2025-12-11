// VectorTests.swift
// Tests for Linear.Vector

import Testing
@testable import Algebra_Linear

@Suite("Linear.Vector Tests")
struct VectorTests {
    typealias Vec2 = Linear<Double>.Vector<2>
    typealias Vec3 = Linear<Double>.Vector<3>
    typealias Vec4 = Linear<Double>.Vector<4>

    // MARK: - Construction

    @Test("2D vector construction")
    func vector2DConstruction() {
        let v = Vec2(dx: 3.0, dy: 4.0)
        #expect(v.dx == 3.0)
        #expect(v.dy == 4.0)
    }

    @Test("3D vector construction")
    func vector3DConstruction() {
        let v = Vec3(dx: 1.0, dy: 2.0, dz: 3.0)
        #expect(v.dx == 1.0)
        #expect(v.dy == 2.0)
        #expect(v.dz == 3.0)
    }

    @Test("4D vector construction")
    func vector4DConstruction() {
        let v = Vec4(dx: 1.0, dy: 2.0, dz: 3.0, dw: 4.0)
        #expect(v.dx == 1.0)
        #expect(v.dy == 2.0)
        #expect(v.dz == 3.0)
        #expect(v.dw == 4.0)
    }

    // MARK: - Zero

    @Test("Zero vector")
    func zeroVector() {
        let zero = Vec2.zero
        #expect(zero.dx == 0)
        #expect(zero.dy == 0)
    }

    // MARK: - Arithmetic

    @Test("Vector addition")
    func addition() {
        let a = Vec2(dx: 1, dy: 2)
        let b = Vec2(dx: 3, dy: 4)
        let sum = a + b
        #expect(sum.dx == 4)
        #expect(sum.dy == 6)
    }

    @Test("Vector subtraction")
    func subtraction() {
        let a = Vec2(dx: 5, dy: 8)
        let b = Vec2(dx: 2, dy: 3)
        let diff = a - b
        #expect(diff.dx == 3)
        #expect(diff.dy == 5)
    }

    @Test("Scalar multiplication")
    func scalarMultiplication() {
        let v = Vec2(dx: 2, dy: 3)
        let scaled = v * 2.0
        #expect(scaled.dx == 4)
        #expect(scaled.dy == 6)
    }

    @Test("Scalar division")
    func scalarDivision() {
        let v = Vec2(dx: 6, dy: 9)
        let scaled = v / 3.0
        #expect(scaled.dx == 2)
        #expect(scaled.dy == 3)
    }

    @Test("Negation")
    func negation() {
        let v = Vec2(dx: 3, dy: -4)
        let neg = -v
        #expect(neg.dx == -3)
        #expect(neg.dy == 4)
    }

    // MARK: - Length

    @Test("2D vector length")
    func length2D() {
        let v = Vec2(dx: 3, dy: 4)
        #expect(v.length == 5.0)
        #expect(v.lengthSquared == 25.0)
    }

    @Test("3D vector length")
    func length3D() {
        let v = Vec3(dx: 2, dy: 3, dz: 6)
        #expect(v.length == 7.0)
    }

    // MARK: - Normalization

    @Test("Vector normalization")
    func normalization() {
        let v = Vec2(dx: 3, dy: 4)
        let unit = v.normalized
        #expect(abs(unit.length - 1.0) < 1e-10)
        #expect(abs(unit.dx - 0.6) < 1e-10)
        #expect(abs(unit.dy - 0.8) < 1e-10)
    }

    @Test("Zero vector normalization returns zero")
    func zeroNormalization() {
        let zero = Vec2.zero
        let normalized = zero.normalized
        #expect(normalized.dx == 0)
        #expect(normalized.dy == 0)
    }

    // MARK: - Dot Product

    @Test("Dot product")
    func dotProduct() {
        let a = Vec2(dx: 1, dy: 2)
        let b = Vec2(dx: 3, dy: 4)
        #expect(a.dot(b) == 11) // 1*3 + 2*4
    }

    @Test("Perpendicular vectors have zero dot product")
    func perpendicularDotProduct() {
        let a = Vec2(dx: 1, dy: 0)
        let b = Vec2(dx: 0, dy: 1)
        #expect(a.dot(b) == 0)
    }

    // MARK: - Cross Product

    @Test("2D cross product")
    func crossProduct2D() {
        let a = Vec2(dx: 1, dy: 0)
        let b = Vec2(dx: 0, dy: 1)
        #expect(a.cross(b) == 1)  // Counter-clockwise
        #expect(b.cross(a) == -1) // Clockwise
    }

    @Test("3D cross product")
    func crossProduct3D() {
        let x = Vec3(dx: 1, dy: 0, dz: 0)
        let y = Vec3(dx: 0, dy: 1, dz: 0)
        let z = x.cross(y)
        #expect(z.dx == 0)
        #expect(z.dy == 0)
        #expect(z.dz == 1)
    }

    // MARK: - Projection

    @Test("Projection onto vector")
    func projection() {
        let v = Vec2(dx: 3, dy: 4)
        let onto = Vec2(dx: 1, dy: 0)
        let proj = v.projection(onto: onto)
        #expect(proj.dx == 3)
        #expect(proj.dy == 0)
    }

    // MARK: - Distance

    @Test("Distance between vectors")
    func distance() {
        let a = Vec2(dx: 0, dy: 0)
        let b = Vec2(dx: 3, dy: 4)
        #expect(a.distance(to: b) == 5)
    }

    // MARK: - Equatable

    @Test("Vector equality")
    func equality() {
        let a = Vec2(dx: 1, dy: 2)
        let b = Vec2(dx: 1, dy: 2)
        let c = Vec2(dx: 1, dy: 3)
        #expect(a == b)
        #expect(a != c)
    }

    // MARK: - Map

    @Test("Functorial map")
    func mapFunction() throws {
        let v = Linear<Int>.Vector<2>([1, 2])
        let doubled: Linear<Int>.Vector<2> = try v.map { $0 * 2 }
        #expect(doubled[0] == 2)
        #expect(doubled[1] == 4)
    }
}
