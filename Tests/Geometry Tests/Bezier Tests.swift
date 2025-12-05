// Bezier Tests.swift
// Tests for Geometry.Bezier type.

import Testing
@testable import Geometry

@Suite("Bezier Tests")
struct BezierTests {

    // MARK: - Initialization

    @Test("Bezier initialization")
    func initialization() {
        let bezier: Geometry<Double>.Bezier = .init(controlPoints: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 2),
            .init(x: 3, y: 2),
            .init(x: 4, y: 0)
        ])
        #expect(bezier.controlPoints.count == 4)
    }

    @Test("Linear Bezier")
    func linearBezier() {
        let bezier: Geometry<Double>.Bezier = .linear(
            from: .init(x: 0, y: 0),
            to: .init(x: 10, y: 10)
        )
        #expect(bezier.degree == 1)
        #expect(bezier.controlPoints.count == 2)
    }

    @Test("Quadratic Bezier")
    func quadraticBezier() {
        let bezier: Geometry<Double>.Bezier = .quadratic(
            from: .init(x: 0, y: 0),
            control: .init(x: 5, y: 10),
            to: .init(x: 10, y: 0)
        )
        #expect(bezier.degree == 2)
        #expect(bezier.controlPoints.count == 3)
    }

    @Test("Cubic Bezier")
    func cubicBezier() {
        let bezier: Geometry<Double>.Bezier = .cubic(
            from: .init(x: 0, y: 0),
            control1: .init(x: 1, y: 2),
            control2: .init(x: 3, y: 2),
            to: .init(x: 4, y: 0)
        )
        #expect(bezier.degree == 3)
        #expect(bezier.controlPoints.count == 4)
    }

    // MARK: - Properties

    @Test("Degree")
    func degree() {
        let linear: Geometry<Double>.Bezier = .linear(
            from: .zero,
            to: .init(x: 1, y: 1)
        )
        #expect(linear.degree == 1)

        let cubic: Geometry<Double>.Bezier = .cubic(
            from: .zero,
            control1: .init(x: 1, y: 1),
            control2: .init(x: 2, y: 1),
            to: .init(x: 3, y: 0)
        )
        #expect(cubic.degree == 3)
    }

    @Test("isValid")
    func isValid() {
        let valid: Geometry<Double>.Bezier = .linear(
            from: .zero,
            to: .init(x: 1, y: 1)
        )
        #expect(valid.isValid)

        let invalid: Geometry<Double>.Bezier = .init(controlPoints: [.zero])
        #expect(!invalid.isValid)
    }

    @Test("Start and end points")
    func startEndPoints() {
        let bezier: Geometry<Double>.Bezier = .cubic(
            from: .init(x: 1, y: 2),
            control1: .init(x: 3, y: 4),
            control2: .init(x: 5, y: 6),
            to: .init(x: 7, y: 8)
        )
        #expect(bezier.startPoint?.x == 1)
        #expect(bezier.startPoint?.y == 2)
        #expect(bezier.endPoint?.x == 7)
        #expect(bezier.endPoint?.y == 8)
    }

    // MARK: - Evaluation

    @Test("Point at t=0")
    func pointAtZero() {
        let bezier: Geometry<Double>.Bezier = .cubic(
            from: .init(x: 0, y: 0),
            control1: .init(x: 1, y: 2),
            control2: .init(x: 3, y: 2),
            to: .init(x: 4, y: 0)
        )
        let point = bezier.point(at: 0)
        #expect(point != nil)
        #expect(abs(point!.x.value - 0) < 1e-10)
        #expect(abs(point!.y.value - 0) < 1e-10)
    }

    @Test("Point at t=1")
    func pointAtOne() {
        let bezier: Geometry<Double>.Bezier = .cubic(
            from: .init(x: 0, y: 0),
            control1: .init(x: 1, y: 2),
            control2: .init(x: 3, y: 2),
            to: .init(x: 4, y: 0)
        )
        let point = bezier.point(at: 1)
        #expect(point != nil)
        #expect(abs(point!.x.value - 4) < 1e-10)
        #expect(abs(point!.y.value - 0) < 1e-10)
    }

    @Test("Point at t=0.5 for linear")
    func pointAtHalfLinear() {
        let bezier: Geometry<Double>.Bezier = .linear(
            from: .init(x: 0, y: 0),
            to: .init(x: 10, y: 10)
        )
        let point = bezier.point(at: 0.5)!
        #expect(abs(point.x.value - 5) < 1e-10)
        #expect(abs(point.y.value - 5) < 1e-10)
    }

    @Test("Point at t=0.5 for quadratic")
    func pointAtHalfQuadratic() {
        let bezier: Geometry<Double>.Bezier = .quadratic(
            from: .init(x: 0, y: 0),
            control: .init(x: 2, y: 4),
            to: .init(x: 4, y: 0)
        )
        let point = bezier.point(at: 0.5)!
        // At t=0.5: (1-t)²P0 + 2(1-t)tP1 + t²P2
        // = 0.25*(0,0) + 0.5*(2,4) + 0.25*(4,0) = (0,0) + (1,2) + (1,0) = (2,2)
        #expect(abs(point.x.value - 2) < 1e-10)
        #expect(abs(point.y.value - 2) < 1e-10)
    }

    // MARK: - Derivative

    @Test("Derivative of linear")
    func derivativeLinear() {
        let bezier: Geometry<Double>.Bezier = .linear(
            from: .init(x: 0, y: 0),
            to: .init(x: 10, y: 20)
        )
        let deriv = bezier.derivative(at: 0.5)!
        // Derivative of linear is constant: n * (P1 - P0) = 1 * (10, 20)
        #expect(abs(deriv.dx.value - 10) < 1e-10)
        #expect(abs(deriv.dy.value - 20) < 1e-10)
    }

    @Test("Tangent is unit vector")
    func tangentIsUnit() {
        let bezier: Geometry<Double>.Bezier = .cubic(
            from: .init(x: 0, y: 0),
            control1: .init(x: 1, y: 2),
            control2: .init(x: 3, y: 2),
            to: .init(x: 4, y: 0)
        )
        let tangent = bezier.tangent(at: 0.5)!
        #expect(abs(tangent.length - 1) < 1e-10)
    }

    @Test("Normal perpendicular to tangent")
    func normalPerpendicular() {
        let bezier: Geometry<Double>.Bezier = .cubic(
            from: .init(x: 0, y: 0),
            control1: .init(x: 1, y: 2),
            control2: .init(x: 3, y: 2),
            to: .init(x: 4, y: 0)
        )
        let tangent = bezier.tangent(at: 0.5)!
        let normal = bezier.normal(at: 0.5)!

        #expect(abs(tangent.dot(normal)) < 1e-10)
    }

    // MARK: - Subdivision

    @Test("Split at t=0.5")
    func splitAtHalf() {
        let bezier: Geometry<Double>.Bezier = .cubic(
            from: .init(x: 0, y: 0),
            control1: .init(x: 0, y: 10),
            control2: .init(x: 10, y: 10),
            to: .init(x: 10, y: 0)
        )
        let split = bezier.split(at: 0.5)!

        // Left curve should start at original start
        #expect(abs(split.left.startPoint!.x.value - 0) < 1e-10)
        #expect(abs(split.left.startPoint!.y.value - 0) < 1e-10)

        // Right curve should end at original end
        #expect(abs(split.right.endPoint!.x.value - 10) < 1e-10)
        #expect(abs(split.right.endPoint!.y.value - 0) < 1e-10)

        // Left end = Right start = midpoint
        let midpoint = bezier.point(at: 0.5)!
        #expect(abs(split.left.endPoint!.x.value - midpoint.x.value) < 1e-10)
        #expect(abs(split.right.startPoint!.x.value - midpoint.x.value) < 1e-10)
    }

    @Test("Subdivide into segments")
    func subdivideIntoSegments() {
        let bezier: Geometry<Double>.Bezier = .cubic(
            from: .init(x: 0, y: 0),
            control1: .init(x: 1, y: 2),
            control2: .init(x: 3, y: 2),
            to: .init(x: 4, y: 0)
        )
        let points = bezier.subdivide(into: 10)
        #expect(points.count == 11) // 10 segments = 11 points

        // First point is start
        #expect(abs(points[0].x.value - 0) < 1e-10)
        // Last point is end
        #expect(abs(points[10].x.value - 4) < 1e-10)
    }

    // MARK: - Bounding Box

    @Test("Conservative bounding box")
    func conservativeBoundingBox() {
        let bezier: Geometry<Double>.Bezier = .cubic(
            from: .init(x: 0, y: 0),
            control1: .init(x: 1, y: 10),
            control2: .init(x: 3, y: 10),
            to: .init(x: 4, y: 0)
        )
        let bbox = bezier.boundingBoxConservative!
        #expect(bbox.llx == 0)
        #expect(bbox.lly == 0)
        #expect(bbox.urx == 4)
        #expect(bbox.ury == 10)
    }

    // MARK: - Length

    @Test("Length of linear Bezier")
    func lengthLinear() {
        let bezier: Geometry<Double>.Bezier = .linear(
            from: .init(x: 0, y: 0),
            to: .init(x: 3, y: 4)
        )
        let length = bezier.length(segments: 100)
        #expect(abs(length - 5) < 0.01)
    }

    @Test("Length approximation")
    func lengthApproximation() {
        let bezier: Geometry<Double>.Bezier = .cubic(
            from: .init(x: 0, y: 0),
            control1: .init(x: 0, y: 10),
            control2: .init(x: 10, y: 10),
            to: .init(x: 10, y: 0)
        )
        let length = bezier.length(segments: 1000)
        // Length should be greater than straight line (10) and less than control polygon
        #expect(length > 10)
        #expect(length < 30)
    }

    // MARK: - Transformation

    @Test("Translation")
    func translation() {
        let bezier: Geometry<Double>.Bezier = .linear(
            from: .init(x: 0, y: 0),
            to: .init(x: 10, y: 10)
        )
        let translated = bezier.translated(by: .init(dx: 5, dy: 5))
        #expect(translated.startPoint?.x == 5)
        #expect(translated.startPoint?.y == 5)
        #expect(translated.endPoint?.x == 15)
        #expect(translated.endPoint?.y == 15)
    }

    @Test("Scaling about point")
    func scalingAboutPoint() {
        let bezier: Geometry<Double>.Bezier = .linear(
            from: .init(x: 0, y: 0),
            to: .init(x: 10, y: 0)
        )
        let scaled = bezier.scaled(by: 2, about: bezier.startPoint!)
        #expect(scaled.startPoint?.x == 0)
        #expect(scaled.endPoint?.x == 20)
    }

    @Test("Reversed curve")
    func reversed() {
        let bezier: Geometry<Double>.Bezier = .cubic(
            from: .init(x: 0, y: 0),
            control1: .init(x: 1, y: 2),
            control2: .init(x: 3, y: 2),
            to: .init(x: 4, y: 0)
        )
        let reversed = bezier.reversed
        #expect(reversed.startPoint?.x == 4)
        #expect(reversed.endPoint?.x == 0)
    }

    // MARK: - Functorial Map

    @Test("Bezier map")
    func bezierMap() {
        let bezier: Geometry<Double>.Bezier = .linear(
            from: .init(x: 0, y: 0),
            to: .init(x: 10, y: 20)
        )
        let mapped: Geometry<Float>.Bezier = bezier.map { Float($0) }
        #expect(mapped.startPoint?.x.value == 0)
        #expect(mapped.endPoint?.x.value == 10)
    }
}
