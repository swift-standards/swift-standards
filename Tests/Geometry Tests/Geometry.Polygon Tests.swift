// Geometry.Polygon Tests.swift
// Tests for Geometry.Polygon type (dynamic-size polygon).

import Testing

@testable import Affine
@testable import Algebra
@testable import Algebra_Linear
@testable import Geometry

// MARK: - Initialization Tests

@Suite("Geometry.Polygon - Initialization")
struct GeometryPolygon_InitializationTests {
    @Test("Polygon initialization")
    func polygonInit() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 4, y: 0),
            .init(x: 4, y: 3),
            .init(x: 0, y: 3),
        ])
        #expect(polygon.vertices.count == 4)
        #expect(polygon.vertexCount == 4)
    }
}

// MARK: - Validity Tests

@Suite("Geometry.Polygon - Validity")
struct GeometryPolygon_ValidityTests {
    @Test("Valid polygon with 3 vertices")
    func validPolygon() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 0, y: 1),
        ])
        #expect(polygon.isValid)
    }

    @Test("Invalid polygon with 2 vertices")
    func invalidPolygon() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
        ])
        #expect(!polygon.isValid)
    }
}

// MARK: - Edges Tests

@Suite("Geometry.Polygon - Edges")
struct GeometryPolygon_EdgesTests {
    @Test("Edges of triangle")
    func triangleEdges() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 4, y: 0),
            .init(x: 2, y: 3),
        ])
        let edges = polygon.edges
        #expect(edges.count == 3)
        #expect(edges[0].start.x == 0)
        #expect(edges[0].end.x == 4)
        #expect(edges[2].start.x == 2)
        #expect(edges[2].end.x == 0)
    }

    @Test("Edges of square")
    func squareEdges() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 1, y: 1),
            .init(x: 0, y: 1),
        ])
        let edges = polygon.edges
        #expect(edges.count == 4)
    }
}

// MARK: - Static Functions Tests

@Suite("Geometry.Polygon - Static Functions")
struct GeometryPolygon_StaticTests {
    @Test("Geometry.area(of:) unit square")
    func staticAreaSquare() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 1, y: 1),
            .init(x: 0, y: 1),
        ])
        let area = Geometry.area(of: polygon)
        #expect(abs(area - 1) < 1e-10)
    }

    @Test("Geometry.area(of:) rectangle")
    func staticAreaRectangle() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 4, y: 0),
            .init(x: 4, y: 3),
            .init(x: 0, y: 3),
        ])
        let area = Geometry.area(of: polygon)
        #expect(abs(area - 12) < 1e-10)
    }

    @Test("Geometry.area(of:) triangle")
    func staticAreaTriangle() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 4, y: 0),
            .init(x: 0, y: 3),
        ])
        let area = Geometry.area(of: polygon)
        #expect(abs(area - 6) < 1e-10)
    }

    @Test("Geometry.signedDoubleArea(of:) CCW positive")
    func staticSignedDoubleAreaCCW() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 1, y: 1),
            .init(x: 0, y: 1),
        ])
        let signedArea = Geometry.signedDoubleArea(of: polygon)
        #expect(signedArea > 0)
    }

    @Test("Geometry.signedDoubleArea(of:) CW negative")
    func staticSignedDoubleAreaCW() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 0, y: 1),
            .init(x: 1, y: 1),
            .init(x: 1, y: 0),
        ])
        let signedArea = Geometry.signedDoubleArea(of: polygon)
        #expect(signedArea < 0)
    }

    @Test("Geometry.perimeter(of:) unit square")
    func staticPerimeterSquare() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 1, y: 1),
            .init(x: 0, y: 1),
        ])
        let perimeter = Geometry.perimeter(of: polygon)
        #expect(abs(perimeter.value - 4) < 1e-10)
    }

    @Test("Geometry.perimeter(of:) 3-4-5 triangle")
    func staticPerimeterTriangle() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 3, y: 0),
            .init(x: 0, y: 4),
        ])
        let perimeter = Geometry.perimeter(of: polygon)
        #expect(abs(perimeter.value - 12) < 1e-10)
    }

    @Test("Geometry.centroid(of:) square")
    func staticCentroidSquare() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 2, y: 0),
            .init(x: 2, y: 2),
            .init(x: 0, y: 2),
        ])
        let centroid = Geometry.centroid(of: polygon)
        #expect(centroid != nil)
        #expect(abs(centroid!.x.value - 1) < 1e-10)
        #expect(abs(centroid!.y.value - 1) < 1e-10)
    }

    @Test("Geometry.centroid(of:) triangle")
    func staticCentroidTriangle() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 6, y: 0),
            .init(x: 0, y: 6),
        ])
        let centroid = Geometry.centroid(of: polygon)!
        #expect(abs(centroid.x.value - 2) < 1e-10)
        #expect(abs(centroid.y.value - 2) < 1e-10)
    }
}

// MARK: - Area and Perimeter Properties Tests

@Suite("Geometry.Polygon - Area and Perimeter Properties")
struct GeometryPolygon_AreaTests {
    @Test("Area property matches static function")
    func areaProperty() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 4, y: 0),
            .init(x: 4, y: 3),
            .init(x: 0, y: 3),
        ])
        #expect(abs(polygon.area - 12) < 1e-10)
    }

    @Test("Perimeter property matches static function")
    func perimeterProperty() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 1, y: 1),
            .init(x: 0, y: 1),
        ])
        #expect(abs(polygon.perimeter.value - 4) < 1e-10)
    }
}

// MARK: - Centroid Tests

@Suite("Geometry.Polygon - Centroid")
struct GeometryPolygon_CentroidTests {
    @Test("Centroid of square")
    func centroidSquare() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 2, y: 0),
            .init(x: 2, y: 2),
            .init(x: 0, y: 2),
        ])
        let centroid = polygon.centroid
        #expect(centroid != nil)
        #expect(abs(centroid!.x.value - 1) < 1e-10)
        #expect(abs(centroid!.y.value - 1) < 1e-10)
    }
}

// MARK: - Bounding Box Tests

@Suite("Geometry.Polygon - Bounding Box")
struct GeometryPolygon_BoundingBoxTests {
    @Test("Bounding box")
    func boundingBox() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 1, y: 2),
            .init(x: 5, y: 3),
            .init(x: 4, y: 7),
            .init(x: 2, y: 5),
        ])
        let bbox = polygon.boundingBox!
        #expect(bbox.llx == 1)
        #expect(bbox.lly == 2)
        #expect(bbox.urx == 5)
        #expect(bbox.ury == 7)
    }
}

// MARK: - Convexity Tests

@Suite("Geometry.Polygon - Convexity")
struct GeometryPolygon_ConvexityTests {
    @Test("Square is convex")
    func squareIsConvex() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 1, y: 1),
            .init(x: 0, y: 1),
        ])
        #expect(polygon.isConvex)
    }

    @Test("L-shape is not convex")
    func lShapeNotConvex() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 2, y: 0),
            .init(x: 2, y: 1),
            .init(x: 1, y: 1),
            .init(x: 1, y: 2),
            .init(x: 0, y: 2),
        ])
        #expect(!polygon.isConvex)
    }

    @Test("Triangle is always convex")
    func triangleIsConvex() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 5, y: 0),
            .init(x: 2, y: 4),
        ])
        #expect(polygon.isConvex)
    }
}

// MARK: - Winding Tests

@Suite("Geometry.Polygon - Winding")
struct GeometryPolygon_WindingTests {
    @Test("Counter-clockwise")
    func counterClockwise() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 1, y: 1),
            .init(x: 0, y: 1),
        ])
        #expect(polygon.isCounterClockwise)
        #expect(!polygon.isClockwise)
    }

    @Test("Clockwise")
    func clockwise() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 0, y: 1),
            .init(x: 1, y: 1),
            .init(x: 1, y: 0),
        ])
        #expect(polygon.isClockwise)
        #expect(!polygon.isCounterClockwise)
    }

    @Test("Reversed polygon")
    func reversed() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 1, y: 1),
        ])
        let reversed = polygon.reversed
        #expect(reversed.vertices[0] == polygon.vertices[2])
        #expect(polygon.isCounterClockwise != reversed.isCounterClockwise)
    }
}

// MARK: - Containment Tests

@Suite("Geometry.Polygon - Containment")
struct GeometryPolygon_ContainmentTests {
    @Test("Contains interior point")
    func containsInterior() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 4, y: 0),
            .init(x: 4, y: 4),
            .init(x: 0, y: 4),
        ])
        let point: Geometry<Double, Void>.Point<2> = .init(x: 2, y: 2)
        #expect(polygon.contains(point))
    }

    @Test("Does not contain exterior point")
    func doesNotContainExterior() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 4, y: 0),
            .init(x: 4, y: 4),
            .init(x: 0, y: 4),
        ])
        let point: Geometry<Double, Void>.Point<2> = .init(x: 10, y: 10)
        #expect(!polygon.contains(point))
    }

    @Test("Contains point in L-shape")
    func containsInLShape() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 2, y: 0),
            .init(x: 2, y: 1),
            .init(x: 1, y: 1),
            .init(x: 1, y: 2),
            .init(x: 0, y: 2),
        ])
        let inside: Geometry<Double, Void>.Point<2> = .init(x: 0.5, y: 0.5)
        #expect(polygon.contains(inside))

        let outside: Geometry<Double, Void>.Point<2> = .init(x: 1.5, y: 1.5)
        #expect(!polygon.contains(outside))
    }

    @Test("Point on boundary")
    func pointOnBoundary() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 4, y: 0),
            .init(x: 4, y: 4),
            .init(x: 0, y: 4),
        ])
        let onEdge: Geometry<Double, Void>.Point<2> = .init(x: 2, y: 0)
        #expect(polygon.isOnBoundary(onEdge))

        let inside: Geometry<Double, Void>.Point<2> = .init(x: 2, y: 2)
        #expect(!polygon.isOnBoundary(inside))
    }
}

// MARK: - Transformation Tests

@Suite("Geometry.Polygon - Transformations")
struct GeometryPolygon_TransformationTests {
    @Test("Translation")
    func translation() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 0, y: 1),
        ])
        let translated = polygon.translated(by: .init(dx: 5, dy: 10))
        #expect(translated.vertices[0].x == 5)
        #expect(translated.vertices[0].y == 10)
    }

    @Test("Scaling about centroid")
    func scalingAboutCentroid() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 2, y: 0),
            .init(x: 2, y: 2),
            .init(x: 0, y: 2),
        ])
        let scaled = polygon.scaled(by: 2)!
        #expect(abs(scaled.area - 16) < 1e-10)
        let originalCentroid = polygon.centroid!
        let scaledCentroid = scaled.centroid!
        #expect(abs(originalCentroid.x.value - scaledCentroid.x.value) < 1e-10)
        #expect(abs(originalCentroid.y.value - scaledCentroid.y.value) < 1e-10)
    }

    @Test("Scaling about point")
    func scalingAboutPoint() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 1, y: 1),
            .init(x: 0, y: 1),
        ])
        let scaled = polygon.scaled(by: 2, about: polygon.vertices[0])
        #expect(scaled.vertices[0].x == 0)
        #expect(scaled.vertices[0].y == 0)
        #expect(scaled.vertices[1].x == 2)
        #expect(scaled.vertices[2].y == 2)
    }
}

// MARK: - Triangulation Tests

@Suite("Geometry.Polygon - Triangulation")
struct GeometryPolygon_TriangulationTests {
    @Test("Triangulate triangle")
    func triangulateTriangle() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 4, y: 0),
            .init(x: 2, y: 3),
        ])
        let triangles = polygon.triangulate()
        #expect(triangles.count == 1)
    }

    @Test("Triangulate square")
    func triangulateSquare() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 4, y: 0),
            .init(x: 4, y: 4),
            .init(x: 0, y: 4),
        ])
        let triangles = polygon.triangulate()
        #expect(triangles.count == 2)

        let totalArea = triangles.reduce(0.0) { $0 + $1.area }
        #expect(abs(totalArea - polygon.area) < 1e-10)
    }

    @Test("Triangulate pentagon")
    func triangulatePentagon() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 4, y: 0),
            .init(x: 5, y: 3),
            .init(x: 2, y: 5),
            .init(x: -1, y: 3),
        ])
        let triangles = polygon.triangulate()
        #expect(triangles.count == 3)

        let totalArea = triangles.reduce(0.0) { $0 + $1.area }
        #expect(abs(totalArea - polygon.area) < 1e-10)
    }
}

// MARK: - Functorial Map Tests

@Suite("Geometry.Polygon - Functorial Map")
struct GeometryPolygon_MapTests {
    @Test("Polygon map to different scalar type")
    func polygonMap() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 0, y: 1),
        ])
        let mapped: Geometry<Float, Void>.Polygon = polygon.map { Float($0) }
        #expect(mapped.vertices.count == 3)
        #expect(mapped.vertices[0].x.value == 0)
        #expect(mapped.vertices[1].x.value == 1)
    }
}
