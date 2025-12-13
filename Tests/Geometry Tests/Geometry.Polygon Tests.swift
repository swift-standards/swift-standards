// Geometry.Polygon Tests.swift
// Tests for Geometry.Polygon type (dynamic-size polygon).

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

private func isApprox(_ a: Area, _ b: Area, tol: Double = 1e-10) -> Bool {
    return abs(a.rawValue - b.rawValue) < tol
}

// MARK: - Initialization Tests

@Suite
struct `Geometry.Polygon - Initialization` {
    @Test
    func `Polygon initialization`() {
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

@Suite
struct `Geometry.Polygon - Validity` {
    @Test
    func `Valid polygon with 3 vertices`() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 0, y: 1),
        ])
        #expect(polygon.isValid)
    }

    @Test
    func `Invalid polygon with 2 vertices`() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
        ])
        #expect(!polygon.isValid)
    }
}

// MARK: - Edges Tests

@Suite
struct `Geometry.Polygon - Edges` {
    @Test
    func `Edges of triangle`() {
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

    @Test
    func `Edges of square`() {
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

@Suite
struct `Geometry.Polygon - Static Functions` {
    @Test
    func `Geometry.area(of:) unit square`() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 1, y: 1),
            .init(x: 0, y: 1),
        ])
        let area = Geometry.area(of: polygon)
        #expect(abs(area - 1) < 1e-10)
    }

    @Test
    func `Geometry.area(of:) rectangle`() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 4, y: 0),
            .init(x: 4, y: 3),
            .init(x: 0, y: 3),
        ])
        let area = Geometry.area(of: polygon)
        #expect(abs(area - 12) < 1e-10)
    }

    @Test
    func `Geometry.area(of:) triangle`() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 4, y: 0),
            .init(x: 0, y: 3),
        ])
        let area = Geometry.area(of: polygon)
        #expect(abs(area - 6) < 1e-10)
    }

    @Test
    func `Geometry.signedDoubleArea(of:) CCW positive`() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 1, y: 1),
            .init(x: 0, y: 1),
        ])
        let signedArea = Geometry.signedDoubleArea(of: polygon)
        #expect(signedArea > 0)
    }

    @Test
    func `Geometry.signedDoubleArea(of:) CW negative`() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 0, y: 1),
            .init(x: 1, y: 1),
            .init(x: 1, y: 0),
        ])
        let signedArea = Geometry.signedDoubleArea(of: polygon)
        #expect(signedArea < 0)
    }

    @Test
    func `Geometry.perimeter(of:) unit square`() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 1, y: 1),
            .init(x: 0, y: 1),
        ])
        let perimeter = Geometry.perimeter(of: polygon)
        #expect(isApprox(perimeter, Distance(4)))
    }

    @Test
    func `Geometry.perimeter(of:) 3-4-5 triangle`() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 3, y: 0),
            .init(x: 0, y: 4),
        ])
        let perimeter = Geometry.perimeter(of: polygon)
        #expect(isApprox(perimeter, Distance(12)))
    }

    @Test
    func `Geometry.centroid(of:) square`() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 2, y: 0),
            .init(x: 2, y: 2),
            .init(x: 0, y: 2),
        ])
        let centroid = Geometry.centroid(of: polygon)
        #expect(centroid != nil)
        #expect(isApprox(centroid!.x, X(1)))
        #expect(isApprox(centroid!.y, Y(1)))
    }

    @Test
    func `Geometry.centroid(of:) triangle`() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 6, y: 0),
            .init(x: 0, y: 6),
        ])
        let centroid = Geometry.centroid(of: polygon)!
        #expect(isApprox(centroid.x, X(2)))
        #expect(isApprox(centroid.y, Y(2)))
    }
}

// MARK: - Area and Perimeter Properties Tests

@Suite
struct `Geometry.Polygon - Area and Perimeter Properties` {
    @Test
    func `Area property matches static function`() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 4, y: 0),
            .init(x: 4, y: 3),
            .init(x: 0, y: 3),
        ])
        #expect(abs(polygon.area - 12) < 1e-10)
    }

    @Test
    func `Perimeter property matches static function`() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 1, y: 1),
            .init(x: 0, y: 1),
        ])
        #expect(isApprox(polygon.perimeter, Distance(4)))
    }
}

// MARK: - Centroid Tests

@Suite
struct `Geometry.Polygon - Centroid` {
    @Test
    func `Centroid of square`() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 2, y: 0),
            .init(x: 2, y: 2),
            .init(x: 0, y: 2),
        ])
        let centroid = polygon.centroid
        #expect(centroid != nil)
        #expect(isApprox(centroid!.x, X(1)))
        #expect(isApprox(centroid!.y, Y(1)))
    }
}

// MARK: - Bounding Box Tests

@Suite
struct `Geometry.Polygon - Bounding Box` {
    @Test
    func `Bounding box`() {
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

@Suite
struct `Geometry.Polygon - Convexity` {
    @Test
    func `Square is convex`() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 1, y: 1),
            .init(x: 0, y: 1),
        ])
        #expect(polygon.isConvex)
    }

    @Test
    func `L-shape is not convex`() {
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

    @Test
    func `Triangle is always convex`() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 5, y: 0),
            .init(x: 2, y: 4),
        ])
        #expect(polygon.isConvex)
    }
}

// MARK: - Winding Tests

@Suite
struct `Geometry.Polygon - Winding` {
    @Test
    func `Counter-clockwise`() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 1, y: 1),
            .init(x: 0, y: 1),
        ])
        #expect(polygon.isCounterClockwise)
        #expect(!polygon.isClockwise)
    }

    @Test
    func `Clockwise`() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 0, y: 1),
            .init(x: 1, y: 1),
            .init(x: 1, y: 0),
        ])
        #expect(polygon.isClockwise)
        #expect(!polygon.isCounterClockwise)
    }

    @Test
    func `Reversed polygon`() {
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

@Suite
struct `Geometry.Polygon - Containment` {
    @Test
    func `Contains interior point`() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 4, y: 0),
            .init(x: 4, y: 4),
            .init(x: 0, y: 4),
        ])
        let point: Geometry<Double, Void>.Point<2> = .init(x: 2, y: 2)
        #expect(polygon.contains(point))
    }

    @Test
    func `Does not contain exterior point`() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 4, y: 0),
            .init(x: 4, y: 4),
            .init(x: 0, y: 4),
        ])
        let point: Geometry<Double, Void>.Point<2> = .init(x: 10, y: 10)
        #expect(!polygon.contains(point))
    }

    @Test
    func `Contains point in L-shape`() {
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

    @Test
    func `Point on boundary`() {
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

@Suite
struct `Geometry.Polygon - Transformations` {
    @Test
    func `Translation`() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 0, y: 1),
        ])
        let translated = polygon.translated(by: .init(dx: 5, dy: 10))
        #expect(translated.vertices[0].x == 5)
        #expect(translated.vertices[0].y == 10)
    }

    @Test
    func `Scaling about centroid`() {
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
        #expect(isApprox(originalCentroid.x, scaledCentroid.x))
        #expect(isApprox(originalCentroid.y, scaledCentroid.y))
    }

    @Test
    func `Scaling about point`() {
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

@Suite
struct `Geometry.Polygon - Triangulation` {
    @Test
    func `Triangulate triangle`() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 4, y: 0),
            .init(x: 2, y: 3),
        ])
        let triangles = polygon.triangulate()
        #expect(triangles.count == 1)
    }

    @Test
    func `Triangulate square`() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 4, y: 0),
            .init(x: 4, y: 4),
            .init(x: 0, y: 4),
        ])
        let triangles = polygon.triangulate()
        #expect(triangles.count == 2)

        let totalArea = triangles.reduce(0.0) { $0 + $1.area.rawValue }
        #expect(abs(totalArea - polygon.area) < 1e-10)
    }

    @Test
    func `Triangulate pentagon`() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 4, y: 0),
            .init(x: 5, y: 3),
            .init(x: 2, y: 5),
            .init(x: -1, y: 3),
        ])
        let triangles = polygon.triangulate()
        #expect(triangles.count == 3)

        let totalArea = triangles.reduce(0.0) { $0 + $1.area.rawValue }
        #expect(abs(totalArea - polygon.area) < 1e-10)
    }
}

// MARK: - Functorial Map Tests

@Suite
struct `Geometry.Polygon - Functorial Map` {
    @Test
    func `Polygon map to different scalar type`() {
        let polygon: Geometry<Double, Void>.Polygon = .init(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 0, y: 1),
        ])
        let mapped: Geometry<Float, Void>.Polygon = polygon.map { Float($0) }
        #expect(mapped.vertices.count == 3)
        let expectedX0: Geometry<Float, Void>.X = 0
        let expectedX1: Geometry<Float, Void>.X = 1
        #expect(mapped.vertices[0].x == expectedX0)
        #expect(mapped.vertices[1].x == expectedX1)
    }
}
