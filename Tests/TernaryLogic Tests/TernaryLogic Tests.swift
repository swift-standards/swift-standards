// TernaryLogic Tests.swift
// Tests for Strong Kleene three-valued logic.

import Testing
@testable import TernaryLogic

@Suite
struct ThreeValuedLogicANDTests {
    @Test
    func `AND with both known values`() {
        #expect((false && false) == false)
        #expect((false && true) == false)
        #expect((true && false) == false)
        #expect((true && true) == true)
    }

    @Test
    func `AND with nil short-circuits on false`() {
        let nilValue: Bool? = nil
        // false && nil = false (Strong Kleene short-circuit)
        #expect((false && nilValue) == false)
        #expect((nilValue && false) == false)
    }

    @Test
    func `AND with nil propagates when no short-circuit`() {
        let nilValue: Bool? = nil
        // true && nil = nil
        #expect((true && nilValue) == nil)
        #expect((nilValue && true) == nil)
        // nil && nil = nil
        #expect((nilValue && nilValue) == nil)
    }

    @Test
    func `AND lazy evaluation`() {
        var evaluated = false
        let lazyValue: () -> Bool? = {
            evaluated = true
            return true
        }

        // Should NOT evaluate rhs when lhs is false
        _ = false && lazyValue()
        #expect(evaluated == false)
    }
}

@Suite
struct ThreeValuedLogicORTests {
    @Test
    func `OR with both known values`() {
        #expect((false || false) == false)
        #expect((false || true) == true)
        #expect((true || false) == true)
        #expect((true || true) == true)
    }

    @Test
    func `OR with nil short-circuits on true`() {
        let nilValue: Bool? = nil
        // true || nil = true (Strong Kleene short-circuit)
        #expect((true || nilValue) == true)
        #expect((nilValue || true) == true)
    }

    @Test
    func `OR with nil propagates when no short-circuit`() {
        let nilValue: Bool? = nil
        // false || nil = nil
        #expect((false || nilValue) == nil)
        #expect((nilValue || false) == nil)
        // nil || nil = nil
        #expect((nilValue || nilValue) == nil)
    }

    @Test
    func `OR lazy evaluation`() {
        var evaluated = false
        let lazyValue: () -> Bool? = {
            evaluated = true
            return false
        }

        // Should NOT evaluate rhs when lhs is true
        _ = true || lazyValue()
        #expect(evaluated == false)
    }
}

@Suite
struct ThreeValuedLogicNOTTests {
    @Test
    func `NOT with known values`() {
        #expect((!true) == false)
        #expect((!false) == true)
    }

    @Test
    func `NOT with nil`() {
        let nilValue: Bool? = nil
        #expect((!nilValue) == nil)
    }

    @Test
    func `NOT is involution`() {
        #expect((!(!true)) == true)
        #expect((!(!false)) == false)
    }
}

@Suite
struct ThreeValuedLogicXORTests {
    @Test
    func `XOR with both known values`() {
        #expect((false ^ false) == false)
        #expect((false ^ true) == true)
        #expect((true ^ false) == true)
        #expect((true ^ true) == false)
    }

    @Test
    func `XOR with nil always nil`() {
        let nilValue: Bool? = nil
        #expect((false ^ nilValue) == nil)
        #expect((true ^ nilValue) == nil)
        #expect((nilValue ^ false) == nil)
        #expect((nilValue ^ true) == nil)
        #expect((nilValue ^ nilValue) == nil)
    }
}

@Suite
struct ThreeValuedLogicNANDTests {
    @Test
    func `NAND with both known values`() {
        #expect((false !&& false) == true)
        #expect((false !&& true) == true)
        #expect((true !&& false) == true)
        #expect((true !&& true) == false)
    }

    @Test
    func `NAND with nil`() {
        let nilValue: Bool? = nil
        // NAND(false, nil) = NOT(AND(false, nil)) = NOT(false) = true
        #expect((false !&& nilValue) == true)
        #expect((nilValue !&& false) == true)
        // NAND(true, nil) = NOT(AND(true, nil)) = NOT(nil) = nil
        #expect((true !&& nilValue) == nil)
        #expect((nilValue !&& true) == nil)
    }
}

@Suite
struct ThreeValuedLogicNORTests {
    @Test
    func `NOR with both known values`() {
        #expect((false !|| false) == true)
        #expect((false !|| true) == false)
        #expect((true !|| false) == false)
        #expect((true !|| true) == false)
    }

    @Test
    func `NOR with nil`() {
        let nilValue: Bool? = nil
        // NOR(true, nil) = NOT(OR(true, nil)) = NOT(true) = false
        #expect((true !|| nilValue) == false)
        #expect((nilValue !|| true) == false)
        // NOR(false, nil) = NOT(OR(false, nil)) = NOT(nil) = nil
        #expect((false !|| nilValue) == nil)
        #expect((nilValue !|| false) == nil)
    }
}

@Suite
struct ThreeValuedLogicXNORTests {
    @Test
    func `XNOR with both known values`() {
        #expect((false !^ false) == true)
        #expect((false !^ true) == false)
        #expect((true !^ false) == false)
        #expect((true !^ true) == true)
    }

    @Test
    func `XNOR with nil always nil`() {
        let nilValue: Bool? = nil
        #expect((false !^ nilValue) == nil)
        #expect((true !^ nilValue) == nil)
        #expect((nilValue !^ false) == nil)
        #expect((nilValue !^ true) == nil)
        #expect((nilValue !^ nilValue) == nil)
    }
}

@Suite
struct ThreeValuedLogicDeMorganTests {
    @Test
    func `De Morgan laws for known values`() {
        for a in [true, false] {
            for b in [true, false] {
                // !(a && b) == !a || !b
                #expect(!(a && b) == (!a || !b))
                // !(a || b) == !a && !b
                #expect(!(a || b) == (!a && !b))
            }
        }
    }

    @Test
    func `De Morgan laws with nil`() {
        let nilValue: Bool? = nil

        // When result is determinate, De Morgan holds
        // !(false && nil) = !false = true
        // !false || !nil = true || nil = true ✓
        #expect(!(false && nilValue) == ((!false) || (!nilValue)))

        // !(true || nil) = !true = false
        // !true && !nil = false && nil = false ✓
        #expect(!(true || nilValue) == ((!true) && (!nilValue)))
    }
}

@Suite
struct ThreeValuedLogicComplexExpressionTests {
    @Test
    func `Complex expression with mixed values`() {
        let a: Bool? = true
        let b: Bool? = false
        let c: Bool? = nil

        // (true && false) || nil = false || nil = nil
        #expect(((a && b) || c) == nil)

        // true && (false || nil) = true && nil = nil
        #expect((a && (b || c)) == nil)

        // (true || nil) && false = true && false = false
        #expect(((a || c) && b) == false)
    }

    @Test
    func `Implication using OR and NOT`() {
        // a → b  ≡  !a || b
        func implies(_ a: Bool?, _ b: Bool?) -> Bool? {
            !a || b
        }

        // true → true = true
        #expect(implies(true, true) == true)
        // true → false = false
        #expect(implies(true, false) == false)
        // false → anything = true (vacuous truth)
        #expect(implies(false, true) == true)
        #expect(implies(false, false) == true)
        #expect(implies(false, nil) == true)
        // nil → true = nil || true = true
        #expect(implies(nil, true) == true)
        // nil → false = nil || false = nil
        #expect(implies(nil, false) == nil)
    }
}
