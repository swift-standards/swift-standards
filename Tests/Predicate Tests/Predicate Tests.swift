// Predicate Tests.swift
// Tests for Predicate<T> type and core composition operators.

import Testing

@testable import Predicate

// MARK: - Basic Tests

@Suite
struct PredicateBasicTests {
    @Test
    func predicateCreationAndEvaluation() {
        let isEven = Predicate<Int> { $0 % 2 == 0 }

        #expect(isEven(4) == true)
        #expect(isEven(3) == false)
        #expect(isEven.evaluate(4) == true)
    }

    @Test(arguments: [0, 100, -50])
    func predicateAlways(value: Int) {
        let always = Predicate<Int>.always
        #expect(always(value) == true)
    }

    @Test(arguments: [0, 100, -50])
    func predicateNever(value: Int) {
        let never = Predicate<Int>.never
        #expect(never(value) == false)
    }

    @Test
    func staticCallAsFunction() {
        let isEven = Predicate<Int> { $0 % 2 == 0 }
        #expect(Predicate.callAsFunction(isEven, 4) == true)
        #expect(Predicate.callAsFunction(isEven, 3) == false)
    }
}

// MARK: - AND Tests

@Suite
struct PredicateANDTests {
    let isEven = Predicate<Int> { $0 % 2 == 0 }
    let isPositive = Predicate<Int> { $0 > 0 }

    @Test(arguments: [
        (value: 4, expected: true),   // even and positive
        (value: 3, expected: false),  // odd
        (value: -4, expected: false), // negative
        (value: -3, expected: false)  // odd and negative
    ])
    func staticAND(value: Int, expected: Bool) {
        let combined = Predicate.and(isEven, isPositive)
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: 3, expected: false),
        (value: -4, expected: false)
    ])
    func operatorAND(value: Int, expected: Bool) {
        let combined = isEven && isPositive
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: -4, expected: false)
    ])
    func fluentAND(value: Int, expected: Bool) {
        let combined = isEven.and(isPositive)
        #expect(combined(value) == expected)
    }

    @Test
    func ANDisCommutative() {
        let p1 = isEven && isPositive
        let p2 = isPositive && isEven

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func ANDisAssociative() {
        let greaterThan5 = Predicate<Int> { $0 > 5 }

        let p1 = (isEven && isPositive) && greaterThan5
        let p2 = isEven && (isPositive && greaterThan5)

        for n in -10...20 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func ANDidentity() {
        // p && .always == p
        let p = isEven && .always

        for n in -10...10 {
            #expect(p(n) == isEven(n))
        }
    }

    @Test
    func ANDannihilator() {
        // p && .never == .never
        let p = isEven && .never

        for n in -10...10 {
            #expect(p(n) == false)
        }
    }
}

// MARK: - OR Tests

@Suite
struct PredicateORTests {
    let isEven = Predicate<Int> { $0 % 2 == 0 }
    let isNegative = Predicate<Int> { $0 < 0 }

    @Test(arguments: [
        (value: 4, expected: true),   // even
        (value: -3, expected: true),  // negative
        (value: -4, expected: true),  // both
        (value: 3, expected: false)   // neither
    ])
    func staticOR(value: Int, expected: Bool) {
        let combined = Predicate.or(isEven, isNegative)
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: 3, expected: false)
    ])
    func operatorOR(value: Int, expected: Bool) {
        let combined = isEven || isNegative
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: 3, expected: false)
    ])
    func fluentOR(value: Int, expected: Bool) {
        let combined = isEven.or(isNegative)
        #expect(combined(value) == expected)
    }

    @Test
    func ORisCommutative() {
        let p1 = isEven || isNegative
        let p2 = isNegative || isEven

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func ORisAssociative() {
        let isZero = Predicate<Int> { $0 == 0 }

        let p1 = (isEven || isNegative) || isZero
        let p2 = isEven || (isNegative || isZero)

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func ORidentity() {
        // p || .never == p
        let p = isEven || .never

        for n in -10...10 {
            #expect(p(n) == isEven(n))
        }
    }

    @Test
    func ORannihilator() {
        // p || .always == .always
        let p = isEven || .always

        for n in -10...10 {
            #expect(p(n) == true)
        }
    }
}

// MARK: - NOT Tests

@Suite
struct PredicateNOTTests {
    let isEven = Predicate<Int> { $0 % 2 == 0 }

    @Test(arguments: [
        (value: 3, expected: true),
        (value: 4, expected: false)
    ])
    func staticNegated(value: Int, expected: Bool) {
        let isOdd = Predicate.negated(isEven)
        #expect(isOdd(value) == expected)
    }

    @Test(arguments: [
        (value: 3, expected: true),
        (value: 4, expected: false)
    ])
    func operatorNOT(value: Int, expected: Bool) {
        let isOdd = !isEven
        #expect(isOdd(value) == expected)
    }

    @Test(arguments: [
        (value: 3, expected: true),
        (value: 4, expected: false)
    ])
    func propertyNegated(value: Int, expected: Bool) {
        let isOdd = isEven.negated
        #expect(isOdd(value) == expected)
    }

    @Test
    func NOTisInvolution() {
        let doubleNegated = !(!isEven)

        for n in -10...10 {
            #expect(doubleNegated(n) == isEven(n))
        }
    }

    @Test
    func NOTcomplementLaw() {
        // p && !p == .never
        let contradiction = isEven && !isEven

        for n in -10...10 {
            #expect(contradiction(n) == false)
        }
    }

    @Test
    func NOTtautologyLaw() {
        // p || !p == .always
        let tautology = isEven || !isEven

        for n in -10...10 {
            #expect(tautology(n) == true)
        }
    }
}

// MARK: - XOR Tests

@Suite
struct PredicateXORTests {
    let isEven = Predicate<Int> { $0 % 2 == 0 }
    let isPositive = Predicate<Int> { $0 > 0 }

    @Test(arguments: [
        (value: 4, expected: false),  // both true
        (value: 3, expected: true),   // positive only
        (value: -4, expected: true),  // even only
        (value: -3, expected: false)  // neither
    ])
    func staticXOR(value: Int, expected: Bool) {
        let combined = Predicate.xor(isEven, isPositive)
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: false),
        (value: 3, expected: true)
    ])
    func operatorXOR(value: Int, expected: Bool) {
        let combined = isEven ^ isPositive
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: false),
        (value: 3, expected: true)
    ])
    func fluentXOR(value: Int, expected: Bool) {
        let combined = isEven.xor(isPositive)
        #expect(combined(value) == expected)
    }

    @Test
    func XORisCommutative() {
        let p1 = isEven ^ isPositive
        let p2 = isPositive ^ isEven

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func XORisAssociative() {
        let isSmall = Predicate<Int> { abs($0) < 5 }

        let p1 = (isEven ^ isPositive) ^ isSmall
        let p2 = isEven ^ (isPositive ^ isSmall)

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }
}

// MARK: - NAND / NOR Tests

@Suite
struct PredicateNANDNORTests {
    let isEven = Predicate<Int> { $0 % 2 == 0 }
    let isPositive = Predicate<Int> { $0 > 0 }

    @Test
    func staticNAND() {
        let nand = Predicate.nand(isEven, isPositive)
        let notAnd = !(isEven && isPositive)

        for n in -10...10 {
            #expect(nand(n) == notAnd(n))
        }
    }

    @Test
    func fluentNAND() {
        let nand = isEven.nand(isPositive)
        let notAnd = !(isEven && isPositive)

        for n in -10...10 {
            #expect(nand(n) == notAnd(n))
        }
    }

    @Test
    func staticNOR() {
        let nor = Predicate.nor(isEven, isPositive)
        let notOr = !(isEven || isPositive)

        for n in -10...10 {
            #expect(nor(n) == notOr(n))
        }
    }

    @Test
    func fluentNOR() {
        let nor = isEven.nor(isPositive)
        let notOr = !(isEven || isPositive)

        for n in -10...10 {
            #expect(nor(n) == notOr(n))
        }
    }
}

// MARK: - Implication Tests

@Suite
struct PredicateImplicationTests {
    let isEven = Predicate<Int> { $0 % 2 == 0 }
    let isPositive = Predicate<Int> { $0 > 0 }

    @Test
    func staticImplies() {
        let implies = Predicate.implies(isEven, isPositive)
        let notOr = !isEven || isPositive

        for n in -10...10 {
            #expect(implies(n) == notOr(n))
        }
    }

    @Test
    func fluentImplies() {
        let implies = isEven.implies(isPositive)
        let notOr = !isEven || isPositive

        for n in -10...10 {
            #expect(implies(n) == notOr(n))
        }
    }

    @Test
    func staticIff() {
        let iff = Predicate.iff(isEven, isPositive)
        let notXor = !(isEven ^ isPositive)

        for n in -10...10 {
            #expect(iff(n) == notXor(n))
        }
    }

    @Test
    func fluentIff() {
        let iff = isEven.iff(isPositive)
        let notXor = !(isEven ^ isPositive)

        for n in -10...10 {
            #expect(iff(n) == notXor(n))
        }
    }

    @Test
    func staticUnless() {
        let unless = Predicate.unless(isEven, condition: isPositive)
        let reversed = Predicate.implies(isPositive, isEven)

        for n in -10...10 {
            #expect(unless(n) == reversed(n))
        }
    }

    @Test
    func fluentUnless() {
        let unless = isEven.unless(isPositive)
        let reversed = isPositive.implies(isEven)

        for n in -10...10 {
            #expect(unless(n) == reversed(n))
        }
    }
}

// MARK: - De Morgan Tests

@Suite
struct PredicateDeMorganTests {
    let isEven = Predicate<Int> { $0 % 2 == 0 }
    let isPositive = Predicate<Int> { $0 > 0 }

    @Test
    func deMorganLaw1() {
        // !(a && b) == !a || !b
        let p1 = !(isEven && isPositive)
        let p2 = !isEven || !isPositive

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func deMorganLaw2() {
        // !(a || b) == !a && !b
        let p1 = !(isEven || isPositive)
        let p2 = !isEven && !isPositive

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }
}

// MARK: - Distributivity Tests

@Suite
struct PredicateDistributivityTests {
    let isEven = Predicate<Int> { $0 % 2 == 0 }
    let isPositive = Predicate<Int> { $0 > 0 }
    let isSmall = Predicate<Int> { abs($0) < 5 }

    @Test
    func ANDdistributesOverOR() {
        // a && (b || c) == (a && b) || (a && c)
        let p1 = isEven && (isPositive || isSmall)
        let p2 = (isEven && isPositive) || (isEven && isSmall)

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func ORdistributesOverAND() {
        // a || (b && c) == (a || b) && (a || c)
        let p1 = isEven || (isPositive && isSmall)
        let p2 = (isEven || isPositive) && (isEven || isSmall)

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }
}

// MARK: - Pullback Tests

@Suite
struct PredicatePullbackTests {
    @Test
    func staticPullbackWithClosure() {
        let isEven = Predicate<Int> { $0 % 2 == 0 }
        let hasEvenLength = Predicate.pullback(isEven) { (s: String) in s.count }

        #expect(hasEvenLength("hi") == true)   // count 2
        #expect(hasEvenLength("hello") == false) // count 5
    }

    @Test
    func staticPullbackWithKeyPath() {
        let isLong = Predicate<Int> { $0 > 3 }
        let hasLongCount: Predicate<String> = Predicate.pullback(isLong, \.count)

        #expect(hasLongCount("hi") == false)  // count 2
        #expect(hasLongCount("hello") == true) // count 5
    }

    @Test
    func instancePullbackWithClosure() {
        let isEven = Predicate<Int> { $0 % 2 == 0 }
        let hasEvenLength = isEven.pullback { (s: String) in s.count }

        #expect(hasEvenLength("hi") == true)
        #expect(hasEvenLength("hello") == false)
    }

    @Test
    func instancePullbackWithKeyPath() {
        let isLong = Predicate<Int> { $0 > 3 }
        let hasLongCount: Predicate<String> = isLong.pullback(\.count)

        #expect(hasLongCount("hi") == false)
        #expect(hasLongCount("hello") == true)
    }
}

// MARK: - Where Clause Tests

@Suite
struct PredicateWhereTests {
    struct Person {
        let age: Int
        let name: String
    }

    @Test
    func whereWithPredicate() {
        let isAdult = Predicate<Person>.where(\.age, Predicate<Int> { $0 >= 18 })

        let adult = Person(age: 25, name: "Alice")
        let child = Person(age: 15, name: "Bob")

        #expect(isAdult(adult) == true)
        #expect(isAdult(child) == false)
    }

    @Test
    func whereWithClosure() {
        let hasLongName = Predicate<Person>.where(\.name) { $0.count > 5 }

        let alice = Person(age: 25, name: "Alice")
        let alexander = Person(age: 30, name: "Alexander")

        #expect(hasLongName(alice) == false)
        #expect(hasLongName(alexander) == true)
    }

    @Test
    func whereWithFluentPredicate() {
        let isAdult = Predicate<Person>.where(\.age, .greater.thanOrEqualTo(18))

        let adult = Person(age: 25, name: "Alice")
        let child = Person(age: 15, name: "Bob")

        #expect(isAdult(adult) == true)
        #expect(isAdult(child) == false)
    }
}

// MARK: - Optional Tests

@Suite
struct PredicateOptionalTests {
    @Test(arguments: [
        (value: nil as Int?, expected: true),
        (value: 42 as Int?, expected: false)
    ])
    func isNil(value: Int?, expected: Bool) {
        let isNil = Predicate<Int>.is.nil
        #expect(isNil(value) == expected)
    }

    @Test(arguments: [
        (value: 42 as Int?, expected: true),
        (value: nil as Int?, expected: false)
    ])
    func isNotNil(value: Int?, expected: Bool) {
        let isNotNil = Predicate<Int>.is.notNil
        #expect(isNotNil(value) == expected)
    }

    @Test
    func staticOptionalLiftWithDefault() {
        let isEven = Predicate<Int> { $0 % 2 == 0 }
        let optionalIsEven = Predicate.optional(isEven, default: false)

        #expect(optionalIsEven(4) == true)
        #expect(optionalIsEven(3) == false)
        #expect(optionalIsEven(nil) == false)
    }

    @Test
    func instanceOptionalLiftWithDefault() {
        let isEven = Predicate<Int> { $0 % 2 == 0 }
        let test = isEven.optional(default: false)

        #expect(test(4) == true)
        #expect(test(3) == false)
        #expect(test(nil) == false)
    }

    @Test
    func optionalLiftWithTrueDefault() {
        let isEven = Predicate<Int> { $0 % 2 == 0 }
        let test = isEven.optional(default: true)

        #expect(test(nil) == true)
    }
}

// MARK: - Quantifier Tests

@Suite
struct PredicateQuantifierTests {
    let isEven = Predicate<Int> { $0 % 2 == 0 }

    // MARK: Static Methods

    @Test(arguments: [
        (array: [2, 4, 6], expected: true),
        (array: [2, 3, 4], expected: false),
        (array: [], expected: true)  // vacuous truth
    ])
    func staticAll(array: [Int], expected: Bool) {
        let allEven = Predicate.all(isEven)
        #expect(allEven(array) == expected)
    }

    @Test(arguments: [
        (array: [1, 2, 3], expected: true),
        (array: [1, 3, 5], expected: false),
        (array: [], expected: false)
    ])
    func staticAny(array: [Int], expected: Bool) {
        let anyEven = Predicate.any(isEven)
        #expect(anyEven(array) == expected)
    }

    @Test(arguments: [
        (array: [1, 3, 5], expected: true),
        (array: [1, 2, 3], expected: false),
        (array: [], expected: true)
    ])
    func staticNone(array: [Int], expected: Bool) {
        let noneEven = Predicate.none(isEven)
        #expect(noneEven(array) == expected)
    }

    // MARK: Instance Properties

    @Test(arguments: [
        (array: [2, 4, 6], expected: true),
        (array: [2, 3, 4], expected: false),
        (array: [], expected: true)
    ])
    func propertyAll(array: [Int], expected: Bool) {
        let allEven = isEven.all
        #expect(allEven(array) == expected)
    }

    @Test(arguments: [
        (array: [1, 2, 3], expected: true),
        (array: [1, 3, 5], expected: false),
        (array: [], expected: false)
    ])
    func propertyAny(array: [Int], expected: Bool) {
        let anyEven = isEven.any
        #expect(anyEven(array) == expected)
    }

    @Test(arguments: [
        (array: [1, 3, 5], expected: true),
        (array: [1, 2, 3], expected: false),
        (array: [], expected: true)
    ])
    func propertyNone(array: [Int], expected: Bool) {
        let noneEven = isEven.none
        #expect(noneEven(array) == expected)
    }

    // MARK: Generic Sequence Methods

    @Test
    func staticForAllWithSet() {
        let allEven: Predicate<Set<Int>> = Predicate.forAll(isEven)

        #expect(allEven(Set([2, 4, 6])) == true)
        #expect(allEven(Set([2, 3, 4])) == false)
        #expect(allEven(Set()) == true)
    }

    @Test
    func staticForAnyWithSet() {
        let anyEven: Predicate<Set<Int>> = Predicate.forAny(isEven)

        #expect(anyEven(Set([1, 2, 3])) == true)
        #expect(anyEven(Set([1, 3, 5])) == false)
        #expect(anyEven(Set()) == false)
    }

    @Test
    func staticForNoneWithSet() {
        let noneEven: Predicate<Set<Int>> = Predicate.forNone(isEven)

        #expect(noneEven(Set([1, 3, 5])) == true)
        #expect(noneEven(Set([1, 2, 3])) == false)
        #expect(noneEven(Set()) == true)
    }

    @Test
    func instanceForAllWithSet() {
        let allEven: Predicate<Set<Int>> = isEven.forAll()

        #expect(allEven(Set([2, 4, 6])) == true)
        #expect(allEven(Set([2, 3, 4])) == false)
        #expect(allEven(Set()) == true)
    }

    @Test
    func instanceForAnyWithSet() {
        let anyEven: Predicate<Set<Int>> = isEven.forAny()

        #expect(anyEven(Set([1, 2, 3])) == true)
        #expect(anyEven(Set([1, 3, 5])) == false)
        #expect(anyEven(Set()) == false)
    }

    @Test
    func instanceForNoneWithSet() {
        let noneEven: Predicate<Set<Int>> = isEven.forNone()

        #expect(noneEven(Set([1, 3, 5])) == true)
        #expect(noneEven(Set([1, 2, 3])) == false)
        #expect(noneEven(Set()) == true)
    }

    @Test
    func forAllWithClosedRange() {
        let allEven: Predicate<ClosedRange<Int>> = isEven.forAll()

        #expect(allEven(2...2) == true)   // single even
        #expect(allEven(1...10) == false) // mixed
    }

    @Test
    func forAnyWithClosedRange() {
        let anyEven: Predicate<ClosedRange<Int>> = isEven.forAny()

        #expect(anyEven(1...10) == true)
        #expect(anyEven(1...1) == false) // single odd
    }
}

// MARK: - Count Quantifier Tests

@Suite
struct PredicateCountQuantifierTests {
    let isEven = Predicate<Int> { $0 % 2 == 0 }

    @Test(arguments: [
        (array: [2, 4, 6], n: 2, expected: true),
        (array: [2, 4], n: 3, expected: false),
        (array: [2, 4, 6, 8], n: 3, expected: true)
    ])
    func staticAtLeast(array: [Int], n: Int, expected: Bool) {
        let predicate = Predicate.Count.atLeast(isEven, n)
        #expect(predicate(array) == expected)
    }

    @Test(arguments: [
        (array: [2, 4, 6], n: 3, expected: true),
        (array: [2, 4, 6, 8], n: 3, expected: false),
        (array: [2, 4], n: 5, expected: true)
    ])
    func staticAtMost(array: [Int], n: Int, expected: Bool) {
        let predicate = Predicate.Count.atMost(isEven, n)
        #expect(predicate(array) == expected)
    }

    @Test(arguments: [
        (array: [2, 4, 6], n: 3, expected: true),
        (array: [2, 4], n: 3, expected: false),
        (array: [2, 4, 6, 8], n: 3, expected: false)
    ])
    func staticExactly(array: [Int], n: Int, expected: Bool) {
        let predicate = Predicate.Count.exactly(isEven, n)
        #expect(predicate(array) == expected)
    }

    @Test(arguments: [
        (array: [1, 3, 5], expected: true),
        (array: [2, 3, 5], expected: false),
        (array: [], expected: true)
    ])
    func staticZero(array: [Int], expected: Bool) {
        let predicate = Predicate.Count.zero(isEven)
        #expect(predicate(array) == expected)
    }

    @Test(arguments: [
        (array: [2, 3, 5], expected: true),
        (array: [1, 3, 5], expected: false),
        (array: [2, 4, 6], expected: false)
    ])
    func staticOne(array: [Int], expected: Bool) {
        let predicate = Predicate.Count.one(isEven)
        #expect(predicate(array) == expected)
    }

    @Test(arguments: [
        (array: [2, 4, 6], n: 2, expected: true),
        (array: [2, 4], n: 3, expected: false)
    ])
    func instanceAtLeast(array: [Int], n: Int, expected: Bool) {
        let predicate = isEven.count.atLeast(n)
        #expect(predicate(array) == expected)
    }

    @Test(arguments: [
        (array: [2, 4, 6], n: 3, expected: true),
        (array: [2, 4, 6, 8], n: 3, expected: false)
    ])
    func instanceAtMost(array: [Int], n: Int, expected: Bool) {
        let predicate = isEven.count.atMost(n)
        #expect(predicate(array) == expected)
    }

    @Test(arguments: [
        (array: [2, 4, 6], n: 3, expected: true),
        (array: [2, 4], n: 3, expected: false)
    ])
    func instanceExactly(array: [Int], n: Int, expected: Bool) {
        let predicate = isEven.count.exactly(n)
        #expect(predicate(array) == expected)
    }

    @Test(arguments: [
        (array: [1, 3, 5], expected: true),
        (array: [2, 3, 5], expected: false)
    ])
    func instanceZero(array: [Int], expected: Bool) {
        let predicate = isEven.count.zero
        #expect(predicate(array) == expected)
    }

    @Test(arguments: [
        (array: [2, 3, 5], expected: true),
        (array: [1, 3, 5], expected: false)
    ])
    func instanceOne(array: [Int], expected: Bool) {
        let predicate = isEven.count.one
        #expect(predicate(array) == expected)
    }
}

// MARK: - Fluent Factory Tests

@Suite
struct PredicateFluentFactoryTests {
    @Test(arguments: [
        (value: 0, expected: true),
        (value: 1, expected: false)
    ])
    func equalTo(value: Int, expected: Bool) {
        let isZero = Predicate<Int>.equal.to(0)
        #expect(isZero(value) == expected)
    }

    @Test(arguments: [
        (value: 0, expected: false),
        (value: 1, expected: true)
    ])
    func notEqualTo(value: Int, expected: Bool) {
        let isNotZero = Predicate<Int>.not.equalTo(0)
        #expect(isNotZero(value) == expected)
    }

    @Test(arguments: [
        (value: "a" as Character, expected: true),
        (value: "b" as Character, expected: false)
    ])
    func inCollection(value: Character, expected: Bool) {
        let isVowel = Predicate<Character>.in.collection("aeiou")
        #expect(isVowel(value) == expected)
    }

    @Test(arguments: [
        (value: 3, threshold: 5, expected: true),
        (value: 5, threshold: 5, expected: false)
    ])
    func lessThan(value: Int, threshold: Int, expected: Bool) {
        let predicate = Predicate<Int>.less.than(threshold)
        #expect(predicate(value) == expected)
    }

    @Test(arguments: [
        (value: 5, threshold: 5, expected: true),
        (value: 6, threshold: 5, expected: false)
    ])
    func lessThanOrEqualTo(value: Int, threshold: Int, expected: Bool) {
        let predicate = Predicate<Int>.less.thanOrEqualTo(threshold)
        #expect(predicate(value) == expected)
    }

    @Test(arguments: [
        (value: 6, threshold: 5, expected: true),
        (value: 5, threshold: 5, expected: false)
    ])
    func greaterThan(value: Int, threshold: Int, expected: Bool) {
        let predicate = Predicate<Int>.greater.than(threshold)
        #expect(predicate(value) == expected)
    }

    @Test(arguments: [
        (value: 5, threshold: 5, expected: true),
        (value: 4, threshold: 5, expected: false)
    ])
    func greaterThanOrEqualTo(value: Int, threshold: Int, expected: Bool) {
        let predicate = Predicate<Int>.greater.thanOrEqualTo(threshold)
        #expect(predicate(value) == expected)
    }

    @Test(arguments: [
        (value: 15, expected: true),
        (value: 12, expected: false),
        (value: 20, expected: false)
    ])
    func inRange(value: Int, expected: Bool) {
        let isTeenager = Predicate<Int>.in.range(13...19)
        #expect(isTeenager(value) == expected)
    }

    @Test(arguments: [
        (value: 10, expected: true),
        (value: 15, expected: false)
    ])
    func notInRange(value: Int, expected: Bool) {
        let outsideTeenage = Predicate<Int>.not.inRange(13...19)
        #expect(outsideTeenage(value) == expected)
    }

    @Test(arguments: [
        (value: [], expected: true),
        (value: [1], expected: false)
    ])
    func isEmpty(value: [Int], expected: Bool) {
        #expect(Predicate<[Int]>.is.empty(value) == expected)
    }

    @Test(arguments: [
        (value: [1], expected: true),
        (value: [], expected: false)
    ])
    func isNotEmpty(value: [Int], expected: Bool) {
        #expect(Predicate<[Int]>.is.notEmpty(value) == expected)
    }

    @Test(arguments: [
        (value: [1, 2, 3], count: 3, expected: true),
        (value: [1, 2], count: 3, expected: false)
    ])
    func hasCount(value: [Int], count: Int, expected: Bool) {
        #expect(Predicate<[Int]>.has.count(count)(value) == expected)
    }

    @Test(arguments: [
        (value: "hello", substring: "ell", expected: true),
        (value: "hello", substring: "xyz", expected: false)
    ])
    func containsSubstring(value: String, substring: String, expected: Bool) {
        #expect(Predicate<String>.contains.substring(substring)(value) == expected)
    }

    @Test(arguments: [
        (value: "hello", prefix: "hel", expected: true),
        (value: "hello", prefix: "xyz", expected: false)
    ])
    func hasPrefix(value: String, prefix: String, expected: Bool) {
        #expect(Predicate<String>.has.prefix(prefix)(value) == expected)
    }

    @Test(arguments: [
        (value: "hello", suffix: "llo", expected: true),
        (value: "hello", suffix: "xyz", expected: false)
    ])
    func hasSuffix(value: String, suffix: String, expected: Bool) {
        #expect(Predicate<String>.has.suffix(suffix)(value) == expected)
    }

    @Test(arguments: [
        (value: "red", expected: true),
        (value: "yellow", expected: false)
    ])
    func equalToAnyOf(value: String, expected: Bool) {
        let isPrimaryColor = Predicate<String>.equal.toAny(of: "red", "green", "blue")
        #expect(isPrimaryColor(value) == expected)
    }

    @Test(arguments: [
        (value: "yellow", expected: true),
        (value: "red", expected: false)
    ])
    func equalToNoneOf(value: String, expected: Bool) {
        let isNotPrimaryColor = Predicate<String>.equal.toNone(of: "red", "green", "blue")
        #expect(isNotPrimaryColor(value) == expected)
    }
}

// MARK: - Identifiable Tests

@Suite
struct PredicateIdentifiableTests {
    struct Item: Identifiable {
        let id: Int
        let name: String
    }

    @Test(arguments: [
        (item: Item(id: 1, name: "A"), targetId: 1, expected: true),
        (item: Item(id: 2, name: "B"), targetId: 1, expected: false)
    ])
    func hasId(item: Item, targetId: Int, expected: Bool) {
        let predicate = Predicate<Item>.has.id(targetId)
        #expect(predicate(item) == expected)
    }

    @Test(arguments: [
        (item: Item(id: 1, name: "A"), expected: true),
        (item: Item(id: 4, name: "D"), expected: false)
    ])
    func hasIdInCollection(item: Item, expected: Bool) {
        let predicate = Predicate<Item>.has.id(in: [1, 2, 3])
        #expect(predicate(item) == expected)
    }
}
