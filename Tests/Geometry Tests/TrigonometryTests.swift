// TrigonometryTests.swift
// Tests for trigonometric extensions on Geometry types.

import Geometry
import RealModule
import Testing

@Suite("Trigonometry Tests")
struct TrigonometryTests {

    // MARK: - Radian Trigonometry

    @Test("Radian sin/cos/tan")
    func radianTrigonometry() {
        let angle: Geometry<Double>.Radian = .pi(over: 2)
        #expect(abs(angle.sin - 1.0) < 1e-10)
        #expect(abs(angle.cos) < 1e-10)

        let angle45: Geometry<Double>.Radian = .pi(over: 4)
        #expect(abs(angle45.tan - 1.0) < 1e-10)
    }

    @Test("Radian constants")
    func radianConstants() {
        #expect(abs(Geometry<Double>.Radian.pi.value - Double.pi) < 1e-10)
        #expect(abs(Geometry<Double>.Radian.pi(times: 2).value - 2 * Double.pi) < 1e-10)
        #expect(abs(Geometry<Double>.Radian.pi(over: 2).value - Double.pi / 2) < 1e-10)
        #expect(abs(Geometry<Double>.Radian.pi(over: 4).value - Double.pi / 4) < 1e-10)
        #expect(abs(Geometry<Double>.Radian.pi(over: 3).value - Double.pi / 3) < 1e-10)
        #expect(abs(Geometry<Double>.Radian.pi(over: 6).value - Double.pi / 6) < 1e-10)
    }

    @Test("Inverse trigonometric functions")
    func inverseTrig() {
        let angle = Geometry<Double>.Radian.asin(0.5)
        #expect(abs(angle.value - Double.pi / 6) < 1e-10)

        let angle2 = Geometry<Double>.Radian.acos(0.5)
        #expect(abs(angle2.value - Double.pi / 3) < 1e-10)

        let angle3 = Geometry<Double>.Radian.atan(1.0)
        #expect(abs(angle3.value - Double.pi / 4) < 1e-10)

        let angle4 = Geometry<Double>.Radian.atan2(y: 1.0, x: 1.0)
        #expect(abs(angle4.value - Double.pi / 4) < 1e-10)
    }

    // MARK: - Degree Trigonometry

    @Test("Degree to Radian conversion")
    func degreeToRadian() {
        let deg90: Geometry<Double>.Degree = .rightAngle
        #expect(abs(deg90.radians.value - Double.pi / 2) < 1e-10)

        let deg180: Geometry<Double>.Degree = .straight
        #expect(abs(deg180.radians.value - Double.pi) < 1e-10)

        let deg360: Geometry<Double>.Degree = .fullCircle
        #expect(abs(deg360.radians.value - 2 * Double.pi) < 1e-10)
    }

    @Test("Radian to Degree conversion")
    func radianToDegree() {
        let rad: Geometry<Double>.Radian = .pi
        #expect(abs(rad.degrees.value - 180.0) < 1e-10)

        let rad2: Geometry<Double>.Radian = .pi(over: 2)
        #expect(abs(rad2.degrees.value - 90.0) < 1e-10)
    }

    @Test("Degree sin/cos/tan")
    func degreeTrigonometry() {
        let deg30: Geometry<Double>.Degree = .thirty
        #expect(abs(deg30.sin - 0.5) < 1e-10)

        let deg60: Geometry<Double>.Degree = .sixty
        #expect(abs(deg60.cos - 0.5) < 1e-10)

        let deg45: Geometry<Double>.Degree = .fortyFive
        #expect(abs(deg45.tan - 1.0) < 1e-10)
    }

    @Test("Degree constants")
    func degreeConstants() {
        #expect(Geometry<Double>.Degree.rightAngle.value == 90)
        #expect(Geometry<Double>.Degree.straight.value == 180)
        #expect(Geometry<Double>.Degree.fullCircle.value == 360)
        #expect(Geometry<Double>.Degree.fortyFive.value == 45)
        #expect(Geometry<Double>.Degree.sixty.value == 60)
        #expect(Geometry<Double>.Degree.thirty.value == 30)
    }

    // MARK: - Float Support

    @Test("Float type support")
    func floatSupport() {
        let angle: Geometry<Float>.Radian = .pi
        #expect(abs(angle.sin) < 1e-6)
        #expect(abs(angle.cos + 1.0) < 1e-6)

        let deg: Geometry<Float>.Degree = .rightAngle
        #expect(abs(deg.sin - 1.0) < 1e-6)
    }

    // MARK: - AffineTransform Rotation

    @Test("AffineTransform rotation from Radian")
    func affineTransformRotationRadian() {
        let transform = Geometry<Double>.AffineTransform.rotation(.pi(over: 2))
        let point = Geometry<Double>.Point(x: 1.0, y: 0.0)
        let rotated = transform.apply(to: point)

        #expect(abs(rotated.x) < 1e-10)
        #expect(abs(rotated.y - 1.0) < 1e-10)
    }

    @Test("AffineTransform rotation from Degree")
    func affineTransformRotationDegree() {
        let transform = Geometry<Double>.AffineTransform.rotation(
            Geometry<Double>.Degree.rightAngle
        )
        let point = Geometry<Double>.Point(x: 1.0, y: 0.0)
        let rotated = transform.apply(to: point)

        #expect(abs(rotated.x) < 1e-10)
        #expect(abs(rotated.y - 1.0) < 1e-10)
    }

    // MARK: - Vector Trigonometry

    @Test("Vector angle")
    func vectorAngle() {
        let v1 = Geometry<Double>.Vector(dx: 1.0, dy: 0.0)
        #expect(abs(v1.angle.value) < 1e-10)

        let v2 = Geometry<Double>.Vector(dx: 0.0, dy: 1.0)
        #expect(abs(v2.angle.value - Double.pi / 2) < 1e-10)

        let v3 = Geometry<Double>.Vector(dx: 1.0, dy: 1.0)
        #expect(abs(v3.angle.value - Double.pi / 4) < 1e-10)
    }

    @Test("Vector unit at angle")
    func vectorUnitAtAngle() {
        let v = Geometry<Double>.Vector.unit(at: .pi(over: 4))
        let expected = 1.0 / Double.sqrt(2.0)
        #expect(abs(v.dx - expected) < 1e-10)
        #expect(abs(v.dy - expected) < 1e-10)
    }

    @Test("Vector polar")
    func vectorPolar() {
        let v = Geometry<Double>.Vector.polar(length: 2.0, angle: .pi(over: 6))
        #expect(abs(v.dx - Double.sqrt(3.0)) < 1e-10)
        #expect(abs(v.dy - 1.0) < 1e-10)
    }

    @Test("Vector angle between")
    func vectorAngleBetween() {
        let v1 = Geometry<Double>.Vector(dx: 1.0, dy: 0.0)
        let v2 = Geometry<Double>.Vector(dx: 0.0, dy: 1.0)
        let angle = v1.angle(to: v2)
        #expect(abs(angle.value - Double.pi / 2) < 1e-10)
    }

    @Test("Vector rotation")
    func vectorRotation() {
        let v = Geometry<Double>.Vector(dx: 1.0, dy: 0.0)
        let rotated = v.rotated(by: .pi(over: 2))
        #expect(abs(rotated.dx) < 1e-10)
        #expect(abs(rotated.dy - 1.0) < 1e-10)
    }

    // MARK: - Point Trigonometry

    @Test("Point polar coordinates")
    func pointPolar() {
        let p = Geometry<Double>.Point.polar(radius: 2.0, angle: .pi(over: 3))
        #expect(abs(p.x - 1.0) < 1e-10)
        #expect(abs(p.y - Double.sqrt(3.0)) < 1e-10)
    }

    @Test("Point angle and radius")
    func pointAngleAndRadius() {
        let p = Geometry<Double>.Point(x: 3.0, y: 4.0)
        #expect(abs(p.radius - 5.0) < 1e-10)

        let p2 = Geometry<Double>.Point(x: 1.0, y: 1.0)
        #expect(abs(p2.angle.value - Double.pi / 4) < 1e-10)
    }

    @Test("Point rotation around origin")
    func pointRotationOrigin() {
        let p = Geometry<Double>.Point(x: 1.0, y: 0.0)
        let rotated = p.rotated(by: .pi(over: 2))
        #expect(abs(rotated.x) < 1e-10)
        #expect(abs(rotated.y - 1.0) < 1e-10)
    }

    @Test("Point rotation around center")
    func pointRotationCenter() {
        let p = Geometry<Double>.Point(x: 2.0, y: 0.0)
        let center = Geometry<Double>.Point(x: 1.0, y: 0.0)
        let rotated = p.rotated(by: .pi(over: 2), around: center)
        #expect(abs(rotated.x - 1.0) < 1e-10)
        #expect(abs(rotated.y - 1.0) < 1e-10)
    }
}
