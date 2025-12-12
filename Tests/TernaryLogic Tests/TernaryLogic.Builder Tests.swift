import StandardLibraryExtensions
import Testing

@testable import TernaryLogic

@Suite
struct `TernaryLogic.Builder Tests` {

    @Suite
    struct `TernaryLogic.all (Strong Kleene AND)` {

        @Test
        func `All true returns true`() {
            let result = Bool?.all {
                true
                true
                true
            }
            #expect(result == true)
        }

        @Test
        func `Any false returns false`() {
            let result = Bool?.all {
                true
                false
                true
            }
            #expect(result == false)
        }

        @Test
        func `Unknown with no false returns unknown`() {
            let result = Bool?.all {
                true
                nil as Bool?
                true
            }
            #expect(result == nil)
        }

        @Test
        func `False dominates unknown`() {
            let result = Bool?.all {
                nil as Bool?
                false
                nil as Bool?
            }
            #expect(result == false)
        }

        @Test
        func `Empty block returns true`() {
            let result: Bool? = Bool?.all {
            }
            #expect(result == true)
        }

        @Test
        func `Single true`() {
            let result = Bool?.all {
                true
            }
            #expect(result == true)
        }

        @Test
        func `Single false`() {
            let result = Bool?.all {
                false
            }
            #expect(result == false)
        }

        @Test
        func `Single unknown`() {
            let result = Bool?.all {
                nil as Bool?
            }
            #expect(result == nil)
        }

        @Test
        func `Conditional inclusion - true branch`() {
            let condition = true
            let result = Bool?.all {
                true
                if condition {
                    true
                }
            }
            #expect(result == true)
        }

        @Test
        func `Conditional inclusion - false branch yields unknown`() {
            let condition = false
            let result = Bool?.all {
                true
                if condition {
                    true
                }
            }
            // In ternary logic, missing value = unknown
            #expect(result == nil)
        }

        @Test
        func `If-else first branch`() {
            let condition = true
            let result = Bool?.all {
                if condition {
                    true
                } else {
                    false
                }
            }
            #expect(result == true)
        }

        @Test
        func `If-else second branch`() {
            let condition = false
            let result = Bool?.all {
                if condition {
                    true
                } else {
                    false
                }
            }
            #expect(result == false)
        }

        @Test
        func `For loop all true`() {
            let result = Bool?.all {
                for _ in 1...3 {
                    true
                }
            }
            #expect(result == true)
        }

        @Test
        func `For loop with false`() {
            let values: [Bool?] = [true, false, true]
            let result = Bool?.all {
                for v in values {
                    v
                }
            }
            #expect(result == false)
        }

        @Test
        func `For loop with unknown`() {
            let values: [Bool?] = [true, nil, true]
            let result = Bool?.all {
                for v in values {
                    v
                }
            }
            #expect(result == nil)
        }
    }

    @Suite
    struct `TernaryLogic.any (Strong Kleene OR)` {

        @Test
        func `All false returns false`() {
            let result = Bool?.any {
                false
                false
                false
            }
            #expect(result == false)
        }

        @Test
        func `Any true returns true`() {
            let result = Bool?.any {
                false
                true
                false
            }
            #expect(result == true)
        }

        @Test
        func `Unknown with no true returns unknown`() {
            let result = Bool?.any {
                false
                nil as Bool?
                false
            }
            #expect(result == nil)
        }

        @Test
        func `True dominates unknown`() {
            let result = Bool?.any {
                nil as Bool?
                true
                nil as Bool?
            }
            #expect(result == true)
        }

        @Test
        func `Empty block returns false`() {
            let result: Bool? = Bool?.any {
            }
            #expect(result == false)
        }

        @Test
        func `Single true`() {
            let result = Bool?.any {
                true
            }
            #expect(result == true)
        }

        @Test
        func `Single false`() {
            let result = Bool?.any {
                false
            }
            #expect(result == false)
        }

        @Test
        func `Single unknown`() {
            let result = Bool?.any {
                nil as Bool?
            }
            #expect(result == nil)
        }

        @Test
        func `Conditional inclusion - false branch yields unknown`() {
            let condition = false
            let result = Bool?.any {
                false
                if condition {
                    true
                }
            }
            // In ternary logic, missing value = unknown
            #expect(result == nil)
        }
    }

    @Suite
    struct `TernaryLogic.none (Strong Kleene NOR)` {

        @Test
        func `All false returns true`() {
            let result = Bool?.none {
                false
                false
                false
            }
            #expect(result == true)
        }

        @Test
        func `Any true returns false`() {
            let result = Bool?.none {
                false
                true
                false
            }
            #expect(result == false)
        }

        @Test
        func `Unknown with no true returns unknown`() {
            let result = Bool?.none {
                false
                nil as Bool?
                false
            }
            #expect(result == nil)
        }

        @Test
        func `True dominates unknown for NOR`() {
            let result = Bool?.none {
                nil as Bool?
                true
                nil as Bool?
            }
            // NOR of (unknown OR true OR unknown) = NOR of true = false
            #expect(result == false)
        }

        @Test
        func `Empty block returns true`() {
            let result: Bool? = Bool?.none {
            }
            // NOR of empty = NOT(false) = true
            #expect(result == true)
        }

        @Test
        func `Single true returns false`() {
            let result = Bool?.none {
                true
            }
            #expect(result == false)
        }

        @Test
        func `Single false returns true`() {
            let result = Bool?.none {
                false
            }
            #expect(result == true)
        }

        @Test
        func `Single unknown returns unknown`() {
            let result = Bool?.none {
                nil as Bool?
            }
            #expect(result == nil)
        }
    }

    @Suite
    struct `Static Method Tests` {

        @Test
        func `All.buildExpression Bool?`() {
            let result = TernaryLogic.Builder<Bool?>.All.buildExpression(true as Bool?)
            #expect(result == true)
        }

        @Test
        func `All.buildExpression Bool`() {
            let result = TernaryLogic.Builder<Bool?>.All.buildExpression(true)
            #expect(result == true)
        }

        @Test
        func `All.buildPartialBlock accumulated`() {
            // true AND true = true
            let r1 = TernaryLogic.Builder<Bool?>.All.buildPartialBlock(
                accumulated: true,
                next: true
            )
            #expect(r1 == true)

            // true AND false = false
            let r2 = TernaryLogic.Builder<Bool?>.All.buildPartialBlock(
                accumulated: true,
                next: false
            )
            #expect(r2 == false)

            // true AND unknown = unknown
            let r3 = TernaryLogic.Builder<Bool?>.All.buildPartialBlock(accumulated: true, next: nil)
            #expect(r3 == nil)

            // unknown AND false = false (false dominates)
            let r4 = TernaryLogic.Builder<Bool?>.All.buildPartialBlock(
                accumulated: nil,
                next: false
            )
            #expect(r4 == false)
        }

        @Test
        func `Any.buildPartialBlock accumulated`() {
            // false OR false = false
            let r1 = TernaryLogic.Builder<Bool?>.`Any`.buildPartialBlock(
                accumulated: false,
                next: false
            )
            #expect(r1 == false)

            // false OR true = true
            let r2 = TernaryLogic.Builder<Bool?>.`Any`.buildPartialBlock(
                accumulated: false,
                next: true
            )
            #expect(r2 == true)

            // false OR unknown = unknown
            let r3 = TernaryLogic.Builder<Bool?>.`Any`.buildPartialBlock(
                accumulated: false,
                next: nil
            )
            #expect(r3 == nil)

            // unknown OR true = true (true dominates)
            let r4 = TernaryLogic.Builder<Bool?>.`Any`.buildPartialBlock(
                accumulated: nil,
                next: true
            )
            #expect(r4 == true)
        }

        @Test
        func `None.buildFinalResult`() {
            // NOR of true = false
            let r1 = TernaryLogic.Builder<Bool?>.None.buildFinalResult(true)
            #expect(r1 == false)

            // NOR of false = true
            let r2 = TernaryLogic.Builder<Bool?>.None.buildFinalResult(false)
            #expect(r2 == true)

            // NOR of unknown = unknown
            let r3 = TernaryLogic.Builder<Bool?>.None.buildFinalResult(nil)
            #expect(r3 == nil)
        }
    }

    @Suite
    struct `Comparison with Bool.Builder` {

        @Test
        func `Bool.all vs Bool?.all - no unknowns`() {
            // With no unknowns, they should behave the same
            let boolResult = Bool.all {
                true
                true
            }
            let ternaryResult: Bool? = Bool?.all {
                true
                true
            }
            #expect(boolResult == true)
            #expect(ternaryResult == true)
        }

        @Test
        func `Bool.all vs Bool?.all - with conditional`() {
            let condition = false

            // Bool.all: missing value treated as identity (true for AND)
            let boolResult = Bool.all {
                true
                if condition {
                    true
                }
            }
            // Bool?.all: missing value treated as unknown
            let ternaryResult: Bool? = Bool?.all {
                true
                if condition {
                    true
                }
            }

            #expect(boolResult == true)  // Bool treats missing as true (identity for AND)
            #expect(ternaryResult == nil)  // Bool? treats missing as unknown
        }
    }
}
