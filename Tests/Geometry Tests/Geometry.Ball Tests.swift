// Geometry.Ball Tests.swift
// Tests for Geometry.Ball type (N-dimensional ball/hypersphere).

import Angle
import Testing

@testable import Affine
@testable import Algebra
@testable import Algebra_Linear
@testable import Geometry

// MARK: - Initialization Tests

@Suite("Geometry.Ball - Initialization")
struct GeometryBall_InitializationTests {
    @Test("Ball initialization with center and radius")
    func ballInitialization() {
        let ball: Geometry<Double, Void>.Ball<2> = .init(
            center: .init(x: 10, y: 20),
            radius: 5
        )
        #expect(ball.center.x == 10)
        #expect(ball.center.y == 20)
        #expect(ball.radius == 5)
    }

    @Test("Ball at origin with radius")
    func ballAtOrigin() {
        let ball: Geometry<Double, Void>.Ball<2> = .init(radius: 10)
        #expect(ball.center.x == 0)
        #expect(ball.center.y == 0)
        #expect(ball.radius == 10)
    }

    @Test("Unit ball")
    func unitBall() {
        let ball: Geometry<Double, Void>.Ball<2> = .unit
        #expect(ball.center.x == 0)
        #expect(ball.center.y == 0)
        #expect(ball.radius == 1)
    }

    @Test("Circle typealias")
    func circleTypealias() {
        let circle: Geometry<Double, Void>.Circle = .init(
            center: .init(x: 5, y: 10),
            radius: 3
        )
        #expect(circle.center.x == 5)
        #expect(circle.radius == 3)
    }

    @Test("Circle from circular ellipse")
    func circleFromEllipse() {
        let ellipse: Geometry<Double, Void>.Ellipse = .circle(
            center: .init(x: 5, y: 10),
            radius: 7
        )
        let circle = Geometry<Double, Void>.Circle(ellipse)
        #expect(circle != nil)
        #expect(circle?.center.x == 5)
        #expect(circle?.center.y == 10)
        #expect(circle?.radius == 7)
    }

    @Test("Circle from non-circular ellipse returns nil")
    func circleFromNonCircularEllipse() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(semiMajor: 10, semiMinor: 5)
        let circle = Geometry<Double, Void>.Circle(ellipse)
        #expect(circle == nil)
    }
}

// MARK: - Properties Tests

@Suite("Geometry.Ball - Properties")
struct GeometryBall_PropertiesTests {
    @Test("Circle diameter")
    func circleDiameter() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        #expect(circle.diameter.width.value == 10)
    }

    @Test("Circle circumference")
    func circleCircumference() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 1)
        #expect(abs(circle.circumference.value - 2 * .pi) < 1e-10)
    }

    @Test("Circle area using property")
    func circleAreaProperty() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 2)
        #expect(abs(circle.area.value - 4 * .pi) < 1e-10)
    }

    @Test("Sphere surface area")
    func sphereSurfaceArea() {
        let sphere: Geometry<Double, Void>.Sphere = .init(center: .zero, radius: 2)
        // Surface area = 4πr² = 4π(4) = 16π
        #expect(abs(sphere.surfaceArea - 16 * .pi) < 1e-10)
    }

    @Test("Sphere volume")
    func sphereVolume() {
        let sphere: Geometry<Double, Void>.Sphere = .init(center: .zero, radius: 3)
        // Volume = (4/3)πr³ = (4/3)π(27) = 36π
        #expect(abs(sphere.volume - 36 * .pi) < 1e-10)
    }
}

// MARK: - Static Function Tests

@Suite("Geometry.Ball - Static Functions")
struct GeometryBall_StaticTests {
    @Test("Geometry.area(of:) for circle")
    func staticAreaFunction() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 3)
        let area = Geometry.area(of: circle)
        #expect(abs(area.value - 9 * .pi) < 1e-10)
    }

    @Test("Geometry.boundingBox(of:) for circle")
    func staticBoundingBox() {
        let circle: Geometry<Double, Void>.Circle = .init(
            center: .init(x: 10, y: 20),
            radius: 5
        )
        let bbox = Geometry.boundingBox(of: circle)
        #expect(bbox.llx == 5)
        #expect(bbox.lly == 15)
        #expect(bbox.urx == 15)
        #expect(bbox.ury == 25)
    }

    @Test("Geometry.contains(_:point:) for point inside")
    func staticContainsPointInside() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 10)
        let point: Geometry<Double, Void>.Point<2> = .init(x: 3, y: 4)  // distance 5
        #expect(Geometry.contains(circle, point: point))
    }

    @Test("Geometry.contains(_:point:) for point on boundary")
    func staticContainsPointOnBoundary() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let point: Geometry<Double, Void>.Point<2> = .init(x: 3, y: 4)  // distance 5
        #expect(Geometry.contains(circle, point: point))
    }

    @Test("Geometry.contains(_:point:) for point outside")
    func staticContainsPointOutside() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let point: Geometry<Double, Void>.Point<2> = .init(x: 6, y: 8)  // distance 10
        #expect(!Geometry.contains(circle, point: point))
    }

    @Test("Geometry.contains(_:_:) circle contains another")
    func staticContainsCircle() {
        let outer: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 10)
        let inner: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 3)
        #expect(Geometry.contains(outer, inner))
    }

    @Test("Geometry.contains(_:_:) circle does not contain larger circle")
    func staticDoesNotContainLargerCircle() {
        let small: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 3)
        let large: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 10)
        #expect(!Geometry.contains(small, large))
    }

    @Test("Geometry.intersects(_:_:) overlapping circles")
    func staticIntersectsOverlapping() {
        let c1: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let c2: Geometry<Double, Void>.Circle = .init(center: .init(x: 6, y: 0), radius: 5)
        #expect(Geometry.intersects(c1, c2))
    }

    @Test("Geometry.intersects(_:_:) tangent circles")
    func staticIntersectsTangent() {
        let c1: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let c2: Geometry<Double, Void>.Circle = .init(center: .init(x: 10, y: 0), radius: 5)
        #expect(Geometry.intersects(c1, c2))
    }

    @Test("Geometry.intersects(_:_:) separate circles")
    func staticDoesNotIntersect() {
        let c1: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let c2: Geometry<Double, Void>.Circle = .init(center: .init(x: 20, y: 0), radius: 5)
        #expect(!Geometry.intersects(c1, c2))
    }
}

// MARK: - Containment Tests

@Suite("Geometry.Ball - Containment")
struct GeometryBall_ContainmentTests {
    @Test("Contains center point")
    func containsCenter() {
        let circle: Geometry<Double, Void>.Circle = .init(
            center: .init(x: 5, y: 5),
            radius: 10
        )
        #expect(circle.contains(circle.center))
    }

    @Test("Contains interior using containsInterior")
    func containsInteriorPoint() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 10)
        let point: Geometry<Double, Void>.Point<2> = .init(x: 3, y: 4)
        #expect(circle.containsInterior(point))
    }

    @Test("Boundary point not strictly interior")
    func boundaryNotInterior() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let point: Geometry<Double, Void>.Point<2> = .init(x: 3, y: 4)  // distance 5
        #expect(!circle.containsInterior(point))
    }

    @Test("Circle contains smaller circle")
    func circleContainsCircle() {
        let outer: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 10)
        let inner: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 3)
        #expect(outer.contains(inner))
    }
}

// MARK: - Point on Circle Tests

@Suite("Geometry.Ball - Parametric Points")
struct GeometryBall_ParametricTests {
    @Test("Point at angle 0 (rightmost)")
    func pointAtZero() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let point = circle.point(at: .zero)
        #expect(abs(point.x.value - 5) < 1e-10)
        #expect(abs(point.y.value) < 1e-10)
    }

    @Test("Point at angle π/2 (top)")
    func pointAtHalfPi() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let point = circle.point(at: .halfPi)
        #expect(abs(point.x.value) < 1e-10)
        #expect(abs(point.y.value - 5) < 1e-10)
    }

    @Test("Point at angle π (leftmost)")
    func pointAtPi() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let point = circle.point(at: .pi)
        #expect(abs(point.x.value - (-5)) < 1e-10)
        #expect(abs(point.y.value) < 1e-10)
    }

    @Test("Point with offset center")
    func pointWithOffsetCenter() {
        let circle: Geometry<Double, Void>.Circle = .init(
            center: .init(x: 10, y: 20),
            radius: 5
        )
        let point = circle.point(at: .zero)
        #expect(abs(point.x.value - 15) < 1e-10)
        #expect(abs(point.y.value - 20) < 1e-10)
    }

    @Test("Closest point to exterior point")
    func closestPointToExterior() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let exterior: Geometry<Double, Void>.Point<2> = .init(x: 10, y: 0)
        let closest = circle.closestPoint(to: exterior)
        #expect(abs(closest.x.value - 5) < 1e-10)
        #expect(abs(closest.y.value) < 1e-10)
    }

    @Test("Closest point when query point is at center")
    func closestPointAtCenter() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let closest = circle.closestPoint(to: circle.center)
        // Should return rightmost point when at center
        #expect(abs(closest.x.value - 5) < 1e-10)
        #expect(abs(closest.y.value) < 1e-10)
    }
}

// MARK: - Tangent Tests

@Suite("Geometry.Ball - Tangent Vectors")
struct GeometryBall_TangentTests {
    @Test("Tangent at angle 0 points up")
    func tangentAtZero() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let tangent = circle.tangent(at: .zero)
        #expect(abs(tangent.dx.value) < 1e-10)
        #expect(abs(tangent.dy.value - 1) < 1e-10)
    }

    @Test("Tangent at angle π/2 points left")
    func tangentAtHalfPi() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let tangent = circle.tangent(at: .halfPi)
        #expect(abs(tangent.dx.value - (-1)) < 1e-10)
        #expect(abs(tangent.dy.value) < 1e-10)
    }

    @Test("Tangent is perpendicular to radius")
    func tangentPerpendicularToRadius() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let angle: Radian = .init(Double.pi / 3)
        let point = circle.point(at: angle)
        let tangent = circle.tangent(at: angle)
        let radius: Geometry<Double, Void>.Vector<2> = .init(
            dx: Geometry<Double, Void>.Width(point.x.value),
            dy: Geometry<Double, Void>.Height(point.y.value)
        )
        let dot = radius.dot(tangent)
        #expect(abs(dot) < 1e-10)
    }
}

// MARK: - Bounding Box Tests

@Suite("Geometry.Ball - Bounding Box")
struct GeometryBall_BoundingBoxTests {
    @Test("Bounding box at origin")
    func boundingBoxAtOrigin() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let bbox = circle.boundingBox
        #expect(bbox.llx == -5)
        #expect(bbox.lly == -5)
        #expect(bbox.urx == 5)
        #expect(bbox.ury == 5)
    }

    @Test("Bounding box with offset")
    func boundingBoxWithOffset() {
        let circle: Geometry<Double, Void>.Circle = .init(
            center: .init(x: 10, y: 20),
            radius: 5
        )
        let bbox = circle.boundingBox
        #expect(bbox.llx == 5)
        #expect(bbox.lly == 15)
        #expect(bbox.urx == 15)
        #expect(bbox.ury == 25)
    }
}

// MARK: - Transformation Tests

@Suite("Geometry.Ball - Transformations")
struct GeometryBall_TransformationTests {
    @Test("Translation preserves radius")
    func translation() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let translated = circle.translated(by: .init(dx: 10, dy: 20))
        #expect(translated.center.x == 10)
        #expect(translated.center.y == 20)
        #expect(translated.radius == 5)
    }

    @Test("Uniform scaling about center")
    func scalingAboutCenter() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let scaled = circle.scaled(by: 2)
        #expect(scaled.center.x == 0)
        #expect(scaled.center.y == 0)
        #expect(scaled.radius == 10)
    }

    @Test("Scaling about arbitrary point")
    func scalingAboutPoint() {
        let circle: Geometry<Double, Void>.Circle = .init(
            center: .init(x: 10, y: 0),
            radius: 5
        )
        let scaled = circle.scaled(by: 2, about: .zero)
        #expect(scaled.center.x == 20)
        #expect(scaled.center.y == 0)
        #expect(scaled.radius == 10)
    }
}

// MARK: - Line Intersection Tests

@Suite("Geometry.Ball - Line Intersection")
struct GeometryBall_LineIntersectionTests {
    @Test("Geometry.intersection(_:_:) line through center")
    func staticLineThroughCenter() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let line: Geometry<Double, Void>.Line = .init(
            point: .zero,
            direction: .init(dx: 1, dy: 0)
        )
        let intersections = Geometry.intersection(circle, line)
        #expect(intersections.count == 2)
        let sorted = intersections.sorted { $0.x.value < $1.x.value }
        #expect(abs(sorted[0].x.value - (-5)) < 1e-10)
        #expect(abs(sorted[1].x.value - 5) < 1e-10)
    }

    @Test("Line tangent to circle")
    func lineTangent() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let line: Geometry<Double, Void>.Line = .init(
            point: .init(x: 5, y: 0),
            direction: .init(dx: 0, dy: 1)
        )
        let intersections = circle.intersection(with: line)
        #expect(intersections.count == 1)
        #expect(abs(intersections[0].x.value - 5) < 1e-10)
        #expect(abs(intersections[0].y.value) < 1e-10)
    }

    @Test("Line misses circle")
    func lineMissesCircle() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let line: Geometry<Double, Void>.Line = .init(
            point: .init(x: 10, y: 0),
            direction: .init(dx: 0, dy: 1)
        )
        let intersections = circle.intersection(with: line)
        #expect(intersections.isEmpty)
    }
}

// MARK: - Circle-Circle Intersection Tests

@Suite("Geometry.Ball - Circle Intersection")
struct GeometryBall_CircleIntersectionTests {
    @Test("Geometry.intersection(_:_:) two points")
    func staticIntersectionTwoPoints() {
        let c1: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let c2: Geometry<Double, Void>.Circle = .init(center: .init(x: 6, y: 0), radius: 5)
        let intersections = Geometry.intersection(c1, c2)
        #expect(intersections.count == 2)
    }

    @Test("Tangent circles touch at one point")
    func tangentCircles() {
        let c1: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let c2: Geometry<Double, Void>.Circle = .init(center: .init(x: 10, y: 0), radius: 5)
        let intersections = c1.intersection(with: c2)
        #expect(intersections.count == 1)
        #expect(abs(intersections[0].x.value - 5) < 1e-10)
        #expect(abs(intersections[0].y.value) < 1e-10)
    }

    @Test("Separate circles")
    func separateCircles() {
        let c1: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let c2: Geometry<Double, Void>.Circle = .init(center: .init(x: 20, y: 0), radius: 5)
        let intersections = c1.intersection(with: c2)
        #expect(intersections.isEmpty)
    }

    @Test("One circle inside another")
    func circleInsideAnother() {
        let c1: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 10)
        let c2: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 3)
        let intersections = c1.intersection(with: c2)
        #expect(intersections.isEmpty)
    }

    @Test("Intersection method on circle")
    func intersectionMethod() {
        let c1: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let c2: Geometry<Double, Void>.Circle = .init(center: .init(x: 6, y: 0), radius: 5)
        #expect(c1.intersects(c2))
    }
}

// MARK: - Bezier Approximation Tests

@Suite("Geometry.Ball - Bezier Curves")
struct GeometryBall_BezierTests {
    @Test("Bezier curves count")
    func bezierCurvesCount() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let curves = circle.bezierCurves
        #expect(curves.count == 4)
    }

    @Test("Bezier start point")
    func bezierStartPoint() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let startPoint = circle.bezierStartPoint
        #expect(abs(startPoint.x.value - 5) < 1e-10)
        #expect(abs(startPoint.y.value) < 1e-10)
    }

    @Test("First bezier segment starts at rightmost point")
    func firstBezierSegment() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let curves = circle.bezierCurves
        let first = curves[0]
        #expect(abs(first.start.x.value - 5) < 1e-10)
        #expect(abs(first.start.y.value) < 1e-10)
    }
}

// MARK: - Functorial Map Tests

@Suite("Geometry.Ball - Functorial Map")
struct GeometryBall_MapTests {
    @Test("Map to different scalar type")
    func mapToFloat() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let mapped: Geometry<Float, Void>.Circle = circle.map { Float($0) }
        #expect(mapped.center.x.value == 0)
        #expect(mapped.center.y.value == 0)
        #expect(mapped.radius.value == 5)
    }
}
