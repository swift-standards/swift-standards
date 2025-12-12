import Testing

@testable import StandardLibraryExtensions

@Suite
struct `Bool.Builder Tests` {

    @Suite
    struct `Bool.all (AND Semantics)` {

        @Test
        func `All true returns true`() {
            let result = Bool.all {
                true
                true
                true
            }
            #expect(result == true)
        }

        @Test
        func `Any false returns false`() {
            let result = Bool.all {
                true
                false
                true
            }
            #expect(result == false)
        }

        @Test
        func `Empty block returns true (identity)`() {
            let result = Bool.all {
            }
            #expect(result == true)
        }

        @Test
        func `Single true`() {
            let result = Bool.all {
                true
            }
            #expect(result == true)
        }

        @Test
        func `Single false`() {
            let result = Bool.all {
                false
            }
            #expect(result == false)
        }

        @Test
        func `Conditional inclusion - true`() {
            let include = true
            let result = Bool.all {
                true
                if include {
                    true
                }
            }
            #expect(result == true)
        }

        @Test
        func `Conditional inclusion - false condition`() {
            let include = false
            let result = Bool.all {
                true
                if include {
                    false
                }
            }
            #expect(result == true)
        }

        @Test
        func `For loop all true`() {
            let result = Bool.all {
                for _ in 1...3 {
                    true
                }
            }
            #expect(result == true)
        }

        @Test
        func `For loop with false`() {
            let result = Bool.all {
                for i in 1...3 {
                    i != 2
                }
            }
            #expect(result == false)
        }
    }

    @Suite
    struct `Bool.any (OR Semantics)` {

        @Test
        func `All false returns false`() {
            let result = Bool.any {
                false
                false
                false
            }
            #expect(result == false)
        }

        @Test
        func `Any true returns true`() {
            let result = Bool.any {
                false
                true
                false
            }
            #expect(result == true)
        }

        @Test
        func `Empty block returns false (identity)`() {
            let result = Bool.any {
            }
            #expect(result == false)
        }

        @Test
        func `Single true`() {
            let result = Bool.any {
                true
            }
            #expect(result == true)
        }

        @Test
        func `Single false`() {
            let result = Bool.any {
                false
            }
            #expect(result == false)
        }

        @Test
        func `Conditional inclusion - true condition with true value`() {
            let include = true
            let result = Bool.any {
                false
                if include {
                    true
                }
            }
            #expect(result == true)
        }

        @Test
        func `Conditional inclusion - false condition`() {
            let include = false
            let result = Bool.any {
                false
                if include {
                    true
                }
            }
            #expect(result == false)
        }

        @Test
        func `For loop all false`() {
            let result = Bool.any {
                for _ in 1...3 {
                    false
                }
            }
            #expect(result == false)
        }

        @Test
        func `For loop with true`() {
            let result = Bool.any {
                for i in 1...3 {
                    i == 2
                }
            }
            #expect(result == true)
        }
    }

    @Suite
    struct `Bool.count` {

        @Test
        func `Counts true values`() {
            let result = Bool.count {
                true
                false
                true
                true
                false
            }
            #expect(result == 3)
        }

        @Test
        func `All false returns zero`() {
            let result = Bool.count {
                false
                false
                false
            }
            #expect(result == 0)
        }

        @Test
        func `All true returns count`() {
            let result = Bool.count {
                true
                true
                true
            }
            #expect(result == 3)
        }

        @Test
        func `Empty block returns zero`() {
            let result = Bool.count {
            }
            #expect(result == 0)
        }

        @Test
        func `For loop counting`() {
            let result = Bool.count {
                for i in 1...10 {
                    i % 2 == 0
                }
            }
            #expect(result == 5)
        }
    }

    @Suite
    struct `Bool.one (XOR Semantics)` {

        @Test
        func `Exactly one true returns true`() {
            let result = Bool.one {
                false
                true
                false
            }
            #expect(result == true)
        }

        @Test
        func `Multiple true returns false`() {
            let result = Bool.one {
                true
                true
                false
            }
            #expect(result == false)
        }

        @Test
        func `All false returns false`() {
            let result = Bool.one {
                false
                false
                false
            }
            #expect(result == false)
        }

        @Test
        func `Empty block returns false`() {
            let result = Bool.one {
            }
            #expect(result == false)
        }

        @Test
        func `Single true returns true`() {
            let result = Bool.one {
                true
            }
            #expect(result == true)
        }
    }

    @Suite
    struct `Bool.none (NOR Semantics)` {

        @Test
        func `All false returns true`() {
            let result = Bool.none {
                false
                false
                false
            }
            #expect(result == true)
        }

        @Test
        func `Any true returns false`() {
            let result = Bool.none {
                false
                true
                false
            }
            #expect(result == false)
        }

        @Test
        func `Empty block returns true`() {
            let result = Bool.none {
            }
            #expect(result == true)
        }

        @Test
        func `Single false returns true`() {
            let result = Bool.none {
                false
            }
            #expect(result == true)
        }

        @Test
        func `Single true returns false`() {
            let result = Bool.none {
                true
            }
            #expect(result == false)
        }
    }

    @Suite
    struct `Real-World Patterns` {

        @Test
        func `Validation with all`() {
            let username = "john_doe"
            let password = "secret123"
            let age = 25

            let isValid = Bool.all {
                !username.isEmpty
                password.count >= 8
                age >= 18
            }

            #expect(isValid == true)
        }

        @Test
        func `Permission check with any`() {
            let isAdmin = false
            let isOwner = true
            let isPublic = false

            let canAccess = Bool.any {
                isAdmin
                isOwner
                isPublic
            }

            #expect(canAccess == true)
        }

        @Test
        func `Mutual exclusion with one`() {
            let option1 = false
            let option2 = true
            let option3 = false

            let exactlyOneSelected = Bool.one {
                option1
                option2
                option3
            }

            #expect(exactlyOneSelected == true)
        }

        @Test
        func `No errors check with none`() {
            let hasNetworkError = false
            let hasValidationError = false
            let hasTimeout = false

            let noErrors = Bool.none {
                hasNetworkError
                hasValidationError
                hasTimeout
            }

            #expect(noErrors == true)
        }
    }

    @Suite
    struct `Limited Availability` {

        @Test
        func `Limited availability passthrough - all`() {
            let result = Bool.all {
                true
                if #available(macOS 26, iOS 26, *) {
                    true
                }
            }
            #expect(result == true)
        }

        @Test
        func `Limited availability passthrough - any`() {
            let result = Bool.any {
                false
                if #available(macOS 26, iOS 26, *) {
                    true
                }
            }
            #expect(result == true)
        }
    }
}
