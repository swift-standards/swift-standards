//// Affine.Transform Tests.swift
//// Tests for Affine.Transform.swift
//
// import Dimension
// import Testing
//
// @testable import Affine
// @testable import Algebra
// @testable import Algebra_Linear
//
// @Suite
// struct `Affine.Transform Tests` {
//    typealias Transform = Affine<Double, Void>.Transform
//    typealias Point2 = Affine<Double, Void>.Point<2>
//    typealias Vec2 = Linear<Double, Void>.Vector<2>
//    typealias Matrix2x2 = Linear<Double, Void>.Matrix<2, 2>
//    typealias Translation = Affine<Double, Void>.Translation
//    typealias Dx = Linear<Double, Void>.Dx
//    typealias Dy = Linear<Double, Void>.Dy
//
//    // MARK: - Identity Tests
//
//    @Suite
//    struct `Identity` {
//        @Test
//        func `Identity transform has correct values`() {
//            let id = Transform.identity
//            #expect(id.a == 1)
//            #expect(id.b == 0)
//            #expect(id.c == 0)
//            #expect(id.d == 1)
//            #expect(id.tx.value == 0)
//            #expect(id.ty.value == 0)
//        }
//
//        @Test(arguments: [
//            Point2(x: 0, y: 0),
//            Point2(x: 3, y: 4),
//            Point2(x: -5, y: 7),
//            Point2(x: 1.5, y: -2.5)
//        ])
//        func identityPreservesPoints(p: Point2) {
//            let id = Transform.identity
//            let transformed = Transform.apply(id, to: p)
//            #expect(transformed.x.value == p.x.value)
//            #expect(transformed.y.value == p.y.value)
//        }
//
//        @Test
//        func `Identity preserves points instance method`() {
//            let id = Transform.identity
//            let p = Point2(x: 3, y: 4)
//            let transformed = id.apply(to: p)
//            #expect(transformed.x.value == 3)
//            #expect(transformed.y.value == 4)
//        }
//    }
//
//    // MARK: - Translation Tests
//
//    @Suite
//    struct `Translations` {
//        @Test
//        func `Translation from dx/dy`() {
//            let t = Transform.translation(dx: 10, dy: 20)
//            let p = Point2(x: 1, y: 2)
//            let result = Transform.apply(t, to: p)
//            #expect(result.x.value == 11)
//            #expect(result.y.value == 22)
//        }
//
//        @Test
//        func `Translation from vector`() {
//            let v = Vec2(dx: 10, dy: 20)
//            let t = Transform.translation(v)
//            let p = Point2(x: 1, y: 2)
//            let result = Transform.apply(t, to: p)
//            #expect(result.x.value == 11)
//            #expect(result.y.value == 22)
//        }
//
//        @Test
//        func `Translation from Translation value`() {
//            let translation = Translation(dx: 10, dy: 20)
//            let t = Transform.translation(translation)
//            let p = Point2(x: 1, y: 2)
//            let result = Transform.apply(t, to: p)
//            #expect(result.x.value == 11)
//            #expect(result.y.value == 22)
//        }
//
//        @Test
//        func `Translation has identity linear part`() {
//            let t = Transform.translation(dx: 10, dy: 20)
//            #expect(t.linear == Matrix2x2.identity)
//        }
//    }
//
//    // MARK: - Scaling Tests
//
//    @Suite
//    struct `Scaling` {
//        @Test
//        func `Uniform scaling`() {
//            let t = Transform.scale(2)
//            let p = Point2(x: 3, y: 4)
//            let result = Transform.apply(t, to: p)
//            #expect(result.x.value == 6)
//            #expect(result.y.value == 8)
//        }
//
//        @Test
//        func `Non-uniform scaling`() {
//            let t = Transform.scale(x: 2, y: 3)
//            let p = Point2(x: 3, y: 4)
//            let result = Transform.apply(t, to: p)
//            #expect(result.x.value == 6)
//            #expect(result.y.value == 12)
//        }
//
//        @Test
//        func `Scaling by zero collapses point`() {
//            let t = Transform.scale(0)
//            let p = Point2(x: 3, y: 4)
//            let result = Transform.apply(t, to: p)
//            #expect(result.x.value == 0)
//            #expect(result.y.value == 0)
//        }
//
//        @Test
//        func `Negative scaling inverts coordinates`() {
//            let t = Transform.scale(-1)
//            let p = Point2(x: 3, y: 4)
//            let result = Transform.apply(t, to: p)
//            #expect(result.x.value == -3)
//            #expect(result.y.value == -4)
//        }
//    }
//
//    // MARK: - Rotation Tests
//
//    @Suite
//    struct `Rotation` {
//        @Test
//        func `Rotation by 90 degrees (radians)`() {
//            let t = Transform.rotation(Degree(90))
//            let p = Point2(x: 1, y: 0)
//            let result = Transform.apply(t, to: p)
//            #expect(abs(result.x.value) < 1e-10)
//            #expect(abs(result.y.value - 1) < 1e-10)
//        }
//
//        @Test
//        func `Rotation by 180 degrees`() {
//            let t = Transform.rotation(Degree(180))
//            let p = Point2(x: 1, y: 0)
//            let result = Transform.apply(t, to: p)
//            #expect(abs(result.x.value - (-1)) < 1e-10)
//            #expect(abs(result.y.value) < 1e-10)
//        }
//
//        @Test
//        func `Rotation by 270 degrees`() {
//            let t = Transform.rotation(Degree(270))
//            let p = Point2(x: 1, y: 0)
//            let result = Transform.apply(t, to: p)
//            #expect(abs(result.x.value) < 1e-10)
//            #expect(abs(result.y.value - (-1)) < 1e-10)
//        }
//
//        @Test
//        func `Rotation by degrees`() {
//            let t = Transform.rotation(Degree(90))
//            let p = Point2(x: 1, y: 0)
//            let result = Transform.apply(t, to: p)
//            #expect(abs(result.x.value) < 1e-10)
//            #expect(abs(result.y.value - 1) < 1e-10)
//        }
//
//        @Test(arguments: [
//            (Point2(x: 3, y: 4), 45.0),
//            (Point2(x: 1, y: 1), 90.0),
//            (Point2(x: 5, y: 0), 180.0)
//        ])
//        func rotationPreservesDistance(p: Point2, degrees: Double) {
//            let t = Transform.rotation(Degree(degrees))
//            let result = Transform.apply(t, to: p)
//            let originalDist = p.distance(to: .zero)
//            let resultDist = result.distance(to: .zero)
//            #expect(abs(originalDist - resultDist) < 1e-10)
//        }
//    }
//
//    // MARK: - Shear Tests
//
//    @Suite
//    struct `Shear` {
//        @Test
//        func `Horizontal shear`() {
//            let t = Transform.shear(x: 1, y: 0)
//            let p = Point2(x: 0, y: 1)
//            let result = Transform.apply(t, to: p)
//            #expect(result.x.value == 1)
//            #expect(result.y.value == 1)
//        }
//
//        @Test
//        func `Vertical shear`() {
//            let t = Transform.shear(x: 0, y: 1)
//            let p = Point2(x: 1, y: 0)
//            let result = Transform.apply(t, to: p)
//            #expect(result.x.value == 1)
//            #expect(result.y.value == 1)
//        }
//    }
//
//    // MARK: - Composition Tests
//
//    @Suite
//    struct `Composition` {
//        @Test
//        func `Concatenation order (scale then translate)`() {
//            let scale = Transform.scale(2)
//            let translate = Transform.translation(dx: 10, dy: 0)
//            let combined = Transform.concatenating(translate, scale)
//
//            let p = Point2(x: 1, y: 0)
//            let result = Transform.apply(combined, to: p)
//            // scale: (1,0) -> (2,0), translate: (2,0) -> (12,0)
//            #expect(result.x.value == 12)
//            #expect(result.y.value == 0)
//        }
//
//        @Test
//        func `Concatenation instance method`() {
//            let scale = Transform.scale(2)
//            let translate = Transform.translation(dx: 10, dy: 0)
//            let combined = translate.concatenating(scale)
//
//            let p = Point2(x: 1, y: 0)
//            let result = combined.apply(to: p)
//            #expect(result.x.value == 12)
//            #expect(result.y.value == 0)
//        }
//
//        @Test
//        func `Compose multiple transforms`() {
//            let composed = Transform.composed(
//                .translation(dx: 1, dy: 0),
//                .scale(2),
//                .translation(dx: 0, dy: 1)
//            )
//            let p = Point2(x: 0, y: 0)
//            let result = Transform.apply(composed, to: p)
//            #expect(result.x.value == 1)
//            #expect(result.y.value == 2)
//        }
//
//        @Test
//        func `Compose from array`() {
//            let transforms = [
//                Transform.translation(dx: 1, dy: 0),
//                Transform.scale(2),
//                Transform.translation(dx: 0, dy: 1)
//            ]
//            let composed = Transform.composed(transforms)
//            let p = Point2(x: 0, y: 0)
//            let result = Transform.apply(composed, to: p)
//            #expect(result.x.value == 1)
//            #expect(result.y.value == 2)
//        }
//
//        @Test
//        func `Identity is neutral for composition`() {
//            let t = Transform.translation(dx: 5, dy: 10)
//            let composed1 = Transform.concatenating(t, .identity)
//            let composed2 = Transform.concatenating(.identity, t)
//
//            let p = Point2(x: 1, y: 1)
//            let result1 = Transform.apply(composed1, to: p)
//            let result2 = Transform.apply(composed2, to: p)
//
//            #expect(result1.x.value == 6)
//            #expect(result1.y.value == 11)
//            #expect(result2.x.value == 6)
//            #expect(result2.y.value == 11)
//        }
//    }
//
//    // MARK: - Fluent Modifier Tests
//
//    @Suite
//    struct `Fluent Modifiers` {
//        @Test
//        func `Fluent translation by dx/dy`() {
//            let t = Transform.identity.translated(dx: 10, dy: 20)
//            let p = Point2(x: 1, y: 2)
//            let result = Transform.apply(t, to: p)
//            #expect(result.x.value == 11)
//            #expect(result.y.value == 22)
//        }
//
//        @Test
//        func `Fluent translation by vector`() {
//            let v = Vec2(dx: 10, dy: 20)
//            let t = Transform.identity.translated(by: v)
//            let p = Point2(x: 1, y: 2)
//            let result = Transform.apply(t, to: p)
//            #expect(result.x.value == 11)
//            #expect(result.y.value == 22)
//        }
//
//        @Test
//        func `Fluent translation by Translation`() {
//            let translation = Translation(dx: 10, dy: 20)
//            let t = Transform.identity.translated(by: translation)
//            let p = Point2(x: 1, y: 2)
//            let result = Transform.apply(t, to: p)
//            #expect(result.x.value == 11)
//            #expect(result.y.value == 22)
//        }
//
//        @Test
//        func `Fluent uniform scaling`() {
//            let t = Transform.identity.scaled(by: 2)
//            let p = Point2(x: 3, y: 4)
//            let result = Transform.apply(t, to: p)
//            #expect(result.x.value == 6)
//            #expect(result.y.value == 8)
//        }
//
//        @Test
//        func `Fluent non-uniform scaling`() {
//            let t = Transform.identity.scaled(x: 2, y: 3)
//            let p = Point2(x: 3, y: 4)
//            let result = Transform.apply(t, to: p)
//            #expect(result.x.value == 6)
//            #expect(result.y.value == 12)
//        }
//
//        @Test
//        func `Fluent rotation (radians)`() {
//            let t = Transform.identity.rotated(by: Degree(90))
//            let p = Point2(x: 1, y: 0)
//            let result = Transform.apply(t, to: p)
//            #expect(abs(result.x.value) < 1e-10)
//            #expect(abs(result.y.value - 1) < 1e-10)
//        }
//
//        @Test
//        func `Fluent rotation (degrees)`() {
//            let t = Transform.identity.rotated(by: Degree(90))
//            let p = Point2(x: 1, y: 0)
//            let result = Transform.apply(t, to: p)
//            #expect(abs(result.x.value) < 1e-10)
//            #expect(abs(result.y.value - 1) < 1e-10)
//        }
//
//        @Test
//        func `Chained fluent modifiers`() {
//            // Composition: scale ∘ rotate ∘ translate
//            // Execution order (right-to-left): translate → rotate → scale
//            let t = Transform.identity
//                .scaled(by: 2)
//                .rotated(by: Degree(90))
//                .translated(dx: 10, dy: 0)
//
//            let p = Point2(x: 1, y: 0)
//            let result = Transform.apply(t, to: p)
//            // translate: (1,0) -> (11,0)
//            // rotate 90°: (11,0) -> (0,11)
//            // scale ×2: (0,11) -> (0,22)
//            #expect(abs(result.x.value - 0) < 1e-10)
//            #expect(abs(result.y.value - 22) < 1e-10)
//        }
//
//        @Test
//        func `Static fluent methods`() {
//            // Composition: scale ∘ translate
//            // Execution order (right-to-left): translate → scale
//            let base = Transform.scale(2)
//            let t = Transform.translated(base, dx: 10, dy: 0)
//            let p = Point2(x: 1, y: 0)
//            let result = Transform.apply(t, to: p)
//            // translate: (1,0) -> (11,0)
//            // scale ×2: (11,0) -> (22,0)
//            #expect(result.x.value == 22)
//        }
//    }
//
//    // MARK: - Inversion Tests
//
//    @Suite
//    struct `Inversion` {
//        @Test
//        func `Determinant of identity`() {
//            let t = Transform.identity
//            #expect(t.determinant == 1)
//        }
//
//        @Test
//        func `Determinant of scaling`() {
//            let t = Transform.scale(x: 2, y: 3)
//            #expect(t.determinant == 6)
//        }
//
//        @Test
//        func `Determinant of rotation is 1`() {
//            let t = Transform.rotation(Degree(45))
//            #expect(abs(t.determinant - 1) < 1e-10)
//        }
//
//        @Test
//        func `Identity is invertible`() {
//            let t = Transform.identity
//            #expect(t.isInvertible)
//        }
//
//        @Test
//        func `Singular transform is not invertible`() {
//            let singular = Transform(a: 1.0, b: 2.0, c: 2.0, d: 4.0, tx: 0.0, ty: 0.0)
//            #expect(!singular.isInvertible)
//        }
//
//        @Test
//        func `Invert translation`() {
//            let t = Transform.translation(dx: 10, dy: 20)
//            guard let inv = Transform.inverted(t) else {
//                #expect(Bool(false), "Transform should be invertible")
//                return
//            }
//
//            let p = Point2(x: 1, y: 2)
//            let transformed = Transform.apply(t, to: p)
//            let restored = Transform.apply(inv, to: transformed)
//
//            #expect(abs(restored.x.value - p.x.value) < 1e-10)
//            #expect(abs(restored.y.value - p.y.value) < 1e-10)
//        }
//
//        @Test
//        func `Invert scaling`() {
//            let t = Transform.scale(2)
//            guard let inv = Transform.inverted(t) else {
//                #expect(Bool(false), "Transform should be invertible")
//                return
//            }
//
//            let p = Point2(x: 3, y: 4)
//            let transformed = Transform.apply(t, to: p)
//            let restored = Transform.apply(inv, to: transformed)
//
//            #expect(abs(restored.x.value - p.x.value) < 1e-10)
//            #expect(abs(restored.y.value - p.y.value) < 1e-10)
//        }
//
//        @Test
//        func `Invert rotation`() {
//            let t = Transform.rotation(Degree(45))
//            guard let inv = Transform.inverted(t) else {
//                #expect(Bool(false), "Transform should be invertible")
//                return
//            }
//
//            let p = Point2(x: 3, y: 4)
//            let transformed = Transform.apply(t, to: p)
//            let restored = Transform.apply(inv, to: transformed)
//
//            #expect(abs(restored.x.value - p.x.value) < 1e-10)
//            #expect(abs(restored.y.value - p.y.value) < 1e-10)
//        }
//
//        @Test
//        func `Invert complex transform`() {
//            let t = Transform.identity
//                .scaled(by: 2)
//                .rotated(by: Degree(45))
//                .translated(dx: 10, dy: 20)
//
//            guard let inv = Transform.inverted(t) else {
//                #expect(Bool(false), "Transform should be invertible")
//                return
//            }
//
//            let p = Point2(x: 1, y: 2)
//            let transformed = Transform.apply(t, to: p)
//            let restored = Transform.apply(inv, to: transformed)
//
//            #expect(abs(restored.x.value - p.x.value) < 1e-10)
//            #expect(abs(restored.y.value - p.y.value) < 1e-10)
//        }
//
//        @Test
//        func `Inverse instance method`() {
//            let t = Transform.translation(dx: 10, dy: 20).scaled(by: 2)
//            guard let inv = t.inverted else {
//                #expect(Bool(false), "Transform should be invertible")
//                return
//            }
//
//            let p = Point2(x: 1, y: 2)
//            let transformed = t.apply(to: p)
//            let restored = inv.apply(to: transformed)
//
//            #expect(abs(restored.x.value - p.x.value) < 1e-10)
//            #expect(abs(restored.y.value - p.y.value) < 1e-10)
//        }
//
//        @Test
//        func `Singular transform has no inverse`() {
//            let singular = Transform(a: 1.0, b: 2.0, c: 2.0, d: 4.0, tx: 0.0, ty: 0.0)
//            #expect(Transform.inverted(singular) == nil)
//            #expect(singular.inverted == nil)
//        }
//    }
//
//    // MARK: - Vector Transform Tests
//
//    @Suite
//    struct `Vector Transform` {
//        @Test
//        func `Vector transform ignores translation`() {
//            let t = Transform.translation(dx: 100, dy: 200).scaled(by: 2)
//            let v = Vec2(dx: 3, dy: 4)
//            let result = Transform.apply(t, to: v)
//            // Translation should be ignored, only scaling applies
//            #expect(result.dx.value == 6)
//            #expect(result.dy.value == 8)
//        }
//
//        @Test
//        func `Vector transform instance method`() {
//            let t = Transform.translation(dx: 100, dy: 200).scaled(by: 2)
//            let v = Vec2(dx: 3, dy: 4)
//            let result = t.apply(to: v)
//            #expect(result.dx.value == 6)
//            #expect(result.dy.value == 8)
//        }
//
//        @Test
//        func `Identity preserves vectors`() {
//            let v = Vec2(dx: 3, dy: 4)
//            let result = Transform.apply(.identity, to: v)
//            #expect(result.dx.value == 3)
//            #expect(result.dy.value == 4)
//        }
//
//        @Test
//        func `Rotation transforms vectors`() {
//            let t = Transform.rotation(Degree(90))
//            let v = Vec2(dx: 1, dy: 0)
//            let result = Transform.apply(t, to: v)
//            #expect(abs(result.dx.value) < 1e-10)
//            #expect(abs(result.dy.value - 1) < 1e-10)
//        }
//    }
//
//    // MARK: - Construction Tests
//
//    @Suite
//    struct `Construction` {
//        @Test
//        func `Construction from raw components`() {
//            let t = Transform(a: 1, b: 2, c: 3, d: 4, tx: 5, ty: 6)
//            #expect(t.a == 1)
//            #expect(t.b == 2)
//            #expect(t.c == 3)
//            #expect(t.d == 4)
//            #expect(t.tx.value == 5)
//            #expect(t.ty.value == 6)
//        }
//
//        @Test
//        func `Construction from linear and translation`() {
//            let linear = Matrix2x2(a: 1, b: 2, c: 3, d: 4)
//            let translation = Affine<Double, Void>.Translation(dx: 5.0, dy: 6.0)
//            let t = Transform(linear: linear, translation: translation)
//            #expect(t.a == 1)
//            #expect(t.b == 2)
//            #expect(t.c == 3)
//            #expect(t.d == 4)
//            #expect(t.tx.value == 5)
//            #expect(t.ty.value == 6)
//        }
//
//        @Test
//        func `Construction from linear only`() {
//            let linear = Matrix2x2(a: 1, b: 2, c: 3, d: 4)
//            let t = Transform(linear: linear)
//            #expect(t.a == 1)
//            #expect(t.b == 2)
//            #expect(t.c == 3)
//            #expect(t.d == 4)
//            #expect(t.tx.value == 0)
//            #expect(t.ty.value == 0)
//        }
//
//        @Test
//        func `Construction from translation only`() {
//            let translation = Affine<Double, Void>.Translation(dx: 5.0, dy: 6.0)
//            let t = Transform(translation: translation)
//            #expect(t.a == 1)
//            #expect(t.b == 0)
//            #expect(t.c == 0)
//            #expect(t.d == 1)
//            #expect(t.tx.value == 5)
//            #expect(t.ty.value == 6)
//        }
//    }
//
//    // MARK: - Equatable Tests
//
//    @Suite
//    struct `Equatable` {
//        @Test
//        func `Transform equality`() {
//            let a = Transform.translation(dx: 1, dy: 2)
//            let b = Transform.translation(dx: 1, dy: 2)
//            let c = Transform.translation(dx: 1, dy: 3)
//            #expect(a == b)
//            #expect(a != c)
//        }
//
//        @Test
//        func `Identity equals identity`() {
//            #expect(Transform.identity == Transform.identity)
//        }
//
//        @Test
//        func `Different transforms are not equal`() {
//            let scale = Transform.scale(2)
//            let rotate = Transform.rotation(Degree(45))
//            #expect(scale != rotate)
//        }
//    }
// }
