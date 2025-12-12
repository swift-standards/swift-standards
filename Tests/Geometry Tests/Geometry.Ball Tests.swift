// Geometry.Ball Tests.swift
// Tests for Geometry.Ball type (N-dimensional ball/hypersphere).

import Angle
import Testing

@testable import Affine
@testable import Algebra
@testable import Algebra_Linear
@testable import Geometry

// MARK: - Initialization Tests

@Suite
struct `Geometry.Ball - Initialization` {
    @Test
    func `Ball initialization with center and radius`() {
        let ball: Geometry<Double, Void>.Ball<2> = .init(
            center: .init(x: 10, y: 20),
            radius: 5
        )
        #expect(ball.center.x == 10)
        #expect(ball.center.y == 20)
        #expect(ball.radius == 5)
    }

    @Test
    func `Ball at origin with radius`() {
        let ball: Geometry<Double, Void>.Ball<2> = .init(radius: 10)
        #expect(ball.center.x == 0)
        #expect(ball.center.y == 0)
        #expect(ball.radius == 10)
    }

    @Test
    func `Unit ball`() {
        let ball: Geometry<Double, Void>.Ball<2> = .unit
        #expect(ball.center.x == 0)
        #expect(ball.center.y == 0)
        #expect(ball.radius == 1)
    }

    @Test
    func `Circle typealias`() {
        let circle: Geometry<Double, Void>.Circle = .init(
            center: .init(x: 5, y: 10),
            radius: 3
        )
        #expect(circle.center.x == 5)
        #expect(circle.radius == 3)
    }

    @Test
    func `Circle from circular ellipse`() {
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

    @Test
    func `Circle from non-circular ellipse returns nil`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(semiMajor: 10, semiMinor: 5)
        let circle = Geometry<Double, Void>.Circle(ellipse)
        #expect(circle == nil)
    }
}

// MARK: - Properties Tests

@Suite
struct `Geometry.Ball - Properties` {
    @Test
    func `Circle diameter`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        #expect(circle.diameter.width.value == 10)
    }

    @Test
    func `Circle circumference`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 1)
        #expect(abs(circle.circumference.value - 2 * .pi) < 1e-10)
    }

    @Test
    func `Circle area using property`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 2)
        #expect(abs(circle.area.value - 4 * .pi) < 1e-10)
    }

    @Test
    func `Sphere surface area`() {
        let sphere: Geometry<Double, Void>.Sphere = .init(center: .zero, radius: 2)
        // Surface area = 4πr² = 4π(4) = 16π
        #expect(abs(sphere.surfaceArea - 16 * .pi) < 1e-10)
    }

    @Test
    func `Sphere volume`() {
        let sphere: Geometry<Double, Void>.Sphere = .init(center: .zero, radius: 3)
        // Volume = (4/3)πr³ = (4/3)π(27) = 36π
        #expect(abs(sphere.volume - 36 * .pi) < 1e-10)
    }
}

// MARK: - Static Function Tests

@Suite
struct `Geometry.Ball - Static Functions` {
    @Test
    func `Geometry.area(of:) for circle`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 3)
        let area = Geometry.area(of: circle)
        #expect(abs(area.value - 9 * .pi) < 1e-10)
    }

    @Test
    func `Geometry.boundingBox(of:) for circle`() {
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

    @Test
    func `Geometry.contains(_:point:) for point inside`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 10)
        let point: Geometry<Double, Void>.Point<2> = .init(x: 3, y: 4)  // distance 5
        #expect(Geometry.contains(circle, point: point))
    }

    @Test
    func `Geometry.contains(_:point:) for point on boundary`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let point: Geometry<Double, Void>.Point<2> = .init(x: 3, y: 4)  // distance 5
        #expect(Geometry.contains(circle, point: point))
    }

    @Test
    func `Geometry.contains(_:point:) for point outside`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let point: Geometry<Double, Void>.Point<2> = .init(x: 6, y: 8)  // distance 10
        #expect(!Geometry.contains(circle, point: point))
    }

    @Test
    func `Geometry.contains(_:_:) circle contains another`() {
        let outer: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 10)
        let inner: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 3)
        #expect(Geometry.contains(outer, inner))
    }

    @Test
    func `Geometry.contains(_:_:) circle does not contain larger circle`() {
        let small: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 3)
        let large: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 10)
        #expect(!Geometry.contains(small, large))
    }

    @Test
    func `Geometry.intersects(_:_:) overlapping circles`() {
        let c1: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let c2: Geometry<Double, Void>.Circle = .init(center: .init(x: 6, y: 0), radius: 5)
        #expect(Geometry.intersects(c1, c2))
    }

    @Test
    func `Geometry.intersects(_:_:) tangent circles`() {
        let c1: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let c2: Geometry<Double, Void>.Circle = .init(center: .init(x: 10, y: 0), radius: 5)
        #expect(Geometry.intersects(c1, c2))
    }

    @Test
    func `Geometry.intersects(_:_:) separate circles`() {
        let c1: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let c2: Geometry<Double, Void>.Circle = .init(center: .init(x: 20, y: 0), radius: 5)
        #expect(!Geometry.intersects(c1, c2))
    }
}

// MARK: - Containment Tests

@Suite
struct `Geometry.Ball - Containment` {
    @Test
    func `Contains center point`() {
        let circle: Geometry<Double, Void>.Circle = .init(
            center: .init(x: 5, y: 5),
            radius: 10
        )
        #expect(circle.contains(circle.center))
    }

    @Test
    func `Contains interior using containsInterior`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 10)
        let point: Geometry<Double, Void>.Point<2> = .init(x: 3, y: 4)
        #expect(circle.containsInterior(point))
    }

    @Test
    func `Boundary point not strictly interior`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let point: Geometry<Double, Void>.Point<2> = .init(x: 3, y: 4)  // distance 5
        #expect(!circle.containsInterior(point))
    }

    @Test
    func `Circle contains smaller circle`() {
        let outer: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 10)
        let inner: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 3)
        #expect(outer.contains(inner))
    }
}

// MARK: - Point on Circle Tests

@Suite
struct `Geometry.Ball - Parametric Points` {
    @Test
    func `Point at angle 0 (rightmost)`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let point = circle.point(at: .zero)
        #expect(abs(point.x.value - 5) < 1e-10)
        #expect(abs(point.y.value) < 1e-10)
    }

    @Test
    func `Point at angle π/2 (top)`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let point = circle.point(at: .halfPi)
        #expect(abs(point.x.value) < 1e-10)
        #expect(abs(point.y.value - 5) < 1e-10)
    }

    @Test
    func `Point at angle π (leftmost)`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let point = circle.point(at: .pi)
        #expect(abs(point.x.value - (-5)) < 1e-10)
        #expect(abs(point.y.value) < 1e-10)
    }

    @Test
    func `Point with offset center`() {
        let circle: Geometry<Double, Void>.Circle = .init(
            center: .init(x: 10, y: 20),
            radius: 5
        )
        let point = circle.point(at: .zero)
        #expect(abs(point.x.value - 15) < 1e-10)
        #expect(abs(point.y.value - 20) < 1e-10)
    }

    @Test
    func `Closest point to exterior point`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let exterior: Geometry<Double, Void>.Point<2> = .init(x: 10, y: 0)
        let closest = circle.closestPoint(to: exterior)
        #expect(abs(closest.x.value - 5) < 1e-10)
        #expect(abs(closest.y.value) < 1e-10)
    }

    @Test
    func `Closest point when query point is at center`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let closest = circle.closestPoint(to: circle.center)
        // Should return rightmost point when at center
        #expect(abs(closest.x.value - 5) < 1e-10)
        #expect(abs(closest.y.value) < 1e-10)
    }
}

// MARK: - Tangent Tests

@Suite
struct `Geometry.Ball - Tangent Vectors` {
    @Test
    func `Tangent at angle 0 points up`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let tangent = circle.tangent(at: .zero)
        #expect(abs(tangent.dx.value) < 1e-10)
        #expect(abs(tangent.dy.value - 1) < 1e-10)
    }

    @Test
    func `Tangent at angle π/2 points left`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let tangent = circle.tangent(at: .halfPi)
        #expect(abs(tangent.dx.value - (-1)) < 1e-10)
        #expect(abs(tangent.dy.value) < 1e-10)
    }

    @Test
    func `Tangent is perpendicular to radius`() {
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

@Suite
struct `Geometry.Ball - Bounding Box` {
    @Test
    func `Bounding box at origin`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let bbox = circle.boundingBox
        #expect(bbox.llx == -5)
        #expect(bbox.lly == -5)
        #expect(bbox.urx == 5)
        #expect(bbox.ury == 5)
    }

    @Test
    func `Bounding box with offset`() {
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

@Suite
struct `Geometry.Ball - Transformations` {
    @Test
    func `Translation preserves radius`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let translated = circle.translated(by: .init(dx: 10, dy: 20))
        #expect(translated.center.x == 10)
        #expect(translated.center.y == 20)
        #expect(translated.radius == 5)
    }

    @Test
    func `Uniform scaling about center`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let scaled = circle.scaled(by: 2)
        #expect(scaled.center.x == 0)
        #expect(scaled.center.y == 0)
        #expect(scaled.radius == 10)
    }

    @Test
    func `Scaling about arbitrary point`() {
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

@Suite
struct `Geometry.Ball - Line Intersection` {
    @Test
    func `Geometry.intersection(_:_:) line through center`() {
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

    @Test
    func `Line tangent to circle`() {
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

    @Test
    func `Line misses circle`() {
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

@Suite
struct `Geometry.Ball - Circle Intersection` {
    @Test
    func `Geometry.intersection(_:_:) two points`() {
        let c1: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let c2: Geometry<Double, Void>.Circle = .init(center: .init(x: 6, y: 0), radius: 5)
        let intersections = Geometry.intersection(c1, c2)
        #expect(intersections.count == 2)
    }

    @Test
    func `Tangent circles touch at one point`() {
        let c1: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let c2: Geometry<Double, Void>.Circle = .init(center: .init(x: 10, y: 0), radius: 5)
        let intersections = c1.intersection(with: c2)
        #expect(intersections.count == 1)
        #expect(abs(intersections[0].x.value - 5) < 1e-10)
        #expect(abs(intersections[0].y.value) < 1e-10)
    }

    @Test
    func `Separate circles`() {
        let c1: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let c2: Geometry<Double, Void>.Circle = .init(center: .init(x: 20, y: 0), radius: 5)
        let intersections = c1.intersection(with: c2)
        #expect(intersections.isEmpty)
    }

    @Test
    func `One circle inside another`() {
        let c1: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 10)
        let c2: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 3)
        let intersections = c1.intersection(with: c2)
        #expect(intersections.isEmpty)
    }

    @Test
    func `Intersection method on circle`() {
        let c1: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let c2: Geometry<Double, Void>.Circle = .init(center: .init(x: 6, y: 0), radius: 5)
        #expect(c1.intersects(c2))
    }
}

// MARK: - Bezier Approximation Tests

@Suite
struct `Geometry.Ball - Bezier Curves` {
    @Test
    func `Bezier curves count`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let curves = circle.bezierCurves
        #expect(curves.count == 4)
    }

    @Test
    func `Bezier start point`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let startPoint = circle.bezierStartPoint
        #expect(abs(startPoint.x.value - 5) < 1e-10)
        #expect(abs(startPoint.y.value) < 1e-10)
    }

    @Test
    func `First bezier segment starts at rightmost point`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let curves = circle.bezierCurves
        let first = curves[0]
        #expect(abs(first.start.x.value - 5) < 1e-10)
        #expect(abs(first.start.y.value) < 1e-10)
    }
}

// MARK: - Functorial Map Tests

@Suite
struct `Geometry.Ball - Functorial Map` {
    @Test
    func `Map to different scalar type`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let mapped: Geometry<Float, Void>.Circle = circle.map { Float($0) }
        #expect(mapped.center.x.value == 0)
        #expect(mapped.center.y.value == 0)
        #expect(mapped.radius.value == 5)
    }
}
