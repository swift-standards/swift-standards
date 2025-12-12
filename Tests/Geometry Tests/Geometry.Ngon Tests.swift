// Geometry.Ngon Tests.swift
// Tests for Geometry.Ngon type (N-sided polygon with compile-time vertex count).

import Angle
import Testing

@testable import Affine
@testable import Algebra
@testable import Algebra_Linear
@testable import Geometry

// MARK: - Triangle (Ngon<3>) Initialization Tests

@Suite("Geometry.Ngon<3> - Initialization")
struct GeometryTriangle_InitializationTests {
    @Test("Triangle initialization with named vertices")
    func triangleInit() {
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

    @Test("Triangle from vertices array")
    func triangleFromArray() {
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

    @Test("Triangle from wrong size array returns nil")
    func triangleFromWrongSizeArray() {
        let twoVertices: [Geometry<Double, Void>.Point<2>] = [
            .init(x: 0, y: 0),
            .init(x: 3, y: 0),
        ]
        let triangle = Geometry<Double, Void>.Triangle(vertices: twoVertices)
        #expect(triangle == nil)
    }
}

// MARK: - Triangle Factory Methods Tests

@Suite("Geometry.Ngon<3> - Factory Methods")
struct GeometryTriangle_FactoryTests {
    @Test("Right triangle factory")
    func rightTriangle() {
        let triangle: Geometry<Double, Void>.Triangle = .right(base: 3, height: 4)
        #expect(triangle.a.x == 0)
        #expect(triangle.a.y == 0)
        #expect(triangle.b.x == 3)
        #expect(triangle.b.y == 0)
        #expect(triangle.c.x == 0)
        #expect(triangle.c.y == 4)
        #expect(abs(triangle.area - 6) < 1e-10)
    }

    @Test("Right triangle at custom origin")
    func rightTriangleAtOrigin() {
        let origin: Geometry<Double, Void>.Point<2> = .init(x: 5, y: 10)
        let triangle: Geometry<Double, Void>.Triangle = .right(base: 3, height: 4, at: origin)
        #expect(triangle.a.x == 5)
        #expect(triangle.a.y == 10)
        #expect(triangle.b.x == 8)
        #expect(triangle.b.y == 10)
    }

    @Test("Equilateral triangle factory")
    func equilateralTriangle() {
        let triangle: Geometry<Double, Void>.Triangle = .equilateral(sideLength: 6)
        let sides = triangle.sideLengths
        #expect(abs(sides.ab - 6) < 1e-10)
        #expect(abs(sides.bc - 6) < 1e-10)
        #expect(abs(sides.ca - 6) < 1e-10)
    }

    @Test("Equilateral triangle at custom origin")
    func equilateralTriangleAtOrigin() {
        let origin: Geometry<Double, Void>.Point<2> = .init(x: 10, y: 20)
        let triangle: Geometry<Double, Void>.Triangle = .equilateral(sideLength: 4, at: origin)
        #expect(triangle.a.x == 10)
        #expect(triangle.a.y == 20)
    }

    @Test("Isosceles triangle factory")
    func isoscelesTriangle() {
        let triangle = Geometry<Double, Void>.Triangle.isosceles(base: 6, leg: 5)
        #expect(triangle != nil)
        let sides = triangle!.sideLengths
        #expect(abs(sides.ab - 6) < 1e-10)
        #expect(abs(sides.bc - 5) < 1e-10)
        #expect(abs(sides.ca - 5) < 1e-10)
    }

    @Test("Isosceles triangle impossible returns nil")
    func isoscelesTriangleImpossible() {
        let triangle = Geometry<Double, Void>.Triangle.isosceles(base: 10, leg: 2)
        #expect(triangle == nil)
    }
}

// MARK: - Triangle Properties Tests

@Suite("Geometry.Ngon<3> - Properties")
struct GeometryTriangle_PropertiesTests {
    @Test("Vertices array")
    func verticesArray() {
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

    @Test("Edges tuple")
    func edgesTuple() {
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

    @Test("Side lengths")
    func sideLengths() {
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

@Suite("Geometry.Ngon<3> - Static Functions")
struct GeometryTriangle_StaticTests {
    @Test("Geometry.area(of:) for right triangle")
    func staticAreaRightTriangle() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 0, y: 3)
        )
        let area = Geometry.area(of: triangle)
        #expect(abs(area - 6) < 1e-10)
    }

    @Test("Geometry.signedDoubleArea(of:) CCW positive")
    func staticSignedDoubleAreaCCW() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 0, y: 3)
        )
        let signedArea = Geometry.signedDoubleArea(of: triangle)
        #expect(signedArea > 0)
    }

    @Test("Geometry.signedDoubleArea(of:) CW negative")
    func staticSignedDoubleAreaCW() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 0, y: 3),
            c: .init(x: 4, y: 0)
        )
        let signedArea = Geometry.signedDoubleArea(of: triangle)
        #expect(signedArea < 0)
    }

    @Test("Geometry.perimeter(of:) 3-4-5 triangle")
    func staticPerimeter() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 3, y: 0),
            c: .init(x: 0, y: 4)
        )
        let perimeter = Geometry.perimeter(of: triangle)
        #expect(abs(perimeter.value - 12) < 1e-10)
    }

    @Test("Geometry.centroid(of:) triangle")
    func staticCentroid() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 6, y: 0),
            c: .init(x: 0, y: 6)
        )
        let centroid = Geometry.centroid(of: triangle)
        #expect(centroid != nil)
        #expect(abs(centroid!.x.value - 2) < 1e-10)
        #expect(abs(centroid!.y.value - 2) < 1e-10)
    }
}

// MARK: - Triangle Area and Perimeter Tests

@Suite("Geometry.Ngon<3> - Area and Perimeter")
struct GeometryTriangle_AreaTests {
    @Test("Area property matches static function")
    func areaProperty() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 0, y: 3)
        )
        #expect(abs(triangle.area - 6) < 1e-10)
    }

    @Test("Signed area CCW")
    func signedAreaCCW() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 0, y: 3)
        )
        #expect(triangle.signedArea > 0)
    }

    @Test("Signed area CW")
    func signedAreaCW() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 0, y: 3),
            c: .init(x: 4, y: 0)
        )
        #expect(triangle.signedArea < 0)
    }

    @Test("Perimeter of 3-4-5 triangle")
    func perimeter() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 3, y: 0),
            c: .init(x: 0, y: 4)
        )
        #expect(abs(triangle.perimeter.value - 12) < 1e-10)
    }
}

// MARK: - Triangle Centroid Tests

@Suite("Geometry.Ngon<3> - Centroid")
struct GeometryTriangle_CentroidTests {
    @Test("Centroid property")
    func centroidProperty() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 6, y: 0),
            c: .init(x: 0, y: 6)
        )
        let centroid: Geometry<Double, Void>.Point<2> = triangle.centroid
        #expect(abs(centroid.x.value - 2) < 1e-10)
        #expect(abs(centroid.y.value - 2) < 1e-10)
    }
}

// MARK: - Triangle Circles Tests

@Suite("Geometry.Ngon<3> - Circles")
struct GeometryTriangle_CirclesTests {
    @Test("Circumcircle of right triangle")
    func circumcircleRightTriangle() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 0, y: 3)
        )
        let circumcircle = triangle.circumcircle
        #expect(circumcircle != nil)
        #expect(abs(circumcircle!.center.x.value - 2) < 1e-10)
        #expect(abs(circumcircle!.center.y.value - 1.5) < 1e-10)
        #expect(abs(circumcircle!.radius.value - 2.5) < 1e-10)
    }

    @Test("Circumcircle passes through all vertices")
    func circumcircleThroughVertices() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 5, y: 0),
            c: .init(x: 2, y: 4)
        )
        let circumcircle = triangle.circumcircle!
        let r = circumcircle.radius.value

        let da = circumcircle.center.distance(to: triangle.a)
        let db = circumcircle.center.distance(to: triangle.b)
        let dc = circumcircle.center.distance(to: triangle.c)

        #expect(abs(da - r) < 1e-10)
        #expect(abs(db - r) < 1e-10)
        #expect(abs(dc - r) < 1e-10)
    }

    @Test("Incircle of 3-4-5 triangle")
    func incircle345Triangle() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 3, y: 0),
            c: .init(x: 0, y: 4)
        )
        let incircle = triangle.incircle
        #expect(incircle != nil)
        #expect(abs(incircle!.radius.value - 1) < 1e-10)
    }

    @Test("Orthocenter")
    func orthocenter() {
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

@Suite("Geometry.Ngon<3> - Angles")
struct GeometryTriangle_AnglesTests {
    @Test("Angles of triangle sum to π")
    func anglesSumToPi() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 5, y: 0),
            c: .init(x: 2, y: 4)
        )
        let angles = triangle.angles
        let sum = angles.atA.value + angles.atB.value + angles.atC.value
        #expect(abs(sum - Double.pi) < 1e-10)
    }
}

// MARK: - Triangle Containment Tests

@Suite("Geometry.Ngon<3> - Containment")
struct GeometryTriangle_ContainmentTests {
    @Test("Contains centroid")
    func containsCentroid() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 2, y: 3)
        )
        #expect(triangle.contains(triangle.centroid))
    }

    @Test("Contains vertex")
    func containsVertex() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 2, y: 3)
        )
        #expect(triangle.contains(triangle.a))
    }

    @Test("Does not contain exterior point")
    func doesNotContainExterior() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 2, y: 3)
        )
        let point: Geometry<Double, Void>.Point<2> = .init(x: 10, y: 10)
        #expect(!triangle.contains(point))
    }

    @Test("Contains using barycentric")
    func containsBarycentric() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 2, y: 3)
        )
        #expect(triangle.containsBarycentric(triangle.centroid))
    }
}

// MARK: - Triangle Barycentric Tests

@Suite("Geometry.Ngon<3> - Barycentric Coordinates")
struct GeometryTriangle_BarycentricTests {
    @Test("Barycentric of vertex A")
    func barycentricVertexA() {
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

    @Test("Barycentric of centroid")
    func barycentricCentroid() {
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

    @Test("Barycentric sum is 1")
    func barycentricSumIsOne() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 5, y: 0),
            c: .init(x: 2, y: 4)
        )
        let point: Geometry<Double, Void>.Point<2> = .init(x: 2, y: 1)
        let bary = triangle.barycentric(point)!
        #expect(abs(bary.u + bary.v + bary.w - 1) < 1e-10)
    }

    @Test("Point from barycentric vertex")
    func pointFromBarycentricVertex() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 0, y: 3)
        )
        let point = triangle.point(u: 1, v: 0, w: 0)
        #expect(abs(point.x.value - triangle.a.x.value) < 1e-10)
        #expect(abs(point.y.value - triangle.a.y.value) < 1e-10)
    }

    @Test("Point from barycentric centroid")
    func pointFromBarycentricCentroid() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 6, y: 0),
            c: .init(x: 0, y: 6)
        )
        let point = triangle.point(u: 1.0 / 3.0, v: 1.0 / 3.0, w: 1.0 / 3.0)
        #expect(abs(point.x.value - 2) < 1e-10)
        #expect(abs(point.y.value - 2) < 1e-10)
    }
}

// MARK: - Triangle Bounding Box Tests

@Suite("Geometry.Ngon<3> - Bounding Box")
struct GeometryTriangle_BoundingBoxTests {
    @Test("Bounding box")
    func boundingBox() {
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

@Suite("Geometry.Ngon<3> - Transformations")
struct GeometryTriangle_TransformationTests {
    @Test("Translation")
    func translation() {
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

    @Test("Scaling about point")
    func scalingAboutPoint() {
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

    @Test("Scaling about centroid")
    func scalingAboutCentroid() {
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

@Suite("Geometry.Ngon<4> - Quadrilateral")
struct GeometryQuadrilateral_Tests {
    @Test("Quadrilateral initialization")
    func quadInit() {
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

    @Test("Quadrilateral diagonals")
    func diagonals() {
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

    @Test("Quadrilateral triangulation")
    func triangulation() {
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

    @Test("Rectangle area as quadrilateral")
    func rectangleArea() {
        let quad: Geometry<Double, Void>.Quadrilateral = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 4, y: 3),
            d: .init(x: 0, y: 3)
        )
        #expect(abs(quad.area - 12) < 1e-10)
    }
}

// MARK: - Regular Polygon Tests

@Suite("Geometry.Ngon - Regular Polygons")
struct GeometryNgon_RegularTests {
    @Test("Regular hexagon from side length")
    func regularHexagonSideLength() {
        let hexagon = Geometry<Double, Void>.Hexagon.regular(sideLength: 10)
        let perimeter = Geometry.perimeter(of: hexagon)
        #expect(abs(perimeter.value - 60) < 1e-10)
    }

    @Test("Regular pentagon from circumradius")
    func regularPentagonCircumradius() {
        let pentagon = Geometry<Double, Void>.Pentagon.regular(circumradius: 10)
        let vertices = pentagon.vertexArray
        for v in vertices {
            let dist = v.distance(to: .zero)
            #expect(abs(dist - 10) < 1e-10)
        }
    }

    @Test("Regular triangle is equilateral")
    func regularTriangle() {
        let triangle = Geometry<Double, Void>.Triangle.regular(sideLength: 6)
        let sides = triangle.sideLengths
        #expect(abs(sides.ab - 6) < 1e-9)
        #expect(abs(sides.bc - 6) < 1e-9)
        #expect(abs(sides.ca - 6) < 1e-9)
    }
}

// MARK: - Ngon Convexity Tests

@Suite("Geometry.Ngon - Convexity")
struct GeometryNgon_ConvexityTests {
    @Test("Square is convex")
    func squareIsConvex() {
        let square: Geometry<Double, Void>.Quadrilateral = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 1, y: 0),
            c: .init(x: 1, y: 1),
            d: .init(x: 0, y: 1)
        )
        #expect(square.isConvex)
    }

    @Test("Triangle is always convex")
    func triangleIsConvex() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 5, y: 0),
            c: .init(x: 2, y: 4)
        )
        #expect(triangle.isConvex)
    }
}

// MARK: - Ngon Winding Tests

@Suite("Geometry.Ngon - Winding")
struct GeometryNgon_WindingTests {
    @Test("Counter-clockwise winding")
    func counterClockwise() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 1, y: 0),
            c: .init(x: 0, y: 1)
        )
        #expect(triangle.isCounterClockwise)
        #expect(!triangle.isClockwise)
    }

    @Test("Clockwise winding")
    func clockwise() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 0, y: 1),
            c: .init(x: 1, y: 0)
        )
        #expect(triangle.isClockwise)
        #expect(!triangle.isCounterClockwise)
    }

    @Test("Reversed polygon")
    func reversedPolygon() {
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

@Suite("Geometry.Ngon - Functorial Map")
struct GeometryNgon_MapTests {
    @Test("Triangle map to different scalar type")
    func triangleMap() {
        let triangle: Geometry<Double, Void>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 1, y: 0),
            c: .init(x: 0, y: 1)
        )
        let mapped: Geometry<Float, Void>.Triangle = try! triangle.map { Float($0) }
        #expect(mapped.a.x.value == 0)
        #expect(mapped.b.x.value == 1)
        #expect(mapped.c.y.value == 1)
    }
}
