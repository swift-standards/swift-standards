// Predicate+TernaryLogic Tests.swift
// Tests for three-valued logic lifting with optional values.

import Testing
import TernaryLogic

@testable import Predicate

// MARK: - Basic Ternary Logic Tests

@Suite
struct TernaryLogicBasicTests {
    let isEven = Predicate<Int> { $0 % 2 == 0 }
    let isPositive = Predicate<Int> { $0 > 0 }

    @Test(arguments: [
        (value: 4 as Int?, expected: true),
        (value: 3 as Int?, expected: false),
        (value: nil as Int?, expected: nil as Bool?)
    ])
    func staticCallAsFunction(value: Int?, expected: Bool?) {
        let result: Bool? = Predicate.callAsFunction(isEven, value)
        #expect(result == expected)
    }

    @Test(arguments: [
        (value: 4 as Int?, expected: true),
        (value: 3 as Int?, expected: false),
        (value: nil as Int?, expected: nil as Bool?)
    ])
    func instanceCallAsFunction(value: Int?, expected: Bool?) {
        let result: Bool? = isEven(value)
        #expect(result == expected)
    }

    @Test
    func returnsUnknownForNil() {
        let result: Bool? = isEven(nil)
        #expect(result == nil)
    }

    @Test
    func returnsTrueForMatchingValue() {
        let result: Bool? = isEven(4)
        #expect(result == true)
    }

    @Test
    func returnsFalseForNonMatchingValue() {
        let result: Bool? = isEven(3)
        #expect(result == false)
    }
}

// MARK: - Strong Kleene Semantics Tests

@Suite
struct StrongKleeneSemanticsTests {
    let isEven = Predicate<Int> { $0 % 2 == 0 }
    let isPositive = Predicate<Int> { $0 > 0 }

    @Test(arguments: [
        // AND truth table with unknown
        (lhs: nil as Int?, rhs: 4 as Int?, op: "&&", expected: nil as Bool?),    // unknown && true = unknown
        (lhs: nil as Int?, rhs: 3 as Int?, op: "&&", expected: nil as Bool?),    // unknown && false = unknown
        (lhs: 4 as Int?, rhs: nil as Int?, op: "&&", expected: nil as Bool?),    // true && unknown = unknown
        (lhs: 3 as Int?, rhs: nil as Int?, op: "&&", expected: false as Bool?),  // false && unknown = false
    ])
    func ternaryANDsemantics(lhs: Int?, rhs: Int?, op: String, expected: Bool?) {
        let lhsResult: Bool? = isEven(lhs)
        let rhsResult: Bool? = isPositive(rhs)
        let result = lhsResult && rhsResult
        #expect(result == expected)
    }

    @Test(arguments: [
        // OR truth table with unknown (Strong Kleene semantics)
        // isEven: even numbers, isPositive: > 0
        (lhs: nil as Int?, rhs: 4 as Int?, op: "||", expected: true as Bool?),   // unknown || true = true
        (lhs: nil as Int?, rhs: -3 as Int?, op: "||", expected: nil as Bool?),   // unknown || false = unknown
        (lhs: 4 as Int?, rhs: nil as Int?, op: "||", expected: true as Bool?),   // true || unknown = true
        (lhs: 3 as Int?, rhs: nil as Int?, op: "||", expected: nil as Bool?),    // false || unknown = unknown
    ])
    func ternaryORsemantics(lhs: Int?, rhs: Int?, op: String, expected: Bool?) {
        let lhsResult: Bool? = isEven(lhs)
        let rhsResult: Bool? = isPositive(rhs)
        let result = lhsResult || rhsResult
        #expect(result == expected)
    }
}

// MARK: - Composition with Optional Values

@Suite
struct OptionalCompositionTests {
    let isEven = Predicate<Int> { $0 % 2 == 0 }
    let isPositive = Predicate<Int> { $0 > 0 }

    @Test
    func composeWithANDoperator() {
        let combined = isEven && isPositive

        let result1: Bool? = combined(4)
        #expect(result1 == true)

        let result2: Bool? = combined(nil)
        #expect(result2 == nil)
    }

    @Test
    func composeWithORoperator() {
        let combined = isEven || isPositive

        let result1: Bool? = combined(3)
        #expect(result1 == true)

        let result2: Bool? = combined(nil)
        #expect(result2 == nil)
    }

    @Test
    func composeWithNOToperator() {
        let isOdd = !isEven

        let result1: Bool? = isOdd(3)
        #expect(result1 == true)

        let result2: Bool? = isOdd(nil)
        #expect(result2 == nil)
    }

    @Test
    func composeWithXORoperator() {
        let combined = isEven ^ isPositive

        let result1: Bool? = combined(3)
        #expect(result1 == true)

        let result2: Bool? = combined(nil)
        #expect(result2 == nil)
    }
}

// MARK: - Type Inference Tests

@Suite
struct TernaryLogicTypeInferenceTests {
    let isEven = Predicate<Int> { $0 % 2 == 0 }

    @Test
    func infersBoolOptional() {
        let value: Int? = 4
        let result: Bool? = isEven(value)
        #expect(result == true)
    }

    @Test
    func canExplicitlySpecifyType() {
        let value: Int? = nil
        let result: Bool? = Predicate.callAsFunction(isEven, value)
        #expect(result == nil)
    }

    @Test
    func worksWithChainedOptionals() {
        let getValue: () -> Int? = { 4 }
        let result: Bool? = isEven(getValue())
        #expect(result == true)
    }
}

// MARK: - Integration with Fluent Methods

@Suite
struct TernaryLogicFluentMethodTests {
    let isEven = Predicate<Int> { $0 % 2 == 0 }
    let isPositive = Predicate<Int> { $0 > 0 }

    @Test
    func fluentANDwithOptional() {
        let combined = isEven.and(isPositive)

        let result1: Bool? = combined(4)
        #expect(result1 == true)

        let result2: Bool? = combined(nil)
        #expect(result2 == nil)
    }

    @Test
    func fluentORwithOptional() {
        let combined = isEven.or(isPositive)

        let result1: Bool? = combined(3)
        #expect(result1 == true)

        let result2: Bool? = combined(nil)
        #expect(result2 == nil)
    }

    @Test
    func fluentNegatedWithOptional() {
        let isOdd = isEven.negated

        let result1: Bool? = isOdd(3)
        #expect(result1 == true)

        let result2: Bool? = isOdd(nil)
        #expect(result2 == nil)
    }
}

// MARK: - Edge Cases

@Suite
struct TernaryLogicEdgeCasesTests {
    let alwaysTrue = Predicate<Int>.always
    let alwaysFalse = Predicate<Int>.never

    @Test
    func alwaysTrueWithNil() {
        let result: Bool? = alwaysTrue(nil)
        #expect(result == nil)
    }

    @Test
    func alwaysFalseWithNil() {
        let result: Bool? = alwaysFalse(nil)
        #expect(result == nil)
    }

    @Test
    func complexPredicateWithNil() {
        let isEven = Predicate<Int> { $0 % 2 == 0 }
        let isPositive = Predicate<Int> { $0 > 0 }
        let isSmall = Predicate<Int> { abs($0) < 10 }

        let complex = (isEven && isPositive) || isSmall

        let result: Bool? = complex(nil)
        #expect(result == nil)
    }

    @Test
    func nullPropagationThroughChain() {
        let isEven = Predicate<Int> { $0 % 2 == 0 }
        let isPositive = Predicate<Int> { $0 > 0 }
        let isSmall = Predicate<Int> { abs($0) < 10 }

        let chain = isEven.and(isPositive).or(isSmall)

        let result: Bool? = chain(nil)
        #expect(result == nil)
    }
}

// MARK: - Practical Usage Examples

@Suite
struct TernaryLogicPracticalTests {
    struct User {
        var age: Int?
        var isActive: Bool
    }

    @Test
    func optionalPropertyValidation() {
        let isAdult = Predicate<Int> { $0 >= 18 }

        let user1 = User(age: 25, isActive: true)
        let user2 = User(age: 15, isActive: true)
        let user3 = User(age: nil, isActive: true)

        let result1: Bool? = isAdult(user1.age)
        #expect(result1 == true)

        let result2: Bool? = isAdult(user2.age)
        #expect(result2 == false)

        let result3: Bool? = isAdult(user3.age)
        #expect(result3 == nil)
    }

    @Test
    func optionalChainValidation() {
        struct Person {
            var name: String?
        }

        let hasLongName = Predicate<Int> { $0 > 5 }

        let person1 = Person(name: "Alexander")
        let person2 = Person(name: "Bob")
        let person3 = Person(name: nil)

        let result1: Bool? = hasLongName(person1.name?.count)
        #expect(result1 == true)

        let result2: Bool? = hasLongName(person2.name?.count)
        #expect(result2 == false)

        let result3: Bool? = hasLongName(person3.name?.count)
        #expect(result3 == nil)
    }
}

// MARK: - Comparison with Optional Lifting

@Suite
struct TernaryLogicVsOptionalLiftingTests {
    let isEven = Predicate<Int> { $0 % 2 == 0 }

    @Test
    func ternaryLogicReturnsNil() {
        let result: Bool? = isEven(nil as Int?)
        #expect(result == nil)
    }

    @Test
    func optionalLiftingWithDefaultReturnsFalse() {
        let lifted = isEven.optional(default: false)
        let result = lifted(nil)
        #expect(result == false)
    }

    @Test
    func optionalLiftingWithDefaultReturnsTrue() {
        let lifted = isEven.optional(default: true)
        let result = lifted(nil)
        #expect(result == true)
    }

    @Test
    func bothApproachesAgreeOnNonNilValues() {
        let lifted = isEven.optional(default: false)

        let ternaryResult: Bool? = isEven(4 as Int?)
        let liftedResult = lifted(4)

        #expect(ternaryResult == liftedResult)
    }
}
