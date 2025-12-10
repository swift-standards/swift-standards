// GeometryTests.swift

import Testing

@testable import Geometry

// MARK: - Test Unit Type

/// A custom unit type for testing
struct TestUnit: AdditiveArithmetic, Comparable, Codable, Hashable {
    let value: Double

    init(_ value: Double) {
        self.value = value
    }

    static var zero: TestUnit { TestUnit(0) }

    static func + (lhs: TestUnit, rhs: TestUnit) -> TestUnit {
        TestUnit(lhs.value + rhs.value)
    }

    static func - (lhs: TestUnit, rhs: TestUnit) -> TestUnit {
        TestUnit(lhs.value - rhs.value)
    }

    static func < (lhs: TestUnit, rhs: TestUnit) -> Bool {
        lhs.value < rhs.value
    }
}

// MARK: - Geometry Unit Tests

@Suite
struct GeometryUnitTests {
    @Test
    func `Double conforms to Geometry Unit`() {
        let point: Geometry<Double>.Point<2> = .init(x: 10, y: 20)
        #expect(point.x == 10)
    }

    @Test
    func `Custom type conforms to Geometry Unit`() {
        let point: Geometry<TestUnit>.Point<2> = .init(x: TestUnit(10), y: TestUnit(20))
        #expect(point.x.value == 10)
    }
}

// MARK: - Scalar Tests

@Suite
struct ScalarTests {
    @Test
    func `Scalar basic operations`() {
        let a: Geometry<Double>.Scalar = .init(10.0)
        let b: Geometry<Double>.Scalar = .init(5.0)

        #expect((a + b).value == 15)
        #expect((a - b).value == 5)
        #expect((a * 2).value == 20)
        #expect((a / 2).value == 5)
        #expect((-a).value == -10)
    }

    @Test
    func `Scalar comparison`() {
        let a: Geometry<Double>.Scalar = .init(10.0)
        let b: Geometry<Double>.Scalar = .init(20.0)

        #expect(a < b)
        #expect(b > a)
    }

    @Test
    func `Scalar with custom unit`() {
        let a: Geometry<TestUnit>.Scalar = .init(TestUnit(10))
        let b: Geometry<TestUnit>.Scalar = .init(TestUnit(5))
        let sum = a + b
        #expect(sum.value.value == 15)
    }
}

// MARK: - Point Tests

@Suite
struct PointTests {
    @Test
    func `Creates point with coordinates`() {
        let point = Geometry.Point(x: TestUnit(10), y: TestUnit(20))
        #expect(point.x.value == 10)
        #expect(point.y.value == 20)
    }

    @Test
    func `Zero point`() {
        let zero: Geometry<TestUnit>.Point<2> = .zero
        #expect(zero.x.value == 0)
        #expect(zero.y.value == 0)
    }

    @Test
    func `Point addition`() {
        let a = Geometry.Point(x: TestUnit(10), y: TestUnit(20))
        let b = Geometry.Point(x: TestUnit(5), y: TestUnit(15))
        let sum = a + b
        #expect(sum.x.value == 15)
        #expect(sum.y.value == 35)
    }

    @Test
    func `Point subtraction`() {
        let a = Geometry.Point(x: TestUnit(10), y: TestUnit(20))
        let b = Geometry.Point(x: TestUnit(5), y: TestUnit(15))
        let diff = a - b
        #expect(diff.x.value == 5)
        #expect(diff.y.value == 5)
    }

    @Test
    func `Double point translation`() {
        let point: Geometry<Double>.Point<2> = .init(x: 10, y: 20)
        let moved = point.translated(dx: 5, dy: 10)
        #expect(moved.x == 15)
        #expect(moved.y == 30)
    }

    @Test
    func `Double point distance`() {
        let a: Geometry<Double>.Point<2> = .init(x: 0, y: 0)
        let b: Geometry<Double>.Point<2> = .init(x: 3, y: 4)
        #expect(a.distance(to: b) == 5)
    }

    @Test
    func `Point plus vector`() {
        let point: Geometry<Double>.Point<2> = .init(x: 10, y: 20)
        let vector: Geometry<Double>.Vector2 = .init(dx: 5, dy: 10)
        let result = point + vector
        #expect(result.x == 15)
        #expect(result.y == 30)
    }
}

// MARK: - Vector2 Tests

@Suite
struct Vector2Tests {
    @Test
    func `Creates vector`() {
        let v: Geometry<Double>.Vector2 = .init(dx: 3, dy: 4)
        #expect(v.dx == 3)
        #expect(v.dy == 4)
    }

    @Test
    func `Vector length`() {
        let v: Geometry<Double>.Vector2 = .init(dx: 3, dy: 4)
        #expect(v.length == 5)
        #expect(v.lengthSquared == 25)
    }

    @Test
    func `Vector normalization`() {
        let v: Geometry<Double>.Vector2 = .init(dx: 3, dy: 4)
        let n = v.normalized
        #expect(abs(n.length - 1.0) < 0.0001)
    }

    @Test
    func `Vector dot product`() {
        let a: Geometry<Double>.Vector2 = .init(dx: 1, dy: 0)
        let b: Geometry<Double>.Vector2 = .init(dx: 0, dy: 1)
        #expect(a.dot(b) == 0)  // perpendicular
    }

    @Test
    func `Vector cross product`() {
        let a: Geometry<Double>.Vector2 = .init(dx: 1, dy: 0)
        let b: Geometry<Double>.Vector2 = .init(dx: 0, dy: 1)
        #expect(a.cross(b) == 1)  // counter-clockwise
    }

    @Test
    func `Vector arithmetic`() {
        let a: Geometry<Double>.Vector2 = .init(dx: 10, dy: 20)
        let b: Geometry<Double>.Vector2 = .init(dx: 5, dy: 10)

        #expect((a + b).dx == 15)
        #expect((a - b).dx == 5)
        #expect((a * 2).dx == 20)
        #expect((a / 2).dx == 5)
    }
}

// MARK: - Size Tests

@Suite
struct SizeTests {
    @Test
    func `Creates size with dimensions`() {
        let size = Geometry.Size(width: TestUnit(100), height: TestUnit(200))
        #expect(size.width.value == 100)
        #expect(size.height.value == 200)
    }

    @Test
    func `Zero size`() {
        let zero: Geometry<TestUnit>.Size<2> = .zero
        #expect(zero.width.value == 0)
        #expect(zero.height.value == 0)
    }
}

// MARK: - Rectangle Tests

@Suite
struct RectangleTests {
    @Test
    func `Creates rectangle from corners`() {
        let rect = Geometry.Rectangle(
            llx: TestUnit(10),
            lly: TestUnit(20),
            urx: TestUnit(110),
            ury: TestUnit(220)
        )
        #expect(rect.llx.value == 10)
        #expect(rect.lly.value == 20)
        #expect(rect.urx.value == 110)
        #expect(rect.ury.value == 220)
    }

    @Test
    func `Creates rectangle from origin and size`() {
        let rect = Geometry.Rectangle(
            x: TestUnit(10),
            y: TestUnit(20),
            width: TestUnit(100),
            height: TestUnit(200)
        )
        #expect(rect.llx.value == 10)
        #expect(rect.lly.value == 20)
        #expect(rect.width.value == 100)
        #expect(rect.height.value == 200)
    }

    @Test
    func `Rectangle contains point`() {
        let rect: Geometry<Double>.Rectangle = .init(x: 0, y: 0, width: 100, height: 100)
        let inside: Geometry<Double>.Point<2> = .init(x: 50, y: 50)
        let outside: Geometry<Double>.Point<2> = .init(x: 150, y: 150)

        #expect(rect.contains(inside))
        #expect(!rect.contains(outside))
    }

    @Test
    func `Rectangle intersection`() {
        let a: Geometry<Double>.Rectangle = .init(x: 0, y: 0, width: 100, height: 100)
        let b: Geometry<Double>.Rectangle = .init(x: 50, y: 50, width: 100, height: 100)

        #expect(a.intersects(b))

        let intersection = a.intersection(b)!
        #expect(intersection.llx == 50)
        #expect(intersection.lly == 50)
        #expect(intersection.urx == 100)
        #expect(intersection.ury == 100)
    }

    @Test
    func `Rectangle union`() {
        let a: Geometry<Double>.Rectangle = .init(x: 0, y: 0, width: 50, height: 50)
        let b: Geometry<Double>.Rectangle = .init(x: 50, y: 50, width: 50, height: 50)

        let union = a.union(b)
        #expect(union.minX == 0)
        #expect(union.minY == 0)
        #expect(union.maxX == 100)
        #expect(union.maxY == 100)
    }

    @Test
    func `Rectangle inset`() {
        let rect: Geometry<Double>.Rectangle = .init(x: 0, y: 0, width: 100, height: 100)
        let inset = rect.insetBy(dx: 10, dy: 20)

        #expect(inset.llx == 10)
        #expect(inset.lly == 20)
        #expect(inset.urx == 90)
        #expect(inset.ury == 80)
    }

    @Test
    func `Rectangle center`() {
        let rect: Geometry<Double>.Rectangle = .init(x: 0, y: 0, width: 100, height: 100)
        #expect(rect.midX == 50)
        #expect(rect.midY == 50)
        #expect(rect.center.x == 50)
        #expect(rect.center.y == 50)
    }

    @Test
    func `Rectangle corners`() {
        let rect = Geometry.Rectangle(
            x: TestUnit(10),
            y: TestUnit(20),
            width: TestUnit(100),
            height: TestUnit(200)
        )

        let ll = rect.corner(.lowerLeft)
        #expect(ll.x.value == 10)
        #expect(ll.y.value == 20)

        let ur = rect.corner(.upperRight)
        #expect(ur.x.value == 110)
        #expect(ur.y.value == 220)
    }
}

// MARK: - Radian Tests

@Suite
struct RadianTests {
    @Test
    func `Radian zero`() {
        let zero: Geometry<Double>.Radian = .zero
        #expect(zero.value == 0)
    }

    @Test
    func `Radian arithmetic`() {
        let a: Geometry<Double>.Radian = .init(1.0)
        let b: Geometry<Double>.Radian = .init(2.0)
        let sum = a + b
        #expect(sum.value == 3.0)
    }

    @Test
    func `Radian comparable`() {
        let a: Geometry<Double>.Radian = .init(1.0)
        let b: Geometry<Double>.Radian = .init(2.0)
        #expect(a < b)
    }
}

// MARK: - Degree Tests

@Suite
struct DegreeTests {
    @Test
    func `Degree zero`() {
        let zero: Geometry<Double>.Degree = .zero
        #expect(zero.value == 0)
    }

    @Test
    func `Degree arithmetic`() {
        let a: Geometry<Double>.Degree = .init(45)
        let b: Geometry<Double>.Degree = .init(45)
        let sum = a + b
        #expect(sum.value == 90)
    }

    @Test
    func `Degree comparable`() {
        let a: Geometry<Double>.Degree = .init(45)
        let b: Geometry<Double>.Degree = .init(90)
        #expect(a < b)
    }

    @Test
    func `Degree literal`() {
        let deg: Geometry<Double>.Degree = 90.0
        #expect(deg.value == 90)
    }
}

// MARK: - AffineTransform Tests

@Suite
struct AffineTransformTests {
    @Test
    func `Identity transform`() {
        let transform: Geometry<Double>.AffineTransform2 = .identity
        let point: Geometry<Double>.Point<2> = .init(x: 10, y: 20)
        let result = transform.apply(to: point)

        #expect(result.x == 10)
        #expect(result.y == 20)
    }

    @Test
    func `Translation transform`() {
        let transform: Geometry<Double>.AffineTransform2 = .translation(x: .init(100), y: .init(50))
        let point: Geometry<Double>.Point<2> = .init(x: 10, y: 20)
        let result = transform.apply(to: point)

        #expect(result.x == 110)
        #expect(result.y == 70)
    }

    @Test
    func `Scale transform`() {
        let transform: Geometry<Double>.AffineTransform2 = .scale(2)
        let point: Geometry<Double>.Point<2> = .init(x: 10, y: 20)
        let result = transform.apply(to: point)

        #expect(result.x == 20)
        #expect(result.y == 40)
    }

    @Test
    func `Rotation transform`() {
        // 90 degree rotation: cos = 0, sin = 1
        let transform: Geometry<Double>.AffineTransform2 = .rotation(cos: 0, sin: 1)
        let point: Geometry<Double>.Point<2> = .init(x: 1, y: 0)
        let result = transform.apply(to: point)

        #expect(abs(result.x - 0) < 0.0001)
        #expect(abs(result.y - 1) < 0.0001)
    }

    @Test
    func `Transform concatenation`() {
        let translate: Geometry<Double>.AffineTransform2 = .translation(x: .init(10), y: .init(0))
        let scale: Geometry<Double>.AffineTransform2 = .scale(2)

        // Scale first, then translate
        let combined = translate.concatenating(scale)

        let point: Geometry<Double>.Point<2> = .init(x: 5, y: 5)
        let result = combined.apply(to: point)

        // 5 * 2 = 10, then + 10 = 20
        #expect(result.x == 20)
        #expect(result.y == 10)
    }

    @Test
    func `Transform inversion`() {
        let transform: Geometry<Double>.AffineTransform2 = .translation(x: .init(100), y: .init(50))
        let inverse = transform.inverted!

        let point: Geometry<Double>.Point<2> = .init(x: 110, y: 70)
        let result = inverse.apply(to: point)

        #expect(abs(result.x - 10) < 0.0001)
        #expect(abs(result.y - 20) < 0.0001)
    }
}

// MARK: - LineSegment Tests

@Suite
struct LineSegmentTests {
    @Test
    func `Line segment length`() {
        let segment: Geometry<Double>.LineSegment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 3, y: 4)
        )
        #expect(segment.length == 5)
    }

    @Test
    func `Line segment midpoint`() {
        let segment: Geometry<Double>.LineSegment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 10, y: 10)
        )
        #expect(segment.midpoint.x == 5)
        #expect(segment.midpoint.y == 5)
    }

    @Test
    func `Line segment point at parameter`() {
        let segment: Geometry<Double>.LineSegment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 10, y: 10)
        )

        let quarter = segment.point(at: 0.25)
        #expect(quarter.x == 2.5)
        #expect(quarter.y == 2.5)
    }

    @Test
    func `Line segment vector`() {
        let segment: Geometry<Double>.LineSegment = .init(
            start: .init(x: 10, y: 20),
            end: .init(x: 30, y: 50)
        )
        #expect(segment.vector.dx == 20)
        #expect(segment.vector.dy == 30)
    }
}

// MARK: - Line Tests

@Suite
struct LineTests {
    @Test
    func `Line from point and direction`() {
        let line: Geometry<Double>.Line = .init(
            point: .init(x: 0, y: 0),
            direction: .init(dx: 1, dy: 1)
        )
        #expect(line.point.x == 0)
        #expect(line.point.y == 0)
        #expect(line.direction.dx == 1)
        #expect(line.direction.dy == 1)
    }

    @Test
    func `Line from two points`() {
        let line: Geometry<Double>.Line = .init(
            from: .init(x: 0, y: 0),
            to: .init(x: 10, y: 20)
        )
        #expect(line.point.x == 0)
        #expect(line.point.y == 0)
        #expect(line.direction.dx == 10)
        #expect(line.direction.dy == 20)
    }

    @Test
    func `Line point at parameter`() {
        let line: Geometry<Double>.Line = .init(
            point: .init(x: 0, y: 0),
            direction: .init(dx: 10, dy: 10)
        )
        let p = line.point(at: 0.5)
        #expect(p.x == 5)
        #expect(p.y == 5)
    }

    @Test
    func `Line distance to point`() {
        // Horizontal line y = 0
        let line: Geometry<Double>.Line = .init(
            point: .init(x: 0, y: 0),
            direction: .init(dx: 1, dy: 0)
        )
        // Point at (5, 3) should be distance 3 from line
        let point: Geometry<Double>.Point<2> = .init(x: 5, y: 3)
        #expect(line.distance(to: point) == 3)

        // Zero direction vector returns nil
        let degenerateLine: Geometry<Double>.Line = .init(
            point: .init(x: 0, y: 0),
            direction: .init(dx: 0, dy: 0)
        )
        #expect(degenerateLine.distance(to: point) == nil)
    }

    @Test
    func `Line Segment via nested type`() {
        // Test that Line.Segment works the same as LineSegment
        let segment: Geometry<Double>.Line.Segment = .init(
            start: .init(x: 0, y: 0),
            end: .init(x: 3, y: 4)
        )
        #expect(segment.length == 5)
    }

    @Test
    func `Segment to Line conversion`() {
        let segment: Geometry<Double>.Line.Segment = .init(
            start: .init(x: 10, y: 20),
            end: .init(x: 30, y: 50)
        )
        let line = segment.line
        #expect(line.point.x == 10)
        #expect(line.point.y == 20)
        #expect(line.direction.dx == 20)
        #expect(line.direction.dy == 30)
    }
}

// MARK: - EdgeInsets Tests

@Suite
struct EdgeInsetsTests {
    @Test
    func `Creates edge insets`() {
        let insets = Geometry.EdgeInsets(
            top: TestUnit(10),
            leading: TestUnit(20),
            bottom: TestUnit(30),
            trailing: TestUnit(40)
        )
        #expect(insets.top.value == 10)
        #expect(insets.leading.value == 20)
        #expect(insets.bottom.value == 30)
        #expect(insets.trailing.value == 40)
    }

    @Test
    func `Creates uniform edge insets`() {
        let insets = Geometry.EdgeInsets(all: TestUnit(10))
        #expect(insets.top.value == 10)
        #expect(insets.leading.value == 10)
        #expect(insets.bottom.value == 10)
        #expect(insets.trailing.value == 10)
    }

    @Test
    func `Zero edge insets`() {
        let zero: Geometry<TestUnit>.EdgeInsets = .zero
        #expect(zero.top.value == 0)
        #expect(zero.leading.value == 0)
        #expect(zero.bottom.value == 0)
        #expect(zero.trailing.value == 0)
    }
}

// MARK: - Dimension Tests

@Suite
struct DimensionTests {
    @Test
    func `Width comparison`() {
        let a = Geometry.Width(TestUnit(10))
        let b = Geometry.Width(TestUnit(20))
        #expect(a < b)
    }

    @Test
    func `Height addition`() {
        let a = Geometry.Height(TestUnit(10))
        let b = Geometry.Height(TestUnit(20))
        let sum = a + b
        #expect(sum.value.value == 30)
    }

    @Test
    func `Length zero`() {
        let zero: Geometry<TestUnit>.Length = .zero
        #expect(zero.value.value == 0)
    }

    @Test
    func `Width literals`() {
        let w: Geometry<Double>.Width = 100.0
        #expect(w.value == 100)

        let wInt: Geometry<Double>.Width = 50
        #expect(wInt.value == 50)
    }

    @Test
    func `Height negation`() {
        let h: Geometry<Double>.Height = .init(10)
        let neg = -h
        #expect(neg.value == -10)
    }

    @Test
    func `Length multiplication and division`() {
        let len: Geometry<Double>.Length = .init(10)
        #expect((len * 2).value == 20)
        #expect((2 * len).value == 20)
        #expect((len / 2).value == 5)
    }

    @Test
    func `Dimension map`() {
        let dim: Geometry<Double>.Dimension = .init(10)
        let mapped = dim.map { $0 * 2 }
        #expect(mapped.value == 20)
    }

    @Test
    func `X negation and multiplication`() {
        let x: Geometry<Double>.X = .init(10)
        #expect((-x).value == -10)
        #expect((x * 2).value == 20)
        #expect((x / 2).value == 5)
    }

    @Test
    func `Y negation and multiplication`() {
        let y: Geometry<Double>.Y = .init(10)
        #expect((-y).value == -10)
        #expect((y * 2).value == 20)
        #expect((y / 2).value == 5)
    }
}

// MARK: - AffineTransform Generic Tests

@Suite
struct AffineTransformGenericTests {
    @Test
    func `Float AffineTransform`() {
        let transform: Geometry<Float>.AffineTransform = .identity
        let point: Geometry<Float>.Point<2> = .init(x: 10, y: 20)
        let result = transform.apply(to: point)
        #expect(result.x == 10)
        #expect(result.y == 20)
    }

    @Test
    func `Float rotation`() {
        let transform: Geometry<Float>.AffineTransform = .rotation(cos: 0, sin: 1)
        let point: Geometry<Float>.Point<2> = .init(x: 1, y: 0)
        let result = transform.apply(to: point)
        #expect(abs(result.x) < 0.0001)
        #expect(abs(result.y - 1) < 0.0001)
    }

    @Test
    func `AffineTransform map`() {
        let transform: Geometry<Double>.AffineTransform = .scale(2)
        let floatTransform = transform.map { Float($0) }
        #expect(floatTransform.a == 2)
    }
}
