// VectorTests.swift
// Tests for Linear.Vector

import Testing

@testable import Algebra
@testable import Algebra_Linear

@Suite
struct `Linear.Vector Tests` {
    typealias Vec2 = Linear<Double, Void>.Vector<2>
    typealias Vec3 = Linear<Double, Void>.Vector<3>
    typealias Vec4 = Linear<Double, Void>.Vector<4>

    // MARK: - Construction

    @Test
    func `2D vector construction`() {
        let v = Vec2(dx: 3.0, dy: 4.0)
        #expect(v.dx == 3.0)
        #expect(v.dy == 4.0)
    }

    @Test
    func `3D vector construction`() {
        let v = Vec3(dx: 1.0, dy: 2.0, dz: 3.0)
        #expect(v.dx == 1.0)
        #expect(v.dy == 2.0)
        #expect(v.dz == 3.0)
    }

    @Test
    func `4D vector construction`() {
        let v = Vec4(dx: 1.0, dy: 2.0, dz: 3.0, dw: 4.0)
        #expect(v.dx == 1.0)
        #expect(v.dy == 2.0)
        #expect(v.dz == 3.0)
        #expect(v.dw == 4.0)
    }

    // MARK: - Zero

    @Test
    func `Zero vector`() {
        let zero = Vec2.zero
        #expect(zero.dx == 0)
        #expect(zero.dy == 0)
    }

    // MARK: - Arithmetic

    @Test
    func `Vector addition`() {
        let a = Vec2(dx: 1, dy: 2)
        let b = Vec2(dx: 3, dy: 4)
        let sum = a + b
        #expect(sum.dx == 4)
        #expect(sum.dy == 6)
    }

    @Test
    func `Vector subtraction`() {
        let a = Vec2(dx: 5, dy: 8)
        let b = Vec2(dx: 2, dy: 3)
        let diff = a - b
        #expect(diff.dx == 3)
        #expect(diff.dy == 5)
    }

    @Test
    func `Scalar multiplication`() {
        let v = Vec2(dx: 2, dy: 3)
        let scaled = v * 2.0
        #expect(scaled.dx == 4)
        #expect(scaled.dy == 6)
    }

    @Test
    func `Scalar division`() {
        let v = Vec2(dx: 6, dy: 9)
        let scaled = v / 3.0
        #expect(scaled.dx == 2)
        #expect(scaled.dy == 3)
    }

    @Test
    func `Negation`() {
        let v = Vec2(dx: 3, dy: -4)
        let neg = -v
        #expect(neg.dx == -3)
        #expect(neg.dy == 4)
    }

    // MARK: - Length

    @Test
    func `2D vector length`() {
        let v = Vec2(dx: 3, dy: 4)
        #expect(v.length == 5.0)
        #expect(v.lengthSquared == 25.0)
    }

    @Test
    func `3D vector length`() {
        let v = Vec3(dx: 2, dy: 3, dz: 6)
        #expect(v.length == 7.0)
    }

    // MARK: - Normalization

    @Test
    func `Vector normalization`() {
        let v = Vec2(dx: 3, dy: 4)
        let unit = v.normalized
        #expect(abs(unit.length - 1.0) < 1e-10)
        #expect(abs(unit.dx - 0.6) < 1e-10)
        #expect(abs(unit.dy - 0.8) < 1e-10)
    }

    @Test
    func `Zero vector normalization returns zero`() {
        let zero = Vec2.zero
        let normalized = zero.normalized
        #expect(normalized.dx == 0)
        #expect(normalized.dy == 0)
    }

    // MARK: - Dot Product

    @Test
    func `Dot product`() {
        let a = Vec2(dx: 1, dy: 2)
        let b = Vec2(dx: 3, dy: 4)
        #expect(a.dot(b) == 11)  // 1*3 + 2*4
    }

    @Test
    func `Perpendicular vectors have zero dot product`() {
        let a = Vec2(dx: 1, dy: 0)
        let b = Vec2(dx: 0, dy: 1)
        #expect(a.dot(b) == 0)
    }

    // MARK: - Cross Product

    @Test
    func `2D cross product`() {
        let a = Vec2(dx: 1, dy: 0)
        let b = Vec2(dx: 0, dy: 1)
        #expect(a.cross(b) == 1)  // Counter-clockwise
        #expect(b.cross(a) == -1)  // Clockwise
    }

    @Test
    func `3D cross product`() {
        let x = Vec3(dx: 1, dy: 0, dz: 0)
        let y = Vec3(dx: 0, dy: 1, dz: 0)
        let z = x.cross(y)
        #expect(z.dx == 0)
        #expect(z.dy == 0)
        #expect(z.dz == 1)
    }

    // MARK: - Projection

    @Test
    func `Projection onto vector`() {
        let v = Vec2(dx: 3, dy: 4)
        let onto = Vec2(dx: 1, dy: 0)
        let proj = v.projection(onto: onto)
        #expect(proj.dx == 3)
        #expect(proj.dy == 0)
    }

    // MARK: - Distance

    @Test
    func `Distance between vectors`() {
        let a = Vec2(dx: 0, dy: 0)
        let b = Vec2(dx: 3, dy: 4)
        #expect(a.distance(to: b) == 5)
    }

    // MARK: - Equatable

    @Test
    func `Vector equality`() {
        let a = Vec2(dx: 1, dy: 2)
        let b = Vec2(dx: 1, dy: 2)
        let c = Vec2(dx: 1, dy: 3)
        #expect(a == b)
        #expect(a != c)
    }

    // MARK: - Map

    @Test
    func `Functorial map`() throws {
        let v = Linear<Int, Void>.Vector<2>([1, 2])
        let doubled: Linear<Int, Void>.Vector<2> = try v.map { $0 * 2 }
        #expect(doubled[0] == 2)
        #expect(doubled[1] == 4)
    }
}
