// TransformTests.swift
// Tests for Affine.Transform

import Angle
import Testing

@testable import Affine
@testable import Algebra
@testable import Algebra_Linear

@Suite("Affine.Transform Tests")
struct TransformTests {
    typealias Transform = Affine<Double, Void>.Transform
    typealias Point2 = Affine<Double, Void>.Point<2>
    typealias Vec2 = Linear<Double, Void>.Vector<2>

    // MARK: - Identity

    @Test("Identity transform")
    func identityTransform() {
        let id = Transform.identity
        #expect(id.a == 1)
        #expect(id.b == 0)
        #expect(id.c == 0)
        #expect(id.d == 1)
        #expect(id.tx.value == 0)
        #expect(id.ty.value == 0)
    }

    @Test("Identity preserves points")
    func identityPreservesPoints() {
        let id = Transform.identity
        let p = Point2(x: 3, y: 4)
        let transformed = id.apply(to: p)
        #expect(transformed.x.value == 3)
        #expect(transformed.y.value == 4)
    }

    // MARK: - Translation

    @Test("Translation transform")
    func translationTransform() {
        let t = Transform.translation(dx: 10, dy: 20)
        let p = Point2(x: 1, y: 2)
        let result = t.apply(to: p)
        #expect(result.x.value == 11)
        #expect(result.y.value == 22)
    }

    @Test("Translation from vector")
    func translationFromVector() {
        let v = Vec2(dx: 10, dy: 20)
        let t = Transform.translation(v)
        let p = Point2(x: 1, y: 2)
        let result = t.apply(to: p)
        #expect(result.x.value == 11)
        #expect(result.y.value == 22)
    }

    // MARK: - Scaling

    @Test("Uniform scaling")
    func uniformScaling() {
        let t = Transform.scale(2)
        let p = Point2(x: 3, y: 4)
        let result = t.apply(to: p)
        #expect(result.x.value == 6)
        #expect(result.y.value == 8)
    }

    @Test("Non-uniform scaling")
    func nonUniformScaling() {
        let t = Transform.scale(x: 2, y: 3)
        let p = Point2(x: 3, y: 4)
        let result = t.apply(to: p)
        #expect(result.x.value == 6)
        #expect(result.y.value == 12)
    }

    // MARK: - Rotation

    @Test("Rotation by 90 degrees")
    func rotation90() {
        let t = Transform.rotation(Degree(90))
        let p = Point2(x: 1, y: 0)
        let result = t.apply(to: p)
        // After 90 degrees rotation, (1, 0) -> (0, 1)
        #expect(abs(result.x.value) < 1e-10)
        #expect(abs(result.y.value - 1) < 1e-10)
    }

    @Test("Rotation by 180 degrees")
    func rotation180() {
        let t = Transform.rotation(Degree(180))
        let p = Point2(x: 1, y: 0)
        let result = t.apply(to: p)
        // After 180 degrees rotation, (1, 0) -> (-1, 0)
        #expect(abs(result.x.value - (-1)) < 1e-10)
        #expect(abs(result.y.value) < 1e-10)
    }

    @Test("Rotation preserves distance from origin")
    func rotationPreservesDistance() {
        let t = Transform.rotation(Degree(45))
        let p = Point2(x: 3, y: 4)
        let result = t.apply(to: p)
        let originalDist = p.distance(to: .zero)
        let resultDist = result.distance(to: .zero)
        #expect(abs(originalDist - resultDist) < 1e-10)
    }

    // MARK: - Composition

    @Test("Concatenation order")
    func concatenationOrder() {
        // First scale by 2, then translate by (10, 0)
        let scale = Transform.scale(2)
        let translate = Transform.translation(dx: 10, dy: 0)
        let combined = translate.concatenating(scale)

        let p = Point2(x: 1, y: 0)
        let result = combined.apply(to: p)
        // scale: (1,0) -> (2,0), translate: (2,0) -> (12,0)
        #expect(result.x.value == 12)
        #expect(result.y.value == 0)
    }

    @Test("Multiple compositions")
    func multipleCompositions() {
        // Note: composed applies transforms in reverse order (right-to-left matrix multiplication)
        // So [t1, t2, t3] applies t3 first, then t2, then t1
        let composed = Transform.composed(
            .translation(dx: 1, dy: 0),  // Applied last
            .scale(2),  // Applied second
            .translation(dx: 0, dy: 1)  // Applied first
        )
        let p = Point2(x: 0, y: 0)
        let result = composed.apply(to: p)
        // translate(0,1): (0,0) -> (0,1)
        // scale(2): (0,1) -> (0,2)
        // translate(1,0): (0,2) -> (1,2)
        #expect(result.x.value == 1)
        #expect(result.y.value == 2)
    }

    // MARK: - Fluent Modifiers

    @Test("Fluent translation")
    func fluentTranslation() {
        let t = Transform.identity.translated(dx: 10, dy: 20)
        let p = Point2(x: 1, y: 2)
        let result = t.apply(to: p)
        #expect(result.x.value == 11)
        #expect(result.y.value == 22)
    }

    @Test("Fluent scaling")
    func fluentScaling() {
        let t = Transform.identity.scaled(by: 2)
        let p = Point2(x: 3, y: 4)
        let result = t.apply(to: p)
        #expect(result.x.value == 6)
        #expect(result.y.value == 8)
    }

    @Test("Fluent rotation")
    func fluentRotation() {
        let t = Transform.identity.rotated(by: Degree(90))
        let p = Point2(x: 1, y: 0)
        let result = t.apply(to: p)
        #expect(abs(result.x.value) < 1e-10)
        #expect(abs(result.y.value - 1) < 1e-10)
    }

    // MARK: - Inversion

    @Test("Determinant")
    func determinant() {
        let t = Transform.scale(x: 2, y: 3)
        #expect(t.determinant == 6)
    }

    @Test("Invertibility")
    func invertibility() {
        let t = Transform.scale(2)
        #expect(t.isInvertible)

        let singular = Transform(a: 1.0, b: 2.0, c: 2.0, d: 4.0, tx: Double(0), ty: Double(0))
        #expect(!singular.isInvertible)
    }

    @Test("Inverse transform")
    func inverseTransform() {
        let t = Transform.translation(dx: 10, dy: 20).scaled(by: 2)
        guard let inv = t.inverted else {
            #expect(Bool(false), "Transform should be invertible")
            return
        }

        let p = Point2(x: 1, y: 2)
        let transformed = t.apply(to: p)
        let restored = inv.apply(to: transformed)

        #expect(abs(restored.x.value - p.x.value) < 1e-10)
        #expect(abs(restored.y.value - p.y.value) < 1e-10)
    }

    @Test("Singular transform has no inverse")
    func singularNoInverse() {
        let singular = Transform(a: 1.0, b: 2.0, c: 2.0, d: 4.0, tx: Double(0), ty: Double(0))
        #expect(singular.inverted == nil)
    }

    // MARK: - Vector Transform

    @Test("Vector transform ignores translation")
    func vectorTransformIgnoresTranslation() {
        let t = Transform.translation(dx: 100, dy: 200).scaled(by: 2)
        let v = Vec2(dx: 3, dy: 4)
        let result = t.apply(to: v)
        // Translation should be ignored, only scaling applies
        #expect(result.dx == 6)
        #expect(result.dy == 8)
    }

    // MARK: - Equatable

    @Test("Transform equality")
    func equality() {
        let a = Transform.translation(dx: 1, dy: 2)
        let b = Transform.translation(dx: 1, dy: 2)
        let c = Transform.translation(dx: 1, dy: 3)
        #expect(a == b)
        #expect(a != c)
    }
}
