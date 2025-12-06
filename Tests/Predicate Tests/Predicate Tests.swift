// Predicate Tests.swift
// Tests for predicate composition operators.

import Testing
@testable import Predicate

@Suite
struct PredicateANDTests {
    let isEven: (Int) -> Bool = { $0 % 2 == 0 }
    let isPositive: (Int) -> Bool = { $0 > 0 }

    @Test
    func `AND combines predicates`() {
        let isEvenAndPositive = isEven && isPositive

        #expect(isEvenAndPositive(4) == true)   // even and positive
        #expect(isEvenAndPositive(3) == false)  // odd
        #expect(isEvenAndPositive(-4) == false) // negative
        #expect(isEvenAndPositive(-3) == false) // odd and negative
    }

    @Test
    func `AND is commutative`() {
        let p1 = isEven && isPositive
        let p2 = isPositive && isEven

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func `AND is associative`() {
        let greaterThan5: (Int) -> Bool = { $0 > 5 }

        let p1 = (isEven && isPositive) && greaterThan5
        let p2 = isEven && (isPositive && greaterThan5)

        for n in -10...20 {
            #expect(p1(n) == p2(n))
        }
    }
}

@Suite
struct PredicateORTests {
    let isEven: (Int) -> Bool = { $0 % 2 == 0 }
    let isNegative: (Int) -> Bool = { $0 < 0 }

    @Test
    func `OR combines predicates`() {
        let isEvenOrNegative = isEven || isNegative

        #expect(isEvenOrNegative(4) == true)    // even
        #expect(isEvenOrNegative(-3) == true)   // negative
        #expect(isEvenOrNegative(-4) == true)   // both
        #expect(isEvenOrNegative(3) == false)   // neither
    }

    @Test
    func `OR is commutative`() {
        let p1 = isEven || isNegative
        let p2 = isNegative || isEven

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func `OR is associative`() {
        let isZero: (Int) -> Bool = { $0 == 0 }

        let p1 = (isEven || isNegative) || isZero
        let p2 = isEven || (isNegative || isZero)

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }
}

@Suite
struct PredicateNOTTests {
    let isEven: (Int) -> Bool = { $0 % 2 == 0 }

    @Test
    func `NOT negates predicate`() {
        let isOdd = !isEven

        #expect(isOdd(3) == true)
        #expect(isOdd(4) == false)
    }

    @Test
    func `NOT is involution`() {
        let doubleNegated = !(!isEven)

        for n in -10...10 {
            #expect(doubleNegated(n) == isEven(n))
        }
    }
}

@Suite
struct PredicateXORTests {
    let isEven: (Int) -> Bool = { $0 % 2 == 0 }
    let isPositive: (Int) -> Bool = { $0 > 0 }

    @Test
    func `XOR returns true when exactly one is true`() {
        let isEvenXorPositive = isEven ^ isPositive

        #expect(isEvenXorPositive(4) == false)   // both true
        #expect(isEvenXorPositive(3) == true)    // positive only
        #expect(isEvenXorPositive(-4) == true)   // even only
        #expect(isEvenXorPositive(-3) == false)  // neither
    }

    @Test
    func `XOR is commutative`() {
        let p1 = isEven ^ isPositive
        let p2 = isPositive ^ isEven

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func `XOR is associative`() {
        let isSmall: (Int) -> Bool = { abs($0) < 5 }

        let p1 = (isEven ^ isPositive) ^ isSmall
        let p2 = isEven ^ (isPositive ^ isSmall)

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }
}

@Suite
struct PredicateDeMorganTests {
    let isEven: (Int) -> Bool = { $0 % 2 == 0 }
    let isPositive: (Int) -> Bool = { $0 > 0 }

    @Test
    func `De Morgan law 1`() {
        // !(a && b) == !a || !b
        let p1 = !(isEven && isPositive)
        let p2 = !isEven || !isPositive

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func `De Morgan law 2`() {
        // !(a || b) == !a && !b
        let p1 = !(isEven || isPositive)
        let p2 = !isEven && !isPositive

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }
}

@Suite
struct PredicateDistributivityTests {
    let isEven: (Int) -> Bool = { $0 % 2 == 0 }
    let isPositive: (Int) -> Bool = { $0 > 0 }
    let isSmall: (Int) -> Bool = { abs($0) < 5 }

    @Test
    func `AND distributes over OR`() {
        // a && (b || c) == (a && b) || (a && c)
        let p1 = isEven && (isPositive || isSmall)
        let p2 = (isEven && isPositive) || (isEven && isSmall)

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func `OR distributes over AND`() {
        // a || (b && c) == (a || b) && (a || c)
        let p1 = isEven || (isPositive && isSmall)
        let p2 = (isEven || isPositive) && (isEven || isSmall)

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }
}

@Suite
struct PredicateIdentityTests {
    let isEven: (Int) -> Bool = { $0 % 2 == 0 }
    let alwaysTrue: (Int) -> Bool = { _ in true }
    let alwaysFalse: (Int) -> Bool = { _ in false }

    @Test
    func `AND identity`() {
        // a && true == a
        let p = isEven && alwaysTrue

        for n in -10...10 {
            #expect(p(n) == isEven(n))
        }
    }

    @Test
    func `AND annihilator`() {
        // a && false == false
        let p = isEven && alwaysFalse

        for n in -10...10 {
            #expect(p(n) == false)
        }
    }

    @Test
    func `OR identity`() {
        // a || false == a
        let p = isEven || alwaysFalse

        for n in -10...10 {
            #expect(p(n) == isEven(n))
        }
    }

    @Test
    func `OR annihilator`() {
        // a || true == true
        let p = isEven || alwaysTrue

        for n in -10...10 {
            #expect(p(n) == true)
        }
    }
}
