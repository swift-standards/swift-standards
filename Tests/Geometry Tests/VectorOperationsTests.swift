// VectorOperationsTests.swift
// Tests for vector operations including projection, rejection, and angle calculations.

import Testing
@testable import Geometry

@Suite("Vector Projection Tests")
struct VectorProjectionTests {
    @Test("Projection onto parallel vector")
    func projectionOntoParallel() {
        let v: Geometry<Double>.Vector<2> = .init(dx: 4, dy: 0)
        let onto: Geometry<Double>.Vector<2> = .init(dx: 1, dy: 0)

        let projection = v.projection(onto: onto)
        #expect(abs(projection.dx.value - 4) < 1e-10)
        #expect(abs(projection.dy.value) < 1e-10)
    }

    @Test("Projection onto perpendicular vector")
    func projectionOntoPerpendicular() {
        let v: Geometry<Double>.Vector<2> = .init(dx: 4, dy: 0)
        let onto: Geometry<Double>.Vector<2> = .init(dx: 0, dy: 1)

        let projection = v.projection(onto: onto)
        #expect(abs(projection.dx.value) < 1e-10)
        #expect(abs(projection.dy.value) < 1e-10)
    }

    @Test("Projection onto diagonal vector")
    func projectionOntoDiagonal() {
        let v: Geometry<Double>.Vector<2> = .init(dx: 3, dy: 0)
        let onto: Geometry<Double>.Vector<2> = .init(dx: 1, dy: 1)

        // Projection of (3,0) onto (1,1) should be (1.5, 1.5)
        let projection = v.projection(onto: onto)
        #expect(abs(projection.dx.value - 1.5) < 1e-10)
        #expect(abs(projection.dy.value - 1.5) < 1e-10)
    }

    @Test("Projection onto zero vector")
    func projectionOntoZero() {
        let v: Geometry<Double>.Vector<2> = .init(dx: 3, dy: 4)
        let onto: Geometry<Double>.Vector<2> = .zero

        let projection = v.projection(onto: onto)
        #expect(abs(projection.dx.value) < 1e-10)
        #expect(abs(projection.dy.value) < 1e-10)
    }
}

@Suite("Vector Rejection Tests")
struct VectorRejectionTests {
    @Test("Rejection from parallel vector")
    func rejectionFromParallel() {
        let v: Geometry<Double>.Vector<2> = .init(dx: 4, dy: 0)
        let from: Geometry<Double>.Vector<2> = .init(dx: 1, dy: 0)

        let rejection = v.rejection(from: from)
        #expect(abs(rejection.dx.value) < 1e-10)
        #expect(abs(rejection.dy.value) < 1e-10)
    }

    @Test("Rejection from perpendicular vector")
    func rejectionFromPerpendicular() {
        let v: Geometry<Double>.Vector<2> = .init(dx: 4, dy: 0)
        let from: Geometry<Double>.Vector<2> = .init(dx: 0, dy: 1)

        let rejection = v.rejection(from: from)
        #expect(abs(rejection.dx.value - 4) < 1e-10)
        #expect(abs(rejection.dy.value) < 1e-10)
    }

    @Test("Rejection from diagonal vector")
    func rejectionFromDiagonal() {
        let v: Geometry<Double>.Vector<2> = .init(dx: 3, dy: 0)
        let from: Geometry<Double>.Vector<2> = .init(dx: 1, dy: 1)

        // Rejection should be (3,0) - (1.5, 1.5) = (1.5, -1.5)
        let rejection = v.rejection(from: from)
        #expect(abs(rejection.dx.value - 1.5) < 1e-10)
        #expect(abs(rejection.dy.value - (-1.5)) < 1e-10)
    }

    @Test("Projection plus rejection equals original")
    func projectionPlusRejection() {
        let v: Geometry<Double>.Vector<2> = .init(dx: 5, dy: 7)
        let onto: Geometry<Double>.Vector<2> = .init(dx: 3, dy: 4)

        let projection = v.projection(onto: onto)
        let rejection = v.rejection(from: onto)
        let sum = projection + rejection

        #expect(abs(sum.dx.value - v.dx.value) < 1e-10)
        #expect(abs(sum.dy.value - v.dy.value) < 1e-10)
    }

    @Test("Projection and rejection are perpendicular")
    func projectionRejectionPerpendicular() {
        let v: Geometry<Double>.Vector<2> = .init(dx: 5, dy: 7)
        let onto: Geometry<Double>.Vector<2> = .init(dx: 3, dy: 4)

        let projection = v.projection(onto: onto)
        let rejection = v.rejection(from: onto)

        let dot = projection.dot(rejection)
        #expect(abs(dot) < 1e-10)
    }
}

@Suite("Vector Angle Tests")
struct VectorAngleTests {
    @Test("Angle to perpendicular vector")
    func angleToPerpendicular() {
        let v1: Geometry<Double>.Vector<2> = .init(dx: 1, dy: 0)
        let v2: Geometry<Double>.Vector<2> = .init(dx: 0, dy: 1)

        let angle = v1.angle(to: v2)
        #expect(abs(angle.value - Double.pi / 2) < 1e-10)
    }

    @Test("Angle to same direction")
    func angleToSameDirection() {
        let v1: Geometry<Double>.Vector<2> = .init(dx: 1, dy: 0)
        let v2: Geometry<Double>.Vector<2> = .init(dx: 2, dy: 0)

        let angle = v1.angle(to: v2)
        #expect(abs(angle.value) < 1e-10)
    }

    @Test("Angle to opposite direction")
    func angleToOppositeDirection() {
        let v1: Geometry<Double>.Vector<2> = .init(dx: 1, dy: 0)
        let v2: Geometry<Double>.Vector<2> = .init(dx: -1, dy: 0)

        let angle = v1.angle(to: v2)
        #expect(abs(angle.value - Double.pi) < 1e-10)
    }

    @Test("Angle is symmetric in magnitude")
    func angleSymmetric() {
        let v1: Geometry<Double>.Vector<2> = .init(dx: 1, dy: 0)
        let v2: Geometry<Double>.Vector<2> = .init(dx: 1, dy: 1)

        let angle1 = v1.angle(to: v2)
        let angle2 = v2.angle(to: v1)

        // Unsigned angle should be the same
        #expect(abs(abs(angle1.value) - abs(angle2.value)) < 1e-10)
    }

    @Test("Signed angle counter-clockwise")
    func signedAngleCCW() {
        let v1: Geometry<Double>.Vector<2> = .init(dx: 1, dy: 0)
        let v2: Geometry<Double>.Vector<2> = .init(dx: 0, dy: 1)

        let angle = v1.signedAngle(to: v2)
        #expect(angle.value > 0) // CCW is positive
        #expect(abs(angle.value - Double.pi / 2) < 1e-10)
    }

    @Test("Signed angle clockwise")
    func signedAngleCW() {
        let v1: Geometry<Double>.Vector<2> = .init(dx: 1, dy: 0)
        let v2: Geometry<Double>.Vector<2> = .init(dx: 0, dy: -1)

        let angle = v1.signedAngle(to: v2)
        #expect(angle.value < 0) // CW is negative
        #expect(abs(angle.value - (-(Double.pi / 2))) < 1e-10)
    }
}

@Suite("Vector Distance Tests")
struct VectorDistanceTests {
    @Test("Distance to parallel vectors")
    func distanceToParallel() {
        let v1: Geometry<Double>.Vector<2> = .init(dx: 3, dy: 0)
        let v2: Geometry<Double>.Vector<2> = .init(dx: 7, dy: 0)

        let dist = v1.distance(to: v2)
        #expect(abs(dist - 4) < 1e-10)
    }

    @Test("Distance to perpendicular vectors")
    func distanceToPerpendicular() {
        let v1: Geometry<Double>.Vector<2> = .init(dx: 3, dy: 0)
        let v2: Geometry<Double>.Vector<2> = .init(dx: 0, dy: 4)

        let dist = v1.distance(to: v2)
        #expect(abs(dist - 5) < 1e-10)
    }

    @Test("Distance to self is zero")
    func distanceToSelf() {
        let v: Geometry<Double>.Vector<2> = .init(dx: 3, dy: 4)

        let dist = v.distance(to: v)
        #expect(abs(dist) < 1e-10)
    }
}

@Suite("Vector 3D Cross Product Tests")
struct Vector3DCrossProductTests {
    @Test("Cross product of unit vectors")
    func crossProductUnitVectors() {
        let i: Geometry<Double>.Vector<3> = .init(dx: 1, dy: 0, dz: 0)
        let j: Geometry<Double>.Vector<3> = .init(dx: 0, dy: 1, dz: 0)
        let k: Geometry<Double>.Vector<3> = .init(dx: 0, dy: 0, dz: 1)

        let iCrossJ = i.cross(j)
        #expect(abs(iCrossJ.dx) < 1e-10)
        #expect(abs(iCrossJ.dy) < 1e-10)
        #expect(abs(iCrossJ.dz - 1) < 1e-10)

        let jCrossK = j.cross(k)
        #expect(abs(jCrossK.dx - 1) < 1e-10)
        #expect(abs(jCrossK.dy) < 1e-10)
        #expect(abs(jCrossK.dz) < 1e-10)

        let kCrossI = k.cross(i)
        #expect(abs(kCrossI.dx) < 1e-10)
        #expect(abs(kCrossI.dy - 1) < 1e-10)
        #expect(abs(kCrossI.dz) < 1e-10)
    }

    @Test("Cross product anticommutative")
    func crossProductAnticommutative() {
        let v1: Geometry<Double>.Vector<3> = .init(dx: 1, dy: 2, dz: 3)
        let v2: Geometry<Double>.Vector<3> = .init(dx: 4, dy: 5, dz: 6)

        let cross1 = v1.cross(v2)
        let cross2 = v2.cross(v1)

        #expect(abs(cross1.dx + cross2.dx) < 1e-10)
        #expect(abs(cross1.dy + cross2.dy) < 1e-10)
        #expect(abs(cross1.dz + cross2.dz) < 1e-10)
    }

    @Test("Cross product perpendicular to both vectors")
    func crossProductPerpendicular() {
        let v1: Geometry<Double>.Vector<3> = .init(dx: 1, dy: 2, dz: 3)
        let v2: Geometry<Double>.Vector<3> = .init(dx: 4, dy: 5, dz: 6)

        let cross = v1.cross(v2)

        #expect(abs(v1.dot(cross)) < 1e-10)
        #expect(abs(v2.dot(cross)) < 1e-10)
    }

    @Test("Cross product of parallel vectors is zero")
    func crossProductParallel() {
        let v1: Geometry<Double>.Vector<3> = .init(dx: 1, dy: 2, dz: 3)
        let v2: Geometry<Double>.Vector<3> = .init(dx: 2, dy: 4, dz: 6)

        let cross = v1.cross(v2)

        #expect(abs(cross.dx) < 1e-10)
        #expect(abs(cross.dy) < 1e-10)
        #expect(abs(cross.dz) < 1e-10)
    }
}
