// Geometry.Ngon Tests.swift
// Tests for Geometry.Ngon type (N-sided polygon with compile-time vertex count).

import Dimension
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

private func isApprox(_ a: Distance, _ b: Distance, tol: Double = 1e-10) -> Bool {
    let diff = a - b
    let tolerance = Distance(tol)
    return diff > -tolerance && diff < tolerance
}

private func isApproxScalar(_ a: Double, _ b: Double, tol: Double = 1e-10) -> Bool {
    return abs(a - b) < tol
}

private func isApprox(_ a: Area, _ b: Area, tol: Double = 1e-10) -> Bool {
    return abs(a.rawValue - b.rawValue) < tol
}

private func isApprox(_ a: Radian<Double>, _ b: Radian<Double>, tol: Double = 1e-10) -> Bool {
    let diff = a - b
    return diff > Radian(-tol) && diff < Radian(tol)
}

// MARK: - Triangle (Ngon<3>) Initialization Tests

@Suite
struct `Geometry.Ngon<3> - Initialization` {
    @Test
    func `Triangle initialization with named vertices`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 2, y: 3)
        )
        #expect(triangle.a.x == 0)
        #expect(triangle.a.y == 0)
        #expect(triangle.b.x == 4)
        #expect(triangle.b.y == 0)
        #expect(triangle.c.x == 2)
        #expect(triangle.c.y == 3)
    }

    @Test
    func `Triangle from vertices array`() {
        let vertices: [Geometry<Double, Void>.Point<2>] = [
            .init(x: 0, y: 0),
            .init(x: 3, y: 0),
            .init(x: 0, y: 4),
        ]
        let triangle = Geometry<Double, Void>.Triangle(vertices: vertices)
        #expect(triangle != nil)
        #expect(triangle!.a.x == 0)
        #expect(triangle!.b.x == 3)
        #expect(triangle!.c.y == 4)
    }

    @Test
    func `Triangle from wrong size array returns nil`() {
        let twoVertices: [Geometry<Double, Void>.Point<2>] = [
            .init(x: 0, y: 0),
            .init(x: 3, y: 0),
        ]
        let triangle = Geometry<Double, Void>.Triangle(vertices: twoVertices)
        #expect(triangle == nil)
    }
}

// MARK: - Triangle Factory Methods Tests

@Suite
struct `Geometry.Ngon<3> - Factory Methods` {
    @Test
    func `Right triangle factory`() {
        let triangle: Geometry<Double, Void>.Triangle = .right(base: 3, height: 4)
        #expect(triangle.a.x == 0)
        #expect(triangle.a.y == 0)
        #expect(triangle.b.x == 3)
        #expect(triangle.b.y == 0)
        #expect(triangle.c.x == 0)
        #expect(triangle.c.y == 4)
        let expectedArea: Area = 6
        #expect(isApprox(triangle.area, expectedArea))
    }

    @Test
    func `Right triangle at custom origin`() {
        let origin: Geometry<Double, Void>.Point<2> = .init(x: 5, y: 10)
        let triangle: Geometry<Double, Void>.Triangle = .right(base: 3, height: 4, at: origin)
        #expect(triangle.a.x == 5)
        #expect(triangle.a.y == 10)
        #expect(triangle.b.x == 8)
        #expect(triangle.b.y == 10)
    }

    @Test
    func `Equilateral triangle factory`() {
        let triangle: Geometry<Double, Void>.Triangle = .equilateral(sideLength: 6)
        let sides = triangle.sideLengths
        #expect(abs(sides.ab - 6) < 1e-10)
        #expect(abs(sides.bc - 6) < 1e-10)
        #expect(abs(sides.ca - 6) < 1e-10)
    }

    @Test
    func `Equilateral triangle at custom origin`() {
        let origin: Geometry<Double, Void>.Point<2> = .init(x: 10, y: 20)
        let triangle: Geometry<Double, Void>.Triangle = .equilateral(sideLength: 4, at: origin)
        #expect(triangle.a.x == 10)
        #expect(triangle.a.y == 20)
    }

    @Test
    func `Isosceles triangle factory`() {
        let triangle = Geometry<Double, Void>.Triangle.isosceles(base: 6, leg: 5)
        #expect(triangle != nil)
        let sides = triangle!.sideLengths
        #expect(abs(sides.ab - 6) < 1e-10)
        #expect(abs(sides.bc - 5) < 1e-10)
        #expect(abs(sides.ca - 5) < 1e-10)
    }

    @Test
    func `Isosceles triangle impossible returns nil`() {
        let triangle = Geometry<Double, Void>.Triangle.isosceles(base: 10, leg: 2)
        #expect(triangle == nil)
    }
}

// MARK: - Triangle Properties Tests

@Suite
struct `Geometry.Ngon<3> - Properties` {
    @Test
    func `Vertices array`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 1, y: 0),
            c: .init(x: 0, y: 1)
        )
        let vertices = triangle.vertexArray
        #expect(vertices.count == 3)
        #expect(vertices[0] == triangle.a)
        #expect(vertices[1] == triangle.b)
        #expect(vertices[2] == triangle.c)
    }

    @Test
    func `Edges tuple`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 0, y: 3)
        )
        let edges = triangle.edges
        #expect(edges.ab.start == triangle.a)
        #expect(edges.ab.end == triangle.b)
        #expect(edges.bc.start == triangle.b)
        #expect(edges.bc.end == triangle.c)
        #expect(edges.ca.start == triangle.c)
        #expect(edges.ca.end == triangle.a)
    }

    @Test
    func `Side lengths`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 3, y: 0),
            c: .init(x: 0, y: 4)
        )
        let sides = triangle.sideLengths
        #expect(abs(sides.ab - 3) < 1e-10)
        #expect(abs(sides.ca - 4) < 1e-10)
        #expect(abs(sides.bc - 5) < 1e-10)
    }
}

// MARK: - Triangle Static Functions Tests

@Suite
struct `Geometry.Ngon<3> - Static Functions` {
    @Test
    func `Geometry.area(of:) for right triangle`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 0, y: 3)
        )
        let area = Geometry.area(of: triangle)
        let expectedArea: Area = 6
        #expect(isApprox(area, expectedArea))
    }

    @Test
    func `Geometry.signedDoubleArea(of:) CCW positive`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 0, y: 3)
        )
        let signedArea = Geometry.signedDoubleArea(of: triangle)
        #expect(signedArea > 0)
    }

    @Test
    func `Geometry.signedDoubleArea(of:) CW negative`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 0, y: 3),
            c: .init(x: 4, y: 0)
        )
        let signedArea = Geometry.signedDoubleArea(of: triangle)
        #expect(signedArea < 0)
    }

    @Test
    func `Geometry.perimeter(of:) 3-4-5 triangle`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 3, y: 0),
            c: .init(x: 0, y: 4)
        )
        let perimeter = Geometry.perimeter(of: triangle)
        #expect(isApprox(perimeter, Distance(12)))
    }

    @Test
    func `Geometry.centroid(of:) triangle`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 6, y: 0),
            c: .init(x: 0, y: 6)
        )
        let centroid = Geometry.centroid(of: triangle)
        #expect(centroid != nil)
        #expect(isApprox(centroid!.x, X(2)))
        #expect(isApprox(centroid!.y, Y(2)))
    }
}

// MARK: - Triangle Area and Perimeter Tests

@Suite
struct `Geometry.Ngon<3> - Area and Perimeter` {
    @Test
    func `Area property matches static function`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 0, y: 3)
        )
        let expectedArea: Area = 6
        #expect(isApprox(triangle.area, expectedArea))
    }

    @Test
    func `Signed area CCW`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 0, y: 3)
        )
        #expect(triangle.signedArea > 0)
    }

    @Test
    func `Signed area CW`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 0, y: 3),
            c: .init(x: 4, y: 0)
        )
        #expect(triangle.signedArea < 0)
    }

    @Test
    func `Perimeter of 3-4-5 triangle`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 3, y: 0),
            c: .init(x: 0, y: 4)
        )
        #expect(isApprox(triangle.perimeter, Distance(12)))
    }
}

// MARK: - Triangle Centroid Tests

@Suite
struct `Geometry.Ngon<3> - Centroid` {
    @Test
    func `Centroid property`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 6, y: 0),
            c: .init(x: 0, y: 6)
        )
        let centroid: Geometry<Double, Void>.Point<2> = triangle.centroid
        #expect(isApprox(centroid.x, X(2)))
        #expect(isApprox(centroid.y, Y(2)))
    }
}

// MARK: - Triangle Circles Tests

@Suite
struct `Geometry.Ngon<3> - Circles` {
    @Test
    func `Circumcircle of right triangle`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 0, y: 3)
        )
        let circumcircle = triangle.circumcircle
        #expect(circumcircle != nil)
        #expect(isApprox(circumcircle!.center.x, X(2)))
        #expect(isApprox(circumcircle!.center.y, Y(1.5)))
        #expect(isApprox(circumcircle!.radius, Distance(2.5)))
    }

    @Test
    func `Circumcircle passes through all vertices`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 5, y: 0),
            c: .init(x: 2, y: 4)
        )
        let circumcircle = triangle.circumcircle!
        let r = circumcircle.radius

        let da = circumcircle.center.distance(to: triangle.a)
        let db = circumcircle.center.distance(to: triangle.b)
        let dc = circumcircle.center.distance(to: triangle.c)

        #expect(isApprox(da, r))
        #expect(isApprox(db, r))
        #expect(isApprox(dc, r))
    }

    @Test
    func `Incircle of 3-4-5 triangle`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 3, y: 0),
            c: .init(x: 0, y: 4)
        )
        let incircle = triangle.incircle
        #expect(incircle != nil)
        #expect(isApprox(incircle!.radius, Distance(1)))
    }

    @Test
    func `Orthocenter`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 2, y: 3)
        )
        let ortho = triangle.orthocenter
        #expect(ortho != nil)
    }
}

// MARK: - Triangle Angles Tests

@Suite
struct `Geometry.Ngon<3> - Angles` {
    @Test
    func `Angles of triangle sum to π`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 5, y: 0),
            c: .init(x: 2, y: 4)
        )
        let angles = triangle.angles
        let sum = angles.atA + angles.atB + angles.atC
        #expect(isApprox(sum, .pi))
    }
}

// MARK: - Triangle Containment Tests

@Suite
struct `Geometry.Ngon<3> - Containment` {
    @Test
    func `Contains centroid`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 2, y: 3)
        )
        #expect(triangle.contains(triangle.centroid))
    }

    @Test
    func `Contains vertex`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 2, y: 3)
        )
        #expect(triangle.contains(triangle.a))
    }

    @Test
    func `Does not contain exterior point`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 2, y: 3)
        )
        let point: Geometry<Double, Void>.Point<2> = .init(x: 10, y: 10)
        #expect(!triangle.contains(point))
    }

    @Test
    func `Contains using barycentric`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 2, y: 3)
        )
        #expect(triangle.containsBarycentric(triangle.centroid))
    }
}

// MARK: - Triangle Barycentric Tests

@Suite
struct `Geometry.Ngon<3> - Barycentric Coordinates` {
    @Test
    func `Barycentric of vertex A`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 0, y: 3)
        )
        let bary = triangle.barycentric(triangle.a)
        #expect(bary != nil)
        #expect(abs(bary!.u - 1) < 1e-10)
        #expect(abs(bary!.v) < 1e-10)
        #expect(abs(bary!.w) < 1e-10)
    }

    @Test
    func `Barycentric of centroid`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 3, y: 0),
            c: .init(x: 0, y: 3)
        )
        let bary = triangle.barycentric(triangle.centroid)
        #expect(bary != nil)
        #expect(abs(bary!.u - 1.0 / 3.0) < 1e-10)
        #expect(abs(bary!.v - 1.0 / 3.0) < 1e-10)
        #expect(abs(bary!.w - 1.0 / 3.0) < 1e-10)
    }

    @Test
    func `Barycentric sum is 1`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 5, y: 0),
            c: .init(x: 2, y: 4)
        )
        let point: Geometry<Double, Void>.Point<2> = .init(x: 2, y: 1)
        let bary = triangle.barycentric(point)!
        #expect(abs(bary.u + bary.v + bary.w - 1) < 1e-10)
    }

    @Test
    func `Point from barycentric vertex`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 0, y: 3)
        )
        let point = triangle.point(u: 1, v: 0, w: 0)
        #expect(isApprox(point.x, triangle.a.x))
        #expect(isApprox(point.y, triangle.a.y))
    }

    @Test
    func `Point from barycentric centroid`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 6, y: 0),
            c: .init(x: 0, y: 6)
        )
        let point = triangle.point(u: 1.0 / 3.0, v: 1.0 / 3.0, w: 1.0 / 3.0)
        #expect(isApprox(point.x, X(2)))
        #expect(isApprox(point.y, Y(2)))
    }
}

// MARK: - Triangle Bounding Box Tests

@Suite
struct `Geometry.Ngon<3> - Bounding Box` {
    @Test
    func `Bounding box`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 1, y: 2),
            b: .init(x: 5, y: 3),
            c: .init(x: 3, y: 7)
        )
        let bbox = triangle.boundingBox
        #expect(bbox.llx == 1)
        #expect(bbox.lly == 2)
        #expect(bbox.urx == 5)
        #expect(bbox.ury == 7)
    }
}

// MARK: - Triangle Transformation Tests

@Suite
struct `Geometry.Ngon<3> - Transformations` {
    @Test
    func `Translation`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 1, y: 0),
            c: .init(x: 0, y: 1)
        )
        let translated = triangle.translated(by: .init(dx: 5, dy: 10))
        #expect(translated.a.x == 5)
        #expect(translated.a.y == 10)
        #expect(translated.b.x == 6)
        #expect(translated.b.y == 10)
    }

    @Test
    func `Scaling about point`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 2, y: 0),
            c: .init(x: 0, y: 2)
        )
        let scaled = triangle.scaled(by: 2, about: triangle.a)
        #expect(scaled.a.x == 0)
        #expect(scaled.a.y == 0)
        #expect(scaled.b.x == 4)
        #expect(scaled.c.y == 4)
    }

    @Test
    func `Scaling about centroid`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 2, y: 0),
            c: .init(x: 0, y: 2)
        )
        let scaled = triangle.scaled(by: 2)
        #expect(abs(scaled.area - 4 * triangle.area) < 1e-10)
    }
}

// MARK: - Quadrilateral (Ngon<4>) Tests

@Suite
struct `Geometry.Ngon<4> - Quadrilateral` {
    @Test
    func `Quadrilateral initialization`() {
        let quad: Geometry<Double, Void>.Quadrilateral = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 4, y: 3),
            d: .init(x: 0, y: 3)
        )
        #expect(quad.a.x == 0)
        #expect(quad.b.x == 4)
        #expect(quad.c.y == 3)
        #expect(quad.d.y == 3)
    }

    @Test
    func `Quadrilateral diagonals`() {
        let quad: Geometry<Double, Void>.Quadrilateral = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 4, y: 3),
            d: .init(x: 0, y: 3)
        )
        let diags = quad.diagonals
        #expect(diags.ac.start == quad.a)
        #expect(diags.ac.end == quad.c)
        #expect(diags.bd.start == quad.b)
        #expect(diags.bd.end == quad.d)
    }

    @Test
    func `Quadrilateral triangulation`() {
        let quad: Geometry<Double, Void>.Quadrilateral = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 4, y: 3),
            d: .init(x: 0, y: 3)
        )
        let triangles = quad.triangles
        #expect(triangles.0.a == quad.a)
        #expect(triangles.0.b == quad.b)
        #expect(triangles.0.c == quad.c)
        #expect(triangles.1.a == quad.a)
        #expect(triangles.1.b == quad.c)
        #expect(triangles.1.c == quad.d)
    }

    @Test
    func `Rectangle area as quadrilateral`() {
        let quad: Geometry<Double, Void>.Quadrilateral = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 4, y: 3),
            d: .init(x: 0, y: 3)
        )
        #expect(abs(quad.area.rawValue - 12) < 1e-10)
    }
}

// MARK: - Regular Polygon Tests

@Suite
struct `Geometry.Ngon - Regular Polygons` {
    @Test
    func `Regular hexagon from side length`() {
        let hexagon = Geometry<Double, Void>.Hexagon.regular(sideLength: 10)
        let perimeter = Geometry.perimeter(of: hexagon)
        #expect(isApprox(perimeter, Distance(60)))
    }

    @Test
    func `Regular pentagon from circumradius`() {
        let pentagon = Geometry<Double, Void>.Pentagon.regular(circumradius: 10)
        let vertices = pentagon.vertexArray
        for v in vertices {
            let dist = v.distance(to: .zero)
            #expect(abs(dist - 10) < 1e-10)
        }
    }

    @Test
    func `Regular triangle is equilateral`() {
        let triangle = Geometry<Double, Void>.Triangle.regular(sideLength: 6)
        let sides = triangle.sideLengths
        #expect(abs(sides.ab - 6) < 1e-9)
        #expect(abs(sides.bc - 6) < 1e-9)
        #expect(abs(sides.ca - 6) < 1e-9)
    }
}

// MARK: - Ngon Convexity Tests

@Suite
struct `Geometry.Ngon - Convexity` {
    @Test
    func `Square is convex`() {
        let square: Geometry<Double, Void>.Quadrilateral = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 1, y: 0),
            c: .init(x: 1, y: 1),
            d: .init(x: 0, y: 1)
        )
        #expect(square.isConvex)
    }

    @Test
    func `Triangle is always convex`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 5, y: 0),
            c: .init(x: 2, y: 4)
        )
        #expect(triangle.isConvex)
    }
}

// MARK: - Ngon Winding Tests

@Suite
struct `Geometry.Ngon - Winding` {
    @Test
    func `Counter-clockwise winding`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 1, y: 0),
            c: .init(x: 0, y: 1)
        )
        #expect(triangle.isCounterClockwise)
        #expect(!triangle.isClockwise)
    }

    @Test
    func `Clockwise winding`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 0, y: 1),
            c: .init(x: 1, y: 0)
        )
        #expect(triangle.isClockwise)
        #expect(!triangle.isCounterClockwise)
    }

    @Test
    func `Reversed polygon`() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 1, y: 0),
            c: .init(x: 0, y: 1)
        )
        let reversed = triangle.reversed
        #expect(triangle.isCounterClockwise != reversed.isCounterClockwise)
    }
}

// MARK: - Functorial Map Tests

@Suite
struct `Geometry.Ngon - Functorial Map` {
    @Test
    func `Triangle map to different scalar type`() throws {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 1, y: 0),
            c: .init(x: 0, y: 1)
        )
        let mapped: Geometry<Float, Void>.Triangle = try triangle.map { Float($0) }
        let expectedAX: Geometry<Float, Void>.X = 0
        let expectedBX: Geometry<Float, Void>.X = 1
        let expectedCY: Geometry<Float, Void>.Y = 1
        #expect(mapped.a.x == expectedAX)
        #expect(mapped.b.x == expectedBX)
        #expect(mapped.c.y == expectedCY)
    }
}
