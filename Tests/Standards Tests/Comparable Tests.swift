// Comparable Tests.swift
// swift-standards
//
// Tests for Comparable extensions

import Testing
@testable import Standards

@Suite("Comparable Clamping")
struct ComparableClampingTests {

    // MARK: - Values within range

    @Test("Clamping value within range returns value")
    func clampWithinRange() {
        #expect(5.clamped(to: 0...10) == 5)
        #expect(0.clamped(to: 0...10) == 0)
        #expect(10.clamped(to: 0...10) == 10)
    }

    @Test("Clamping at exact boundaries")
    func clampAtBoundaries() {
        #expect(0.clamped(to: 0...100) == 0)
        #expect(100.clamped(to: 0...100) == 100)
        #expect((-5).clamped(to: -5...5) == -5)
        #expect(5.clamped(to: -5...5) == 5)
    }

    // MARK: - Values outside range

    @Test("Clamping value above range returns upper bound")
    func clampAboveRange() {
        #expect(15.clamped(to: 0...10) == 10)
        #expect(100.clamped(to: 0...10) == 10)
        #expect(1000.clamped(to: 0...10) == 10)
    }

    @Test("Clamping value below range returns lower bound")
    func clampBelowRange() {
        #expect((-5).clamped(to: 0...10) == 0)
        #expect((-100).clamped(to: 0...10) == 0)
        #expect((-1000).clamped(to: 0...10) == 0)
    }

    // MARK: - Different numeric types

    @Test("Clamping with Double")
    func clampDouble() {
        #expect(5.5.clamped(to: 0.0...10.0) == 5.5)
        #expect(15.5.clamped(to: 0.0...10.0) == 10.0)
        #expect((-5.5).clamped(to: 0.0...10.0) == 0.0)
    }

    @Test("Clamping with Float")
    func clampFloat() {
        let value: Float = 5.5
        let clamped = value.clamped(to: 0.0...10.0)
        #expect(clamped == 5.5)
    }

    @Test("Clamping with UInt8")
    func clampUInt8() {
        let value: UInt8 = 200
        #expect(value.clamped(to: 0...100) == 100)
        #expect(UInt8(50).clamped(to: 0...100) == 50)
    }

    @Test("Clamping with Int16")
    func clampInt16() {
        let value: Int16 = 1000
        #expect(value.clamped(to: -100...100) == 100)
        #expect(Int16(-500).clamped(to: -100...100) == -100)
    }

    // MARK: - Single value range

    @Test("Clamping to single value range")
    func clampSingleValueRange() {
        #expect(5.clamped(to: 7...7) == 7)
        #expect(10.clamped(to: 7...7) == 7)
        #expect(0.clamped(to: 7...7) == 7)
    }

    // MARK: - String clamping (lexicographic order)

    @Test("Clamping strings lexicographically")
    func clampStrings() {
        #expect("dog".clamped(to: "cat"..."zebra") == "dog")
        #expect("apple".clamped(to: "cat"..."zebra") == "cat")
        #expect("zoo".clamped(to: "cat"..."zebra") == "zebra")
    }

    // MARK: - Character clamping

    @Test("Clamping characters")
    func clampCharacters() {
        let char: Character = "m"
        #expect(char.clamped(to: "a"..."z") == "m")
        #expect(Character("5").clamped(to: "a"..."z") == "a")
        #expect(Character("~").clamped(to: "a"..."z") == "z")
    }

    // MARK: - Category theory properties

    @Test("Order preservation - monotonicity")
    func orderPreservation() {
        // ∀x,y ∈ T: x ≤ y ⟹ clamp(x) ≤ clamp(y)
        let range = 0...10

        let x = 3
        let y = 7
        #expect(x <= y)
        #expect(x.clamped(to: range) <= y.clamped(to: range))

        // Test with values outside range
        let a = -5
        let b = 15
        #expect(a <= b)
        #expect(a.clamped(to: range) <= b.clamped(to: range))
    }

    @Test("Codomain restriction property")
    func codomainRestriction() {
        // ∀x ∈ T: a ≤ clamp(x) ≤ b
        let range = 0...10

        for value in [-100, -10, -1, 0, 5, 10, 11, 100] {
            let clamped = value.clamped(to: range)
            #expect(clamped >= range.lowerBound)
            #expect(clamped <= range.upperBound)
        }
    }

    @Test("Identity morphism for values in range")
    func identityMorphism() {
        // ∀x ∈ [a,b]: clamp(x) = x
        let range = 0...10

        for value in 0...10 {
            #expect(value.clamped(to: range) == value)
        }
    }

    @Test("Idempotence property")
    func idempotence() {
        // clamp(clamp(x)) = clamp(x)
        let range = 0...10

        for value in [-100, -10, 0, 5, 10, 100] {
            let onceClamped = value.clamped(to: range)
            let twiceClamped = onceClamped.clamped(to: range)
            #expect(onceClamped == twiceClamped)
        }
    }

    // MARK: - Edge cases

    @Test("Clamping extreme values")
    func clampExtremeValues() {
        #expect(Int.max.clamped(to: 0...100) == 100)
        #expect(Int.min.clamped(to: 0...100) == 0)
        #expect(Int.min.clamped(to: -100...100) == -100)
    }

    @Test("Clamping with negative ranges")
    func clampNegativeRange() {
        #expect((-3).clamped(to: -10...(-5)) == -5)
        #expect((-15).clamped(to: -10...(-5)) == -10)
        #expect(0.clamped(to: -10...(-5)) == -5)
    }
}
