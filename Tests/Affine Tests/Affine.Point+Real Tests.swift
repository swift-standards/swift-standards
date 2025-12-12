// Affine.Point+Real Tests.swift
// Tests for Affine.Point+Real.swift polar coordinates and rotation

import Angle
import Foundation
import Testing

@testable import Affine
@testable import Algebra

@Suite("Affine.Point+Real Tests")
struct AffinePointRealTests {
    typealias Point2 = Affine<Double, Void>.Point<2>

    // MARK: - Polar Coordinate Tests

    @Suite("Polar Coordinates")
    struct PolarTests {
        @Test("Create point from polar coordinates (0 degrees)")
        func polarZeroDegrees() {
            let p = Point2.polar(radius: .init(5.0), angle: Degree(0).radians)
            #expect(abs(p.x.value - 5.0) < 1e-10)
            #expect(abs(p.y.value - 0.0) < 1e-10)
        }

        @Test("Create point from polar coordinates (90 degrees)")
        func polar90Degrees() {
            let p = Point2.polar(radius: .init(5.0), angle: Degree(90).radians)
            #expect(abs(p.x.value - 0.0) < 1e-10)
            #expect(abs(p.y.value - 5.0) < 1e-10)
        }

        @Test("Create point from polar coordinates (180 degrees)")
        func polar180Degrees() {
            let p = Point2.polar(radius: .init(5.0), angle: Degree(180).radians)
            #expect(abs(p.x.value - (-5.0)) < 1e-10)
            #expect(abs(p.y.value - 0.0) < 1e-10)
        }

        @Test("Create point from polar coordinates (270 degrees)")
        func polar270Degrees() {
            let p = Point2.polar(radius: .init(5.0), angle: Degree(270).radians)
            #expect(abs(p.x.value - 0.0) < 1e-10)
            #expect(abs(p.y.value - (-5.0)) < 1e-10)
        }

        @Test("Create point from polar coordinates (45 degrees)")
        func polar45Degrees() {
            let p = Point2.polar(radius: .init(1.0), angle: Degree(45).radians)
            let expected = 1.0 / sqrt(2.0)
            #expect(abs(p.x.value - expected) < 1e-10)
            #expect(abs(p.y.value - expected) < 1e-10)
        }

        @Test("Angle of point at (1, 0)")
        func angleAtOneZero() {
            let p = Point2(x: 1, y: 0)
            let angle = p.angle
            #expect(abs(angle.degrees.value) < 1e-10)
        }

        @Test("Angle of point at (0, 1)")
        func angleAtZeroOne() {
            let p = Point2(x: 0, y: 1)
            let angle = p.angle
            #expect(abs(angle.degrees.value - 90) < 1e-10)
        }

        @Test("Angle of point at (-1, 0)")
        func angleAtMinusOneZero() {
            let p = Point2(x: -1, y: 0)
            let angle = p.angle
            #expect(abs(abs(angle.degrees.value) - 180) < 1e-10)
        }

        @Test("Angle of point at (0, -1)")
        func angleAtZeroMinusOne() {
            let p = Point2(x: 0, y: -1)
            let angle = p.angle
            #expect(abs(angle.degrees.value - (-90)) < 1e-10)
        }

        @Test("Radius of point")
        func radius() {
            let p = Point2(x: 3, y: 4)
            #expect(p.radius.value == 5.0)
        }

        @Test("Radius of origin")
        func radiusOrigin() {
            let p = Point2.zero
            #expect(p.radius.value == 0.0)
        }

        @Test("Polar round-trip conversion", arguments: [
            (5.0, 0.0),
            (5.0, 45.0),
            (5.0, 90.0),
            (3.0, 135.0),
            (7.0, 270.0)
        ])
        func polarRoundTrip(radius: Double, deg: Double) {
            let angle = Degree(deg).radians
            let p = Point2.polar(radius: .init(radius), angle: angle)
            #expect(abs(p.radius.value - radius) < 1e-10)

            // Normalize angles for comparison
            let angleDiff = abs(p.angle.degrees.value - deg)
            let normalizedDiff = min(angleDiff, abs(angleDiff - 360), abs(angleDiff + 360))
            #expect(normalizedDiff < 1e-8)
        }
    }

    // MARK: - Rotation Tests

    @Suite("Rotation")
    struct RotationTests {
        @Test("Rotate by 90 degrees around origin (radians)")
        func rotate90Radians() {
            let p = Point2(x: 1, y: 0)
            let rotated = Point2.rotated(p, by: Degree(90))
            #expect(abs(rotated.x.value - 0.0) < 1e-10)
            #expect(abs(rotated.y.value - 1.0) < 1e-10)
        }

        @Test("Rotate by 90 degrees around origin instance method (radians)")
        func rotate90RadiansInstance() {
            let p = Point2(x: 1, y: 0)
            let rotated = p.rotated(by: Degree(90))
            #expect(abs(rotated.x.value - 0.0) < 1e-10)
            #expect(abs(rotated.y.value - 1.0) < 1e-10)
        }

        @Test("Rotate by 180 degrees around origin")
        func rotate180() {
            let p = Point2(x: 1, y: 0)
            let rotated = Point2.rotated(p, by: Degree(180))
            #expect(abs(rotated.x.value - (-1.0)) < 1e-10)
            #expect(abs(rotated.y.value - 0.0) < 1e-10)
        }

        @Test("Rotate by 270 degrees around origin")
        func rotate270() {
            let p = Point2(x: 1, y: 0)
            let rotated = Point2.rotated(p, by: Degree(270))
            #expect(abs(rotated.x.value - 0.0) < 1e-10)
            #expect(abs(rotated.y.value - (-1.0)) < 1e-10)
        }

        @Test("Rotate by 45 degrees around origin")
        func rotate45() {
            let p = Point2(x: 1, y: 0)
            let rotated = Point2.rotated(p, by: Degree(45))
            let expected = 1.0 / sqrt(2.0)
            #expect(abs(rotated.x.value - expected) < 1e-10)
            #expect(abs(rotated.y.value - expected) < 1e-10)
        }

        @Test("Rotate by degrees (90 degrees)")
        func rotateByDegrees90() {
            let p = Point2(x: 1, y: 0)
            let rotated = Point2.rotated(p, by: Degree(90))
            #expect(abs(rotated.x.value - 0.0) < 1e-10)
            #expect(abs(rotated.y.value - 1.0) < 1e-10)
        }

        @Test("Rotate by degrees instance method")
        func rotateByDegreesInstance() {
            let p = Point2(x: 1, y: 0)
            let rotated = p.rotated(by: Degree(90))
            #expect(abs(rotated.x.value - 0.0) < 1e-10)
            #expect(abs(rotated.y.value - 1.0) < 1e-10)
        }

        @Test("Rotation preserves distance from origin", arguments: [
            (Point2(x: 3, y: 4), 45.0),
            (Point2(x: 1, y: 1), 90.0),
            (Point2(x: 5, y: 0), 180.0),
            (Point2(x: -2, y: 3), 270.0)
        ])
        func rotationPreservesDistance(p: Point2, degrees: Double) {
            let rotated = Point2.rotated(p, by: Degree(degrees))
            let originalDist = p.distance(to: .zero)
            let rotatedDist = rotated.distance(to: .zero)
            #expect(abs(originalDist - rotatedDist) < 1e-10)
        }

        @Test("Rotate around custom center (90 degrees)")
        func rotateAroundCenter90() {
            let center = Point2(x: 1, y: 1)
            let p = Point2(x: 2, y: 1)
            let rotated = Point2.rotated(p, by: Degree(90), around: center)
            #expect(abs(rotated.x.value - 1.0) < 1e-10)
            #expect(abs(rotated.y.value - 2.0) < 1e-10)
        }

        @Test("Rotate around custom center instance method")
        func rotateAroundCenterInstance() {
            let center = Point2(x: 1, y: 1)
            let p = Point2(x: 2, y: 1)
            let rotated = p.rotated(by: Degree(90), around: center)
            #expect(abs(rotated.x.value - 1.0) < 1e-10)
            #expect(abs(rotated.y.value - 2.0) < 1e-10)
        }

        @Test("Rotate around custom center (180 degrees)")
        func rotateAroundCenter180() {
            let center = Point2(x: 0, y: 0)
            let p = Point2(x: 1, y: 1)
            let rotated = Point2.rotated(p, by: Degree(180), around: center)
            #expect(abs(rotated.x.value - (-1.0)) < 1e-10)
            #expect(abs(rotated.y.value - (-1.0)) < 1e-10)
        }

        @Test("Rotate around center preserves distance from center", arguments: [
            (Point2(x: 5, y: 5), Point2(x: 8, y: 5), 45.0),
            (Point2(x: 0, y: 0), Point2(x: 3, y: 4), 90.0),
            (Point2(x: 1, y: 1), Point2(x: 1, y: 2), 180.0)
        ])
        func rotateAroundCenterPreservesDistance(center: Point2, p: Point2, degrees: Double) {
            let rotated = Point2.rotated(p, by: Degree(degrees), around: center)
            let originalDist = p.distance(to: center)
            let rotatedDist = rotated.distance(to: center)
            #expect(abs(originalDist - rotatedDist) < 1e-10)
        }

        @Test("Rotate around custom center by degrees (90 degrees)")
        func rotateAroundCenterByDegrees() {
            let center = Point2(x: 1, y: 1)
            let p = Point2(x: 2, y: 1)
            let rotated = Point2.rotated(p, by: Degree(90), around: center)
            #expect(abs(rotated.x.value - 1.0) < 1e-10)
            #expect(abs(rotated.y.value - 2.0) < 1e-10)
        }

        @Test("Rotate around custom center by degrees instance method")
        func rotateAroundCenterByDegreesInstance() {
            let center = Point2(x: 1, y: 1)
            let p = Point2(x: 2, y: 1)
            let rotated = p.rotated(by: Degree(90), around: center)
            #expect(abs(rotated.x.value - 1.0) < 1e-10)
            #expect(abs(rotated.y.value - 2.0) < 1e-10)
        }

        @Test("Multiple rotations compose correctly")
        func multipleRotations() {
            let p = Point2(x: 1, y: 0)
            let rotated1 = Point2.rotated(p, by: Degree(45))
            let rotated2 = Point2.rotated(rotated1, by: Degree(45))
            let rotatedDirect = Point2.rotated(p, by: Degree(90))
            #expect(abs(rotated2.x.value - rotatedDirect.x.value) < 1e-10)
            #expect(abs(rotated2.y.value - rotatedDirect.y.value) < 1e-10)
        }
    }
}
