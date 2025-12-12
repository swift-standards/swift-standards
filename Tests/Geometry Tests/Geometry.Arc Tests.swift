// Geometry.Arc Tests.swift
// Tests for Geometry.Arc type.

import Angle
import Testing

@testable import Affine
@testable import Algebra
@testable import Algebra_Linear
@testable import Geometry
@testable import RealModule

// MARK: - Initialization Tests

@Suite("Geometry.Arc - Initialization")
struct GeometryArc_InitializationTests {
    @Test("Arc initialization")
    func arcInit() {
        let arc: Geometry<Double, Void>.Arc = .init(
            center: .init(x: 10, y: 20),
            radius: 5,
            startAngle: .zero,
            endAngle: .pi
        )
        #expect(arc.center.x == 10)
        #expect(arc.center.y == 20)
        #expect(arc.radius == 5)
        #expect(arc.startAngle == .zero)
        #expect(arc.endAngle.value == Double.pi)
    }

    @Test("Full circle arc")
    func fullCircle() {
        let arc: Geometry<Double, Void>.Arc = .fullCircle(center: .zero, radius: 5)
        #expect(arc.startAngle == .zero)
        #expect(abs(arc.endAngle.value - 2 * Double.pi) < 1e-10)
        #expect(arc.isFullCircle)
    }

    @Test("Semicircle arc")
    func semicircle() {
        let arc: Geometry<Double, Void>.Arc = .semicircle(center: .zero, radius: 5)
        #expect(arc.startAngle == .zero)
        #expect(abs(arc.endAngle.value - Double.pi) < 1e-10)
    }

    @Test("Quarter circle arc")
    func quarterCircle() {
        let arc: Geometry<Double, Void>.Arc = .quarterCircle(center: .zero, radius: 5)
        #expect(arc.startAngle == .zero)
        #expect(abs(arc.endAngle.value - Double.pi / 2) < 1e-10)
    }

    @Test("Quarter circle with start angle")
    func quarterCircleWithStart() {
        let arc: Geometry<Double, Void>.Arc = .quarterCircle(
            center: .zero,
            radius: 5,
            startAngle: .halfPi
        )
        #expect(abs(arc.startAngle.value - Double.pi / 2) < 1e-10)
        #expect(abs(arc.endAngle.value - Double.pi) < 1e-10)
    }
}

// MARK: - Properties Tests

@Suite("Geometry.Arc - Properties")
struct GeometryArc_PropertiesTests {
    @Test("Sweep angle")
    func sweep() {
        let arc: Geometry<Double, Void>.Arc = .init(
            center: .zero,
            radius: 5,
            startAngle: .zero,
            endAngle: .pi
        )
        #expect(abs(arc.sweep.value - Double.pi) < 1e-10)
    }

    @Test("Counter-clockwise sweep")
    func counterClockwise() {
        let arc: Geometry<Double, Void>.Arc = .init(
            center: .zero,
            radius: 5,
            startAngle: .zero,
            endAngle: .pi
        )
        #expect(arc.isCounterClockwise)
    }

    @Test("Clockwise sweep")
    func clockwise() {
        let arc: Geometry<Double, Void>.Arc = .init(
            center: .zero,
            radius: 5,
            startAngle: .pi,
            endAngle: .zero
        )
        #expect(!arc.isCounterClockwise)
    }

    @Test("Is full circle")
    func isFullCircle() {
        let full: Geometry<Double, Void>.Arc = .fullCircle(center: .zero, radius: 5)
        #expect(full.isFullCircle)

        let half: Geometry<Double, Void>.Arc = .semicircle(center: .zero, radius: 5)
        #expect(!half.isFullCircle)
    }
}

// MARK: - Endpoints Tests

@Suite("Geometry.Arc - Endpoints")
struct GeometryArc_EndpointsTests {
    @Test("Start point")
    func startPoint() {
        let arc: Geometry<Double, Void>.Arc = .init(
            center: .zero,
            radius: 5,
            startAngle: .zero,
            endAngle: .pi
        )
        #expect(abs(arc.startPoint.x.value - 5) < 1e-10)
        #expect(abs(arc.startPoint.y.value) < 1e-10)
    }

    @Test("End point")
    func endPoint() {
        let arc: Geometry<Double, Void>.Arc = .init(
            center: .zero,
            radius: 5,
            startAngle: .zero,
            endAngle: .pi
        )
        #expect(abs(arc.endPoint.x.value - (-5)) < 1e-10)
        #expect(abs(arc.endPoint.y.value) < 1e-10)
    }

    @Test("Mid point")
    func midPoint() {
        let arc: Geometry<Double, Void>.Arc = .init(
            center: .zero,
            radius: 5,
            startAngle: .zero,
            endAngle: .pi
        )
        #expect(abs(arc.midPoint.x.value) < 1e-10)
        #expect(abs(arc.midPoint.y.value - 5) < 1e-10)
    }

    @Test("Start point with offset center")
    func startPointOffset() {
        let arc: Geometry<Double, Void>.Arc = .init(
            center: .init(x: 10, y: 20),
            radius: 5,
            startAngle: .zero,
            endAngle: .pi
        )
        #expect(abs(arc.startPoint.x.value - 15) < 1e-10)
        #expect(abs(arc.startPoint.y.value - 20) < 1e-10)
    }
}

// MARK: - Parametric Points Tests

@Suite("Geometry.Arc - Parametric Points")
struct GeometryArc_ParametricTests {
    @Test("Point at t=0")
    func pointAt0() {
        let arc: Geometry<Double, Void>.Arc = .init(
            center: .zero,
            radius: 5,
            startAngle: .zero,
            endAngle: .pi
        )
        let point = arc.point(at: 0)
        #expect(abs(point.x.value - arc.startPoint.x.value) < 1e-10)
        #expect(abs(point.y.value - arc.startPoint.y.value) < 1e-10)
    }

    @Test("Point at t=1")
    func pointAt1() {
        let arc: Geometry<Double, Void>.Arc = .init(
            center: .zero,
            radius: 5,
            startAngle: .zero,
            endAngle: .pi
        )
        let point = arc.point(at: 1)
        #expect(abs(point.x.value - arc.endPoint.x.value) < 1e-10)
        #expect(abs(point.y.value - arc.endPoint.y.value) < 1e-10)
    }

    @Test("Point at t=0.5")
    func pointAtHalf() {
        let arc: Geometry<Double, Void>.Arc = .init(
            center: .zero,
            radius: 5,
            startAngle: .zero,
            endAngle: .pi
        )
        let point = arc.point(at: 0.5)
        #expect(abs(point.x.value - arc.midPoint.x.value) < 1e-10)
        #expect(abs(point.y.value - arc.midPoint.y.value) < 1e-10)
    }
}

// MARK: - Tangent Tests

@Suite("Geometry.Arc - Tangent")
struct GeometryArc_TangentTests {
    @Test("Tangent at t=0")
    func tangentAt0() {
        let arc: Geometry<Double, Void>.Arc = .init(
            center: .zero,
            radius: 5,
            startAngle: .zero,
            endAngle: .pi
        )
        let tangent = arc.tangent(at: 0)
        #expect(abs(tangent.dx.value) < 1e-10)
        #expect(abs(tangent.dy.value - 1) < 1e-10)
    }

    @Test("Tangent at t=0.5")
    func tangentAtHalf() {
        let arc: Geometry<Double, Void>.Arc = .init(
            center: .zero,
            radius: 5,
            startAngle: .zero,
            endAngle: .pi
        )
        let tangent = arc.tangent(at: 0.5)
        #expect(abs(tangent.dx.value - (-1)) < 1e-10)
        #expect(abs(tangent.dy.value) < 1e-10)
    }
}

// MARK: - Length Tests

@Suite("Geometry.Arc - Length")
struct GeometryArc_LengthTests {
    @Test("Length of semicircle")
    func lengthSemicircle() {
        let arc: Geometry<Double, Void>.Arc = .semicircle(center: .zero, radius: 5)
        #expect(abs(arc.length - 5 * Double.pi) < 1e-10)
    }

    @Test("Length of full circle")
    func lengthFullCircle() {
        let arc: Geometry<Double, Void>.Arc = .fullCircle(center: .zero, radius: 5)
        #expect(abs(arc.length - 10 * Double.pi) < 1e-10)
    }

    @Test("Length of quarter circle")
    func lengthQuarterCircle() {
        let arc: Geometry<Double, Void>.Arc = .quarterCircle(center: .zero, radius: 4)
        #expect(abs(arc.length - 2 * Double.pi) < 1e-10)
    }
}

// MARK: - Bounding Box Tests

@Suite("Geometry.Arc - Bounding Box")
struct GeometryArc_BoundingBoxTests {
    @Test("Bounding box of quarter circle")
    func boundingBoxQuarter() {
        let arc: Geometry<Double, Void>.Arc = .quarterCircle(center: .zero, radius: 5)
        let bbox = arc.boundingBox
        #expect(abs(bbox.llx.value) < 1e-10)
        #expect(abs(bbox.lly.value) < 1e-10)
        #expect(abs(bbox.urx.value - 5) < 1e-10)
        #expect(abs(bbox.ury.value - 5) < 1e-10)
    }

    @Test("Bounding box of semicircle")
    func boundingBoxSemicircle() {
        let arc: Geometry<Double, Void>.Arc = .semicircle(center: .zero, radius: 5)
        let bbox = arc.boundingBox
        #expect(abs(bbox.llx.value - (-5)) < 1e-10)
        #expect(abs(bbox.lly.value) < 1e-10)
        #expect(abs(bbox.urx.value - 5) < 1e-10)
        #expect(abs(bbox.ury.value - 5) < 1e-10)
    }

    @Test("Bounding box of full circle")
    func boundingBoxFullCircle() {
        let arc: Geometry<Double, Void>.Arc = .fullCircle(center: .zero, radius: 5)
        let bbox = arc.boundingBox
        #expect(abs(bbox.llx.value - (-5)) < 1e-10)
        #expect(abs(bbox.lly.value - (-5)) < 1e-10)
        #expect(abs(bbox.urx.value - 5) < 1e-10)
        #expect(abs(bbox.ury.value - 5) < 1e-10)
    }
}

// MARK: - Containment Tests

@Suite("Geometry.Arc - Containment")
struct GeometryArc_ContainmentTests {
    @Test("Contains point on arc")
    func containsPoint() {
        let arc: Geometry<Double, Void>.Arc = .quarterCircle(center: .zero, radius: 5)
        let x = 5 * Double.cos(Double.pi / 4)
        let y = 5 * Double.sin(Double.pi / 4)
        let point: Geometry<Double, Void>.Point<2> = .init(
            x: Geometry<Double, Void>.X(x),
            y: Geometry<Double, Void>.Y(y)
        )
        #expect(arc.contains(point))
    }

    @Test("Does not contain point outside arc range")
    func doesNotContainOutsideRange() {
        let arc: Geometry<Double, Void>.Arc = .quarterCircle(center: .zero, radius: 5)
        let point: Geometry<Double, Void>.Point<2> = .init(x: -5, y: 0)
        #expect(!arc.contains(point))
    }

    @Test("Does not contain point at wrong radius")
    func doesNotContainWrongRadius() {
        let arc: Geometry<Double, Void>.Arc = .quarterCircle(center: .zero, radius: 5)
        let point: Geometry<Double, Void>.Point<2> = .init(x: 3, y: 3)
        #expect(!arc.contains(point))
    }
}

// MARK: - Transformation Tests

@Suite("Geometry.Arc - Transformations")
struct GeometryArc_TransformationTests {
    @Test("Translation")
    func translation() {
        let arc: Geometry<Double, Void>.Arc = .semicircle(center: .zero, radius: 5)
        let translated = arc.translated(by: .init(dx: 10, dy: 20))
        #expect(translated.center.x == 10)
        #expect(translated.center.y == 20)
        #expect(translated.radius == 5)
    }

    @Test("Scaling")
    func scaling() {
        let arc: Geometry<Double, Void>.Arc = .semicircle(center: .zero, radius: 5)
        let scaled = arc.scaled(by: 2)
        #expect(scaled.radius == 10)
        #expect(scaled.startAngle == arc.startAngle)
        #expect(scaled.endAngle == arc.endAngle)
    }

    @Test("Reversed arc")
    func reversed() {
        let arc: Geometry<Double, Void>.Arc = .init(
            center: .zero,
            radius: 5,
            startAngle: .zero,
            endAngle: .pi
        )
        let reversed = arc.reversed
        #expect(reversed.startAngle == arc.endAngle)
        #expect(reversed.endAngle == arc.startAngle)
    }
}

// MARK: - Bezier Conversion Tests

@Suite("Geometry.Arc - Bezier Conversion")
struct GeometryArc_BezierTests {
    @Test("Quarter arc to Beziers")
    func quarterArcToBeziers() {
        let arc: Geometry<Double, Void>.Arc = .quarterCircle(center: .zero, radius: 5)
        let beziers = [Geometry<Double, Void>.Bezier](arc: arc)
        #expect(beziers.count == 1)
        #expect(beziers[0].degree == 3)
    }

    @Test("Semicircle to Beziers")
    func semicircleToBeziers() {
        let arc: Geometry<Double, Void>.Arc = .semicircle(center: .zero, radius: 5)
        let beziers = [Geometry<Double, Void>.Bezier](arc: arc)
        #expect(beziers.count == 2)
    }

    @Test("Full circle to Beziers")
    func fullCircleToBeziers() {
        let arc: Geometry<Double, Void>.Arc = .fullCircle(center: .zero, radius: 5)
        let beziers = [Geometry<Double, Void>.Bezier](arc: arc)
        #expect(beziers.count == 4)
    }

    @Test("Beziers start and end match arc")
    func beziersMatchArc() {
        let arc: Geometry<Double, Void>.Arc = .quarterCircle(center: .zero, radius: 5)
        let beziers = [Geometry<Double, Void>.Bezier](arc: arc)

        let firstBezier = beziers.first!
        #expect(abs(firstBezier.startPoint!.x.value - arc.startPoint.x.value) < 1e-10)
        #expect(abs(firstBezier.startPoint!.y.value - arc.startPoint.y.value) < 1e-10)

        let lastBezier = beziers.last!
        #expect(abs(lastBezier.endPoint!.x.value - arc.endPoint.x.value) < 1e-10)
        #expect(abs(lastBezier.endPoint!.y.value - arc.endPoint.y.value) < 1e-10)
    }
}

// MARK: - Functorial Map Tests

@Suite("Geometry.Arc - Functorial Map")
struct GeometryArc_MapTests {
    @Test("Arc map to different scalar type")
    func arcMap() {
        let arc: Geometry<Double, Void>.Arc = .semicircle(center: .zero, radius: 5)
        let mapped: Geometry<Float, Void>.Arc = arc.map { Float($0) }
        #expect(mapped.center.x.value == 0)
        #expect(mapped.radius.value == 5)
    }
}
