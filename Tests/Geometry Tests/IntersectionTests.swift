// IntersectionTests.swift
// Tests for intersection operations on Line, Line.Segment, and other geometric types.

import Testing
@testable import Geometry

@Suite("Line Intersection Tests")
struct LineIntersectionTests {
    @Test("Intersecting lines")
    func intersectingLines() {
        // Line y = x (through origin, slope 1)
        let line1: Geometry<Double>.Line = .init(
            point: .init(x: 0, y: 0),
            direction: .init(dx: 1, dy: 1)
        )
        // Line y = -x + 2 (through (0,2) and (2,0), slope -1)
        let line2: Geometry<Double>.Line = .init(
            point: .init(x: 0, y: 2),
            direction: .init(dx: 1, dy: -1)
        )

        let intersection = line1.intersection(with: line2)
        #expect(intersection != nil)
        #expect(abs(intersection!.x.value - 1) < 1e-10)
        #expect(abs(intersection!.y.value - 1) < 1e-10)
    }

    @Test("Parallel lines do not intersect")
    func parallelLines() {
        let line1: Geometry<Double>.Line = .init(
            point: .init(x: 0, y: 0),
            direction: .init(dx: 1, dy: 0)
        )
        let line2: Geometry<Double>.Line = .init(
            point: .init(x: 0, y: 5),
            direction: .init(dx: 1, dy: 0)
        )

        let intersection = line1.intersection(with: line2)
        #expect(intersection == nil)
    }

    @Test("Coincident lines do not intersect (special case)")
    func coincidentLines() {
        let line1: Geometry<Double>.Line = .init(
            point: .init(x: 0, y: 0),
            direction: .init(dx: 1, dy: 1)
        )
        let line2: Geometry<Double>.Line = .init(
            point: .init(x: 1, y: 1),
            direction: .init(dx: 2, dy: 2)
        )

        // Parallel (same direction), returns nil
        let intersection = line1.intersection(with: line2)
        #expect(intersection == nil)
    }

    @Test("Perpendicular lines")
    func perpendicularLines() {
        let horizontal: Geometry<Double>.Line = .init(
            point: .init(x: 0, y: 5),
            direction: .init(dx: 1, dy: 0)
        )
        let vertical: Geometry<Double>.Line = .init(
            point: .init(x: 3, y: 0),
            direction: .init(dx: 0, dy: 1)
        )

        let intersection = horizontal.intersection(with: vertical)
        #expect(intersection != nil)
        #expect(abs(intersection!.x.value - 3) < 1e-10)
        #expect(abs(intersection!.y.value - 5) < 1e-10)
    }
}

@Suite("Line Segment Intersection Tests")
struct LineSegmentIntersectionTests {
    @Test("Intersecting segments")
    func intersectingSegments() {
        let seg1: Geometry<Double>.Line.Segment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 10, y: 10)
        )
        let seg2: Geometry<Double>.Line.Segment = .init(
            start: .init(x: 0, y: 10),
            end: .init(x: 10, y: 0)
        )

        let intersection = seg1.intersection(with: seg2)
        #expect(intersection != nil)
        #expect(abs(intersection!.x.value - 5) < 1e-10)
        #expect(abs(intersection!.y.value - 5) < 1e-10)
    }

    @Test("Non-intersecting segments (parallel)")
    func parallelSegments() {
        let seg1: Geometry<Double>.Line.Segment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 10, y: 0)
        )
        let seg2: Geometry<Double>.Line.Segment = .init(
            start: .init(x: 0, y: 5),
            end: .init(x: 10, y: 5)
        )

        let intersection = seg1.intersection(with: seg2)
        #expect(intersection == nil)
    }

    @Test("Non-intersecting segments (would intersect if extended)")
    func nonIntersectingWouldExtend() {
        let seg1: Geometry<Double>.Line.Segment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 2, y: 2)
        )
        let seg2: Geometry<Double>.Line.Segment = .init(
            start: .init(x: 0, y: 10),
            end: .init(x: 2, y: 8)
        )

        // Lines would intersect at (5, 5) but segments don't reach there
        let intersection = seg1.intersection(with: seg2)
        #expect(intersection == nil)
    }

    @Test("T-junction intersection")
    func tJunctionIntersection() {
        let horizontal: Geometry<Double>.Line.Segment = .init(
            start: .init(x: 0, y: 5),
            end: .init(x: 10, y: 5)
        )
        let vertical: Geometry<Double>.Line.Segment = .init(
            start: .init(x: 5, y: 0),
            end: .init(x: 5, y: 5)
        )

        let intersection = horizontal.intersection(with: vertical)
        #expect(intersection != nil)
        #expect(abs(intersection!.x.value - 5) < 1e-10)
        #expect(abs(intersection!.y.value - 5) < 1e-10)
    }

    @Test("Segment intersection at endpoint")
    func endpointIntersection() {
        let seg1: Geometry<Double>.Line.Segment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 5, y: 5)
        )
        let seg2: Geometry<Double>.Line.Segment = .init(
            start: .init(x: 5, y: 5),
            end: .init(x: 10, y: 0)
        )

        let intersection = seg1.intersection(with: seg2)
        #expect(intersection != nil)
        #expect(abs(intersection!.x.value - 5) < 1e-10)
        #expect(abs(intersection!.y.value - 5) < 1e-10)
    }
}

@Suite("Line Projection and Reflection Tests")
struct LineProjectionReflectionTests {
    @Test("Point projection onto horizontal line")
    func projectionOntoHorizontal() {
        let line: Geometry<Double>.Line = .init(
            point: .init(x: 0, y: 0),
            direction: .init(dx: 1, dy: 0)
        )
        let point: Geometry<Double>.Point<2> = .init(x: 5, y: 7)

        let projection = line.projection(of: point)
        #expect(projection != nil)
        #expect(abs(projection!.x.value - 5) < 1e-10)
        #expect(abs(projection!.y.value - 0) < 1e-10)
    }

    @Test("Point projection onto vertical line")
    func projectionOntoVertical() {
        let line: Geometry<Double>.Line = .init(
            point: .init(x: 3, y: 0),
            direction: .init(dx: 0, dy: 1)
        )
        let point: Geometry<Double>.Point<2> = .init(x: 7, y: 5)

        let projection = line.projection(of: point)
        #expect(projection != nil)
        #expect(abs(projection!.x.value - 3) < 1e-10)
        #expect(abs(projection!.y.value - 5) < 1e-10)
    }

    @Test("Point projection onto diagonal line")
    func projectionOntoDiagonal() {
        let line: Geometry<Double>.Line = .init(
            point: .init(x: 0, y: 0),
            direction: .init(dx: 1, dy: 1)
        )
        let point: Geometry<Double>.Point<2> = .init(x: 0, y: 4)

        let projection = line.projection(of: point)
        #expect(projection != nil)
        // Projection of (0, 4) onto y=x should be (2, 2)
        #expect(abs(projection!.x.value - 2) < 1e-10)
        #expect(abs(projection!.y.value - 2) < 1e-10)
    }

    @Test("Point reflection across horizontal line")
    func reflectionAcrossHorizontal() {
        let line: Geometry<Double>.Line = .init(
            point: .init(x: 0, y: 0),
            direction: .init(dx: 1, dy: 0)
        )
        let point: Geometry<Double>.Point<2> = .init(x: 5, y: 3)

        let reflection = line.reflection(of: point)
        #expect(reflection != nil)
        #expect(abs(reflection!.x.value - 5) < 1e-10)
        #expect(abs(reflection!.y.value - (-3)) < 1e-10)
    }

    @Test("Point reflection across vertical line")
    func reflectionAcrossVertical() {
        let line: Geometry<Double>.Line = .init(
            point: .init(x: 5, y: 0),
            direction: .init(dx: 0, dy: 1)
        )
        let point: Geometry<Double>.Point<2> = .init(x: 3, y: 7)

        let reflection = line.reflection(of: point)
        #expect(reflection != nil)
        #expect(abs(reflection!.x.value - 7) < 1e-10)
        #expect(abs(reflection!.y.value - 7) < 1e-10)
    }

    @Test("Point on line has same projection")
    func pointOnLine() {
        let line: Geometry<Double>.Line = .init(
            point: .init(x: 0, y: 0),
            direction: .init(dx: 1, dy: 1)
        )
        let point: Geometry<Double>.Point<2> = .init(x: 3, y: 3)

        let projection = line.projection(of: point)
        #expect(projection != nil)
        #expect(abs(projection!.x.value - 3) < 1e-10)
        #expect(abs(projection!.y.value - 3) < 1e-10)
    }

    @Test("Zero direction line returns nil")
    func zeroDirectionLine() {
        let line: Geometry<Double>.Line = .init(
            point: .init(x: 0, y: 0),
            direction: .init(dx: 0, dy: 0)
        )
        let point: Geometry<Double>.Point<2> = .init(x: 5, y: 5)

        #expect(line.projection(of: point) == nil)
        #expect(line.reflection(of: point) == nil)
    }
}

@Suite("Line Segment Distance Tests")
struct LineSegmentDistanceTests {
    @Test("Distance to point on segment")
    func distanceToPointOnSegment() {
        let segment: Geometry<Double>.Line.Segment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 10, y: 0)
        )
        let point: Geometry<Double>.Point<2> = .init(x: 5, y: 0)

        #expect(abs(segment.distance(to: point)) < 1e-10)
    }

    @Test("Distance to point near segment")
    func distanceToPointNearSegment() {
        let segment: Geometry<Double>.Line.Segment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 10, y: 0)
        )
        let point: Geometry<Double>.Point<2> = .init(x: 5, y: 3)

        #expect(abs(segment.distance(to: point) - 3) < 1e-10)
    }

    @Test("Distance to point past segment end")
    func distanceToPointPastEnd() {
        let segment: Geometry<Double>.Line.Segment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 10, y: 0)
        )
        let point: Geometry<Double>.Point<2> = .init(x: 15, y: 0)

        #expect(abs(segment.distance(to: point) - 5) < 1e-10)
    }

    @Test("Distance to point before segment start")
    func distanceToPointBeforeStart() {
        let segment: Geometry<Double>.Line.Segment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 10, y: 0)
        )
        let point: Geometry<Double>.Point<2> = .init(x: -3, y: 4)

        // Distance to (0, 0) should be 5 (3-4-5 triangle)
        #expect(abs(segment.distance(to: point) - 5) < 1e-10)
    }
}
