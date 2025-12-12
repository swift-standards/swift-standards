// Geometry.AffineTransform+Symmetry Tests.swift

import Affine
import Angle
import Foundation
import Geometry
import Testing

@testable import Symmetry

@Suite
struct `Geometry.AffineTransform+Symmetry Tests` {

    // MARK: - Rotation initialization

    @Test
    func `Initialize from rotation creates correct transform`() {
        let rotation = Rotation<2, Double>(angle: .pi / 4)
        let transform = Affine<Double, Void>.Transform(rotation)

        // Check linear part matches rotation matrix
        let angle = Double.pi / 4
        let expectedCos = cos(angle)
        let expectedSin = sin(angle)

        #expect(abs(transform.linear.a - expectedCos) < 1e-10)
        #expect(abs(transform.linear.b + expectedSin) < 1e-10)
        #expect(abs(transform.linear.c - expectedSin) < 1e-10)
        #expect(abs(transform.linear.d - expectedCos) < 1e-10)

        // Translation should be zero
        #expect(transform.translation == .zero)
    }

    @Test
    func `Initialize from identity rotation creates identity transform`() {
        let rotation = Rotation<2, Double>.identity
        let transform = Affine<Double, Void>.Transform(rotation)

        #expect(transform.linear.a == 1)
        #expect(transform.linear.b == 0)
        #expect(transform.linear.c == 0)
        #expect(transform.linear.d == 1)
        #expect(transform.translation == .zero)
    }

    @Test
    func `Initialize from quarter turn rotation`() {
        let rotation = Rotation<2, Double>.quarterTurn
        let transform = Affine<Double, Void>.Transform(rotation)

        // 90 degrees: cos(π/2) ≈ 0, sin(π/2) ≈ 1
        #expect(abs(transform.linear.a) < 1e-10)      // cos(π/2)
        #expect(abs(transform.linear.b + 1) < 1e-10)  // -sin(π/2)
        #expect(abs(transform.linear.c - 1) < 1e-10)  // sin(π/2)
        #expect(abs(transform.linear.d) < 1e-10)      // cos(π/2)
        #expect(transform.translation == .zero)
    }

    // MARK: - Scale initialization

    @Test
    func `Initialize from scale creates correct transform`() {
        let scale = Scale<2, Double>(x: 2.0, y: 3.0)
        let transform = Affine<Double, Void>.Transform(scale)

        #expect(transform.linear.a == 2.0)
        #expect(transform.linear.b == 0)
        #expect(transform.linear.c == 0)
        #expect(transform.linear.d == 3.0)
        #expect(transform.translation == .zero)
    }

    @Test
    func `Initialize from identity scale creates identity transform`() {
        let scale = Scale<2, Double>.identity
        let transform = Affine<Double, Void>.Transform(scale)

        #expect(transform.linear.a == 1)
        #expect(transform.linear.b == 0)
        #expect(transform.linear.c == 0)
        #expect(transform.linear.d == 1)
        #expect(transform.translation == .zero)
    }

    @Test
    func `Initialize from uniform scale`() {
        let scale = Scale<2, Double>.uniform(2.5)
        let transform = Affine<Double, Void>.Transform(scale)

        #expect(transform.linear.a == 2.5)
        #expect(transform.linear.b == 0)
        #expect(transform.linear.c == 0)
        #expect(transform.linear.d == 2.5)
        #expect(transform.translation == .zero)
    }

    @Test
    func `Initialize from double scale`() {
        let scale = Scale<2, Double>.double
        let transform = Affine<Double, Void>.Transform(scale)

        #expect(transform.linear.a == 2)
        #expect(transform.linear.b == 0)
        #expect(transform.linear.c == 0)
        #expect(transform.linear.d == 2)
    }

    @Test
    func `Initialize from half scale`() {
        let scale = Scale<2, Double>.half
        let transform = Affine<Double, Void>.Transform(scale)

        #expect(transform.linear.a == 0.5)
        #expect(transform.linear.b == 0)
        #expect(transform.linear.c == 0)
        #expect(transform.linear.d == 0.5)
    }

    // MARK: - Shear initialization

    @Test
    func `Initialize from shear creates correct transform`() {
        let shear = Shear<2, Double>(x: 0.5, y: 0.3)
        let transform = Affine<Double, Void>.Transform(shear)

        #expect(transform.linear.a == 1)
        #expect(transform.linear.b == 0.5)
        #expect(transform.linear.c == 0.3)
        #expect(transform.linear.d == 1)
        #expect(transform.translation == .zero)
    }

    @Test
    func `Initialize from identity shear creates identity transform`() {
        let shear = Shear<2, Double>.identity
        let transform = Affine<Double, Void>.Transform(shear)

        #expect(transform.linear.a == 1)
        #expect(transform.linear.b == 0)
        #expect(transform.linear.c == 0)
        #expect(transform.linear.d == 1)
        #expect(transform.translation == .zero)
    }

    @Test
    func `Initialize from horizontal shear`() {
        let shear = Shear<2, Double>.horizontal(0.7)
        let transform = Affine<Double, Void>.Transform(shear)

        #expect(transform.linear.a == 1)
        #expect(transform.linear.b == 0.7)
        #expect(transform.linear.c == 0)
        #expect(transform.linear.d == 1)
    }

    @Test
    func `Initialize from vertical shear`() {
        let shear = Shear<2, Double>.vertical(0.4)
        let transform = Affine<Double, Void>.Transform(shear)

        #expect(transform.linear.a == 1)
        #expect(transform.linear.b == 0)
        #expect(transform.linear.c == 0.4)
        #expect(transform.linear.d == 1)
    }
}
