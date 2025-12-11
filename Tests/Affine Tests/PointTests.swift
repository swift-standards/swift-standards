// PointTests.swift
// Tests for Affine.Point

import Testing
@testable import Algebra
@testable import Affine
@testable import Algebra_Linear

@Suite("Affine.Point Tests")
struct PointTests {
    typealias Point2 = Affine<Double>.Point<2>
    typealias Point3 = Affine<Double>.Point<3>
    typealias Vec2 = Linear<Double>.Vector<2>

    // MARK: - Construction

    @Test("2D point construction with X/Y")
    func point2DConstructionTyped() {
        let p = Point2(x: Affine<Double>.X(3.0), y: Affine<Double>.Y(4.0))
        #expect(p.x.value == 3.0)
        #expect(p.y.value == 4.0)
    }

    @Test("2D point construction with raw values")
    func point2DConstructionRaw() {
        let p = Point2(x: 3.0, y: 4.0)
        #expect(p.x.value == 3.0)
        #expect(p.y.value == 4.0)
    }

    @Test("3D point construction")
    func point3DConstruction() {
        let p = Point3(
            x: Affine<Double>.X(1.0),
            y: Affine<Double>.Y(2.0),
            z: Affine<Double>.Z(3.0)
        )
        #expect(p.x == 1.0)
        #expect(p.y == 2.0)
        #expect(p.z == 3.0)
    }

    // MARK: - Zero/Origin

    @Test("Zero point (origin)")
    func zeroPoint() {
        let origin = Point2.zero
        #expect(origin.x.value == 0)
        #expect(origin.y.value == 0)
    }

    // MARK: - Affine Arithmetic

    @Test("Point - Point = Vector")
    func pointMinusPoint() {
        let p1 = Point2(x: 5, y: 8)
        let p2 = Point2(x: 2, y: 3)
        let v: Vec2 = p1 - p2
        #expect(v.dx == 3)
        #expect(v.dy == 5)
    }

    @Test("Point + Vector = Point")
    func pointPlusVector() {
        let p = Point2(x: 1, y: 2)
        let v = Vec2(dx: 3, dy: 4)
        let result: Point2 = p + v
        #expect(result.x.value == 4)
        #expect(result.y.value == 6)
    }

    @Test("Point - Vector = Point")
    func pointMinusVector() {
        let p = Point2(x: 5, y: 6)
        let v = Vec2(dx: 2, dy: 3)
        let result: Point2 = p - v
        #expect(result.x.value == 3)
        #expect(result.y.value == 3)
    }

    // MARK: - Translation

    @Test("Translate by deltas")
    func translateByDeltas() {
        let p = Point2(x: 1, y: 2)
        let translated = p.translated(dx: 3, dy: 4)
        #expect(translated.x.value == 4)
        #expect(translated.y.value == 6)
    }

    @Test("Translate by vector")
    func translateByVector() {
        let p = Point2(x: 1, y: 2)
        let v = Vec2(dx: 3, dy: 4)
        let translated = p.translated(by: v)
        #expect(translated.x.value == 4)
        #expect(translated.y.value == 6)
    }

    @Test("Vector to another point")
    func vectorToPoint() {
        let p1 = Point2(x: 1, y: 2)
        let p2 = Point2(x: 4, y: 6)
        let v = p1.vector(to: p2)
        #expect(v.dx == 3)
        #expect(v.dy == 4)
    }

    // MARK: - Distance

    @Test("Distance between points")
    func distance() {
        let p1 = Point2(x: 0, y: 0)
        let p2 = Point2(x: 3, y: 4)
        #expect(p1.distance(to: p2) == 5.0)
    }

    @Test("Distance squared")
    func distanceSquared() {
        let p1 = Point2(x: 0, y: 0)
        let p2 = Point2(x: 3, y: 4)
        #expect(p1.distanceSquared(to: p2) == 25.0)
    }

    // MARK: - Interpolation

    @Test("Linear interpolation")
    func lerp() {
        let p1 = Point2(x: 0, y: 0)
        let p2 = Point2(x: 10, y: 20)

        let mid = p1.lerp(to: p2, t: 0.5)
        #expect(mid.x.value == 5)
        #expect(mid.y.value == 10)

        let quarter = p1.lerp(to: p2, t: 0.25)
        #expect(quarter.x.value == 2.5)
        #expect(quarter.y.value == 5)
    }

    @Test("Midpoint")
    func midpoint() {
        let p1 = Point2(x: 0, y: 0)
        let p2 = Point2(x: 10, y: 20)
        let mid = p1.midpoint(to: p2)
        #expect(mid.x.value == 5)
        #expect(mid.y.value == 10)
    }

    // MARK: - Equatable

    @Test("Point equality")
    func equality() {
        let a = Point2(x: 1, y: 2)
        let b = Point2(x: 1, y: 2)
        let c = Point2(x: 1, y: 3)
        #expect(a == b)
        #expect(a != c)
    }

    // MARK: - Subscript

    @Test("Subscript access")
    func subscriptAccess() {
        var p = Point2(x: 1, y: 2)
        #expect(p[0] == 1)
        #expect(p[1] == 2)

        p[0] = 10
        #expect(p[0] == 10)
    }
}
