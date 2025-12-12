// Geometry.Bezier Tests.swift
// Tests for Geometry.Bezier type.

import Angle
import Testing

@testable import Affine
@testable import Algebra
@testable import Algebra_Linear
@testable import Geometry

// MARK: - Initialization Tests

@Suite
struct `Geometry.Bezier - Initialization` {
    @Test
    func `Bezier initialization`() {
        let bezier: Geometry<Double, Void>.Bezier = .init(controlPoints: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 2),
            .init(x: 3, y: 2),
            .init(x: 4, y: 0),
        ])
        #expect(bezier.controlPoints.count == 4)
    }

    @Test
    func `Linear Bezier`() {
        let bezier: Geometry<Double, Void>.Bezier = .linear(
            from: .init(x: 0, y: 0),
            to: .init(x: 10, y: 10)
        )
        #expect(bezier.degree == 1)
        #expect(bezier.controlPoints.count == 2)
    }

    @Test
    func `Quadratic Bezier`() {
        let bezier: Geometry<Double, Void>.Bezier = .quadratic(
            from: .init(x: 0, y: 0),
            control: .init(x: 5, y: 10),
            to: .init(x: 10, y: 0)
        )
        #expect(bezier.degree == 2)
        #expect(bezier.controlPoints.count == 3)
    }

    @Test
    func `Cubic Bezier`() {
        let bezier: Geometry<Double, Void>.Bezier = .cubic(
            from: .init(x: 0, y: 0),
            control1: .init(x: 1, y: 2),
            control2: .init(x: 3, y: 2),
            to: .init(x: 4, y: 0)
        )
        #expect(bezier.degree == 3)
        #expect(bezier.controlPoints.count == 4)
    }
}

// MARK: - Properties Tests

@Suite
struct `Geometry.Bezier - Properties` {
    @Test
    func `Degree property`() {
        let linear: Geometry<Double, Void>.Bezier = .linear(from: .zero, to: .init(x: 1, y: 1))
        #expect(linear.degree == 1)

        let cubic: Geometry<Double, Void>.Bezier = .cubic(
            from: .zero,
            control1: .init(x: 1, y: 1),
            control2: .init(x: 2, y: 1),
            to: .init(x: 3, y: 0)
        )
        #expect(cubic.degree == 3)
    }

    @Test
    func `isValid`() {
        let valid: Geometry<Double, Void>.Bezier = .linear(from: .zero, to: .init(x: 1, y: 1))
        #expect(valid.isValid)

        let invalid: Geometry<Double, Void>.Bezier = .init(controlPoints: [.zero])
        #expect(!invalid.isValid)
    }

    @Test
    func `Start and end points`() {
        let bezier: Geometry<Double, Void>.Bezier = .cubic(
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
}

// MARK: - Evaluation Tests

@Suite
struct `Geometry.Bezier - Evaluation` {
    @Test
    func `Point at t=0`() {
        let bezier: Geometry<Double, Void>.Bezier = .cubic(
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

    @Test
    func `Point at t=1`() {
        let bezier: Geometry<Double, Void>.Bezier = .cubic(
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

    @Test
    func `Point at t=0.5 for linear`() {
        let bezier: Geometry<Double, Void>.Bezier = .linear(
            from: .init(x: 0, y: 0),
            to: .init(x: 10, y: 10)
        )
        let point = bezier.point(at: 0.5)!
        #expect(abs(point.x.value - 5) < 1e-10)
        #expect(abs(point.y.value - 5) < 1e-10)
    }

    @Test
    func `Point at t=0.5 for quadratic`() {
        let bezier: Geometry<Double, Void>.Bezier = .quadratic(
            from: .init(x: 0, y: 0),
            control: .init(x: 2, y: 4),
            to: .init(x: 4, y: 0)
        )
        let point = bezier.point(at: 0.5)!
        #expect(abs(point.x.value - 2) < 1e-10)
        #expect(abs(point.y.value - 2) < 1e-10)
    }
}

// MARK: - Derivative Tests

@Suite
struct `Geometry.Bezier - Derivative` {
    @Test
    func `Derivative of linear`() {
        let bezier: Geometry<Double, Void>.Bezier = .linear(
            from: .init(x: 0, y: 0),
            to: .init(x: 10, y: 20)
        )
        let deriv = bezier.derivative(at: 0.5)!
        #expect(abs(deriv.dx.value - 10) < 1e-10)
        #expect(abs(deriv.dy.value - 20) < 1e-10)
    }

    @Test
    func `Tangent is unit vector`() {
        let bezier: Geometry<Double, Void>.Bezier = .cubic(
            from: .init(x: 0, y: 0),
            control1: .init(x: 1, y: 2),
            control2: .init(x: 3, y: 2),
            to: .init(x: 4, y: 0)
        )
        let tangent = bezier.tangent(at: 0.5)!
        #expect(abs(tangent.length - 1) < 1e-10)
    }

    @Test
    func `Normal perpendicular to tangent`() {
        let bezier: Geometry<Double, Void>.Bezier = .cubic(
            from: .init(x: 0, y: 0),
            control1: .init(x: 1, y: 2),
            control2: .init(x: 3, y: 2),
            to: .init(x: 4, y: 0)
        )
        let tangent = bezier.tangent(at: 0.5)!
        let normal = bezier.normal(at: 0.5)!

        #expect(abs(tangent.dot(normal)) < 1e-10)
    }
}

// MARK: - Subdivision Tests

@Suite
struct `Geometry.Bezier - Subdivision` {
    @Test
    func `Split at t=0.5`() {
        let bezier: Geometry<Double, Void>.Bezier = .cubic(
            from: .init(x: 0, y: 0),
            control1: .init(x: 0, y: 10),
            control2: .init(x: 10, y: 10),
            to: .init(x: 10, y: 0)
        )
        let split = bezier.split(at: 0.5)!

        #expect(abs(split.left.startPoint!.x.value - 0) < 1e-10)
        #expect(abs(split.left.startPoint!.y.value - 0) < 1e-10)

        #expect(abs(split.right.endPoint!.x.value - 10) < 1e-10)
        #expect(abs(split.right.endPoint!.y.value - 0) < 1e-10)

        let midpoint = bezier.point(at: 0.5)!
        #expect(abs(split.left.endPoint!.x.value - midpoint.x.value) < 1e-10)
        #expect(abs(split.right.startPoint!.x.value - midpoint.x.value) < 1e-10)
    }

    @Test
    func `Subdivide into segments`() {
        let bezier: Geometry<Double, Void>.Bezier = .cubic(
            from: .init(x: 0, y: 0),
            control1: .init(x: 1, y: 2),
            control2: .init(x: 3, y: 2),
            to: .init(x: 4, y: 0)
        )
        let points = bezier.subdivide(into: 10)
        #expect(points.count == 11)

        #expect(abs(points[0].x.value - 0) < 1e-10)
        #expect(abs(points[10].x.value - 4) < 1e-10)
    }
}

// MARK: - Bounding Box Tests

@Suite
struct `Geometry.Bezier - Bounding Box` {
    @Test
    func `Conservative bounding box`() {
        let bezier: Geometry<Double, Void>.Bezier = .cubic(
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
}

// MARK: - Length Tests

@Suite
struct `Geometry.Bezier - Length` {
    @Test
    func `Length of linear Bezier`() {
        let bezier: Geometry<Double, Void>.Bezier = .linear(
            from: .init(x: 0, y: 0),
            to: .init(x: 3, y: 4)
        )
        let length = bezier.length(segments: 100)
        #expect(abs(length - 5) < 0.01)
    }

    @Test
    func `Length approximation`() {
        let bezier: Geometry<Double, Void>.Bezier = .cubic(
            from: .init(x: 0, y: 0),
            control1: .init(x: 0, y: 10),
            control2: .init(x: 10, y: 10),
            to: .init(x: 10, y: 0)
        )
        let length = bezier.length(segments: 1000)
        #expect(length > 10)
        #expect(length < 30)
    }
}

// MARK: - Transformation Tests

@Suite
struct `Geometry.Bezier - Transformations` {
    @Test
    func `Translation`() {
        let bezier: Geometry<Double, Void>.Bezier = .linear(
            from: .init(x: 0, y: 0),
            to: .init(x: 10, y: 10)
        )
        let translated = bezier.translated(by: .init(dx: 5, dy: 5))
        #expect(translated.startPoint?.x == 5)
        #expect(translated.startPoint?.y == 5)
        #expect(translated.endPoint?.x == 15)
        #expect(translated.endPoint?.y == 15)
    }

    @Test
    func `Scaling about point`() {
        let bezier: Geometry<Double, Void>.Bezier = .linear(
            from: .init(x: 0, y: 0),
            to: .init(x: 10, y: 0)
        )
        let scaled = bezier.scaled(by: 2, about: bezier.startPoint!)
        #expect(scaled.startPoint?.x == 0)
        #expect(scaled.endPoint?.x == 20)
    }

    @Test
    func `Reversed curve`() {
        let bezier: Geometry<Double, Void>.Bezier = .cubic(
            from: .init(x: 0, y: 0),
            control1: .init(x: 1, y: 2),
            control2: .init(x: 3, y: 2),
            to: .init(x: 4, y: 0)
        )
        let reversed = bezier.reversed
        #expect(reversed.startPoint?.x == 4)
        #expect(reversed.endPoint?.x == 0)
    }
}

// MARK: - Ellipse Approximation Tests

@Suite
struct `Geometry.Bezier - Ellipse Approximation` {
    @Test
    func `Approximating unit circle`() {
        let circle: Geometry<Double, Void>.Circle = .unit
        let beziers = Geometry<Double, Void>.Bezier.approximating(circle)
        #expect(beziers.count == 4)

        for b in beziers {
            #expect(b.degree == 3)
        }

        #expect(abs(beziers[0].startPoint!.x.value - 1) < 1e-10)
        #expect(abs(beziers[0].startPoint!.y.value) < 1e-10)

        #expect(abs(beziers[3].endPoint!.x.value - 1) < 1e-10)
        #expect(abs(beziers[3].endPoint!.y.value) < 1e-10)
    }

    @Test
    func `Approximating ellipse`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(semiMajor: 10, semiMinor: 5)
        let beziers = Geometry<Double, Void>.Bezier.approximating(ellipse)
        #expect(beziers.count == 4)

        #expect(abs(beziers[0].startPoint!.x.value - 10) < 1e-10)
        #expect(abs(beziers[0].startPoint!.y.value) < 1e-10)

        #expect(abs(beziers[1].startPoint!.x.value) < 1e-10)
        #expect(abs(beziers[1].startPoint!.y.value - 5) < 1e-10)
    }

    @Test
    func `Bezier approximation is continuous`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(
            center: .init(x: 5, y: 5),
            semiMajor: 10,
            semiMinor: 5
        )
        let beziers = Geometry<Double, Void>.Bezier.approximating(ellipse)

        for i in 0..<3 {
            let end = beziers[i].endPoint!
            let start = beziers[i + 1].startPoint!
            #expect(abs(end.x.value - start.x.value) < 1e-10)
            #expect(abs(end.y.value - start.y.value) < 1e-10)
        }

        let lastEnd = beziers[3].endPoint!
        let firstStart = beziers[0].startPoint!
        #expect(abs(lastEnd.x.value - firstStart.x.value) < 1e-10)
        #expect(abs(lastEnd.y.value - firstStart.y.value) < 1e-10)
    }
}

// MARK: - Functorial Map Tests

@Suite
struct `Geometry.Bezier - Functorial Map` {
    @Test
    func `Bezier map to different scalar type`() {
        let bezier: Geometry<Double, Void>.Bezier = .linear(
            from: .init(x: 0, y: 0),
            to: .init(x: 10, y: 20)
        )
        let mapped: Geometry<Float, Void>.Bezier = bezier.map { Float($0) }
        #expect(mapped.startPoint?.x.value == 0)
        #expect(mapped.endPoint?.x.value == 10)
    }
}
