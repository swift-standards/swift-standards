// Geometry.Ellipse Tests.swift
// Tests for Geometry.Ellipse type.

import Angle
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

private func isApproxScalar(_ a: Double, _ b: Double, tol: Double = 1e-10) -> Bool {
    return abs(a - b) < tol
}

private func isApprox(_ a: Radian<Double>, _ b: Radian<Double>, tol: Double = 1e-10) -> Bool {
    let diff = a - b
    return diff > Radian(-tol) && diff < Radian(tol)
}

// MARK: - Initialization Tests

@Suite
struct `Geometry.Ellipse - Initialization` {
    @Test
    func `Ellipse initialization`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(
            center: .init(x: 10, y: 20),
            semiMajor: 8,
            semiMinor: 5,
            rotation: .zero
        )
        #expect(ellipse.center.x == 10)
        #expect(ellipse.center.y == 20)
        #expect(ellipse.semiMajor == 8)
        #expect(ellipse.semiMinor == 5)
        #expect(ellipse.rotation == .zero)
    }

    @Test
    func `Axis-aligned ellipse at origin`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(semiMajor: 10, semiMinor: 5)
        #expect(ellipse.center.x == 0)
        #expect(ellipse.center.y == 0)
        #expect(ellipse.rotation == .zero)
    }

    @Test
    func `Circle as special ellipse`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .circle(
            center: .init(x: 5, y: 5),
            radius: 10
        )
        #expect(ellipse.semiMajor == 10)
        #expect(ellipse.semiMinor == 10)
    }

    @Test
    func `Ellipse from circle`() {
        let circle: Geometry<Double, Void>.Circle = .init(
            center: .init(x: 5, y: 10),
            radius: 7
        )
        let ellipse = Geometry<Double, Void>.Ellipse(circle)
        #expect(ellipse.center.x == 5)
        #expect(ellipse.center.y == 10)
        #expect(ellipse.semiMajor == 7)
        #expect(ellipse.semiMinor == 7)
        #expect(ellipse.rotation == .zero)
        #expect(ellipse.isCircle)
    }
}

// MARK: - Properties Tests

@Suite
struct `Geometry.Ellipse - Properties` {
    @Test
    func `Major and minor axes`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(semiMajor: 10, semiMinor: 5)
        #expect(ellipse.majorAxis == 20)
        #expect(ellipse.minorAxis == 10)
    }

    @Test
    func `Eccentricity of circle is zero`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .circle(center: .zero, radius: 10)
        #expect(abs(ellipse.eccentricity) < 1e-10)
    }

    @Test
    func `Eccentricity of elongated ellipse`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(semiMajor: 5, semiMinor: 3)
        // e = sqrt(1 - (b/a)^2) = sqrt(1 - 9/25) = sqrt(16/25) = 4/5 = 0.8
        #expect(abs(ellipse.eccentricity - 0.8) < 1e-10)
    }

    @Test
    func `Focal distance`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(semiMajor: 5, semiMinor: 3)
        // c = sqrt(a^2 - b^2) = sqrt(25 - 9) = 4
        #expect(isApprox(ellipse.focalDistance, Distance(4)))
    }

    @Test
    func `isCircle for circle`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .circle(center: .zero, radius: 5)
        #expect(ellipse.isCircle)
    }

    @Test
    func `isCircle for non-circle`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(semiMajor: 10, semiMinor: 5)
        #expect(!ellipse.isCircle)
    }
}

// MARK: - Foci Tests

@Suite
struct `Geometry.Ellipse - Foci` {
    @Test
    func `Foci of axis-aligned ellipse`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(semiMajor: 5, semiMinor: 3)
        let foci = ellipse.foci
        // c = sqrt(a^2 - b^2) = sqrt(25 - 9) = 4
        #expect(isApprox(foci.f1.x, X(-4)))
        #expect(isApprox(foci.f1.y, Y(0)))
        #expect(isApprox(foci.f2.x, X(4)))
        #expect(isApprox(foci.f2.y, Y(0)))
    }

    @Test
    func `Foci of circle are coincident`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .circle(center: .zero, radius: 5)
        let foci = ellipse.foci
        #expect(isApprox(foci.f1.x, X(0)))
        #expect(isApprox(foci.f1.y, Y(0)))
        #expect(isApprox(foci.f2.x, X(0)))
        #expect(isApprox(foci.f2.y, Y(0)))
    }
}

// MARK: - Static Functions Tests

@Suite
struct `Geometry.Ellipse - Static Functions` {
    @Test
    func `Geometry.area(of:) ellipse`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(semiMajor: 5, semiMinor: 3)
        let area = Geometry.area(of: ellipse)
        // Area = π * a * b = π * 5 * 3 = 15π
        #expect(isApproxScalar(area, 15 * .pi))
    }

    @Test
    func `Geometry.contains(_:point:) center`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(
            center: .init(x: 5, y: 5),
            semiMajor: 10,
            semiMinor: 5
        )
        #expect(Geometry.contains(ellipse, point: ellipse.center))
    }

    @Test
    func `Geometry.contains(_:point:) interior point`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(semiMajor: 10, semiMinor: 5)
        let point: Geometry<Double, Void>.Point<2> = .init(x: 5, y: 2)
        #expect(Geometry.contains(ellipse, point: point))
    }

    @Test
    func `Geometry.contains(_:point:) exterior point`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(semiMajor: 10, semiMinor: 5)
        let point: Geometry<Double, Void>.Point<2> = .init(x: 15, y: 0)
        #expect(!Geometry.contains(ellipse, point: point))
    }

    @Test
    func `Geometry.point(of:at:) at angle 0`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(semiMajor: 10, semiMinor: 5)
        let point = Geometry.point(of: ellipse, at: .zero)
        #expect(isApprox(point.x, X(10)))
        #expect(isApprox(point.y, Y(0)))
    }

    @Test
    func `Geometry.point(of:at:) at angle π/2`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(semiMajor: 10, semiMinor: 5)
        let point = Geometry.point(of: ellipse, at: .halfPi)
        #expect(isApprox(point.x, X(0)))
        #expect(isApprox(point.y, Y(5)))
    }

    @Test
    func `Geometry.point(of:at:) at angle π`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(semiMajor: 10, semiMinor: 5)
        let point = Geometry.point(of: ellipse, at: .pi)
        #expect(isApprox(point.x, X(-10)))
        #expect(isApprox(point.y, Y(0)))
    }
}

// MARK: - Area and Perimeter Tests

@Suite
struct `Geometry.Ellipse - Area and Perimeter` {
    @Test
    func `Area property matches static function`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(semiMajor: 5, semiMinor: 3)
        #expect(isApproxScalar(ellipse.area, 15 * .pi))
    }

    @Test
    func `Perimeter approximation for circle`() {
        let circle: Geometry<Double, Void>.Ellipse = .circle(center: .zero, radius: 5)
        #expect(isApprox(circle.perimeter, Distance(10 * .pi), tol: 0.01))
    }
}

// MARK: - Point on Ellipse Tests

@Suite
struct `Geometry.Ellipse - Parametric Points` {
    @Test
    func `Point at parameter 0`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(semiMajor: 10, semiMinor: 5)
        let point = ellipse.point(at: .zero)
        #expect(isApprox(point.x, X(10)))
        #expect(isApprox(point.y, Y(0)))
    }

    @Test
    func `Point at parameter π/2`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(semiMajor: 10, semiMinor: 5)
        let point = ellipse.point(at: .halfPi)
        #expect(isApprox(point.x, X(0)))
        #expect(isApprox(point.y, Y(5)))
    }

    @Test
    func `Point at parameter π`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(semiMajor: 10, semiMinor: 5)
        let point = ellipse.point(at: .pi)
        #expect(isApprox(point.x, X(-10)))
        #expect(isApprox(point.y, Y(0)))
    }

    @Test
    func `Tangent at parameter`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(semiMajor: 10, semiMinor: 5)
        let tangent = ellipse.tangent(at: .zero)
        // Tangent at rightmost point should point upward
        #expect(tangent.dy > Dy(0))
    }
}

// MARK: - Containment Tests

@Suite
struct `Geometry.Ellipse - Containment` {
    @Test
    func `Contains center`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(
            center: .init(x: 5, y: 5),
            semiMajor: 10,
            semiMinor: 5
        )
        #expect(ellipse.contains(ellipse.center))
    }

    @Test
    func `Contains point on boundary`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(semiMajor: 10, semiMinor: 5)
        let point: Geometry<Double, Void>.Point<2> = .init(x: 10, y: 0)
        #expect(ellipse.contains(point))
    }

    @Test
    func `Contains interior point`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(semiMajor: 10, semiMinor: 5)
        let point: Geometry<Double, Void>.Point<2> = .init(x: 5, y: 2)
        #expect(ellipse.contains(point))
    }

    @Test
    func `Does not contain exterior point`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(semiMajor: 10, semiMinor: 5)
        let point: Geometry<Double, Void>.Point<2> = .init(x: 15, y: 0)
        #expect(!ellipse.contains(point))
    }
}

// MARK: - Bounding Box Tests

@Suite
struct `Geometry.Ellipse - Bounding Box` {
    @Test
    func `Bounding box axis-aligned`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(semiMajor: 10, semiMinor: 5)
        let bbox = ellipse.boundingBox
        #expect(isApprox(bbox.llx, X(-10)))
        #expect(isApprox(bbox.lly, Y(-5)))
        #expect(isApprox(bbox.urx, X(10)))
        #expect(isApprox(bbox.ury, Y(5)))
    }

    @Test
    func `Bounding box with center offset`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(
            center: .init(x: 10, y: 20),
            semiMajor: 5,
            semiMinor: 3
        )
        let bbox = ellipse.boundingBox
        #expect(isApprox(bbox.llx, X(5)))
        #expect(isApprox(bbox.lly, Y(17)))
        #expect(isApprox(bbox.urx, X(15)))
        #expect(isApprox(bbox.ury, Y(23)))
    }
}

// MARK: - Circle Conversion Tests

@Suite
struct `Geometry.Ellipse - Circle Conversion` {
    @Test
    func `Circle from circular ellipse`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .circle(center: .zero, radius: 5)
        let circle = Geometry<Double, Void>.Circle(ellipse)
        #expect(circle != nil)
        #expect(circle?.radius == 5)
    }

    @Test
    func `Circle from non-circular ellipse is nil`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(semiMajor: 10, semiMinor: 5)
        let circle = Geometry<Double, Void>.Circle(ellipse)
        #expect(circle == nil)
    }
}

// MARK: - Transformation Tests

@Suite
struct `Geometry.Ellipse - Transformations` {
    @Test
    func `Translation`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(semiMajor: 10, semiMinor: 5)
        let translated = ellipse.translated(by: .init(dx: 5, dy: 10))
        #expect(translated.center.x == X(5))
        #expect(translated.center.y == Y(10))
        #expect(translated.semiMajor == Distance(10))
        #expect(translated.semiMinor == Distance(5))
    }

    @Test
    func `Scaling`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(semiMajor: 10, semiMinor: 5)
        let scaled = ellipse.scaled(by: 2)
        #expect(scaled.semiMajor == Distance(20))
        #expect(scaled.semiMinor == Distance(10))
    }

    @Test
    func `Rotation`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(semiMajor: 10, semiMinor: 5)
        let rotated = ellipse.rotated(by: .halfPi)
        #expect(isApprox(rotated.rotation, .halfPi))
    }
}

// MARK: - Functorial Map Tests

@Suite
struct `Geometry.Ellipse - Functorial Map` {
    @Test
    func `Ellipse map to different scalar type`() {
        let ellipse: Geometry<Double, Void>.Ellipse = .init(semiMajor: 10, semiMinor: 5)
        let mapped: Geometry<Float, Void>.Ellipse = ellipse.map { Float($0) }
        let expectedMajor: Linear<Float, Void>.Magnitude = 10
        let expectedMinor: Linear<Float, Void>.Magnitude = 5
        #expect(mapped.semiMajor == expectedMajor)
        #expect(mapped.semiMinor == expectedMinor)
    }
}
