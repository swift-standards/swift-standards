// Circle Tests.swift
// Tests for Geometry.Circle type.

import Testing
@testable import Geometry

@Suite("Circle Tests")
struct CircleTests {

    // MARK: - Initialization

    @Test("Circle initialization")
    func initialization() {
        let circle: Geometry<Double>.Circle = .init(
            center: .init(x: 10, y: 20),
            radius: 5
        )
        #expect(circle.center.x == 10)
        #expect(circle.center.y == 20)
        #expect(circle.radius == 5)
    }

    @Test("Circle at origin with radius")
    func atOriginWithRadius() {
        let circle: Geometry<Double>.Circle = .init(radius: 10)
        #expect(circle.center.x == 0)
        #expect(circle.center.y == 0)
        #expect(circle.radius == 10)
    }

    // MARK: - Properties

    @Test("Circle diameter")
    func diameter() {
        let circle: Geometry<Double>.Circle = .init(center: .zero, radius: 5)
        #expect(circle.diameter == 10)
    }

    @Test("Circle circumference")
    func circumference() {
        let circle: Geometry<Double>.Circle = .init(center: .zero, radius: 1)
        #expect(abs(circle.circumference - 2 * .pi) < 1e-10)
    }

    @Test("Circle area")
    func area() {
        let circle: Geometry<Double>.Circle = .init(center: .zero, radius: 2)
        #expect(abs(circle.area - 4 * .pi) < 1e-10)
    }

    // MARK: - Containment

    @Test("Circle contains center")
    func containsCenter() {
        let circle: Geometry<Double>.Circle = .init(
            center: .init(x: 5, y: 5),
            radius: 10
        )
        #expect(circle.contains(circle.center))
    }

    @Test("Circle contains interior point")
    func containsInteriorPoint() {
        let circle: Geometry<Double>.Circle = .init(center: .zero, radius: 10)
        let point: Geometry<Double>.Point<2> = .init(x: 3, y: 4) // distance 5
        #expect(circle.contains(point))
    }

    @Test("Circle contains boundary point")
    func containsBoundaryPoint() {
        let circle: Geometry<Double>.Circle = .init(center: .zero, radius: 5)
        let point: Geometry<Double>.Point<2> = .init(x: 3, y: 4) // distance 5
        #expect(circle.contains(point))
    }

    @Test("Circle does not contain exterior point")
    func doesNotContainExteriorPoint() {
        let circle: Geometry<Double>.Circle = .init(center: .zero, radius: 5)
        let point: Geometry<Double>.Point<2> = .init(x: 6, y: 8) // distance 10
        #expect(!circle.contains(point))
    }

    // MARK: - Point on Circle

    @Test("Point at parameter 0")
    func pointAtZero() {
        let circle: Geometry<Double>.Circle = .init(center: .zero, radius: 5)
        let point = circle.point(at: .zero)
        #expect(abs(point.x.value - 5) < 1e-10)
        #expect(abs(point.y.value) < 1e-10)
    }

    @Test("Point at parameter pi/2")
    func pointAtHalfPi() {
        let circle: Geometry<Double>.Circle = .init(center: .zero, radius: 5)
        let point = circle.point(at: .halfPi)
        #expect(abs(point.x.value) < 1e-10)
        #expect(abs(point.y.value - 5) < 1e-10)
    }

    @Test("Point at parameter pi")
    func pointAtPi() {
        let circle: Geometry<Double>.Circle = .init(center: .zero, radius: 5)
        let point = circle.point(at: .pi)
        #expect(abs(point.x.value - (-5)) < 1e-10)
        #expect(abs(point.y.value) < 1e-10)
    }

    @Test("Point with offset center")
    func pointWithOffsetCenter() {
        let circle: Geometry<Double>.Circle = .init(
            center: .init(x: 10, y: 20),
            radius: 5
        )
        let point = circle.point(at: .zero)
        #expect(abs(point.x.value - 15) < 1e-10)
        #expect(abs(point.y.value - 20) < 1e-10)
    }

    // MARK: - Bounding Box

    @Test("Bounding box at origin")
    func boundingBoxAtOrigin() {
        let circle: Geometry<Double>.Circle = .init(center: .zero, radius: 5)
        let bbox = circle.boundingBox
        #expect(bbox.llx == -5)
        #expect(bbox.lly == -5)
        #expect(bbox.urx == 5)
        #expect(bbox.ury == 5)
    }

    @Test("Bounding box with offset")
    func boundingBoxWithOffset() {
        let circle: Geometry<Double>.Circle = .init(
            center: .init(x: 10, y: 20),
            radius: 5
        )
        let bbox = circle.boundingBox
        #expect(bbox.llx == 5)
        #expect(bbox.lly == 15)
        #expect(bbox.urx == 15)
        #expect(bbox.ury == 25)
    }

    // MARK: - Transformation

    @Test("Circle translation")
    func translation() {
        let circle: Geometry<Double>.Circle = .init(center: .zero, radius: 5)
        let translated = circle.translated(by: .init(dx: 10, dy: 20))
        #expect(translated.center.x == 10)
        #expect(translated.center.y == 20)
        #expect(translated.radius == 5)
    }

    @Test("Circle scaling")
    func scaling() {
        let circle: Geometry<Double>.Circle = .init(center: .zero, radius: 5)
        let scaled = circle.scaled(by: 2)
        #expect(scaled.center.x == 0)
        #expect(scaled.center.y == 0)
        #expect(scaled.radius == 10)
    }

    // MARK: - Line Intersection

    @Test("Line through center intersects at two points")
    func lineIntersectionThroughCenter() {
        let circle: Geometry<Double>.Circle = .init(center: .zero, radius: 5)
        let line: Geometry<Double>.Line = .init(
            point: .zero,
            direction: .init(dx: 1, dy: 0)
        )

        let intersections = circle.intersection(with: line)
        #expect(intersections.count == 2)

        let sorted = intersections.sorted { $0.x.value < $1.x.value }
        #expect(abs(sorted[0].x.value - (-5)) < 1e-10)
        #expect(abs(sorted[1].x.value - 5) < 1e-10)
    }

    @Test("Tangent line intersects at one point")
    func tangentLineIntersection() {
        let circle: Geometry<Double>.Circle = .init(center: .zero, radius: 5)
        let line: Geometry<Double>.Line = .init(
            point: .init(x: 5, y: 0),
            direction: .init(dx: 0, dy: 1)
        )

        let intersections = circle.intersection(with: line)
        #expect(intersections.count == 1)
        #expect(abs(intersections[0].x.value - 5) < 1e-10)
        #expect(abs(intersections[0].y.value) < 1e-10)
    }

    @Test("Non-intersecting line")
    func nonIntersectingLine() {
        let circle: Geometry<Double>.Circle = .init(center: .zero, radius: 5)
        let line: Geometry<Double>.Line = .init(
            point: .init(x: 10, y: 0),
            direction: .init(dx: 0, dy: 1)
        )

        let intersections = circle.intersection(with: line)
        #expect(intersections.isEmpty)
    }

    // MARK: - Circle-Circle Intersection

    @Test("Two circles intersect at two points")
    func twoCirclesTwoIntersections() {
        let c1: Geometry<Double>.Circle = .init(center: .zero, radius: 5)
        let c2: Geometry<Double>.Circle = .init(
            center: .init(x: 6, y: 0),
            radius: 5
        )

        let intersections = c1.intersection(with: c2)
        #expect(intersections.count == 2)
    }

    @Test("Tangent circles intersect at one point")
    func tangentCirclesOneIntersection() {
        let c1: Geometry<Double>.Circle = .init(center: .zero, radius: 5)
        let c2: Geometry<Double>.Circle = .init(
            center: .init(x: 10, y: 0),
            radius: 5
        )

        let intersections = c1.intersection(with: c2)
        #expect(intersections.count == 1)
        #expect(abs(intersections[0].x.value - 5) < 1e-10)
        #expect(abs(intersections[0].y.value) < 1e-10)
    }

    @Test("Separate circles do not intersect")
    func separateCirclesNoIntersection() {
        let c1: Geometry<Double>.Circle = .init(center: .zero, radius: 5)
        let c2: Geometry<Double>.Circle = .init(
            center: .init(x: 20, y: 0),
            radius: 5
        )

        let intersections = c1.intersection(with: c2)
        #expect(intersections.isEmpty)
    }

    @Test("One circle inside another")
    func oneInsideOther() {
        let c1: Geometry<Double>.Circle = .init(center: .zero, radius: 10)
        let c2: Geometry<Double>.Circle = .init(center: .zero, radius: 3)

        let intersections = c1.intersection(with: c2)
        #expect(intersections.isEmpty)
    }

    // MARK: - Functorial Map

    @Test("Circle map")
    func circleMap() {
        let circle: Geometry<Double>.Circle = .init(center: .zero, radius: 5)
        let mapped: Geometry<Float>.Circle = circle.map { Float($0) }

        #expect(mapped.center.x.value == 0)
        #expect(mapped.center.y.value == 0)
        #expect(mapped.radius.value == 5)
    }
}
