// Affine.Translation Tests.swift
// Tests for Affine.Translation.swift

import Testing

@testable import Affine
@testable import Algebra
@testable import Algebra_Linear

@Suite("Affine.Translation Tests")
struct AffineTranslationTests {
    typealias Translation = Affine<Double, Void>.Translation
    typealias Dx = Linear<Double, Void>.Dx
    typealias Dy = Linear<Double, Void>.Dy
    typealias Vec2 = Linear<Double, Void>.Vector<2>

    // MARK: - Construction Tests

    @Suite("Construction")
    struct ConstructionTests {
        @Test("Construction from typed components")
        func typedComponents() {
            let t = Translation(dx: Dx(3), dy: Dy(4))
            #expect(t.dx.value == 3)
            #expect(t.dy.value == 4)
        }

        @Test("Construction from raw scalars")
        func rawScalars() {
            let t = Translation(dx: 3.0, dy: 4.0)
            #expect(t.dx.value == 3)
            #expect(t.dy.value == 4)
        }

        @Test("Construction from vector")
        func fromVector() {
            let v = Vec2(dx: 3, dy: 4)
            let t = Translation(v)
            #expect(t.dx.value == 3)
            #expect(t.dy.value == 4)
        }
    }

    // MARK: - Zero Tests

    @Suite("Zero")
    struct ZeroTests {
        @Test("Zero translation")
        func zero() {
            let t = Translation.zero
            #expect(t.dx.value == 0)
            #expect(t.dy.value == 0)
        }

        @Test("Zero is additive identity")
        func zeroIsIdentity() {
            let t = Translation(dx: 5.0, dy: 10.0)
            let result1 = t + .zero
            let result2 = Translation.zero + t
            #expect(result1.dx.value == 5)
            #expect(result1.dy.value == 10)
            #expect(result2.dx.value == 5)
            #expect(result2.dy.value == 10)
        }
    }

    // MARK: - Addition Tests

    @Suite("Addition")
    struct AdditionTests {
        @Test("Add translations", arguments: [
            (Translation(dx: 3.0, dy: 4.0), Translation(dx: 1.0, dy: 2.0), 4.0, 6.0),
            (Translation(dx: 0.0, dy: 0.0), Translation(dx: 5.0, dy: 10.0), 5.0, 10.0),
            (Translation(dx: -3.0, dy: -4.0), Translation(dx: 3.0, dy: 4.0), 0.0, 0.0)
        ])
        func addition(t1: Translation, t2: Translation, expectedDx: Double, expectedDy: Double) {
            let result = t1 + t2
            #expect(result.dx.value == expectedDx)
            #expect(result.dy.value == expectedDy)
        }

        @Test("Addition is commutative")
        func additionCommutative() {
            let t1 = Translation(dx: 3.0, dy: 4.0)
            let t2 = Translation(dx: 5.0, dy: 6.0)
            let result1 = t1 + t2
            let result2 = t2 + t1
            #expect(result1.dx.value == result2.dx.value)
            #expect(result1.dy.value == result2.dy.value)
        }

        @Test("Addition is associative")
        func additionAssociative() {
            let t1 = Translation(dx: 1.0, dy: 2.0)
            let t2 = Translation(dx: 3.0, dy: 4.0)
            let t3 = Translation(dx: 5.0, dy: 6.0)
            let result1 = (t1 + t2) + t3
            let result2 = t1 + (t2 + t3)
            #expect(result1.dx.value == result2.dx.value)
            #expect(result1.dy.value == result2.dy.value)
        }
    }

    // MARK: - Subtraction Tests

    @Suite("Subtraction")
    struct SubtractionTests {
        @Test("Subtract translations", arguments: [
            (Translation(dx: 5.0, dy: 8.0), Translation(dx: 2.0, dy: 3.0), 3.0, 5.0),
            (Translation(dx: 0.0, dy: 0.0), Translation(dx: 1.0, dy: 1.0), -1.0, -1.0),
            (Translation(dx: 10.0, dy: 10.0), Translation(dx: 10.0, dy: 10.0), 0.0, 0.0)
        ])
        func subtraction(t1: Translation, t2: Translation, expectedDx: Double, expectedDy: Double) {
            let result = t1 - t2
            #expect(result.dx.value == expectedDx)
            #expect(result.dy.value == expectedDy)
        }

        @Test("Subtraction with zero")
        func subtractionWithZero() {
            let t = Translation(dx: 5.0, dy: 10.0)
            let result1 = t - .zero
            let result2 = Translation.zero - t
            #expect(result1.dx.value == 5)
            #expect(result1.dy.value == 10)
            #expect(result2.dx.value == -5)
            #expect(result2.dy.value == -10)
        }

        @Test("Self-subtraction gives zero")
        func selfSubtraction() {
            let t = Translation(dx: 5.0, dy: 10.0)
            let result = t - t
            #expect(result.dx.value == 0)
            #expect(result.dy.value == 0)
        }
    }

    // MARK: - Negation Tests

    @Suite("Negation")
    struct NegationTests {
        @Test("Negate translation", arguments: [
            (Translation(dx: 3.0, dy: 4.0), -3.0, -4.0),
            (Translation(dx: -5.0, dy: -10.0), 5.0, 10.0),
            (Translation(dx: 0.0, dy: 0.0), 0.0, 0.0)
        ])
        func negation(t: Translation, expectedDx: Double, expectedDy: Double) {
            let result = -t
            #expect(result.dx.value == expectedDx)
            #expect(result.dy.value == expectedDy)
        }

        @Test("Double negation")
        func doubleNegation() {
            let t = Translation(dx: 3.0, dy: 4.0)
            let result = -(-t)
            #expect(result.dx.value == 3)
            #expect(result.dy.value == 4)
        }

        @Test("Adding negation gives zero")
        func addingNegation() {
            let t = Translation(dx: 5.0, dy: 10.0)
            let result = t + (-t)
            #expect(result.dx.value == 0)
            #expect(result.dy.value == 0)
        }
    }

    // MARK: - Vector Conversion Tests

    @Suite("Vector Conversion")
    struct VectorConversionTests {
        @Test("Convert to vector")
        func toVector() {
            let t = Translation(dx: 3.0, dy: 4.0)
            let v = t.vector
            #expect(v.dx.value == 3)
            #expect(v.dy.value == 4)
        }

        @Test("Round-trip conversion")
        func roundTrip() {
            let original = Translation(dx: 5.0, dy: 10.0)
            let v = original.vector
            let roundTripped = Translation(v)
            #expect(roundTripped.dx.value == original.dx.value)
            #expect(roundTripped.dy.value == original.dy.value)
        }

        @Test("Zero translation to zero vector")
        func zeroToZeroVector() {
            let t = Translation.zero
            let v = t.vector
            #expect(v.dx.value == 0)
            #expect(v.dy.value == 0)
        }
    }

    // MARK: - Equatable Tests

    @Suite("Equatable")
    struct EquatableTests {
        @Test("Translation equality")
        func equality() {
            let a = Translation(dx: 3.0, dy: 4.0)
            let b = Translation(dx: 3.0, dy: 4.0)
            let c = Translation(dx: 3.0, dy: 5.0)
            #expect(a == b)
            #expect(a != c)
        }

        @Test("Zero equals zero")
        func zeroEquality() {
            #expect(Translation.zero == Translation.zero)
        }

        @Test("Different translations are not equal")
        func differentNotEqual() {
            let t1 = Translation(dx: 1.0, dy: 2.0)
            let t2 = Translation(dx: 2.0, dy: 1.0)
            #expect(t1 != t2)
        }
    }

    // MARK: - Hashable Tests

    @Suite("Hashable")
    struct HashableTests {
        @Test("Equal translations have same hash")
        func equalHash() {
            let a = Translation(dx: 3.0, dy: 4.0)
            let b = Translation(dx: 3.0, dy: 4.0)
            #expect(a.hashValue == b.hashValue)
        }

        @Test("Can use translation as dictionary key")
        func dictionaryKey() {
            var dict: [Translation: String] = [:]
            let key = Translation(dx: 1.0, dy: 2.0)
            dict[key] = "test"
            #expect(dict[key] == "test")
        }
    }

    // MARK: - AdditiveArithmetic Protocol Tests

    @Suite("AdditiveArithmetic Protocol")
    struct AdditiveArithmeticTests {
        @Test("Translation conforms to AdditiveArithmetic")
        func conformance() {
            func requiresAdditiveArithmetic<T: AdditiveArithmetic>(_ value: T) -> T {
                value
            }
            let t = Translation(dx: 1.0, dy: 2.0)
            let result = requiresAdditiveArithmetic(t)
            #expect(result.dx.value == 1)
            #expect(result.dy.value == 2)
        }

        @Test("AdditiveArithmetic zero")
        func additiveArithmeticZero() {
            let z: Translation = .zero
            #expect(z.dx.value == 0)
            #expect(z.dy.value == 0)
        }
    }
}
