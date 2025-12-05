// Polygon Tests.swift
// Tests for Geometry.Polygon type.

import Testing
@testable import Geometry

@Suite("Polygon Tests")
struct PolygonTests {

    // MARK: - Initialization

    @Test("Polygon initialization")
    func initialization() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 4, y: 0),
            .init(x: 4, y: 3),
            .init(x: 0, y: 3)
        ])
        #expect(polygon.vertices.count == 4)
        #expect(polygon.vertexCount == 4)
    }

    // MARK: - Validity

    @Test("Valid polygon")
    func validPolygon() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 0, y: 1)
        ])
        #expect(polygon.isValid)
    }

    @Test("Invalid polygon with 2 vertices")
    func invalidPolygon() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0)
        ])
        #expect(!polygon.isValid)
    }

    // MARK: - Edges

    @Test("Edges of triangle")
    func edgesTriangle() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 4, y: 0),
            .init(x: 2, y: 3)
        ])
        let edges = polygon.edges
        #expect(edges.count == 3)

        // First edge: (0,0) to (4,0)
        #expect(edges[0].start.x == 0)
        #expect(edges[0].end.x == 4)

        // Last edge connects back to first vertex
        #expect(edges[2].start.x == 2)
        #expect(edges[2].end.x == 0)
    }

    @Test("Edges of square")
    func edgesSquare() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 1, y: 1),
            .init(x: 0, y: 1)
        ])
        let edges = polygon.edges
        #expect(edges.count == 4)
    }

    // MARK: - Area

    @Test("Area of unit square")
    func areaUnitSquare() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 1, y: 1),
            .init(x: 0, y: 1)
        ])
        #expect(abs(polygon.area - 1) < 1e-10)
    }

    @Test("Area of rectangle")
    func areaRectangle() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 4, y: 0),
            .init(x: 4, y: 3),
            .init(x: 0, y: 3)
        ])
        #expect(abs(polygon.area - 12) < 1e-10)
    }

    @Test("Area of triangle")
    func areaTriangle() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 4, y: 0),
            .init(x: 0, y: 3)
        ])
        #expect(abs(polygon.area - 6) < 1e-10)
    }

    @Test("Signed area CCW is positive")
    func signedAreaCCW() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 1, y: 1),
            .init(x: 0, y: 1)
        ])
        #expect(polygon.signedDoubleArea > 0)
    }

    @Test("Signed area CW is negative")
    func signedAreaCW() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 0, y: 1),
            .init(x: 1, y: 1),
            .init(x: 1, y: 0)
        ])
        #expect(polygon.signedDoubleArea < 0)
    }

    // MARK: - Perimeter

    @Test("Perimeter of unit square")
    func perimeterUnitSquare() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 1, y: 1),
            .init(x: 0, y: 1)
        ])
        #expect(abs(polygon.perimeter - 4) < 1e-10)
    }

    @Test("Perimeter of 3-4-5 triangle")
    func perimeterTriangle() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 3, y: 0),
            .init(x: 0, y: 4)
        ])
        #expect(abs(polygon.perimeter - 12) < 1e-10)
    }

    // MARK: - Centroid

    @Test("Centroid of square")
    func centroidSquare() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 2, y: 0),
            .init(x: 2, y: 2),
            .init(x: 0, y: 2)
        ])
        let centroid = polygon.centroid
        #expect(centroid != nil)
        #expect(abs(centroid!.x.value - 1) < 1e-10)
        #expect(abs(centroid!.y.value - 1) < 1e-10)
    }

    @Test("Centroid of triangle")
    func centroidTriangle() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 6, y: 0),
            .init(x: 0, y: 6)
        ])
        let centroid = polygon.centroid!
        #expect(abs(centroid.x.value - 2) < 1e-10)
        #expect(abs(centroid.y.value - 2) < 1e-10)
    }

    // MARK: - Bounding Box

    @Test("Bounding box")
    func boundingBox() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 1, y: 2),
            .init(x: 5, y: 3),
            .init(x: 4, y: 7),
            .init(x: 2, y: 5)
        ])
        let bbox = polygon.boundingBox!
        #expect(bbox.llx == 1)
        #expect(bbox.lly == 2)
        #expect(bbox.urx == 5)
        #expect(bbox.ury == 7)
    }

    // MARK: - Convexity

    @Test("Square is convex")
    func squareIsConvex() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 1, y: 1),
            .init(x: 0, y: 1)
        ])
        #expect(polygon.isConvex)
    }

    @Test("L-shape is not convex")
    func lShapeIsNotConvex() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 2, y: 0),
            .init(x: 2, y: 1),
            .init(x: 1, y: 1),
            .init(x: 1, y: 2),
            .init(x: 0, y: 2)
        ])
        #expect(!polygon.isConvex)
    }

    @Test("Triangle is always convex")
    func triangleIsConvex() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 5, y: 0),
            .init(x: 2, y: 4)
        ])
        #expect(polygon.isConvex)
    }

    // MARK: - Winding

    @Test("isCounterClockwise")
    func isCounterClockwise() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 1, y: 1),
            .init(x: 0, y: 1)
        ])
        #expect(polygon.isCounterClockwise)
        #expect(!polygon.isClockwise)
    }

    @Test("isClockwise")
    func isClockwise() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 0, y: 1),
            .init(x: 1, y: 1),
            .init(x: 1, y: 0)
        ])
        #expect(polygon.isClockwise)
        #expect(!polygon.isCounterClockwise)
    }

    @Test("Reversed polygon")
    func reversedPolygon() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 1, y: 1)
        ])
        let reversed = polygon.reversed
        #expect(reversed.vertices[0] == polygon.vertices[2])
        #expect(polygon.isCounterClockwise != reversed.isCounterClockwise)
    }

    // MARK: - Containment

    @Test("Contains interior point")
    func containsInterior() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 4, y: 0),
            .init(x: 4, y: 4),
            .init(x: 0, y: 4)
        ])
        let point: Geometry<Double>.Point<2> = .init(x: 2, y: 2)
        #expect(polygon.contains(point))
    }

    @Test("Does not contain exterior point")
    func doesNotContainExterior() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 4, y: 0),
            .init(x: 4, y: 4),
            .init(x: 0, y: 4)
        ])
        let point: Geometry<Double>.Point<2> = .init(x: 10, y: 10)
        #expect(!polygon.contains(point))
    }

    @Test("Contains point in L-shape")
    func containsPointInLShape() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 2, y: 0),
            .init(x: 2, y: 1),
            .init(x: 1, y: 1),
            .init(x: 1, y: 2),
            .init(x: 0, y: 2)
        ])
        // Point in the bottom-left corner of the L
        let inside: Geometry<Double>.Point<2> = .init(x: 0.5, y: 0.5)
        #expect(polygon.contains(inside))

        // Point in the "cut-out" area
        let outside: Geometry<Double>.Point<2> = .init(x: 1.5, y: 1.5)
        #expect(!polygon.contains(outside))
    }

    @Test("isOnBoundary")
    func isOnBoundary() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 4, y: 0),
            .init(x: 4, y: 4),
            .init(x: 0, y: 4)
        ])
        let onEdge: Geometry<Double>.Point<2> = .init(x: 2, y: 0)
        #expect(polygon.isOnBoundary(onEdge))

        let inside: Geometry<Double>.Point<2> = .init(x: 2, y: 2)
        #expect(!polygon.isOnBoundary(inside))
    }

    // MARK: - Transformation

    @Test("Translation")
    func translation() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 0, y: 1)
        ])
        let translated = polygon.translated(by: .init(dx: 5, dy: 10))
        #expect(translated.vertices[0].x == 5)
        #expect(translated.vertices[0].y == 10)
    }

    @Test("Scaling about centroid")
    func scalingAboutCentroid() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 2, y: 0),
            .init(x: 2, y: 2),
            .init(x: 0, y: 2)
        ])
        let scaled = polygon.scaled(by: 2)!
        // Area should be 4x
        #expect(abs(scaled.area - 16) < 1e-10)
        // Centroid should be the same
        let originalCentroid = polygon.centroid!
        let scaledCentroid = scaled.centroid!
        #expect(abs(originalCentroid.x.value - scaledCentroid.x.value) < 1e-10)
        #expect(abs(originalCentroid.y.value - scaledCentroid.y.value) < 1e-10)
    }

    @Test("Scaling about point")
    func scalingAboutPoint() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 1, y: 1),
            .init(x: 0, y: 1)
        ])
        let scaled = polygon.scaled(by: 2, about: polygon.vertices[0])
        #expect(scaled.vertices[0].x == 0)
        #expect(scaled.vertices[0].y == 0)
        #expect(scaled.vertices[1].x == 2)
        #expect(scaled.vertices[2].y == 2)
    }

    // MARK: - Triangulation

    @Test("Triangulate triangle")
    func triangulateTriangle() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 4, y: 0),
            .init(x: 2, y: 3)
        ])
        let triangles = polygon.triangulate()
        #expect(triangles.count == 1)
    }

    @Test("Triangulate square")
    func triangulateSquare() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 4, y: 0),
            .init(x: 4, y: 4),
            .init(x: 0, y: 4)
        ])
        let triangles = polygon.triangulate()
        #expect(triangles.count == 2)

        // Total area should equal original polygon area
        let totalArea = triangles.reduce(0.0) { $0 + $1.area }
        #expect(abs(totalArea - polygon.area) < 1e-10)
    }

    @Test("Triangulate pentagon")
    func triangulatePentagon() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 4, y: 0),
            .init(x: 5, y: 3),
            .init(x: 2, y: 5),
            .init(x: -1, y: 3)
        ])
        let triangles = polygon.triangulate()
        #expect(triangles.count == 3) // n - 2 triangles

        let totalArea = triangles.reduce(0.0) { $0 + $1.area }
        #expect(abs(totalArea - polygon.area) < 1e-10)
    }

    // MARK: - Functorial Map

    @Test("Polygon map")
    func polygonMap() {
        let polygon: Geometry<Double>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 0, y: 1)
        ])
        let mapped: Geometry<Float>.Polygon = polygon.map { Float($0) }
        #expect(mapped.vertices.count == 3)
        #expect(mapped.vertices[0].x.value == 0)
        #expect(mapped.vertices[1].x.value == 1)
    }
}
