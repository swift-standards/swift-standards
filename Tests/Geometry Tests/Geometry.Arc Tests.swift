// Geometry.Arc Tests.swift
// Tests for Geometry.Arc type.

import Angle
import Testing

@testable import Affine
@testable import Algebra
@testable import Algebra_Linear
@testable import Geometry
@testable import RealModule

// MARK: - Test Helpers

private typealias Geo = Geometry<Double, Void>
private typealias X = Geo.X
private typealias Y = Geo.Y
private typealias Dx = Linear<Double, Void>.Dx
private typealias Dy = Linear<Double, Void>.Dy
private typealias Distance = Linear<Double, Void>.Magnitude
private typealias Width = Linear<Double, Void>.Width
private typealias Height = Linear<Double, Void>.Height

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

private func isApprox(_ a: Radian<Double>, _ b: Radian<Double>, tol: Double = 1e-10) -> Bool {
    let diff = a - b
    return diff > Radian(-tol) && diff < Radian(tol)
}

private func isApproxScalar(_ a: Double, _ b: Double, tol: Double = 1e-10) -> Bool {
    return abs(a - b) < tol
}

// MARK: - Initialization Tests

@Suite
struct `Geometry.Arc - Initialization` {
    @Test
    func `Arc initialization`() {
        let arc: Geometry<Double, Void>.Arc = .init(
            center: .init(x: 10, y: 20),
            radius: 5,
            startAngle: .zero,
            endAngle: .pi
        )
        #expect(arc.center.x == X(10))
        #expect(arc.center.y == Y(20))
        #expect(arc.radius == Distance(5))
        #expect(arc.startAngle == .zero)
        #expect(isApprox(arc.endAngle, .pi))
    }

    @Test
    func `Full circle arc`() {
        let arc: Geometry<Double, Void>.Arc = .fullCircle(center: .zero, radius: 5)
        #expect(arc.startAngle == .zero)
        #expect(isApprox(arc.endAngle, Radian<Double>(2 * Double.pi)))
        #expect(arc.isFullCircle)
    }

    @Test
    func `Semicircle arc`() {
        let arc: Geometry<Double, Void>.Arc = .semicircle(center: .zero, radius: 5)
        #expect(arc.startAngle == .zero)
        #expect(isApprox(arc.endAngle, .pi))
    }

    @Test
    func `Quarter circle arc`() {
        let arc: Geometry<Double, Void>.Arc = .quarterCircle(center: .zero, radius: 5)
        #expect(arc.startAngle == .zero)
        #expect(isApprox(arc.endAngle, .halfPi))
    }

    @Test
    func `Quarter circle with start angle`() {
        let arc: Geometry<Double, Void>.Arc = .quarterCircle(
            center: .zero,
            radius: 5,
            startAngle: .halfPi
        )
        #expect(isApprox(arc.startAngle, .halfPi))
        #expect(isApprox(arc.endAngle, .pi))
    }
}

// MARK: - Properties Tests

@Suite
struct `Geometry.Arc - Properties` {
    @Test
    func `Sweep angle`() {
        let arc: Geometry<Double, Void>.Arc = .init(
            center: .zero,
            radius: 5,
            startAngle: .zero,
            endAngle: .pi
        )
        #expect(isApprox(arc.sweep, .pi))
    }

    @Test
    func `Counter-clockwise sweep`() {
        let arc: Geometry<Double, Void>.Arc = .init(
            center: .zero,
            radius: 5,
            startAngle: .zero,
            endAngle: .pi
        )
        #expect(arc.isCounterClockwise)
    }

    @Test
    func `Clockwise sweep`() {
        let arc: Geometry<Double, Void>.Arc = .init(
            center: .zero,
            radius: 5,
            startAngle: .pi,
            endAngle: .zero
        )
        #expect(!arc.isCounterClockwise)
    }

    @Test
    func `Is full circle`() {
        let full: Geometry<Double, Void>.Arc = .fullCircle(center: .zero, radius: 5)
        #expect(full.isFullCircle)

        let half: Geometry<Double, Void>.Arc = .semicircle(center: .zero, radius: 5)
        #expect(!half.isFullCircle)
    }
}

// MARK: - Endpoints Tests

@Suite
struct `Geometry.Arc - Endpoints` {
    @Test
    func `Start point`() {
        let arc: Geometry<Double, Void>.Arc = .init(
            center: .zero,
            radius: 5,
            startAngle: .zero,
            endAngle: .pi
        )
        #expect(isApprox(arc.startPoint.x, X(5)))
        #expect(isApprox(arc.startPoint.y, Y(0)))
    }

    @Test
    func `End point`() {
        let arc: Geometry<Double, Void>.Arc = .init(
            center: .zero,
            radius: 5,
            startAngle: .zero,
            endAngle: .pi
        )
        #expect(isApprox(arc.endPoint.x, X(-5)))
        #expect(isApprox(arc.endPoint.y, Y(0)))
    }

    @Test
    func `Mid point`() {
        let arc: Geometry<Double, Void>.Arc = .init(
            center: .zero,
            radius: 5,
            startAngle: .zero,
            endAngle: .pi
        )
        #expect(isApprox(arc.midPoint.x, X(0)))
        #expect(isApprox(arc.midPoint.y, Y(5)))
    }

    @Test
    func `Start point with offset center`() {
        let arc: Geometry<Double, Void>.Arc = .init(
            center: .init(x: 10, y: 20),
            radius: 5,
            startAngle: .zero,
            endAngle: .pi
        )
        #expect(isApprox(arc.startPoint.x, X(15)))
        #expect(isApprox(arc.startPoint.y, Y(20)))
    }
}

// MARK: - Parametric Points Tests

@Suite
struct `Geometry.Arc - Parametric Points` {
    @Test
    func `Point at t=0`() {
        let arc: Geometry<Double, Void>.Arc = .init(
            center: .zero,
            radius: 5,
            startAngle: .zero,
            endAngle: .pi
        )
        let point = arc.point(at: 0)
        #expect(isApprox(point.x, arc.startPoint.x))
        #expect(isApprox(point.y, arc.startPoint.y))
    }

    @Test
    func `Point at t=1`() {
        let arc: Geometry<Double, Void>.Arc = .init(
            center: .zero,
            radius: 5,
            startAngle: .zero,
            endAngle: .pi
        )
        let point = arc.point(at: 1)
        #expect(isApprox(point.x, arc.endPoint.x))
        #expect(isApprox(point.y, arc.endPoint.y))
    }

    @Test
    func `Point at t=0.5`() {
        let arc: Geometry<Double, Void>.Arc = .init(
            center: .zero,
            radius: 5,
            startAngle: .zero,
            endAngle: .pi
        )
        let point = arc.point(at: 0.5)
        #expect(isApprox(point.x, arc.midPoint.x))
        #expect(isApprox(point.y, arc.midPoint.y))
    }
}

// MARK: - Tangent Tests

@Suite
struct `Geometry.Arc - Tangent` {
    @Test
    func `Tangent at t=0`() {
        let arc: Geometry<Double, Void>.Arc = .init(
            center: .zero,
            radius: 5,
            startAngle: .zero,
            endAngle: .pi
        )
        let tangent = arc.tangent(at: 0)
        #expect(isApprox(tangent.dx, Dx(0)))
        #expect(isApprox(tangent.dy, Dy(1)))
    }

    @Test
    func `Tangent at t=0.5`() {
        let arc: Geometry<Double, Void>.Arc = .init(
            center: .zero,
            radius: 5,
            startAngle: .zero,
            endAngle: .pi
        )
        let tangent = arc.tangent(at: 0.5)
        #expect(isApprox(tangent.dx, Dx(-1)))
        #expect(isApprox(tangent.dy, Dy(0)))
    }
}

// MARK: - Length Tests

@Suite
struct `Geometry.Arc - Length` {
    @Test
    func `Length of semicircle`() {
        let arc: Geometry<Double, Void>.Arc = .semicircle(center: .zero, radius: 5)
        #expect(isApprox(arc.length, Distance(5 * Double.pi)))
    }

    @Test
    func `Length of full circle`() {
        let arc: Geometry<Double, Void>.Arc = .fullCircle(center: .zero, radius: 5)
        #expect(isApprox(arc.length, Distance(10 * Double.pi)))
    }

    @Test
    func `Length of quarter circle`() {
        let arc: Geometry<Double, Void>.Arc = .quarterCircle(center: .zero, radius: 4)
        #expect(isApprox(arc.length, Distance(2 * Double.pi)))
    }
}

// MARK: - Bounding Box Tests

@Suite
struct `Geometry.Arc - Bounding Box` {
    @Test
    func `Bounding box of quarter circle`() {
        let arc: Geometry<Double, Void>.Arc = .quarterCircle(center: .zero, radius: 5)
        let bbox = arc.boundingBox
        #expect(isApprox(bbox.llx, X(0)))
        #expect(isApprox(bbox.lly, Y(0)))
        #expect(isApprox(bbox.urx, X(5)))
        #expect(isApprox(bbox.ury, Y(5)))
    }

    @Test
    func `Bounding box of semicircle`() {
        let arc: Geometry<Double, Void>.Arc = .semicircle(center: .zero, radius: 5)
        let bbox = arc.boundingBox
        #expect(isApprox(bbox.llx, X(-5)))
        #expect(isApprox(bbox.lly, Y(0)))
        #expect(isApprox(bbox.urx, X(5)))
        #expect(isApprox(bbox.ury, Y(5)))
    }

    @Test
    func `Bounding box of full circle`() {
        let arc: Geometry<Double, Void>.Arc = .fullCircle(center: .zero, radius: 5)
        let bbox = arc.boundingBox
        #expect(isApprox(bbox.llx, X(-5)))
        #expect(isApprox(bbox.lly, Y(-5)))
        #expect(isApprox(bbox.urx, X(5)))
        #expect(isApprox(bbox.ury, Y(5)))
    }
}

// MARK: - Containment Tests

@Suite
struct `Geometry.Arc - Containment` {
    @Test
    func `Contains point on arc`() {
        let arc: Geometry<Double, Void>.Arc = .quarterCircle(center: .zero, radius: 5)
        let x = 5 * Double.cos(Double.pi / 4)
        let y = 5 * Double.sin(Double.pi / 4)
        let point: Geometry<Double, Void>.Point<2> = .init(
            x: Geometry<Double, Void>.X(x),
            y: Geometry<Double, Void>.Y(y)
        )
        #expect(arc.contains(point))
    }

    @Test
    func `Does not contain point outside arc range`() {
        let arc: Geometry<Double, Void>.Arc = .quarterCircle(center: .zero, radius: 5)
        let point: Geometry<Double, Void>.Point<2> = .init(x: -5, y: 0)
        #expect(!arc.contains(point))
    }

    @Test
    func `Does not contain point at wrong radius`() {
        let arc: Geometry<Double, Void>.Arc = .quarterCircle(center: .zero, radius: 5)
        let point: Geometry<Double, Void>.Point<2> = .init(x: 3, y: 3)
        #expect(!arc.contains(point))
    }
}

// MARK: - Transformation Tests

@Suite
struct `Geometry.Arc - Transformations` {
    @Test
    func `Translation`() {
        let arc: Geometry<Double, Void>.Arc = .semicircle(center: .zero, radius: 5)
        let translated = arc.translated(by: .init(dx: 10, dy: 20))
        #expect(translated.center.x == X(10))
        #expect(translated.center.y == Y(20))
        #expect(translated.radius == Distance(5))
    }

    @Test
    func `Scaling`() {
        let arc: Geometry<Double, Void>.Arc = .semicircle(center: .zero, radius: 5)
        let scaled = arc.scaled(by: 2)
        #expect(scaled.radius == Distance(10))
        #expect(scaled.startAngle == arc.startAngle)
        #expect(scaled.endAngle == arc.endAngle)
    }

    @Test
    func `Reversed arc`() {
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

@Suite
struct `Geometry.Arc - Bezier Conversion` {
    @Test
    func `Quarter arc to Beziers`() {
        let arc: Geometry<Double, Void>.Arc = .quarterCircle(center: .zero, radius: 5)
        let beziers = [Geometry<Double, Void>.Bezier](arc: arc)
        #expect(beziers.count == 1)
        #expect(beziers[0].degree == 3)
    }

    @Test
    func `Semicircle to Beziers`() {
        let arc: Geometry<Double, Void>.Arc = .semicircle(center: .zero, radius: 5)
        let beziers = [Geometry<Double, Void>.Bezier](arc: arc)
        #expect(beziers.count == 2)
    }

    @Test
    func `Full circle to Beziers`() {
        let arc: Geometry<Double, Void>.Arc = .fullCircle(center: .zero, radius: 5)
        let beziers = [Geometry<Double, Void>.Bezier](arc: arc)
        #expect(beziers.count == 4)
    }

    @Test
    func `Beziers start and end match arc`() {
        let arc: Geometry<Double, Void>.Arc = .quarterCircle(center: .zero, radius: 5)
        let beziers = [Geometry<Double, Void>.Bezier](arc: arc)

        let firstBezier = beziers.first!
        #expect(isApprox(firstBezier.startPoint!.x, arc.startPoint.x))
        #expect(isApprox(firstBezier.startPoint!.y, arc.startPoint.y))

        let lastBezier = beziers.last!
        #expect(isApprox(lastBezier.endPoint!.x, arc.endPoint.x))
        #expect(isApprox(lastBezier.endPoint!.y, arc.endPoint.y))
    }
}

// MARK: - Functorial Map Tests

@Suite
struct `Geometry.Arc - Functorial Map` {
    @Test
    func `Arc map to different scalar type`() {
        let arc: Geometry<Double, Void>.Arc = .semicircle(center: .zero, radius: 5)
        let mapped: Geometry<Float, Void>.Arc = arc.map { Float($0) }
        let expectedX: Geometry<Float, Void>.X = 0
        let expectedRadius: Linear<Float, Void>.Magnitude = 5
        #expect(mapped.center.x == expectedX)
        #expect(mapped.radius == expectedRadius)
    }
}
