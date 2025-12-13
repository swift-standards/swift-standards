// Tagged Tests.swift

import StandardsTestSupport
import Testing
@_spi(Internal) @testable import Dimension

// MARK: - Tagged - Static Functions

@Suite
struct `Tagged - Static Functions` {
    enum Tag1 {}
    enum Tag2 {}

    @Test
    func `map transforms raw value`() {
        let tagged: Tagged<Tag1, Int> = Tagged(10)
        let result = Tagged<Tag1, Int>.map(tagged) { $0 * 2 }
        #expect(result.rawValue == 20)
    }

    @Test
    func `map preserves tag`() {
        let tagged: Tagged<Tag1, Int> = Tagged(10)
        let result: Tagged<Tag1, Double> = Tagged<Tag1, Int>.map(tagged) { Double($0) }
        #expect(result.rawValue == 10.0)
    }

    @Test
    func `retag changes tag type`() {
        let tagged: Tagged<Tag1, Int> = Tagged(42)
        let retagged: Tagged<Tag2, Int> = Tagged<Tag1, Int>.retag(tagged, to: Tag2.self)
        #expect(retagged.rawValue == 42)
    }

    @Test(arguments: [10, 20, -5, 0])
    func `retag preserves raw value`(value: Int) {
        let tagged: Tagged<Tag1, Int> = Tagged(value)
        let retagged: Tagged<Tag2, Int> = Tagged<Tag1, Int>.retag(tagged)
        #expect(retagged.rawValue == value)
    }
}

// MARK: - Tagged - Properties

@Suite
struct `Tagged - Properties` {
    enum TestTag {}

    @Test
    func `rawValue accessor`() {
        let tagged: Tagged<TestTag, Int> = Tagged(42)
        #expect(tagged.rawValue == 42)
    }

    @Test
    func `value is alias for rawValue`() {
        let tagged: Tagged<TestTag, Int> = Tagged(100)
        #expect(tagged.value == tagged.rawValue)
        #expect(tagged.value == 100)
    }

    @Test
    func `map property delegates to static function`() {
        let tagged: Tagged<TestTag, Int> = Tagged(10)
        let result1 = tagged.map { $0 * 2 }
        let result2 = Tagged<TestTag, Int>.map(tagged) { $0 * 2 }
        #expect(result1 == result2)
    }

    @Test
    func `retag property delegates to static function`() {
        enum Tag1 {}
        enum Tag2 {}
        let tagged: Tagged<Tag1, Int> = Tagged(42)
        let result1: Tagged<Tag2, Int> = tagged.retag()
        let result2: Tagged<Tag2, Int> = Tagged<Tag1, Int>.retag(tagged)
        #expect(result1 == result2)
    }
}

// MARK: - Tagged - Initializers

@Suite
struct `Tagged - Initializers` {
    enum TestTag {}

    @Test
    func `init with raw value`() {
        let tagged: Tagged<TestTag, Int> = Tagged(42)
        #expect(tagged.rawValue == 42)
    }

    @Test
    func `init with rawValue label`() {
        let tagged: Tagged<TestTag, String> = Tagged(rawValue: "hello")
        #expect(tagged.rawValue == "hello")
    }

    @Test
    func `integer literal initialization`() {
        let tagged: Tagged<TestTag, Int> = 42
        #expect(tagged.rawValue == 42)
    }

    @Test
    func `float literal initialization`() {
        let tagged: Tagged<TestTag, Double> = 3.14
        #expect(tagged.rawValue == 3.14)
    }

    @Test
    func `string literal initialization`() {
        let tagged: Tagged<TestTag, String> = "hello"
        #expect(tagged.rawValue == "hello")
    }

    @Test
    func `boolean literal initialization`() {
        let tagged: Tagged<TestTag, Bool> = true
        #expect(tagged.rawValue == true)
    }
}

// MARK: - Tagged - Protocol Conformances

@Suite
struct `Tagged - Protocol Conformances` {
    enum TestTag {}

    @Test
    func `Equatable when rawValue is Equatable`() {
        let tag1: Tagged<TestTag, Int> = Tagged(10)
        let tag2: Tagged<TestTag, Int> = Tagged(10)
        let tag3: Tagged<TestTag, Int> = Tagged(20)
        #expect(tag1 == tag2)
        #expect(tag1 != tag3)
    }

    @Test
    func `Hashable when rawValue is Hashable`() {
        let set: Set<Tagged<TestTag, Int>> = [Tagged(10), Tagged(20), Tagged(10)]
        #expect(set.count == 2)
    }

    @Test
    func `Comparable when rawValue is Comparable`() {
        let tag1: Tagged<TestTag, Int> = Tagged(10)
        let tag2: Tagged<TestTag, Int> = Tagged(20)
        #expect(tag1 < tag2)
        #expect(tag2 > tag1)
    }

    @Test
    func `max function`() {
        let tag1: Tagged<TestTag, Int> = Tagged(10)
        let tag2: Tagged<TestTag, Int> = Tagged(20)
        let result = Tagged<TestTag, Int>.max(tag1, tag2)
        #expect(result.rawValue == 20)
    }

    @Test
    func `min function`() {
        let tag1: Tagged<TestTag, Int> = Tagged(10)
        let tag2: Tagged<TestTag, Int> = Tagged(20)
        let result = Tagged<TestTag, Int>.min(tag1, tag2)
        #expect(result.rawValue == 10)
    }
}

// MARK: - Tagged - Affine Arithmetic (Displacement)

@Suite
struct `Tagged - Displacement Arithmetic` {
    enum TestSpace {}

    @Test
    func `displacement + displacement`() {
        let dx1: Displacement.X<TestSpace>.Value<Double> = Tagged(10.0)
        let dx2: Displacement.X<TestSpace>.Value<Double> = Tagged(20.0)
        let result = dx1 + dx2
        #expect(result.rawValue == 30.0)
    }

    @Test
    func `displacement - displacement`() {
        let dx1: Displacement.X<TestSpace>.Value<Double> = Tagged(30.0)
        let dx2: Displacement.X<TestSpace>.Value<Double> = Tagged(10.0)
        let result = dx1 - dx2
        #expect(result.rawValue == 20.0)
    }

    @Test
    func `displacement negation`() {
        let dx: Displacement.X<TestSpace>.Value<Double> = Tagged(10.0)
        let result = -dx
        #expect(result.rawValue == -10.0)
    }

    @Test
    func `displacement scaling by scalar`() {
        let dx: Displacement.X<TestSpace>.Value<Double> = Tagged(10.0)
        let result1 = dx * 2.0
        let result2 = 2.0 * dx
        #expect(result1.rawValue == 20.0)
        #expect(result2.rawValue == 20.0)
    }

    @Test
    func `displacement division by scalar`() {
        let dx: Displacement.X<TestSpace>.Value<Double> = Tagged(10.0)
        let result = dx / 2.0
        #expect(result.rawValue == 5.0)
    }

    @Test
    func `displacement ratio returns scalar`() {
        let dx1: Displacement.X<TestSpace>.Value<Double> = Tagged(10.0)
        let dx2: Displacement.X<TestSpace>.Value<Double> = Tagged(2.0)
        let ratio: Double = dx1 / dx2
        #expect(ratio == 5.0)
    }
}

// MARK: - Tagged - Affine Arithmetic (Coordinate + Displacement)

@Suite
struct `Tagged - Coordinate Displacement Arithmetic` {
    enum TestSpace {}

    @Test
    func `coordinate + displacement = coordinate`() {
        let x: Coordinate.X<TestSpace>.Value<Double> = Tagged(10.0)
        let dx: Displacement.X<TestSpace>.Value<Double> = Tagged(5.0)
        let result = x + dx
        #expect(result.rawValue == 15.0)
    }

    @Test
    func `displacement + coordinate = coordinate`() {
        let dx: Displacement.X<TestSpace>.Value<Double> = Tagged(5.0)
        let x: Coordinate.X<TestSpace>.Value<Double> = Tagged(10.0)
        let result = dx + x
        #expect(result.rawValue == 15.0)
    }

    @Test
    func `coordinate - displacement = coordinate`() {
        let x: Coordinate.X<TestSpace>.Value<Double> = Tagged(10.0)
        let dx: Displacement.X<TestSpace>.Value<Double> = Tagged(3.0)
        let result = x - dx
        #expect(result.rawValue == 7.0)
    }

    @Test
    func `coordinate - coordinate = displacement`() {
        let x1: Coordinate.X<TestSpace>.Value<Double> = Tagged(10.0)
        let x2: Coordinate.X<TestSpace>.Value<Double> = Tagged(7.0)
        let result: Displacement.X<TestSpace>.Value<Double> = x1 - x2
        #expect(result.rawValue == 3.0)
    }
}

// MARK: - Tagged - Angle Arithmetic

@Suite
struct `Tagged - Angle Arithmetic` {

    @Test
    func `radian + radian`() {
        let r1: Radian<Double> = Tagged(.pi)
        let r2: Radian<Double> = Tagged(.pi / 2)
        let result = r1 + r2
        #expect(result.rawValue == .pi * 1.5)
    }

    @Test
    func `radian - radian`() {
        let r1: Radian<Double> = Tagged(.pi)
        let r2: Radian<Double> = Tagged(.pi / 2)
        let result = r1 - r2
        #expect(result.rawValue == .pi / 2)
    }

    @Test
    func `radian scaling by scalar`() {
        let r: Radian<Double> = Tagged(.pi)
        let result1 = r * 2.0
        let result2 = 2.0 * r
        #expect(result1.rawValue == .pi * 2)
        #expect(result2.rawValue == .pi * 2)
    }

    @Test
    func `radian division by scalar`() {
        let r: Radian<Double> = Tagged(.pi)
        let result = r / 2.0
        #expect(result.rawValue == .pi / 2)
    }

    @Test
    func `degree + degree`() {
        let d1: Degree<Double> = Tagged(90.0)
        let d2: Degree<Double> = Tagged(45.0)
        let result = d1 + d2
        #expect(result.rawValue == 135.0)
    }

    @Test
    func `degree - degree`() {
        let d1: Degree<Double> = Tagged(90.0)
        let d2: Degree<Double> = Tagged(45.0)
        let result = d1 - d2
        #expect(result.rawValue == 45.0)
    }
}

// MARK: - Tagged - Magnitude Arithmetic

@Suite
struct `Tagged - Magnitude Arithmetic` {
    enum TestSpace {}

    @Test
    func `magnitude + magnitude`() {
        let m1: Magnitude<TestSpace>.Value<Double> = Tagged(10.0)
        let m2: Magnitude<TestSpace>.Value<Double> = Tagged(5.0)
        let result = m1 + m2
        #expect(result.rawValue == 15.0)
    }

    @Test
    func `magnitude - magnitude`() {
        let m1: Magnitude<TestSpace>.Value<Double> = Tagged(10.0)
        let m2: Magnitude<TestSpace>.Value<Double> = Tagged(3.0)
        let result = m1 - m2
        #expect(result.rawValue == 7.0)
    }

    @Test
    func `magnitude scaling`() {
        let m: Magnitude<TestSpace>.Value<Double> = Tagged(10.0)
        let result = m * 2.0
        #expect(result.rawValue == 20.0)
    }

    @Test
    func `coordinate + magnitude = coordinate`() {
        let x: Coordinate.X<TestSpace>.Value<Double> = Tagged(10.0)
        let m: Magnitude<TestSpace>.Value<Double> = Tagged(5.0)
        let result = x + m
        #expect(result.rawValue == 15.0)
    }

    @Test
    func `coordinate - magnitude = coordinate`() {
        let x: Coordinate.X<TestSpace>.Value<Double> = Tagged(10.0)
        let m: Magnitude<TestSpace>.Value<Double> = Tagged(3.0)
        let result = x - m
        #expect(result.rawValue == 7.0)
    }
}

// MARK: - Tagged - Dimensional Arithmetic

@Suite
struct `Tagged - Dimensional Arithmetic` {
    enum TestSpace {}

    @Test
    func `displacement x displacement = area`() {
        let dx: Displacement.X<TestSpace>.Value<Double> = Tagged(3.0)
        let dy: Displacement.Y<TestSpace>.Value<Double> = Tagged(4.0)
        let area: Area<TestSpace>.Value<Double> = dx * dy
        #expect(area.rawValue == 12.0)
    }

    @Test
    func `area + area`() {
        let a1: Area<TestSpace>.Value<Double> = Tagged(10.0)
        let a2: Area<TestSpace>.Value<Double> = Tagged(5.0)
        let result = a1 + a2
        #expect(result.rawValue == 15.0)
    }

    @Test
    func `area - area`() {
        let a1: Area<TestSpace>.Value<Double> = Tagged(10.0)
        let a2: Area<TestSpace>.Value<Double> = Tagged(3.0)
        let result = a1 - a2
        #expect(result.rawValue == 7.0)
    }

    @Test
    func `area div magnitude = magnitude`() {
        let area: Area<TestSpace>.Value<Double> = Tagged(12.0)
        let mag: Magnitude<TestSpace>.Value<Double> = Tagged(3.0)
        let result: Magnitude<TestSpace>.Value<Double> = area / mag
        #expect(result.rawValue == 4.0)
    }
}

// MARK: - Tagged - Free Functions

@Suite
struct `Tagged - Free Functions` {
    enum TestSpace {}

    @Test
    func `abs function`() {
        let negative: Displacement.X<TestSpace>.Value<Double> = Tagged(-10.0)
        let result = abs(negative)
        #expect(result.rawValue == 10.0)
    }

    @Test
    func `min free function`() {
        let dx1: Displacement.X<TestSpace>.Value<Double> = Tagged(10.0)
        let dx2: Displacement.X<TestSpace>.Value<Double> = Tagged(20.0)
        let result = min(dx1, dx2)
        #expect(result.rawValue == 10.0)
    }

    @Test
    func `max free function`() {
        let dx1: Displacement.X<TestSpace>.Value<Double> = Tagged(10.0)
        let dx2: Displacement.X<TestSpace>.Value<Double> = Tagged(20.0)
        let result = max(dx1, dx2)
        #expect(result.rawValue == 20.0)
    }
}

// MARK: - Tagged - Strideable

@Suite
struct `Tagged - Strideable` {
    enum TestTag {}

    @Test
    func `distance between tagged values`() {
        let tag1: Tagged<TestTag, Int> = Tagged(10)
        let tag2: Tagged<TestTag, Int> = Tagged(20)
        let distance = tag1.distance(to: tag2)
        #expect(distance == 10)
    }

    @Test
    func `advanced by stride`() {
        let tagged: Tagged<TestTag, Int> = Tagged(10)
        let result = tagged.advanced(by: 5)
        #expect(result.rawValue == 15)
    }
}

// MARK: - Tagged - AdditiveArithmetic Zero

@Suite
struct `Tagged - Zero` {
    enum TestTag {}
    enum TestSpace {}

    @Test
    func `zero for generic tag`() {
        let zero: Tagged<TestTag, Int> = .zero
        #expect(zero.rawValue == 0)
    }

    @Test
    func `zero for displacement`() {
        let zero: Displacement.X<TestSpace>.Value<Double> = .zero
        #expect(zero.rawValue == 0.0)
    }

    @Test
    func `zero for magnitude`() {
        let zero: Magnitude<TestSpace>.Value<Double> = .zero
        #expect(zero.rawValue == 0.0)
    }

    @Test
    func `zero for radian`() {
        let zero: Radian<Double> = .zero
        #expect(zero.rawValue == 0.0)
    }
}
