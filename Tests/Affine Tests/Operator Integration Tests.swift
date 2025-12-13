//// Operator Integration Tests.swift
//// Tests verifying type-safe operator interactions across coordinate systems.
//
//import Algebra_Linear
//import Angle
//import Dimension
//import Testing
//
//@testable import Affine
//
//// MARK: - Type Aliases for Brevity
//
//private typealias A = Affine<Double, Void>
//private typealias L = Linear<Double, Void>
//private typealias Point2 = A.Point<2>
//private typealias Vector2 = L.Vector<2>
//private typealias Matrix2x2 = L.Matrix<2, 2>
//private typealias Transform = A.Transform
//
//// MARK: - Affine Geometry Operators
//
//@Suite
//struct `Affine Geometry - Point/Vector Arithmetic` {
//
//    @Test
//    func `Point - Point yields Vector displacement`() {
//        let p1 = Point2(x: 10, y: 20)
//        let p2 = Point2(x: 3, y: 8)
//
//        let displacement: Vector2 = p1 - p2
//
//        #expect(displacement.dx.value == 7)
//        #expect(displacement.dy.value == 12)
//    }
//
//    @Test
//    func `Point + Vector yields translated Point`() {
//        let p = Point2(x: 10, y: 20)
//        let v = Vector2(dx: 5, dy: -3)
//
//        let result: Point2 = p + v
//
//        #expect(result.x.value == 15)
//        #expect(result.y.value == 17)
//    }
//
//    @Test
//    func `Point - Vector yields translated Point`() {
//        let p = Point2(x: 10, y: 20)
//        let v = Vector2(dx: 3, dy: 5)
//
//        let result: Point2 = p - v
//
//        #expect(result.x.value == 7)
//        #expect(result.y.value == 15)
//    }
//
//    @Test
//    func `Point arithmetic round-trip: (p1 - p2) + p2 == p1`() {
//        let p1 = Point2(x: 100, y: 200)
//        let p2 = Point2(x: 30, y: 50)
//
//        let displacement = p1 - p2
//        let recovered = p2 + displacement
//
//        #expect(recovered.x.value == p1.x.value)
//        #expect(recovered.y.value == p1.y.value)
//    }
//}
//
//// MARK: - Tagged Coordinate/Displacement Operators
//
//@Suite
//struct `Tagged - Coordinate/Displacement Arithmetic` {
//
//    // X-axis tests
//    @Test
//    func `X + Dx yields X coordinate`() {
//        let x: A.X = 10
//        let dx: A.Dx = 5
//
//        let result: A.X = x + dx
//
//        #expect(result.value == 15)
//    }
//
//    @Test
//    func `X - X yields Dx displacement`() {
//        let x1: A.X = 10
//        let x2: A.X = 3
//
//        let result: A.Dx = x1 - x2
//
//        #expect(result.value == 7)
//    }
//
//    @Test
//    func `X - Dx yields X coordinate`() {
//        let x: A.X = 10
//        let dx: A.Dx = 3
//
//        let result: A.X = x - dx
//
//        #expect(result.value == 7)
//    }
//
//    @Test
//    func `Dx + X yields X coordinate (commutative)`() {
//        let dx: A.Dx = 5
//        let x: A.X = 10
//
//        let result: A.X = dx + x
//
//        #expect(result.value == 15)
//    }
//
//    // Y-axis tests
//    @Test
//    func `Y + Dy yields Y coordinate`() {
//        let y: A.Y = 20
//        let dy: A.Dy = 8
//
//        let result: A.Y = y + dy
//
//        #expect(result.value == 28)
//    }
//
//    @Test
//    func `Y - Y yields Dy displacement`() {
//        let y1: A.Y = 20
//        let y2: A.Y = 8
//
//        let result: A.Dy = y1 - y2
//
//        #expect(result.value == 12)
//    }
//
//    // Displacement + Displacement
//    @Test
//    func `Dx + Dx yields Dx`() {
//        let dx1: A.Dx = 5
//        let dx2: A.Dx = 3
//
//        let result: A.Dx = dx1 + dx2
//
//        #expect(result.value == 8)
//    }
//
//    @Test
//    func `Dy + Dy yields Dy`() {
//        let dy1: A.Dy = 10
//        let dy2: A.Dy = 7
//
//        let result: A.Dy = dy1 + dy2
//
//        #expect(result.value == 17)
//    }
//}
//
//// MARK: - Tagged Scalar Operations
//
//@Suite
//struct `Tagged - Scalar Multiplication/Division` {
//
//    @Test
//    func `Dx * Scalar yields Dx`() {
//        let dx: A.Dx = 5
//
//        let result: A.Dx = dx * 3.0
//
//        #expect(result.value == 15)
//    }
//
//    @Test
//    func `Scalar * Dx yields Dx (commutative)`() {
//        let dx: A.Dx = 5
//
//        let result: A.Dx = 3.0 * dx
//
//        #expect(result.value == 15)
//    }
//
//    @Test
//    func `Dx / Scalar yields Dx`() {
//        let dx: A.Dx = 15
//
//        let result: A.Dx = dx / 3.0
//
//        #expect(result.value == 5)
//    }
//
//    @Test
//    func `Dx / Dx yields Scalar (ratio)`() {
//        let dx1: A.Dx = 15
//        let dx2: A.Dx = 3
//
//        let ratio: Double = dx1 / dx2
//
//        #expect(ratio == 5)
//    }
//
//    @Test
//    func `Dx * Dx yields Scalar (squared)`() {
//        let dx: A.Dx = 4
//
//        let squared: Double = dx * dx
//
//        #expect(squared == 16)
//    }
//}
//
//// MARK: - Cross-Axis Multiplication
//
//@Suite
//struct `Tagged - Cross-Axis Multiplication` {
//
//    @Test
//    func `Dx * Dy yields Scalar (area)`() {
//        let width: L.Dx = 10
//        let height: L.Dy = 5
//
//        let area: Double = width * height
//
//        #expect(area == 50)
//    }
//
//    @Test
//    func `Dy * Dx yields Scalar (commutative area)`() {
//        let width: L.Dx = 10
//        let height: L.Dy = 5
//
//        let area: Double = height * width
//
//        #expect(area == 50)
//    }
//}
//
//// MARK: - Magnitude/Coordinate Arithmetic
//
//@Suite
//struct `Tagged - Magnitude/Coordinate Arithmetic` {
//
//    @Test
//    func `X + Magnitude yields X (center + radius pattern)`() {
//        let centerX: A.X = 100
//        let radius: A.Distance = 25
//
//        let right: A.X = centerX + radius
//
//        #expect(right.value == 125)
//    }
//
//    @Test
//    func `X - Magnitude yields X (center - radius pattern)`() {
//        let centerX: A.X = 100
//        let radius: A.Distance = 25
//
//        let left: A.X = centerX - radius
//
//        #expect(left.value == 75)
//    }
//
//    @Test
//    func `Magnitude + X yields X (commutative)`() {
//        let radius: A.Distance = 25
//        let centerX: A.X = 100
//
//        let right: A.X = radius + centerX
//
//        #expect(right.value == 125)
//    }
//}
//
//// MARK: - Linear Vector Operators
//
//@Suite
//struct `Linear Vector - Arithmetic Operations` {
//
//    @Test
//    func `Vector + Vector yields Vector`() {
//        let v1 = Vector2(dx: 3, dy: 4)
//        let v2 = Vector2(dx: 1, dy: 2)
//
//        let result: Vector2 = v1 + v2
//
//        #expect(result.dx.value == 4)
//        #expect(result.dy.value == 6)
//    }
//
//    @Test
//    func `Vector - Vector yields Vector`() {
//        let v1 = Vector2(dx: 5, dy: 7)
//        let v2 = Vector2(dx: 2, dy: 3)
//
//        let result: Vector2 = v1 - v2
//
//        #expect(result.dx.value == 3)
//        #expect(result.dy.value == 4)
//    }
//
//    @Test
//    func `Vector * Scalar yields Vector`() {
//        let v = Vector2(dx: 3, dy: 4)
//
//        let result: Vector2 = v * 2.0
//
//        #expect(result.dx.value == 6)
//        #expect(result.dy.value == 8)
//    }
//
//    @Test
//    func `Scalar * Vector yields Vector (commutative)`() {
//        let v = Vector2(dx: 3, dy: 4)
//
//        let result: Vector2 = 2.0 * v
//
//        #expect(result.dx.value == 6)
//        #expect(result.dy.value == 8)
//    }
//
//    @Test
//    func `Vector / Scalar yields Vector`() {
//        let v = Vector2(dx: 6, dy: 8)
//
//        let result: Vector2 = v / 2.0
//
//        #expect(result.dx.value == 3)
//        #expect(result.dy.value == 4)
//    }
//
//    @Test
//    func `-Vector yields negated Vector`() {
//        let v = Vector2(dx: 3, dy: -4)
//
//        let result: Vector2 = -v
//
//        #expect(result.dx.value == -3)
//        #expect(result.dy.value == 4)
//    }
//}
//
//// MARK: - Linear Matrix Operators
//
//@Suite
//struct `Linear Matrix - Arithmetic Operations` {
//
//    @Test
//    func `Matrix + Matrix yields Matrix`() {
//        let m1 = Matrix2x2(a: 1, b: 2, c: 3, d: 4)
//        let m2 = Matrix2x2(a: 5, b: 6, c: 7, d: 8)
//
//        let result: Matrix2x2 = m1 + m2
//
//        #expect(result.a == 6)
//        #expect(result.b == 8)
//        #expect(result.c == 10)
//        #expect(result.d == 12)
//    }
//
//    @Test
//    func `Matrix - Matrix yields Matrix`() {
//        let m1 = Matrix2x2(a: 5, b: 6, c: 7, d: 8)
//        let m2 = Matrix2x2(a: 1, b: 2, c: 3, d: 4)
//
//        let result: Matrix2x2 = m1 - m2
//
//        #expect(result.a == 4)
//        #expect(result.b == 4)
//        #expect(result.c == 4)
//        #expect(result.d == 4)
//    }
//
//    @Test
//    func `Matrix * Scalar yields Matrix`() {
//        let m = Matrix2x2(a: 1, b: 2, c: 3, d: 4)
//
//        let result: Matrix2x2 = m * 2.0
//
//        #expect(result.a == 2)
//        #expect(result.b == 4)
//        #expect(result.c == 6)
//        #expect(result.d == 8)
//    }
//
//    @Test
//    func `Scalar * Matrix yields Matrix (commutative)`() {
//        let m = Matrix2x2(a: 1, b: 2, c: 3, d: 4)
//
//        let result: Matrix2x2 = 2.0 * m
//
//        #expect(result.a == 2)
//        #expect(result.b == 4)
//        #expect(result.c == 6)
//        #expect(result.d == 8)
//    }
//
//    @Test
//    func `Matrix * Vector yields Vector (typed)`() {
//        // Rotation by 90 degrees: [[0, -1], [1, 0]]
//        let rotation = Matrix2x2(a: 0, b: -1, c: 1, d: 0)
//        let v = Vector2(dx: 1, dy: 0)
//
//        let result: Vector2 = rotation * v
//
//        // (1, 0) rotated 90° CCW = (0, 1)
//        #expect(abs(result.dx.value - 0) < 1e-10)
//        #expect(abs(result.dy.value - 1) < 1e-10)
//    }
//
//    @Test
//    func `Matrix * Matrix yields Matrix (composition)`() {
//        // Scale by 2
//        let scale = Matrix2x2(a: 2, b: 0, c: 0, d: 2)
//        // Rotation by 90 degrees
//        let rotation = Matrix2x2(a: 0, b: -1, c: 1, d: 0)
//
//        // scale * rotation: first rotate, then scale
//        let composed = scale.multiplied(by: rotation)
//
//        // Apply to (1, 0): rotate to (0, 1), scale to (0, 2)
//        let v = Vector2(dx: 1, dy: 0)
//        let result = composed * v
//
//        #expect(abs(result.dx.value - 0) < 1e-10)
//        #expect(abs(result.dy.value - 2) < 1e-10)
//    }
//}
//
//// MARK: - Translation Operators
//
//@Suite
//struct `Affine Translation - Arithmetic Operations` {
//
//    @Test
//    func `Translation + Translation yields Translation`() {
//        let t1 = A.Translation(dx: 10, dy: 20)
//        let t2 = A.Translation(dx: 5, dy: 8)
//
//        let result: A.Translation = t1 + t2
//
//        #expect(result.dx.value == 15)
//        #expect(result.dy.value == 28)
//    }
//
//    @Test
//    func `Translation - Translation yields Translation`() {
//        let t1 = A.Translation(dx: 10, dy: 20)
//        let t2 = A.Translation(dx: 3, dy: 5)
//
//        let result: A.Translation = t1 - t2
//
//        #expect(result.dx.value == 7)
//        #expect(result.dy.value == 15)
//    }
//
//    @Test
//    func `Translation.vector returns typed Vector2`() {
//        let t = A.Translation(dx: 10, dy: 20)
//
//        let v: Vector2 = t.vector
//
//        #expect(v.dx.value == 10)
//        #expect(v.dy.value == 20)
//    }
//}
//
//// MARK: - Transform Composition
//
//@Suite
//struct `Affine Transform - Composition Operators` {
//
//    @Test
//    func `Transform composition follows right-to-left execution order`() {
//        // scale ∘ translate: translate first, then scale
//        let translate = Transform.translation(dx: 10, dy: 0)
//        let scale = Transform.scale(2)
//
//        let composed = Transform.concatenating(scale, translate)
//        let p = Point2(x: 1, y: 0)
//        let result = Transform.apply(composed, to: p)
//
//        // translate: (1, 0) -> (11, 0)
//        // scale: (11, 0) -> (22, 0)
//        #expect(abs(result.x.value - 22) < 1e-10)
//        #expect(abs(result.y.value - 0) < 1e-10)
//    }
//
//    @Test
//    func `Transform inverse undoes transformation`() {
//        let t = Transform.rotation(Degree(45)).scaled(by: 2).translated(dx: 100, dy: 50)
//        guard let inv = Transform.inverted(t) else {
//            Issue.record("Transform should be invertible")
//            return
//        }
//
//        let p = Point2(x: 10, y: 20)
//        let transformed = Transform.apply(t, to: p)
//        let recovered = Transform.apply(inv, to: transformed)
//
//        #expect(abs(recovered.x.value - p.x.value) < 1e-10)
//        #expect(abs(recovered.y.value - p.y.value) < 1e-10)
//    }
//
//    @Test
//    func `Transform.apply to Vector ignores translation`() {
//        let t = Transform.translation(dx: 100, dy: 100).scaled(by: 2)
//        let v = Vector2(dx: 3, dy: 4)
//
//        let result = Transform.apply(t, to: v)
//
//        // Vectors are only affected by linear transformation, not translation
//        #expect(abs(result.dx.value - 6) < 1e-10)
//        #expect(abs(result.dy.value - 8) < 1e-10)
//    }
//}
//
//// MARK: - Compound Assignment Operators
//
//@Suite
//struct `Compound Assignment Operators` {
//
//    @Test
//    func `Dx += Dx modifies in place`() {
//        var dx: A.Dx = 10
//        dx += A.Dx(5)
//
//        #expect(dx.value == 15)
//    }
//
//    @Test
//    func `Dx -= Dx modifies in place`() {
//        var dx: A.Dx = 10
//        dx -= A.Dx(3)
//
//        #expect(dx.value == 7)
//    }
//
//    @Test
//    func `Dx *= Scalar modifies in place`() {
//        var dx: A.Dx = 10
//        dx *= 2.0
//
//        #expect(dx.value == 20)
//    }
//
//    @Test
//    func `Dx /= Scalar modifies in place`() {
//        var dx: A.Dx = 20
//        dx /= 4.0
//
//        #expect(dx.value == 5)
//    }
//}
//
//// MARK: - Algebraic Properties
//
//@Suite
//struct `Algebraic Properties` {
//
//    @Test
//    func `Vector addition is commutative`() {
//        let v1 = Vector2(dx: 3, dy: 4)
//        let v2 = Vector2(dx: 1, dy: 2)
//
//        let r1 = v1 + v2
//        let r2 = v2 + v1
//
//        #expect(r1 == r2)
//    }
//
//    @Test
//    func `Vector addition is associative`() {
//        let v1 = Vector2(dx: 1, dy: 2)
//        let v2 = Vector2(dx: 3, dy: 4)
//        let v3 = Vector2(dx: 5, dy: 6)
//
//        let r1 = (v1 + v2) + v3
//        let r2 = v1 + (v2 + v3)
//
//        #expect(r1 == r2)
//    }
//
//    @Test
//    func `Vector zero is identity for addition`() {
//        let v = Vector2(dx: 3, dy: 4)
//
//        let r1 = v + .zero
//        let r2 = Vector2.zero + v
//
//        #expect(r1 == v)
//        #expect(r2 == v)
//    }
//
//    @Test
//    func `Scalar multiplication distributes over vector addition`() {
//        let v1 = Vector2(dx: 3, dy: 4)
//        let v2 = Vector2(dx: 1, dy: 2)
//        let s: Double = 2
//
//        let r1 = s * (v1 + v2)
//        let r2 = (s * v1) + (s * v2)
//
//        #expect(r1 == r2)
//    }
//
//    @Test
//    func `Transform identity leaves points unchanged`() {
//        let p = Point2(x: 42, y: 17)
//
//        let result = Transform.apply(.identity, to: p)
//
//        #expect(result == p)
//    }
//
//    @Test
//    func `Transform composition is associative`() {
//        let t1 = Transform.translation(dx: 10, dy: 20)
//        let t2 = Transform.scale(2)
//        let t3 = Transform.rotation(Degree(30))
//
//        let r1 = Transform.concatenating(Transform.concatenating(t1, t2), t3)
//        let r2 = Transform.concatenating(t1, Transform.concatenating(t2, t3))
//
//        let p = Point2(x: 1, y: 1)
//        let p1 = Transform.apply(r1, to: p)
//        let p2 = Transform.apply(r2, to: p)
//
//        #expect(abs(p1.x.value - p2.x.value) < 1e-10)
//        #expect(abs(p1.y.value - p2.y.value) < 1e-10)
//    }
//}
//
//// MARK: - Type Safety Verification
//
//@Suite
//struct `Type Safety - Operator Return Types` {
//
//    @Test
//    func `All coordinate/displacement operators preserve types correctly`() {
//        // These assignments verify compile-time type correctness
//        let x: A.X = 10
//        let dx: A.Dx = 5
//
//        // Coordinate + Displacement = Coordinate
//        let _: A.X = x + dx
//        let _: A.X = dx + x
//
//        // Coordinate - Displacement = Coordinate
//        let _: A.X = x - dx
//
//        // Coordinate - Coordinate = Displacement
//        let x2: A.X = 3
//        let _: A.Dx = x - x2
//
//        // Displacement + Displacement = Displacement
//        let _: A.Dx = dx + dx
//
//        // Displacement * Scalar = Displacement
//        let _: A.Dx = dx * 2.0
//        let _: A.Dx = 2.0 * dx
//
//        // Displacement / Scalar = Displacement
//        let _: A.Dx = dx / 2.0
//
//        // Displacement / Displacement = Scalar (ratio)
//        let _: Double = dx / dx
//
//        // Displacement * Displacement = Scalar (squared)
//        let _: Double = dx * dx
//
//        // Point - Point = Vector
//        let p1 = Point2(x: 10, y: 20)
//        let p2 = Point2(x: 5, y: 10)
//        let _: Vector2 = p1 - p2
//
//        // Point + Vector = Point
//        let v = Vector2(dx: 1, dy: 2)
//        let _: Point2 = p1 + v
//
//        // Point - Vector = Point
//        let _: Point2 = p1 - v
//
//        // If we got here, all type assignments compiled correctly
//        // (this test is primarily about compile-time type checking)
//        #expect(Bool(true), "All type assignments compiled correctly")
//    }
//}
