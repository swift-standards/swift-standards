// Geometry.Ball Tests.swift
// Tests for Geometry.Ball type (N-dimensional ball/hypersphere).

import Angle
import Testing

@testable import Affine
@testable import Algebra
@testable import Algebra_Linear
@testable import Geometry

// MARK: - Test Helpers

private typealias Geo = Geometry<Double, Void>
private typealias X = Geo.X
private typealias Y = Geo.Y
private typealias Dx = Linear<Double, Void>.Dx
private typealias Dy = Linear<Double, Void>.Dy
private typealias Distance = Linear<Double, Void>.Magnitude
private typealias Width = Linear<Double, Void>.Width
private typealias Height = Linear<Double, Void>.Height
private typealias Area = Geo.Area

private func isApprox(_ a: X, _ b: X, tol: Double = 1e-10) -> Bool {
    let diff = a - b
    let tolerance = Dx(tol)
    return diff > -tolerance && diff < tolerance
}

private func isApprox(_ a: Y, _ b: Y, tol: Double = 1e-10) -> Bool {
    let diff = a - b
    let tolerance = Dy(tol)
    return diff > -tolerance && diff < tolerance
}

private func isApprox(_ a: Dx, _ b: Dx, tol: Double = 1e-10) -> Bool {
    let diff = a - b
    let tolerance = Dx(tol)
    return diff > -tolerance && diff < tolerance
}

private func isApprox(_ a: Dy, _ b: Dy, tol: Double = 1e-10) -> Bool {
    let diff = a - b
    let tolerance = Dy(tol)
    return diff > -tolerance && diff < tolerance
}

private func isApprox(_ a: Distance, _ b: Distance, tol: Double = 1e-10) -> Bool {
    let diff = a - b
    let tolerance = Distance(tol)
    return diff > -tolerance && diff < tolerance
}

private func isApprox(_ a: Width, _ b: Width, tol: Double = 1e-10) -> Bool {
    let diff = a - b
    let tolerance = Width(tol)
    return diff > -tolerance && diff < tolerance
}

private func isApprox(_ a: Area, _ b: Area, tol: Double = 1e-10) -> Bool {
    return abs(a.rawValue - b.rawValue) < tol
}

private func isApproxScalar(_ a: Double, _ b: Double, tol: Double = 1e-10) -> Bool {
    return abs(a - b) < tol
}

// MARK: - Initialization Tests

@Suite
struct `Geometry.Ball - Initialization` {
    @Test
    func `Ball initialization with center and radius`() {
        let ball: Geometry<Double, Void>.Ball<2> = .init(
            center: .init(x: 10, y: 20),
            radius: 5
        )
        #expect(ball.center.x == X(10))
        #expect(ball.center.y == Y(20))
        #expect(ball.radius == Distance(5))
    }

    @Test
    func `Ball at origin with radius`() {
        let ball: Geometry<Double, Void>.Ball<2> = .init(radius: 10)
        #expect(ball.center.x == X(0))
        #expect(ball.center.y == Y(0))
        #expect(ball.radius == Distance(10))
    }

    @Test
    func `Unit ball`() {
        let ball: Geometry<Double, Void>.Ball<2> = .unit
        #expect(ball.center.x == X(0))
        #expect(ball.center.y == Y(0))
        #expect(ball.radius == Distance(1))
    }

    @Test
    func `Circle typealias`() {
        let circle: Geometry<Double, Void>.Circle = .init(
            center: .init(x: 5, y: 10),
            radius: 3
        )
        #expect(circle.center.x == X(5))
        #expect(circle.radius == Distance(3))
    }

    @Test
    func `Circle from circular ellipse`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .circle(
            center: .init(x: 5, y: 10),
            radius: 7
        )
        let circle = Geometry<Double, Void>.Circle(ellipse)
        #expect(circle != nil)
        #expect(circle?.center.x == X(5))
        #expect(circle?.center.y == Y(10))
        #expect(circle?.radius == Distance(7))
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
        #expect(circle.diameter.width == Width(10))
    }

    @Test
    func `Circle circumference`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 1)
        #expect(isApprox(circle.circumference, Distance(2 * .pi)))
    }

    @Test
    func `Circle area using property`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 2)
        #expect(isApprox(circle.area, Area(4 * .pi)))
    }

    @Test
    func `Sphere surface area`() {
        let sphere: Geometry<Double, Void>.Sphere = .init(center: .zero, radius: 2)
        // Surface area = 4πr² = 4π(4) = 16π
        #expect(isApproxScalar(sphere.surfaceArea, 16 * .pi))
    }

    @Test
    func `Sphere volume`() {
        let sphere: Geometry<Double, Void>.Sphere = .init(center: .zero, radius: 3)
        // Volume = (4/3)πr³ = (4/3)π(27) = 36π
        #expect(isApproxScalar(sphere.volume, 36 * .pi))
    }
}

// MARK: - Static Function Tests

@Suite
struct `Geometry.Ball - Static Functions` {
    @Test
    func `Geometry.area(of:) for circle`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 3)
        let area = Geometry.area(of: circle)
        #expect(isApprox(area, Area(9 * .pi)))
    }

    @Test
    func `Geometry.boundingBox(of:) for circle`() {
        let circle: Geometry<Double, Void>.Circle = .init(
            center: .init(x: 10, y: 20),
            radius: 5
        )
        let bbox = Geometry.boundingBox(of: circle)
        #expect(bbox.llx == X(5))
        #expect(bbox.lly == Y(15))
        #expect(bbox.urx == X(15))
        #expect(bbox.ury == Y(25))
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
        #expect(isApprox(point.x, X(5)))
        #expect(isApprox(point.y, Y(0)))
    }

    @Test
    func `Point at angle π/2 (top)`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let point = circle.point(at: .halfPi)
        #expect(isApprox(point.x, X(0)))
        #expect(isApprox(point.y, Y(5)))
    }

    @Test
    func `Point at angle π (leftmost)`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let point = circle.point(at: .pi)
        #expect(isApprox(point.x, X(-5)))
        #expect(isApprox(point.y, Y(0)))
    }

    @Test
    func `Point with offset center`() {
        let circle: Geometry<Double, Void>.Circle = .init(
            center: .init(x: 10, y: 20),
            radius: 5
        )
        let point = circle.point(at: .zero)
        #expect(isApprox(point.x, X(15)))
        #expect(isApprox(point.y, Y(20)))
    }

    @Test
    func `Closest point to exterior point`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let exterior: Geometry<Double, Void>.Point<2> = .init(x: 10, y: 0)
        let closest = circle.closestPoint(to: exterior)
        #expect(isApprox(closest.x, X(5)))
        #expect(isApprox(closest.y, Y(0)))
    }

    @Test
    func `Closest point when query point is at center`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let closest = circle.closestPoint(to: circle.center)
        // Should return rightmost point when at center
        #expect(isApprox(closest.x, X(5)))
        #expect(isApprox(closest.y, Y(0)))
    }
}

// MARK: - Tangent Tests

@Suite
struct `Geometry.Ball - Tangent Vectors` {
    @Test
    func `Tangent at angle 0 points up`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let tangent = circle.tangent(at: .zero)
        #expect(isApprox(tangent.dx, Dx(0)))
        #expect(isApprox(tangent.dy, Dy(1)))
    }

    @Test
    func `Tangent at angle π/2 points left`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let tangent = circle.tangent(at: .halfPi)
        #expect(isApprox(tangent.dx, Dx(-1)))
        #expect(isApprox(tangent.dy, Dy(0)))
    }

    @Test
    func `Tangent is perpendicular to radius`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let angle: Radian = .init(Double.pi / 3)
        let point = circle.point(at: angle)
        let tangent = circle.tangent(at: angle)
        // Create a vector from center to point (which is the radius vector)
        let radiusVector: Geometry<Double, Void>.Vector<2> = .init(
            dx: point.x - circle.center.x,
            dy: point.y - circle.center.y
        )
        let dot = radiusVector.dot(tangent)
        #expect(isApproxScalar(dot, 0))
    }
}

// MARK: - Bounding Box Tests

@Suite
struct `Geometry.Ball - Bounding Box` {
    @Test
    func `Bounding box at origin`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let bbox = circle.boundingBox
        #expect(bbox.llx == X(-5))
        #expect(bbox.lly == Y(-5))
        #expect(bbox.urx == X(5))
        #expect(bbox.ury == Y(5))
    }

    @Test
    func `Bounding box with offset`() {
        let circle: Geometry<Double, Void>.Circle = .init(
            center: .init(x: 10, y: 20),
            radius: 5
        )
        let bbox = circle.boundingBox
        #expect(bbox.llx == X(5))
        #expect(bbox.lly == Y(15))
        #expect(bbox.urx == X(15))
        #expect(bbox.ury == Y(25))
    }
}

// MARK: - Transformation Tests

@Suite
struct `Geometry.Ball - Transformations` {
    @Test
    func `Translation preserves radius`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let translated = circle.translated(by: .init(dx: 10, dy: 20))
        #expect(translated.center.x == X(10))
        #expect(translated.center.y == Y(20))
        #expect(translated.radius == Distance(5))
    }

    @Test
    func `Uniform scaling about center`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let scaled = circle.scaled(by: 2)
        #expect(scaled.center.x == X(0))
        #expect(scaled.center.y == Y(0))
        #expect(scaled.radius == Distance(10))
    }

    @Test
    func `Scaling about arbitrary point`() {
        let circle: Geometry<Double, Void>.Circle = .init(
            center: .init(x: 10, y: 0),
            radius: 5
        )
        let scaled = circle.scaled(by: 2, about: .zero)
        #expect(scaled.center.x == X(20))
        #expect(scaled.center.y == Y(0))
        #expect(scaled.radius == Distance(10))
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
        let sorted = intersections.sorted { $0.x < $1.x }
        #expect(isApprox(sorted[0].x, X(-5)))
        #expect(isApprox(sorted[1].x, X(5)))
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
        #expect(isApprox(intersections[0].x, X(5)))
        #expect(isApprox(intersections[0].y, Y(0)))
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
        #expect(isApprox(intersections[0].x, X(5)))
        #expect(isApprox(intersections[0].y, Y(0)))
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
        #expect(isApprox(startPoint.x, X(5)))
        #expect(isApprox(startPoint.y, Y(0)))
    }

    @Test
    func `First bezier segment starts at rightmost point`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let curves = circle.bezierCurves
        let first = curves[0]
        #expect(isApprox(first.start.x, X(5)))
        #expect(isApprox(first.start.y, Y(0)))
    }
}

// MARK: - Functorial Map Tests

@Suite
struct `Geometry.Ball - Functorial Map` {
    @Test
    func `Map to different scalar type`() {
        let circle: Geometry<Double, Void>.Circle = .init(center: .zero, radius: 5)
        let mapped: Geometry<Float, Void>.Circle = circle.map { Float($0) }
        let expectedX: Geometry<Float, Void>.X = 0
        let expectedY: Geometry<Float, Void>.Y = 0
        let expectedRadius: Linear<Float, Void>.Magnitude = 5
        #expect(mapped.center.x == expectedX)
        #expect(mapped.center.y == expectedY)
        #expect(mapped.radius == expectedRadius)
    }
}
