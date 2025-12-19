// (T) -> Bool Tests.swift
// Tests for closure operators and mixed Predicate/closure operations.

import Testing

@testable import Predicate

// MARK: - Closure-to-Closure Operators

@Suite
struct ClosureOperatorTests {
    let isEven: (Int) -> Bool = { $0 % 2 == 0 }
    let isPositive: (Int) -> Bool = { $0 > 0 }
    let isNegative: (Int) -> Bool = { $0 < 0 }

    @Test(arguments: [
        (value: 4, expected: true),  // even and positive
        (value: 3, expected: false),  // odd
        (value: -4, expected: false),  // negative
        (value: -3, expected: false),  // odd and negative
    ])
    func closureAND(value: Int, expected: Bool) {
        let combined = isEven && isPositive
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),  // even
        (value: -3, expected: true),  // negative
        (value: -4, expected: true),  // both
        (value: 3, expected: false),  // neither
    ])
    func closureOR(value: Int, expected: Bool) {
        let combined = isEven || isNegative
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: false),  // both
        (value: 3, expected: true),  // positive only
        (value: -4, expected: true),  // even only
        (value: -3, expected: false),  // neither
    ])
    func closureXOR(value: Int, expected: Bool) {
        let combined = isEven ^ isPositive
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 3, expected: true),
        (value: 4, expected: false),
    ])
    func closureNOT(value: Int, expected: Bool) {
        let isOdd = !isEven
        #expect(isOdd(value) == expected)
    }

    @Test
    func chainedClosureOperations() {
        let isSmall: (Int) -> Bool = { abs($0) < 5 }
        let combined = isEven && isPositive && isSmall

        #expect(combined(2) == true)
        #expect(combined(4) == true)
        #expect(combined(6) == false)  // not small
        #expect(combined(3) == false)  // not even
        #expect(combined(-2) == false)  // not positive
    }
}

// MARK: - Mixed Predicate and Closure Operators

@Suite
struct MixedPredicateClosureOperatorTests {
    let predicateEven = Predicate<Int> { $0 % 2 == 0 }
    let predicatePositive = Predicate<Int> { $0 > 0 }
    let closureEven: (Int) -> Bool = { $0 % 2 == 0 }
    let closurePositive: (Int) -> Bool = { $0 > 0 }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: 3, expected: false),
        (value: -4, expected: false),
    ])
    func predicateANDclosure(value: Int, expected: Bool) {
        let combined = predicateEven && closurePositive
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: 3, expected: false),
        (value: -4, expected: false),
    ])
    func closureANDpredicate(value: Int, expected: Bool) {
        let combined = closureEven && predicatePositive
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: 3, expected: true),
        (value: -3, expected: false),
    ])
    func predicateORclosure(value: Int, expected: Bool) {
        let combined = predicateEven || closurePositive
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: 3, expected: true),
        (value: -3, expected: false),
    ])
    func closureORpredicate(value: Int, expected: Bool) {
        let combined = closureEven || predicatePositive
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: false),  // both
        (value: 3, expected: true),  // positive only
        (value: -4, expected: true),  // even only
        (value: -3, expected: false),  // neither
    ])
    func predicateXORclosure(value: Int, expected: Bool) {
        let combined = predicateEven ^ closurePositive
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: false),  // both
        (value: 3, expected: true),  // positive only
        (value: -4, expected: true),  // even only
        (value: -3, expected: false),  // neither
    ])
    func closureXORpredicate(value: Int, expected: Bool) {
        let combined = closureEven ^ predicatePositive
        #expect(combined(value) == expected)
    }
}

// MARK: - Fluent Methods with Closures

@Suite
struct FluentMethodClosureTests {
    let predicate = Predicate<Int> { $0 % 2 == 0 }
    let isPositive: (Int) -> Bool = { $0 > 0 }
    let isSmall: (Int) -> Bool = { abs($0) < 10 }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: -4, expected: false),
        (value: 3, expected: false),
    ])
    func fluentAND(value: Int, expected: Bool) {
        let combined = predicate.and(isPositive)
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: -4, expected: true),
        (value: 3, expected: true),
        (value: -3, expected: false),
    ])
    func fluentOR(value: Int, expected: Bool) {
        let combined = predicate.or(isPositive)
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: false),
        (value: 3, expected: true),
        (value: -4, expected: true),
        (value: -3, expected: false),
    ])
    func fluentXOR(value: Int, expected: Bool) {
        let combined = predicate.xor(isPositive)
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: false),  // both true, NAND is false
        (value: 3, expected: true),  // one false
        (value: -4, expected: true),  // one false
    ])
    func fluentNAND(value: Int, expected: Bool) {
        let combined = predicate.nand(isPositive)
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: false),  // one true, NOR is false
        (value: 3, expected: false),  // one true
        (value: -3, expected: true),  // both false
    ])
    func fluentNOR(value: Int, expected: Bool) {
        let combined = predicate.nor(isPositive)
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: -4, expected: false),  // even(true) → positive(false) = false
        (value: 4, expected: true),  // even(true) → positive(true) = true
        (value: -3, expected: true),  // even(false) → positive(false) = true (¬false ∨ false)
        (value: 3, expected: true),  // even(false) → positive(true) = true (¬false ∨ true)
    ])
    func fluentImplies(value: Int, expected: Bool) {
        let combined = predicate.implies(isPositive)
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),  // both true
        (value: -4, expected: false),  // even true, positive false
        (value: 3, expected: false),  // even false, positive true
        (value: -3, expected: true),  // both false
    ])
    func fluentIff(value: Int, expected: Bool) {
        let combined = predicate.iff(isPositive)
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),  // positive -> even is true -> true = true
        (value: -4, expected: true),  // not positive -> even is false -> true = true
        (value: 3, expected: false),  // positive -> even is true -> false = false
        (value: -3, expected: true),  // not positive -> even is don't care = true
    ])
    func fluentUnless(value: Int, expected: Bool) {
        let combined = predicate.unless(isPositive)
        #expect(combined(value) == expected)
    }

    @Test
    func chainedFluentMethods() {
        // isSmall = abs($0) < 10
        let combined = predicate.and(isPositive).or(isSmall)

        #expect(combined(4) == true)  // (even ∧ positive) ∨ small = (true ∧ true) ∨ true = true
        #expect(combined(8) == true)  // (even ∧ positive) ∨ small = (true ∧ true) ∨ true = true (8 < 10)
        #expect(combined(-2) == true)  // (even ∧ positive) ∨ small = (true ∧ false) ∨ true = true
        #expect(combined(3) == true)  // (even ∧ positive) ∨ small = (false ∧ true) ∨ true = true
        #expect(combined(11) == false)  // (even ∧ positive) ∨ small = (false ∧ true) ∨ false = false
    }
}

// MARK: - Commutativity Tests

@Suite
struct ClosureCommutativityTests {
    let isEven: (Int) -> Bool = { $0 % 2 == 0 }
    let isPositive: (Int) -> Bool = { $0 > 0 }

    @Test
    func closureANDisCommutative() {
        let p1 = isEven && isPositive
        let p2 = isPositive && isEven

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func closureORisCommutative() {
        let p1 = isEven || isPositive
        let p2 = isPositive || isEven

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func closureXORisCommutative() {
        let p1 = isEven ^ isPositive
        let p2 = isPositive ^ isEven

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }
}

// MARK: - Associativity Tests

@Suite
struct ClosureAssociativityTests {
    let isEven: (Int) -> Bool = { $0 % 2 == 0 }
    let isPositive: (Int) -> Bool = { $0 > 0 }
    let isSmall: (Int) -> Bool = { abs($0) < 5 }

    @Test
    func closureANDisAssociative() {
        let p1 = (isEven && isPositive) && isSmall
        let p2 = isEven && (isPositive && isSmall)

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func closureORisAssociative() {
        let p1 = (isEven || isPositive) || isSmall
        let p2 = isEven || (isPositive || isSmall)

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func closureXORisAssociative() {
        let p1 = (isEven ^ isPositive) ^ isSmall
        let p2 = isEven ^ (isPositive ^ isSmall)

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }
}

// MARK: - Type Conversion Tests

@Suite
struct ClosureTypeConversionTests {
    @Test
    func closureOperatorsReturnPredicate() {
        let isEven: (Int) -> Bool = { $0 % 2 == 0 }
        let isPositive: (Int) -> Bool = { $0 > 0 }

        // Verify that operators return Predicate<T> type
        let andResult = isEven && isPositive
        let orResult = isEven || isPositive
        let xorResult = isEven ^ isPositive
        let notResult = !isEven

        // These should be usable as Predicates
        #expect(andResult(4) == true)
        #expect(orResult(3) == true)
        #expect(xorResult(3) == true)
        #expect(notResult(3) == true)
    }

    @Test
    func closureCanBeMixedWithPredicateMethods() {
        let isEven: (Int) -> Bool = { $0 % 2 == 0 }
        let isPositive: (Int) -> Bool = { $0 > 0 }

        // Closure operators create Predicate, so we can chain fluent methods
        let combined = (isEven && isPositive).or(Predicate<Int> { $0 == 0 })

        #expect(combined(4) == true)  // even and positive
        #expect(combined(0) == true)  // zero
        #expect(combined(-4) == false)  // even but not positive, not zero
    }
}
