// Ray Tests.swift
// Tests for Geometry.Ray type.

import Testing
@testable import Geometry

@Suite("Ray Tests")
struct RayTests {

    // MARK: - Initialization

    @Test("Ray initialization")
    func initialization() {
        let ray: Geometry<Double>.Ray = .init(
            origin: .init(x: 1, y: 2),
            direction: .init(dx: 3, dy: 4)
        )
        #expect(ray.origin.x == 1)
        #expect(ray.origin.y == 2)
        #expect(ray.direction.dx == 3)
        #expect(ray.direction.dy == 4)
    }

    @Test("Ray from two points")
    func fromTwoPoints() {
        let ray: Geometry<Double>.Ray = .init(
            from: .init(x: 0, y: 0),
            through: .init(x: 3, y: 4)
        )
        #expect(ray.origin.x == 0)
        #expect(ray.origin.y == 0)
        #expect(ray.direction.dx == 3)
        #expect(ray.direction.dy == 4)
    }

    @Test("Ray in direction")
    func inDirection() {
        let ray: Geometry<Double>.Ray = .init(origin: .zero, in: .right)
        #expect(ray.origin.x == 0)
        #expect(ray.origin.y == 0)
        #expect(ray.direction.dx == 1)
        #expect(ray.direction.dy == 0)
    }

    // MARK: - Unit Direction

    @Test("Unit direction")
    func unitDirection() {
        let ray: Geometry<Double>.Ray = .init(
            origin: .zero,
            direction: .init(dx: 3, dy: 4)
        )
        let unit = ray.unitDirection
        #expect(unit != nil)
        #expect(abs(unit!.length - 1) < 1e-10)
    }

    @Test("Unit direction for zero direction")
    func unitDirectionZero() {
        let ray: Geometry<Double>.Ray = .init(
            origin: .zero,
            direction: .zero
        )
        #expect(ray.unitDirection == nil)
    }

    // MARK: - Point at Parameter

    @Test("Point at parameter 0")
    func pointAtZero() {
        let ray: Geometry<Double>.Ray = .init(
            origin: .init(x: 5, y: 10),
            direction: .init(dx: 3, dy: 4)
        )
        let point = ray.point(at: 0)
        #expect(point.x == 5)
        #expect(point.y == 10)
    }

    @Test("Point at parameter 1")
    func pointAtOne() {
        let ray: Geometry<Double>.Ray = .init(
            origin: .init(x: 5, y: 10),
            direction: .init(dx: 3, dy: 4)
        )
        let point = ray.point(at: 1)
        #expect(point.x == 8)
        #expect(point.y == 14)
    }

    @Test("Point at parameter 2")
    func pointAtTwo() {
        let ray: Geometry<Double>.Ray = .init(
            origin: .init(x: 0, y: 0),
            direction: .init(dx: 1, dy: 0)
        )
        let point = ray.point(at: 2)
        #expect(point.x == 2)
        #expect(point.y == 0)
    }

    // MARK: - Contains Point

    @Test("Contains origin")
    func containsOrigin() {
        let ray: Geometry<Double>.Ray = .init(
            origin: .init(x: 5, y: 5),
            direction: .init(dx: 1, dy: 0)
        )
        #expect(ray.contains(ray.origin))
    }

    @Test("Contains point along ray")
    func containsPointAlongRay() {
        let ray: Geometry<Double>.Ray = .init(
            origin: .zero,
            direction: .init(dx: 1, dy: 1)
        )
        let point: Geometry<Double>.Point<2> = .init(x: 5, y: 5)
        #expect(ray.contains(point))
    }

    @Test("Does not contain point behind origin")
    func doesNotContainPointBehind() {
        let ray: Geometry<Double>.Ray = .init(
            origin: .zero,
            direction: .init(dx: 1, dy: 0)
        )
        let point: Geometry<Double>.Point<2> = .init(x: -5, y: 0)
        #expect(!ray.contains(point))
    }

    @Test("Does not contain point off ray")
    func doesNotContainPointOff() {
        let ray: Geometry<Double>.Ray = .init(
            origin: .zero,
            direction: .init(dx: 1, dy: 0)
        )
        let point: Geometry<Double>.Point<2> = .init(x: 5, y: 5)
        #expect(!ray.contains(point))
    }

    // MARK: - Line Intersection

    @Test("Ray intersects line")
    func rayIntersectsLine() {
        let ray: Geometry<Double>.Ray = .init(
            origin: .zero,
            direction: .init(dx: 1, dy: 1)
        )
        let line: Geometry<Double>.Line = .init(
            point: .init(x: 0, y: 5),
            direction: .init(dx: 1, dy: 0)
        )

        let intersection = ray.intersection(with: line)
        #expect(intersection != nil)
        #expect(abs(intersection!.x.value - 5) < 1e-10)
        #expect(abs(intersection!.y.value - 5) < 1e-10)
    }

    @Test("Ray does not intersect line behind origin")
    func rayNoIntersectionBehind() {
        let ray: Geometry<Double>.Ray = .init(
            origin: .init(x: 0, y: 10),
            direction: .init(dx: 1, dy: 1)
        )
        let line: Geometry<Double>.Line = .init(
            point: .init(x: 0, y: 5),
            direction: .init(dx: 1, dy: 0)
        )

        // Line y=5 is behind the ray origin at (0, 10) going up-right
        let intersection = ray.intersection(with: line)
        #expect(intersection == nil)
    }

    @Test("Ray parallel to line")
    func rayParallelToLine() {
        let ray: Geometry<Double>.Ray = .init(
            origin: .zero,
            direction: .init(dx: 1, dy: 0)
        )
        let line: Geometry<Double>.Line = .init(
            point: .init(x: 0, y: 5),
            direction: .init(dx: 1, dy: 0)
        )

        let intersection = ray.intersection(with: line)
        #expect(intersection == nil)
    }

    // MARK: - Segment Intersection

    @Test("Ray intersects segment")
    func rayIntersectsSegment() {
        let ray: Geometry<Double>.Ray = .init(
            origin: .zero,
            direction: .init(dx: 1, dy: 1)
        )
        let segment: Geometry<Double>.Line.Segment = .init(
            start: .init(x: 0, y: 5),
            end: .init(x: 10, y: 5)
        )

        let intersection = ray.intersection(with: segment)
        #expect(intersection != nil)
        #expect(abs(intersection!.x.value - 5) < 1e-10)
        #expect(abs(intersection!.y.value - 5) < 1e-10)
    }

    @Test("Ray misses segment")
    func rayMissesSegment() {
        let ray: Geometry<Double>.Ray = .init(
            origin: .zero,
            direction: .init(dx: 1, dy: 1)
        )
        let segment: Geometry<Double>.Line.Segment = .init(
            start: .init(x: 10, y: 5),
            end: .init(x: 20, y: 5)
        )

        // Ray goes through (5, 5) but segment starts at x=10
        let intersection = ray.intersection(with: segment)
        #expect(intersection == nil)
    }

    // MARK: - Circle Intersection

    @Test("Ray through circle center")
    func rayThroughCircleCenter() {
        let ray: Geometry<Double>.Ray = .init(
            origin: .zero,
            direction: .init(dx: 1, dy: 0)
        )
        let circle: Geometry<Double>.Circle = .init(
            center: .init(x: 10, y: 0),
            radius: 5
        )

        let intersections = ray.intersection(with: circle)
        #expect(intersections.count == 2)

        let sorted = intersections.sorted { $0.x.value < $1.x.value }
        #expect(abs(sorted[0].x.value - 5) < 1e-10)
        #expect(abs(sorted[1].x.value - 15) < 1e-10)
    }

    @Test("Ray tangent to circle")
    func rayTangentToCircle() {
        let ray: Geometry<Double>.Ray = .init(
            origin: .init(x: 0, y: 5),
            direction: .init(dx: 1, dy: 0)
        )
        let circle: Geometry<Double>.Circle = .init(center: .zero, radius: 5)

        let intersections = ray.intersection(with: circle)
        #expect(intersections.count == 1)
        #expect(abs(intersections[0].x.value) < 1e-10)
        #expect(abs(intersections[0].y.value - 5) < 1e-10)
    }

    @Test("Ray misses circle")
    func rayMissesCircle() {
        let ray: Geometry<Double>.Ray = .init(
            origin: .init(x: 0, y: 10),
            direction: .init(dx: 1, dy: 0)
        )
        let circle: Geometry<Double>.Circle = .init(center: .zero, radius: 5)

        let intersections = ray.intersection(with: circle)
        #expect(intersections.isEmpty)
    }

    @Test("Ray origin inside circle")
    func rayOriginInsideCircle() {
        let ray: Geometry<Double>.Ray = .init(
            origin: .zero,
            direction: .init(dx: 1, dy: 0)
        )
        let circle: Geometry<Double>.Circle = .init(center: .zero, radius: 5)

        let intersections = ray.intersection(with: circle)
        #expect(intersections.count == 1)
        #expect(abs(intersections[0].x.value - 5) < 1e-10)
    }

    // MARK: - Conversion to Line

    @Test("To line")
    func toLine() {
        let ray: Geometry<Double>.Ray = .init(
            origin: .init(x: 5, y: 10),
            direction: .init(dx: 3, dy: 4)
        )
        let line = ray.line
        #expect(line.point.x == 5)
        #expect(line.point.y == 10)
        #expect(line.direction.dx == 3)
        #expect(line.direction.dy == 4)
    }

    // MARK: - Functorial Map

    @Test("Ray map")
    func rayMap() {
        let ray: Geometry<Double>.Ray = .init(
            origin: .init(x: 1, y: 2),
            direction: .init(dx: 3, dy: 4)
        )
        let mapped: Geometry<Float>.Ray = ray.map { Float($0) }
        #expect(mapped.origin.x.value == 1)
        #expect(mapped.origin.y.value == 2)
        #expect(mapped.direction.dx.value == 3)
        #expect(mapped.direction.dy.value == 4)
    }
}
