// Geometry.Line Tests.swift
// Tests for Geometry.Line and Geometry.Line.Segment types.

import Affine
import Algebra_Linear
import Testing

@testable import Algebra
@testable import Geometry

// MARK: - Line Initialization Tests

@Suite("Geometry.Line - Initialization")
struct GeometryLine_InitializationTests {
    @Test("Line from point and direction")
    func lineFromPointAndDirection() {
        let line: Geometry<Double, Void>.Line = .init(
            point: .init(x: 0, y: 0),
            direction: .init(dx: 1, dy: 1)
        )
        #expect(line.point.x == 0)
        #expect(line.point.y == 0)
        #expect(line.direction.dx == 1)
        #expect(line.direction.dy == 1)
    }

    @Test("Line from two points")
    func lineFromTwoPoints() {
        let line: Geometry<Double, Void>.Line = .init(
            from: .init(x: 0, y: 0),
            to: .init(x: 10, y: 20)
        )
        #expect(line.point.x == 0)
        #expect(line.point.y == 0)
        #expect(line.direction.dx == 10)
        #expect(line.direction.dy == 20)
    }
}

// MARK: - Line Properties Tests

@Suite("Geometry.Line - Properties")
struct GeometryLine_PropertiesTests {
    @Test("Normalized direction vector")
    func normalizedDirection() {
        let line: Geometry<Double, Void>.Line = .init(
            point: .zero,
            direction: .init(dx: 3, dy: 4)
        )
        let normalized = line.normalizedDirection
        #expect(abs(normalized.length - 1) < 1e-10)
    }

    @Test("Point at parameter")
    func pointAtParameter() {
        let line: Geometry<Double, Void>.Line = .init(
            point: .init(x: 0, y: 0),
            direction: .init(dx: 10, dy: 10)
        )
        let p = line.point(at: 0.5)
        #expect(p.x == 5)
        #expect(p.y == 5)
    }
}

// MARK: - Line Static Functions Tests

@Suite("Geometry.Line - Static Functions")
struct GeometryLine_StaticTests {
    @Test("Geometry.distance(from:to:) horizontal line")
    func staticDistanceHorizontalLine() {
        let line: Geometry<Double, Void>.Line = .init(
            point: .init(x: 0, y: 0),
            direction: .init(dx: 1, dy: 0)
        )
        let point: Geometry<Double, Void>.Point<2> = .init(x: 5, y: 3)
        let distance = Geometry.distance(from: line, to: point)
        #expect(distance != nil)
        #expect(distance! == 3)
    }

    @Test("Geometry.distance(from:to:) vertical line")
    func staticDistanceVerticalLine() {
        let line: Geometry<Double, Void>.Line = .init(
            point: .init(x: 3, y: 0),
            direction: .init(dx: 0, dy: 1)
        )
        let point: Geometry<Double, Void>.Point<2> = .init(x: 7, y: 5)
        let distance = Geometry.distance(from: line, to: point)
        #expect(distance != nil)
        #expect(distance! == 4)
    }

    @Test("Geometry.distance(from:to:) returns nil for zero direction")
    func staticDistanceZeroDirection() {
        let line: Geometry<Double, Void>.Line = .init(
            point: .init(x: 0, y: 0),
            direction: .init(dx: 0, dy: 0)
        )
        let point: Geometry<Double, Void>.Point<2> = .init(x: 5, y: 3)
        #expect(Geometry.distance(from: line, to: point) == nil)
    }

    @Test("Geometry.intersection(_:_:) intersecting lines")
    func staticIntersectionLines() {
        let line1: Geometry<Double, Void>.Line = .init(
            point: .init(x: 0, y: 0),
            direction: .init(dx: 1, dy: 1)
        )
        let line2: Geometry<Double, Void>.Line = .init(
            point: .init(x: 0, y: 2),
            direction: .init(dx: 1, dy: -1)
        )
        let intersection = Geometry.intersection(line1, line2)
        #expect(intersection != nil)
        #expect(abs(intersection!.x.value - 1) < 1e-10)
        #expect(abs(intersection!.y.value - 1) < 1e-10)
    }

    @Test("Geometry.intersection(_:_:) parallel lines")
    func staticIntersectionParallelLines() {
        let line1: Geometry<Double, Void>.Line = .init(
            point: .init(x: 0, y: 0),
            direction: .init(dx: 1, dy: 0)
        )
        let line2: Geometry<Double, Void>.Line = .init(
            point: .init(x: 0, y: 5),
            direction: .init(dx: 1, dy: 0)
        )
        #expect(Geometry.intersection(line1, line2) == nil)
    }

    @Test("Geometry.projection(of:onto:) onto horizontal line")
    func staticProjectionHorizontal() {
        let line: Geometry<Double, Void>.Line = .init(
            point: .init(x: 0, y: 0),
            direction: .init(dx: 1, dy: 0)
        )
        let point: Geometry<Double, Void>.Point<2> = .init(x: 5, y: 7)
        let projection = Geometry.projection(of: point, onto: line)
        #expect(projection != nil)
        #expect(abs(projection!.x.value - 5) < 1e-10)
        #expect(abs(projection!.y.value - 0) < 1e-10)
    }

    @Test("Geometry.projection(of:onto:) onto diagonal line")
    func staticProjectionDiagonal() {
        let line: Geometry<Double, Void>.Line = .init(
            point: .init(x: 0, y: 0),
            direction: .init(dx: 1, dy: 1)
        )
        let point: Geometry<Double, Void>.Point<2> = .init(x: 0, y: 4)
        let projection = Geometry.projection(of: point, onto: line)
        #expect(projection != nil)
        #expect(abs(projection!.x.value - 2) < 1e-10)
        #expect(abs(projection!.y.value - 2) < 1e-10)
    }
}

// MARK: - Line Method Tests

@Suite("Geometry.Line - Instance Methods")
struct GeometryLine_MethodTests {
    @Test("Distance to point")
    func distanceToPoint() {
        let line: Geometry<Double, Void>.Line = .init(
            point: .init(x: 0, y: 0),
            direction: .init(dx: 1, dy: 0)
        )
        let point: Geometry<Double, Void>.Point<2> = .init(x: 5, y: 3)
        #expect(line.distance(to: point) == 3)
    }

    @Test("Intersection with another line")
    func intersectionWithLine() {
        let horizontal: Geometry<Double, Void>.Line = .init(
            point: .init(x: 0, y: 5),
            direction: .init(dx: 1, dy: 0)
        )
        let vertical: Geometry<Double, Void>.Line = .init(
            point: .init(x: 3, y: 0),
            direction: .init(dx: 0, dy: 1)
        )
        let intersection = horizontal.intersection(with: vertical)
        #expect(intersection != nil)
        #expect(abs(intersection!.x.value - 3) < 1e-10)
        #expect(abs(intersection!.y.value - 5) < 1e-10)
    }

    @Test("Projection of point onto line")
    func projectionOfPoint() {
        let line: Geometry<Double, Void>.Line = .init(
            point: .init(x: 0, y: 0),
            direction: .init(dx: 1, dy: 1)
        )
        let point: Geometry<Double, Void>.Point<2> = .init(x: 0, y: 4)
        let projection = line.projection(of: point)
        #expect(projection != nil)
        #expect(abs(projection!.x.value - 2) < 1e-10)
        #expect(abs(projection!.y.value - 2) < 1e-10)
    }

    @Test("Reflection across horizontal line")
    func reflectionHorizontal() {
        let line: Geometry<Double, Void>.Line = .init(
            point: .init(x: 0, y: 0),
            direction: .init(dx: 1, dy: 0)
        )
        let point: Geometry<Double, Void>.Point<2> = .init(x: 5, y: 3)
        let reflection = line.reflection(of: point)
        #expect(reflection != nil)
        #expect(abs(reflection!.x.value - 5) < 1e-10)
        #expect(abs(reflection!.y.value - (-3)) < 1e-10)
    }

    @Test("Reflection across vertical line")
    func reflectionVertical() {
        let line: Geometry<Double, Void>.Line = .init(
            point: .init(x: 5, y: 0),
            direction: .init(dx: 0, dy: 1)
        )
        let point: Geometry<Double, Void>.Point<2> = .init(x: 3, y: 7)
        let reflection = line.reflection(of: point)
        #expect(reflection != nil)
        #expect(abs(reflection!.x.value - 7) < 1e-10)
        #expect(abs(reflection!.y.value - 7) < 1e-10)
    }

    @Test("Point on line has same projection")
    func pointOnLineProjection() {
        let line: Geometry<Double, Void>.Line = .init(
            point: .init(x: 0, y: 0),
            direction: .init(dx: 1, dy: 1)
        )
        let point: Geometry<Double, Void>.Point<2> = .init(x: 3, y: 3)
        let projection = line.projection(of: point)
        #expect(projection != nil)
        #expect(abs(projection!.x.value - 3) < 1e-10)
        #expect(abs(projection!.y.value - 3) < 1e-10)
    }

    @Test("Coincident lines return nil for intersection")
    func coincidentLines() {
        let line1: Geometry<Double, Void>.Line = .init(
            point: .init(x: 0, y: 0),
            direction: .init(dx: 1, dy: 1)
        )
        let line2: Geometry<Double, Void>.Line = .init(
            point: .init(x: 1, y: 1),
            direction: .init(dx: 2, dy: 2)
        )
        #expect(line1.intersection(with: line2) == nil)
    }
}

// MARK: - Line.Segment Initialization Tests

@Suite("Geometry.Line.Segment - Initialization")
struct GeometryLineSegment_InitializationTests {
    @Test("Segment from start and end points")
    func segmentFromPoints() {
        let segment: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 3, y: 4)
        )
        #expect(segment.start.x == 0)
        #expect(segment.start.y == 0)
        #expect(segment.end.x == 3)
        #expect(segment.end.y == 4)
    }

    @Test("LineSegment typealias")
    func lineSegmentTypealias() {
        let segment: Geometry<Double, Void>.LineSegment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 3, y: 4)
        )
        #expect(segment.length == 5)
    }
}

// MARK: - Line.Segment Properties Tests

@Suite("Geometry.Line.Segment - Properties")
struct GeometryLineSegment_PropertiesTests {
    @Test("Segment length")
    func segmentLength() {
        let segment: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 3, y: 4)
        )
        #expect(segment.length == 5)
    }

    @Test("Segment length squared")
    func segmentLengthSquared() {
        let segment: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 3, y: 4)
        )
        #expect(segment.lengthSquared == 25)
    }

    @Test("Segment midpoint")
    func segmentMidpoint() {
        let segment: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 10, y: 10)
        )
        #expect(segment.midpoint.x == 5)
        #expect(segment.midpoint.y == 5)
    }

    @Test("Segment vector")
    func segmentVector() {
        let segment: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 10, y: 20),
            end: .init(x: 30, y: 50)
        )
        #expect(segment.vector.dx == 20)
        #expect(segment.vector.dy == 30)
    }

    @Test("Segment to line conversion")
    func segmentToLine() {
        let segment: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 10, y: 20),
            end: .init(x: 30, y: 50)
        )
        let line = segment.line
        #expect(line.point.x == 10)
        #expect(line.point.y == 20)
        #expect(line.direction.dx == 20)
        #expect(line.direction.dy == 30)
    }

    @Test("Reversed segment")
    func reversedSegment() {
        let segment: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 5, y: 10)
        )
        let reversed = segment.reversed
        #expect(reversed.start.x == 5)
        #expect(reversed.start.y == 10)
        #expect(reversed.end.x == 0)
        #expect(reversed.end.y == 0)
    }
}

// MARK: - Line.Segment Parametric Tests

@Suite("Geometry.Line.Segment - Parametric Points")
struct GeometryLineSegment_ParametricTests {
    @Test("Point at parameter 0")
    func pointAtZero() {
        let segment: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 10, y: 10)
        )
        let point = segment.point(at: 0)
        #expect(point.x == 0)
        #expect(point.y == 0)
    }

    @Test("Point at parameter 0.25")
    func pointAtQuarter() {
        let segment: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 10, y: 10)
        )
        let point = segment.point(at: 0.25)
        #expect(point.x == 2.5)
        #expect(point.y == 2.5)
    }

    @Test("Point at parameter 1")
    func pointAtOne() {
        let segment: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 10, y: 10)
        )
        let point = segment.point(at: 1)
        #expect(point.x == 10)
        #expect(point.y == 10)
    }
}

// MARK: - Line.Segment Static Functions Tests

@Suite("Geometry.Line.Segment - Static Functions")
struct GeometryLineSegment_StaticTests {
    @Test("Geometry.intersection(_:_:) intersecting segments")
    func staticIntersectionSegments() {
        let seg1: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 10, y: 10)
        )
        let seg2: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 0, y: 10),
            end: .init(x: 10, y: 0)
        )
        let intersection = Geometry.intersection(seg1, seg2)
        #expect(intersection != nil)
        #expect(abs(intersection!.x.value - 5) < 1e-10)
        #expect(abs(intersection!.y.value - 5) < 1e-10)
    }

    @Test("Geometry.intersection(_:_:) non-intersecting parallel segments")
    func staticIntersectionParallelSegments() {
        let seg1: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 10, y: 0)
        )
        let seg2: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 0, y: 5),
            end: .init(x: 10, y: 5)
        )
        #expect(Geometry.intersection(seg1, seg2) == nil)
    }

    @Test("Geometry.intersection(_:_:) would intersect if extended")
    func staticIntersectionWouldExtend() {
        let seg1: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 2, y: 2)
        )
        let seg2: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 0, y: 10),
            end: .init(x: 2, y: 8)
        )
        #expect(Geometry.intersection(seg1, seg2) == nil)
    }

    @Test("Geometry.intersection(_:_:) T-junction")
    func staticIntersectionTJunction() {
        let horizontal: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 0, y: 5),
            end: .init(x: 10, y: 5)
        )
        let vertical: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 5, y: 0),
            end: .init(x: 5, y: 5)
        )
        let intersection = Geometry.intersection(horizontal, vertical)
        #expect(intersection != nil)
        #expect(abs(intersection!.x.value - 5) < 1e-10)
        #expect(abs(intersection!.y.value - 5) < 1e-10)
    }

    @Test("Geometry.intersection(_:_:) at endpoint")
    func staticIntersectionEndpoint() {
        let seg1: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 5, y: 5)
        )
        let seg2: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 5, y: 5),
            end: .init(x: 10, y: 0)
        )
        let intersection = Geometry.intersection(seg1, seg2)
        #expect(intersection != nil)
        #expect(abs(intersection!.x.value - 5) < 1e-10)
        #expect(abs(intersection!.y.value - 5) < 1e-10)
    }

    @Test("Geometry.distance(from:to:) point on segment")
    func staticDistancePointOnSegment() {
        let segment: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 10, y: 0)
        )
        let point: Geometry<Double, Void>.Point<2> = .init(x: 5, y: 0)
        let distance = Geometry.distance(from: segment, to: point)
        #expect(abs(distance.value) < 1e-10)
    }

    @Test("Geometry.distance(from:to:) point near segment")
    func staticDistancePointNearSegment() {
        let segment: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 10, y: 0)
        )
        let point: Geometry<Double, Void>.Point<2> = .init(x: 5, y: 3)
        let distance = Geometry.distance(from: segment, to: point)
        #expect(abs(distance.value - 3) < 1e-10)
    }

    @Test("Geometry.distance(from:to:) point past segment end")
    func staticDistancePointPastEnd() {
        let segment: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 10, y: 0)
        )
        let point: Geometry<Double, Void>.Point<2> = .init(x: 15, y: 0)
        let distance = Geometry.distance(from: segment, to: point)
        #expect(abs(distance.value - 5) < 1e-10)
    }

    @Test("Geometry.distance(from:to:) point before segment start")
    func staticDistancePointBeforeStart() {
        let segment: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 10, y: 0)
        )
        let point: Geometry<Double, Void>.Point<2> = .init(x: -3, y: 4)
        let distance = Geometry.distance(from: segment, to: point)
        #expect(abs(distance.value - 5) < 1e-10)
    }

    @Test("Geometry.distance(from:to:) degenerate segment")
    func staticDistanceDegenerateSegment() {
        let segment: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 5, y: 5),
            end: .init(x: 5, y: 5)
        )
        let point: Geometry<Double, Void>.Point<2> = .init(x: 8, y: 9)
        let distance = Geometry.distance(from: segment, to: point)
        #expect(abs(distance.value - 5) < 1e-10)  // 3-4-5 triangle
    }
}

// MARK: - Line.Segment Method Tests

@Suite("Geometry.Line.Segment - Instance Methods")
struct GeometryLineSegment_MethodTests {
    @Test("Intersection with another segment")
    func intersectionWithSegment() {
        let seg1: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 10, y: 10)
        )
        let seg2: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 0, y: 10),
            end: .init(x: 10, y: 0)
        )
        let intersection = seg1.intersection(with: seg2)
        #expect(intersection != nil)
        #expect(abs(intersection!.x.value - 5) < 1e-10)
        #expect(abs(intersection!.y.value - 5) < 1e-10)
    }

    @Test("Intersects method")
    func intersectsMethod() {
        let seg1: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 10, y: 10)
        )
        let seg2: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 0, y: 10),
            end: .init(x: 10, y: 0)
        )
        #expect(seg1.intersects(with: seg2))
    }

    @Test("Distance to point")
    func distanceToPoint() {
        let segment: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 10, y: 0)
        )
        let point: Geometry<Double, Void>.Point<2> = .init(x: 5, y: 3)
        #expect(abs(segment.distance(to: point).value - 3) < 1e-10)
    }
}

// MARK: - Functorial Map Tests

@Suite("Geometry.Line - Functorial Map")
struct GeometryLine_MapTests {
    @Test("Line map to different scalar type")
    func lineMap() {
        let line: Geometry<Double, Void>.Line = .init(
            point: .init(x: 1, y: 2),
            direction: .init(dx: 3, dy: 4)
        )
        let mapped: Geometry<Float, Void>.Line = try! line.map { Float($0) }
        #expect(mapped.point.x.value == 1)
        #expect(mapped.point.y.value == 2)
        #expect(mapped.direction.dx.value == 3)
        #expect(mapped.direction.dy.value == 4)
    }

    @Test("Segment map to different scalar type")
    func segmentMap() {
        let segment: Geometry<Double, Void>.Line.Segment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 5, y: 10)
        )
        let mapped: Geometry<Float, Void>.Line.Segment = try! segment.map { Float($0) }
        #expect(mapped.start.x.value == 0)
        #expect(mapped.end.y.value == 10)
    }
}
