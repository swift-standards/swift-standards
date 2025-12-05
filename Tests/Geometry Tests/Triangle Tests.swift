// Triangle Tests.swift
// Tests for Geometry.Triangle type.

import Testing
@testable import Geometry

@Suite("Triangle Tests")
struct TriangleTests {

    // MARK: - Initialization

    @Test("Triangle initialization")
    func initialization() {
        let triangle: Geometry<Double>.Triangle = .init(
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

    @Test("Triangle init from vertices array")
    func initFromVertices() {
        let vertices: [Geometry<Double>.Point<2>] = [
            .init(x: 0, y: 0),
            .init(x: 3, y: 0),
            .init(x: 0, y: 4)
        ]
        let triangle = Geometry<Double>.Triangle(vertices: vertices)
        #expect(triangle != nil)
        #expect(triangle!.a.x == 0)
        #expect(triangle!.b.x == 3)
        #expect(triangle!.c.y == 4)
    }

    @Test("Triangle init from wrong size array is nil")
    func initFromWrongSizeArray() {
        let twoVertices: [Geometry<Double>.Point<2>] = [
            .init(x: 0, y: 0),
            .init(x: 3, y: 0)
        ]
        let triangle = Geometry<Double>.Triangle(vertices: twoVertices)
        #expect(triangle == nil)
    }

    // MARK: - Factory Methods

    @Test("Right triangle factory")
    func rightTriangle() {
        let triangle: Geometry<Double>.Triangle = .right(base: 3, height: 4)
        #expect(triangle.a.x == 0)
        #expect(triangle.a.y == 0)
        #expect(triangle.b.x == 3)
        #expect(triangle.b.y == 0)
        #expect(triangle.c.x == 0)
        #expect(triangle.c.y == 4)
        // Area = 0.5 * base * height = 6
        #expect(abs(triangle.area - 6) < 1e-10)
    }

    @Test("Right triangle at origin")
    func rightTriangleAtOrigin() {
        let origin: Geometry<Double>.Point<2> = .init(x: 5, y: 10)
        let triangle: Geometry<Double>.Triangle = .right(base: 3, height: 4, at: origin)
        #expect(triangle.a.x == 5)
        #expect(triangle.a.y == 10)
        #expect(triangle.b.x == 8)
        #expect(triangle.b.y == 10)
    }

    @Test("Equilateral triangle factory")
    func equilateralTriangle() {
        let triangle: Geometry<Double>.Triangle = .equilateral(sideLength: 6)
        // All sides should be equal to 6
        let sides = triangle.sideLengths
        #expect(abs(sides.ab - 6) < 1e-10)
        #expect(abs(sides.bc - 6) < 1e-10)
        #expect(abs(sides.ca - 6) < 1e-10)
    }

    @Test("Equilateral triangle at origin")
    func equilateralTriangleAtOrigin() {
        let origin: Geometry<Double>.Point<2> = .init(x: 10, y: 20)
        let triangle: Geometry<Double>.Triangle = .equilateral(sideLength: 4, at: origin)
        #expect(triangle.a.x == 10)
        #expect(triangle.a.y == 20)
    }

    @Test("Isosceles triangle factory")
    func isoscelesTriangle() {
        let triangle = Geometry<Double>.Triangle.isosceles(base: 6, leg: 5)
        #expect(triangle != nil)
        // Base should be 6
        let sides = triangle!.sideLengths
        #expect(abs(sides.ab - 6) < 1e-10)
        // Two legs should be equal to 5
        #expect(abs(sides.bc - 5) < 1e-10)
        #expect(abs(sides.ca - 5) < 1e-10)
    }

    @Test("Isosceles triangle impossible returns nil")
    func isoscelesTriangleImpossible() {
        // Leg too short to reach apex
        let triangle = Geometry<Double>.Triangle.isosceles(base: 10, leg: 2)
        #expect(triangle == nil)
    }

    // MARK: - Properties

    @Test("Vertices array")
    func verticesArray() {
        let triangle: Geometry<Double>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 1, y: 0),
            c: .init(x: 0, y: 1)
        )
        let vertices = triangle.vertices
        #expect(vertices.count == 3)
        #expect(vertices[0] == triangle.a)
        #expect(vertices[1] == triangle.b)
        #expect(vertices[2] == triangle.c)
    }

    @Test("Edges tuple")
    func edgesTuple() {
        let triangle: Geometry<Double>.Triangle = .init(
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

    // MARK: - Area

    @Test("Area of right triangle")
    func areaRightTriangle() {
        let triangle: Geometry<Double>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 0, y: 3)
        )
        // Area = 0.5 * base * height = 0.5 * 4 * 3 = 6
        #expect(abs(triangle.area - 6) < 1e-10)
    }

    @Test("Signed area CCW")
    func signedAreaCCW() {
        let triangle: Geometry<Double>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 0, y: 3)
        )
        #expect(triangle.signedArea > 0)
    }

    @Test("Signed area CW")
    func signedAreaCW() {
        let triangle: Geometry<Double>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 0, y: 3),
            c: .init(x: 4, y: 0)
        )
        #expect(triangle.signedArea < 0)
    }

    // MARK: - Perimeter

    @Test("Perimeter of 3-4-5 triangle")
    func perimeter345() {
        let triangle: Geometry<Double>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 3, y: 0),
            c: .init(x: 0, y: 4)
        )
        // Perimeter = 3 + 4 + 5 = 12
        #expect(abs(triangle.perimeter - 12) < 1e-10)
    }

    // MARK: - Centroid

    @Test("Centroid")
    func centroid() {
        let triangle: Geometry<Double>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 6, y: 0),
            c: .init(x: 0, y: 6)
        )
        // Centroid = average of vertices = (2, 2)
        #expect(abs(triangle.centroid.x.value - 2) < 1e-10)
        #expect(abs(triangle.centroid.y.value - 2) < 1e-10)
    }

    // MARK: - Circumcircle

    @Test("Circumcircle of right triangle")
    func circumcircleRight() {
        let triangle: Geometry<Double>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 0, y: 3)
        )
        let circumcircle = triangle.circumcircle
        #expect(circumcircle != nil)
        // For right triangle, circumcenter is midpoint of hypotenuse
        #expect(abs(circumcircle!.center.x.value - 2) < 1e-10)
        #expect(abs(circumcircle!.center.y.value - 1.5) < 1e-10)
        // Circumradius = half of hypotenuse = 2.5
        #expect(abs(circumcircle!.radius.value - 2.5) < 1e-10)
    }

    @Test("Circumcircle passes through all vertices")
    func circumcirclePassesThroughVertices() {
        let triangle: Geometry<Double>.Triangle = .init(
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

    // MARK: - Incircle

    @Test("Incircle of 3-4-5 triangle")
    func incircle345() {
        let triangle: Geometry<Double>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 3, y: 0),
            c: .init(x: 0, y: 4)
        )
        let incircle = triangle.incircle
        #expect(incircle != nil)
        // Inradius = Area / semi-perimeter = 6 / 6 = 1
        #expect(abs(incircle!.radius.value - 1) < 1e-10)
    }

    // MARK: - Containment

    @Test("Contains centroid")
    func containsCentroid() {
        let triangle: Geometry<Double>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 2, y: 3)
        )
        #expect(triangle.contains(triangle.centroid))
    }

    @Test("Contains vertex")
    func containsVertex() {
        let triangle: Geometry<Double>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 2, y: 3)
        )
        #expect(triangle.contains(triangle.a))
    }

    @Test("Does not contain exterior point")
    func doesNotContainExterior() {
        let triangle: Geometry<Double>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 4, y: 0),
            c: .init(x: 2, y: 3)
        )
        let point: Geometry<Double>.Point<2> = .init(x: 10, y: 10)
        #expect(!triangle.contains(point))
    }

    // MARK: - Barycentric Coordinates

    @Test("Barycentric of vertex a")
    func barycentricVertexA() {
        let triangle: Geometry<Double>.Triangle = .init(
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
        let triangle: Geometry<Double>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 3, y: 0),
            c: .init(x: 0, y: 3)
        )
        let bary = triangle.barycentric(triangle.centroid)
        #expect(bary != nil)
        // Centroid has equal barycentric coordinates
        #expect(abs(bary!.u - 1.0/3.0) < 1e-10)
        #expect(abs(bary!.v - 1.0/3.0) < 1e-10)
        #expect(abs(bary!.w - 1.0/3.0) < 1e-10)
    }

    @Test("Barycentric sum is 1")
    func barycentricSumIsOne() {
        let triangle: Geometry<Double>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 5, y: 0),
            c: .init(x: 2, y: 4)
        )
        let point: Geometry<Double>.Point<2> = .init(x: 2, y: 1)
        let bary = triangle.barycentric(point)!
        #expect(abs(bary.u + bary.v + bary.w - 1) < 1e-10)
    }

    // MARK: - Point from Barycentric

    @Test("Point from barycentric vertex")
    func pointFromBarycentricVertex() {
        let triangle: Geometry<Double>.Triangle = .init(
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
        let triangle: Geometry<Double>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 6, y: 0),
            c: .init(x: 0, y: 6)
        )
        let point = triangle.point(u: 1.0/3.0, v: 1.0/3.0, w: 1.0/3.0)
        #expect(abs(point.x.value - 2) < 1e-10)
        #expect(abs(point.y.value - 2) < 1e-10)
    }

    // MARK: - Bounding Box

    @Test("Bounding box")
    func boundingBox() {
        let triangle: Geometry<Double>.Triangle = .init(
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

    // MARK: - Transformation

    @Test("Translation")
    func translation() {
        let triangle: Geometry<Double>.Triangle = .init(
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

    @Test("Scaling")
    func scaling() {
        let triangle: Geometry<Double>.Triangle = .init(
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

    // MARK: - Functorial Map

    @Test("Triangle map")
    func triangleMap() {
        let triangle: Geometry<Double>.Triangle = .init(
            a: .init(x: 0, y: 0),
            b: .init(x: 1, y: 0),
            c: .init(x: 0, y: 1)
        )
        let mapped: Geometry<Float>.Triangle = triangle.map { Float($0) }
        #expect(mapped.a.x.value == 0)
        #expect(mapped.b.x.value == 1)
        #expect(mapped.c.y.value == 1)
    }
}
