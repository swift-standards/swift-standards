// Predicate Tests.swift
// Tests for Predicate<T> type and core composition operators.

import Testing

@testable import Predicate

// MARK: - Basic Tests

@Suite
struct `Predicate Basic Tests` {
    @Test
    func `predicate Creation And Evaluation`() {
        let isEven = Predicate<Int> { $0 % 2 == 0 }

        #expect(isEven(4) == true)
        #expect(isEven(3) == false)
        #expect(isEven.evaluate(4) == true)
    }

    @Test(arguments: [0, 100, -50])
    func `predicate Always`(value: Int) {
        let always = Predicate<Int>.always
        #expect(always(value) == true)
    }

    @Test(arguments: [0, 100, -50])
    func `predicate Never`(value: Int) {
        let never = Predicate<Int>.never
        #expect(never(value) == false)
    }

    @Test
    func `static Call As Function`() {
        let isEven = Predicate<Int> { $0 % 2 == 0 }
        #expect(Predicate.callAsFunction(isEven, 4) == true)
        #expect(Predicate.callAsFunction(isEven, 3) == false)
    }
}

// MARK: - AND Tests

@Suite
struct `Predicate AND Tests` {
    let isEven = Predicate<Int> { $0 % 2 == 0 }
    let isPositive = Predicate<Int> { $0 > 0 }

    @Test(arguments: [
        (value: 4, expected: true),  // even and positive
        (value: 3, expected: false),  // odd
        (value: -4, expected: false),  // negative
        (value: -3, expected: false),  // odd and negative
    ])
    func `static AND`(value: Int, expected: Bool) {
        let combined = Predicate.and(isEven, isPositive)
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: 3, expected: false),
        (value: -4, expected: false),
    ])
    func `operator AND`(value: Int, expected: Bool) {
        let combined = isEven && isPositive
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: -4, expected: false),
    ])
    func `fluent AND`(value: Int, expected: Bool) {
        let combined = isEven.and(isPositive)
        #expect(combined(value) == expected)
    }

    @Test
    func `AND is Commutative`() {
        let p1 = isEven && isPositive
        let p2 = isPositive && isEven

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func `AND is Associative`() {
        let greaterThan5 = Predicate<Int> { $0 > 5 }

        let p1 = (isEven && isPositive) && greaterThan5
        let p2 = isEven && (isPositive && greaterThan5)

        for n in -10...20 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func `AND identity`() {
        // p && .always == p
        let p = isEven && .always

        for n in -10...10 {
            #expect(p(n) == isEven(n))
        }
    }

    @Test
    func `AND annihilator`() {
        // p && .never == .never
        let p = isEven && .never

        for n in -10...10 {
            #expect(p(n) == false)
        }
    }
}

// MARK: - OR Tests

@Suite
struct `Predicate OR Tests` {
    let isEven = Predicate<Int> { $0 % 2 == 0 }
    let isNegative = Predicate<Int> { $0 < 0 }

    @Test(arguments: [
        (value: 4, expected: true),  // even
        (value: -3, expected: true),  // negative
        (value: -4, expected: true),  // both
        (value: 3, expected: false),  // neither
    ])
    func `static OR`(value: Int, expected: Bool) {
        let combined = Predicate.or(isEven, isNegative)
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: 3, expected: false),
    ])
    func `operator OR`(value: Int, expected: Bool) {
        let combined = isEven || isNegative
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: 3, expected: false),
    ])
    func `fluent OR`(value: Int, expected: Bool) {
        let combined = isEven.or(isNegative)
        #expect(combined(value) == expected)
    }

    @Test
    func `OR is Commutative`() {
        let p1 = isEven || isNegative
        let p2 = isNegative || isEven

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func `OR is Associative`() {
        let isZero = Predicate<Int> { $0 == 0 }

        let p1 = (isEven || isNegative) || isZero
        let p2 = isEven || (isNegative || isZero)

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func `OR identity`() {
        // p || .never == p
        let p = isEven || .never

        for n in -10...10 {
            #expect(p(n) == isEven(n))
        }
    }

    @Test
    func `OR annihilator`() {
        // p || .always == .always
        let p = isEven || .always

        for n in -10...10 {
            #expect(p(n) == true)
        }
    }
}

// MARK: - NOT Tests

@Suite
struct `Predicate NOT Tests` {
    let isEven = Predicate<Int> { $0 % 2 == 0 }

    @Test(arguments: [
        (value: 3, expected: true),
        (value: 4, expected: false),
    ])
    func `static Negated`(value: Int, expected: Bool) {
        let isOdd = Predicate.negated(isEven)
        #expect(isOdd(value) == expected)
    }

    @Test(arguments: [
        (value: 3, expected: true),
        (value: 4, expected: false),
    ])
    func `operator NOT`(value: Int, expected: Bool) {
        let isOdd = !isEven
        #expect(isOdd(value) == expected)
    }

    @Test(arguments: [
        (value: 3, expected: true),
        (value: 4, expected: false),
    ])
    func `property Negated`(value: Int, expected: Bool) {
        let isOdd = isEven.negated
        #expect(isOdd(value) == expected)
    }

    @Test
    func `NOT is Involution`() {
        let doubleNegated = !(!isEven)

        for n in -10...10 {
            #expect(doubleNegated(n) == isEven(n))
        }
    }

    @Test
    func `NOT complement Law`() {
        // p && !p == .never
        let contradiction = isEven && !isEven

        for n in -10...10 {
            #expect(contradiction(n) == false)
        }
    }

    @Test
    func `NOT tautology Law`() {
        // p || !p == .always
        let tautology = isEven || !isEven

        for n in -10...10 {
            #expect(tautology(n) == true)
        }
    }
}

// MARK: - XOR Tests

@Suite
struct `Predicate XOR Tests` {
    let isEven = Predicate<Int> { $0 % 2 == 0 }
    let isPositive = Predicate<Int> { $0 > 0 }

    @Test(arguments: [
        (value: 4, expected: false),  // both true
        (value: 3, expected: true),  // positive only
        (value: -4, expected: true),  // even only
        (value: -3, expected: false),  // neither
    ])
    func `static XOR`(value: Int, expected: Bool) {
        let combined = Predicate.xor(isEven, isPositive)
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: false),
        (value: 3, expected: true),
    ])
    func `operator XOR`(value: Int, expected: Bool) {
        let combined = isEven ^ isPositive
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: false),
        (value: 3, expected: true),
    ])
    func `fluent XOR`(value: Int, expected: Bool) {
        let combined = isEven.xor(isPositive)
        #expect(combined(value) == expected)
    }

    @Test
    func `XOR is Commutative`() {
        let p1 = isEven ^ isPositive
        let p2 = isPositive ^ isEven

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func `XOR is Associative`() {
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
struct `Predicate NAND NOR Tests` {
    let isEven = Predicate<Int> { $0 % 2 == 0 }
    let isPositive = Predicate<Int> { $0 > 0 }

    @Test
    func `static NAND`() {
        let nand = Predicate.nand(isEven, isPositive)
        let notAnd = !(isEven && isPositive)

        for n in -10...10 {
            #expect(nand(n) == notAnd(n))
        }
    }

    @Test
    func `fluent NAND`() {
        let nand = isEven.nand(isPositive)
        let notAnd = !(isEven && isPositive)

        for n in -10...10 {
            #expect(nand(n) == notAnd(n))
        }
    }

    @Test
    func `static NOR`() {
        let nor = Predicate.nor(isEven, isPositive)
        let notOr = !(isEven || isPositive)

        for n in -10...10 {
            #expect(nor(n) == notOr(n))
        }
    }

    @Test
    func `fluent NOR`() {
        let nor = isEven.nor(isPositive)
        let notOr = !(isEven || isPositive)

        for n in -10...10 {
            #expect(nor(n) == notOr(n))
        }
    }
}

// MARK: - Implication Tests

@Suite
struct `Predicate Implication Tests` {
    let isEven = Predicate<Int> { $0 % 2 == 0 }
    let isPositive = Predicate<Int> { $0 > 0 }

    @Test
    func `static Implies`() {
        let implies = Predicate.implies(isEven, isPositive)
        let notOr = !isEven || isPositive

        for n in -10...10 {
            #expect(implies(n) == notOr(n))
        }
    }

    @Test
    func `fluent Implies`() {
        let implies = isEven.implies(isPositive)
        let notOr = !isEven || isPositive

        for n in -10...10 {
            #expect(implies(n) == notOr(n))
        }
    }

    @Test
    func `static Iff`() {
        let iff = Predicate.iff(isEven, isPositive)
        let notXor = !(isEven ^ isPositive)

        for n in -10...10 {
            #expect(iff(n) == notXor(n))
        }
    }

    @Test
    func `fluent Iff`() {
        let iff = isEven.iff(isPositive)
        let notXor = !(isEven ^ isPositive)

        for n in -10...10 {
            #expect(iff(n) == notXor(n))
        }
    }

    @Test
    func `static Unless`() {
        let unless = Predicate.unless(isEven, condition: isPositive)
        let reversed = Predicate.implies(isPositive, isEven)

        for n in -10...10 {
            #expect(unless(n) == reversed(n))
        }
    }

    @Test
    func `fluent Unless`() {
        let unless = isEven.unless(isPositive)
        let reversed = isPositive.implies(isEven)

        for n in -10...10 {
            #expect(unless(n) == reversed(n))
        }
    }
}

// MARK: - De Morgan Tests

@Suite
struct `Predicate DeMorgan Tests` {
    let isEven = Predicate<Int> { $0 % 2 == 0 }
    let isPositive = Predicate<Int> { $0 > 0 }

    @Test
    func `de Morgan Law1`() {
        // !(a && b) == !a || !b
        let p1 = !(isEven && isPositive)
        let p2 = !isEven || !isPositive

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func `de Morgan Law2`() {
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
struct `Predicate Distributivity Tests` {
    let isEven = Predicate<Int> { $0 % 2 == 0 }
    let isPositive = Predicate<Int> { $0 > 0 }
    let isSmall = Predicate<Int> { abs($0) < 5 }

    @Test
    func `AND distributes Over OR`() {
        // a && (b || c) == (a && b) || (a && c)
        let p1 = isEven && (isPositive || isSmall)
        let p2 = (isEven && isPositive) || (isEven && isSmall)

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func `OR distributes Over AND`() {
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
struct `Predicate Pullback Tests` {
    @Test
    func `static Pullback With Closure`() {
        let isEven = Predicate<Int> { $0 % 2 == 0 }
        let hasEvenLength = Predicate.pullback(isEven) { (s: String) in s.count }

        #expect(hasEvenLength("hi") == true)  // count 2
        #expect(hasEvenLength("hello") == false)  // count 5
    }

    @Test
    func `static Pullback With Key Path`() {
        let isLong = Predicate<Int> { $0 > 3 }
        let hasLongCount: Predicate<String> = Predicate.pullback(isLong, \.count)

        #expect(hasLongCount("hi") == false)  // count 2
        #expect(hasLongCount("hello") == true)  // count 5
    }

    @Test
    func `instance Pullback With Closure`() {
        let isEven = Predicate<Int> { $0 % 2 == 0 }
        let hasEvenLength = isEven.pullback { (s: String) in s.count }

        #expect(hasEvenLength("hi") == true)
        #expect(hasEvenLength("hello") == false)
    }

    @Test
    func `instance Pullback With Key Path`() {
        let isLong = Predicate<Int> { $0 > 3 }
        let hasLongCount: Predicate<String> = isLong.pullback(\.count)

        #expect(hasLongCount("hi") == false)
        #expect(hasLongCount("hello") == true)
    }
}

// MARK: - Where Clause Tests

@Suite
struct `Predicate Where Tests` {
    struct Person {
        let age: Int
        let name: String
    }

    @Test
    func `where With Predicate`() {
        let isAdult = Predicate<Person>.where(\.age, Predicate<Int> { $0 >= 18 })

        let adult = Person(age: 25, name: "Alice")
        let child = Person(age: 15, name: "Bob")

        #expect(isAdult(adult) == true)
        #expect(isAdult(child) == false)
    }

    @Test
    func `where With Closure`() {
        let hasLongName = Predicate<Person>.where(\.name) { $0.count > 5 }

        let alice = Person(age: 25, name: "Alice")
        let alexander = Person(age: 30, name: "Alexander")

        #expect(hasLongName(alice) == false)
        #expect(hasLongName(alexander) == true)
    }

    @Test
    func `where With Fluent Predicate`() {
        let isAdult = Predicate<Person>.where(\.age, .greater.thanOrEqualTo(18))

        let adult = Person(age: 25, name: "Alice")
        let child = Person(age: 15, name: "Bob")

        #expect(isAdult(adult) == true)
        #expect(isAdult(child) == false)
    }
}

// MARK: - Optional Tests

@Suite
struct `Predicate Optional Tests` {
    @Test(arguments: [
        (value: nil as Int?, expected: true),
        (value: 42 as Int?, expected: false),
    ])
    func `is Nil`(value: Int?, expected: Bool) {
        let isNil = Predicate<Int>.is.nil
        #expect(isNil(value) == expected)
    }

    @Test(arguments: [
        (value: 42 as Int?, expected: true),
        (value: nil as Int?, expected: false),
    ])
    func `is Not Nil`(value: Int?, expected: Bool) {
        let isNotNil = Predicate<Int>.is.notNil
        #expect(isNotNil(value) == expected)
    }

    @Test
    func `static Optional Lift With Default`() {
        let isEven = Predicate<Int> { $0 % 2 == 0 }
        let optionalIsEven = Predicate.optional(isEven, default: false)

        #expect(optionalIsEven(4) == true)
        #expect(optionalIsEven(3) == false)
        #expect(optionalIsEven(nil) == false)
    }

    @Test
    func `instance Optional Lift With Default`() {
        let isEven = Predicate<Int> { $0 % 2 == 0 }
        let test = isEven.optional(default: false)

        #expect(test(4) == true)
        #expect(test(3) == false)
        #expect(test(nil) == false)
    }

    @Test
    func `optional Lift With True Default`() {
        let isEven = Predicate<Int> { $0 % 2 == 0 }
        let test = isEven.optional(default: true)

        #expect(test(nil) == true)
    }
}

// MARK: - Quantifier Tests

@Suite
struct `Predicate Quantifier Tests` {
    let isEven = Predicate<Int> { $0 % 2 == 0 }

    // MARK: Static Methods

    @Test(arguments: [
        (array: [2, 4, 6], expected: true),
        (array: [2, 3, 4], expected: false),
        (array: [], expected: true),  // vacuous truth
    ])
    func `static All`(array: [Int], expected: Bool) {
        let allEven = Predicate.all(isEven)
        #expect(allEven(array) == expected)
    }

    @Test(arguments: [
        (array: [1, 2, 3], expected: true),
        (array: [1, 3, 5], expected: false),
        (array: [], expected: false),
    ])
    func `static Any`(array: [Int], expected: Bool) {
        let anyEven = Predicate.any(isEven)
        #expect(anyEven(array) == expected)
    }

    @Test(arguments: [
        (array: [1, 3, 5], expected: true),
        (array: [1, 2, 3], expected: false),
        (array: [], expected: true),
    ])
    func `static None`(array: [Int], expected: Bool) {
        let noneEven = Predicate.none(isEven)
        #expect(noneEven(array) == expected)
    }

    // MARK: Instance Properties

    @Test(arguments: [
        (array: [2, 4, 6], expected: true),
        (array: [2, 3, 4], expected: false),
        (array: [], expected: true),
    ])
    func `property All`(array: [Int], expected: Bool) {
        let allEven = isEven.all
        #expect(allEven(array) == expected)
    }

    @Test(arguments: [
        (array: [1, 2, 3], expected: true),
        (array: [1, 3, 5], expected: false),
        (array: [], expected: false),
    ])
    func `property Any`(array: [Int], expected: Bool) {
        let anyEven = isEven.any
        #expect(anyEven(array) == expected)
    }

    @Test(arguments: [
        (array: [1, 3, 5], expected: true),
        (array: [1, 2, 3], expected: false),
        (array: [], expected: true),
    ])
    func `property None`(array: [Int], expected: Bool) {
        let noneEven = isEven.none
        #expect(noneEven(array) == expected)
    }

    // MARK: Generic Sequence Methods

    @Test
    func `static For All With Set`() {
        let allEven: Predicate<Set<Int>> = Predicate.forAll(isEven)

        #expect(allEven(Set([2, 4, 6])) == true)
        #expect(allEven(Set([2, 3, 4])) == false)
        #expect(allEven(Set()) == true)
    }

    @Test
    func `static For Any With Set`() {
        let anyEven: Predicate<Set<Int>> = Predicate.forAny(isEven)

        #expect(anyEven(Set([1, 2, 3])) == true)
        #expect(anyEven(Set([1, 3, 5])) == false)
        #expect(anyEven(Set()) == false)
    }

    @Test
    func `static For None With Set`() {
        let noneEven: Predicate<Set<Int>> = Predicate.forNone(isEven)

        #expect(noneEven(Set([1, 3, 5])) == true)
        #expect(noneEven(Set([1, 2, 3])) == false)
        #expect(noneEven(Set()) == true)
    }

    @Test
    func `instance For All With Set`() {
        let allEven: Predicate<Set<Int>> = isEven.forAll()

        #expect(allEven(Set([2, 4, 6])) == true)
        #expect(allEven(Set([2, 3, 4])) == false)
        #expect(allEven(Set()) == true)
    }

    @Test
    func `instance For Any With Set`() {
        let anyEven: Predicate<Set<Int>> = isEven.forAny()

        #expect(anyEven(Set([1, 2, 3])) == true)
        #expect(anyEven(Set([1, 3, 5])) == false)
        #expect(anyEven(Set()) == false)
    }

    @Test
    func `instance For None With Set`() {
        let noneEven: Predicate<Set<Int>> = isEven.forNone()

        #expect(noneEven(Set([1, 3, 5])) == true)
        #expect(noneEven(Set([1, 2, 3])) == false)
        #expect(noneEven(Set()) == true)
    }

    @Test
    func `for All With Closed Range`() {
        let allEven: Predicate<ClosedRange<Int>> = isEven.forAll()

        #expect(allEven(2...2) == true)  // single even
        #expect(allEven(1...10) == false)  // mixed
    }

    @Test
    func `for Any With Closed Range`() {
        let anyEven: Predicate<ClosedRange<Int>> = isEven.forAny()

        #expect(anyEven(1...10) == true)
        #expect(anyEven(1...1) == false)  // single odd
    }
}

// MARK: - Count Quantifier Tests

@Suite
struct `Predicate Count Quantifier Tests` {
    let isEven = Predicate<Int> { $0 % 2 == 0 }

    @Test(arguments: [
        (array: [2, 4, 6], n: 2, expected: true),
        (array: [2, 4], n: 3, expected: false),
        (array: [2, 4, 6, 8], n: 3, expected: true),
    ])
    func `static At Least`(array: [Int], n: Int, expected: Bool) {
        let predicate = Predicate.Count.atLeast(isEven, n)
        #expect(predicate(array) == expected)
    }

    @Test(arguments: [
        (array: [2, 4, 6], n: 3, expected: true),
        (array: [2, 4, 6, 8], n: 3, expected: false),
        (array: [2, 4], n: 5, expected: true),
    ])
    func `static At Most`(array: [Int], n: Int, expected: Bool) {
        let predicate = Predicate.Count.atMost(isEven, n)
        #expect(predicate(array) == expected)
    }

    @Test(arguments: [
        (array: [2, 4, 6], n: 3, expected: true),
        (array: [2, 4], n: 3, expected: false),
        (array: [2, 4, 6, 8], n: 3, expected: false),
    ])
    func `static Exactly`(array: [Int], n: Int, expected: Bool) {
        let predicate = Predicate.Count.exactly(isEven, n)
        #expect(predicate(array) == expected)
    }

    @Test(arguments: [
        (array: [1, 3, 5], expected: true),
        (array: [2, 3, 5], expected: false),
        (array: [], expected: true),
    ])
    func `static Zero`(array: [Int], expected: Bool) {
        let predicate = Predicate.Count.zero(isEven)
        #expect(predicate(array) == expected)
    }

    @Test(arguments: [
        (array: [2, 3, 5], expected: true),
        (array: [1, 3, 5], expected: false),
        (array: [2, 4, 6], expected: false),
    ])
    func `static One`(array: [Int], expected: Bool) {
        let predicate = Predicate.Count.one(isEven)
        #expect(predicate(array) == expected)
    }

    @Test(arguments: [
        (array: [2, 4, 6], n: 2, expected: true),
        (array: [2, 4], n: 3, expected: false),
    ])
    func `instance At Least`(array: [Int], n: Int, expected: Bool) {
        let predicate = isEven.count.atLeast(n)
        #expect(predicate(array) == expected)
    }

    @Test(arguments: [
        (array: [2, 4, 6], n: 3, expected: true),
        (array: [2, 4, 6, 8], n: 3, expected: false),
    ])
    func `instance At Most`(array: [Int], n: Int, expected: Bool) {
        let predicate = isEven.count.atMost(n)
        #expect(predicate(array) == expected)
    }

    @Test(arguments: [
        (array: [2, 4, 6], n: 3, expected: true),
        (array: [2, 4], n: 3, expected: false),
    ])
    func `instance Exactly`(array: [Int], n: Int, expected: Bool) {
        let predicate = isEven.count.exactly(n)
        #expect(predicate(array) == expected)
    }

    @Test(arguments: [
        (array: [1, 3, 5], expected: true),
        (array: [2, 3, 5], expected: false),
    ])
    func `instance Zero`(array: [Int], expected: Bool) {
        let predicate = isEven.count.zero
        #expect(predicate(array) == expected)
    }

    @Test(arguments: [
        (array: [2, 3, 5], expected: true),
        (array: [1, 3, 5], expected: false),
    ])
    func `instance One`(array: [Int], expected: Bool) {
        let predicate = isEven.count.one
        #expect(predicate(array) == expected)
    }
}

// MARK: - Fluent Factory Tests

@Suite
struct `Predicate Fluent Factory Tests` {
    @Test(arguments: [
        (value: 0, expected: true),
        (value: 1, expected: false),
    ])
    func `equal To`(value: Int, expected: Bool) {
        let isZero = Predicate<Int>.equal.to(0)
        #expect(isZero(value) == expected)
    }

    @Test(arguments: [
        (value: 0, expected: false),
        (value: 1, expected: true),
    ])
    func `not Equal To`(value: Int, expected: Bool) {
        let isNotZero = Predicate<Int>.not.equalTo(0)
        #expect(isNotZero(value) == expected)
    }

    @Test(arguments: [
        (value: "a" as Character, expected: true),
        (value: "b" as Character, expected: false),
    ])
    func `in Collection`(value: Character, expected: Bool) {
        let isVowel = Predicate<Character>.in.collection("aeiou")
        #expect(isVowel(value) == expected)
    }

    @Test(arguments: [
        (value: 3, threshold: 5, expected: true),
        (value: 5, threshold: 5, expected: false),
    ])
    func `less Than`(value: Int, threshold: Int, expected: Bool) {
        let predicate = Predicate<Int>.less.than(threshold)
        #expect(predicate(value) == expected)
    }

    @Test(arguments: [
        (value: 5, threshold: 5, expected: true),
        (value: 6, threshold: 5, expected: false),
    ])
    func `less Than Or Equal To`(value: Int, threshold: Int, expected: Bool) {
        let predicate = Predicate<Int>.less.thanOrEqualTo(threshold)
        #expect(predicate(value) == expected)
    }

    @Test(arguments: [
        (value: 6, threshold: 5, expected: true),
        (value: 5, threshold: 5, expected: false),
    ])
    func `greater Than`(value: Int, threshold: Int, expected: Bool) {
        let predicate = Predicate<Int>.greater.than(threshold)
        #expect(predicate(value) == expected)
    }

    @Test(arguments: [
        (value: 5, threshold: 5, expected: true),
        (value: 4, threshold: 5, expected: false),
    ])
    func `greater Than Or Equal To`(value: Int, threshold: Int, expected: Bool) {
        let predicate = Predicate<Int>.greater.thanOrEqualTo(threshold)
        #expect(predicate(value) == expected)
    }

    @Test(arguments: [
        (value: 15, expected: true),
        (value: 12, expected: false),
        (value: 20, expected: false),
    ])
    func `in Range`(value: Int, expected: Bool) {
        let isTeenager = Predicate<Int>.in.range(13...19)
        #expect(isTeenager(value) == expected)
    }

    @Test(arguments: [
        (value: 10, expected: true),
        (value: 15, expected: false),
    ])
    func `not In Range`(value: Int, expected: Bool) {
        let outsideTeenage = Predicate<Int>.not.inRange(13...19)
        #expect(outsideTeenage(value) == expected)
    }

    @Test(arguments: [
        (value: [], expected: true),
        (value: [1], expected: false),
    ])
    func `is Empty`(value: [Int], expected: Bool) {
        #expect(Predicate<[Int]>.is.empty(value) == expected)
    }

    @Test(arguments: [
        (value: [1], expected: true),
        (value: [], expected: false),
    ])
    func `is Not Empty`(value: [Int], expected: Bool) {
        #expect(Predicate<[Int]>.is.notEmpty(value) == expected)
    }

    @Test(arguments: [
        (value: [1, 2, 3], count: 3, expected: true),
        (value: [1, 2], count: 3, expected: false),
    ])
    func `has Count`(value: [Int], count: Int, expected: Bool) {
        #expect(Predicate<[Int]>.has.count(count)(value) == expected)
    }

    @Test(arguments: [
        (value: "hello", substring: "ell", expected: true),
        (value: "hello", substring: "xyz", expected: false),
    ])
    func `contains Substring`(value: String, substring: String, expected: Bool) {
        #expect(Predicate<String>.contains.substring(substring)(value) == expected)
    }

    @Test(arguments: [
        (value: "hello", prefix: "hel", expected: true),
        (value: "hello", prefix: "xyz", expected: false),
    ])
    func `has Prefix`(value: String, prefix: String, expected: Bool) {
        #expect(Predicate<String>.has.prefix(prefix)(value) == expected)
    }

    @Test(arguments: [
        (value: "hello", suffix: "llo", expected: true),
        (value: "hello", suffix: "xyz", expected: false),
    ])
    func `has Suffix`(value: String, suffix: String, expected: Bool) {
        #expect(Predicate<String>.has.suffix(suffix)(value) == expected)
    }

    @Test(arguments: [
        (value: "red", expected: true),
        (value: "yellow", expected: false),
    ])
    func `equal To Any Of`(value: String, expected: Bool) {
        let isPrimaryColor = Predicate<String>.equal.toAny(of: "red", "green", "blue")
        #expect(isPrimaryColor(value) == expected)
    }

    @Test(arguments: [
        (value: "yellow", expected: true),
        (value: "red", expected: false),
    ])
    func `equal To None Of`(value: String, expected: Bool) {
        let isNotPrimaryColor = Predicate<String>.equal.toNone(of: "red", "green", "blue")
        #expect(isNotPrimaryColor(value) == expected)
    }
}

// MARK: - Identifiable Tests

@Suite
struct `Predicate Identifiable Tests` {
    struct Item: Identifiable {
        let id: Int
        let name: String
    }

    @Test(arguments: [
        (item: Item(id: 1, name: "A"), targetId: 1, expected: true),
        (item: Item(id: 2, name: "B"), targetId: 1, expected: false),
    ])
    func `has Id`(item: Item, targetId: Int, expected: Bool) {
        let predicate = Predicate<Item>.has.id(targetId)
        #expect(predicate(item) == expected)
    }

    @Test(arguments: [
        (item: Item(id: 1, name: "A"), expected: true),
        (item: Item(id: 4, name: "D"), expected: false),
    ])
    func `has Id In Collection`(item: Item, expected: Bool) {
        let predicate = Predicate<Item>.has.id(in: [1, 2, 3])
        #expect(predicate(item) == expected)
    }
}
