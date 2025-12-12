import Testing

@testable import StandardLibraryExtensions

@Suite
struct `Optional.Builder Tests` {

    @Suite
    struct `Basic Coalescing` {

        @Test
        func `First non-nil value is returned`() {
            let a: Int? = nil
            let b: Int? = 42
            let c: Int? = 100

            let result = Optional.first {
                a
                b
                c
            }

            #expect(result == 42)
        }

        @Test
        func `Returns nil when all values are nil`() {
            let a: Int? = nil
            let b: Int? = nil
            let c: Int? = nil

            let result = Optional.first {
                a
                b
                c
            }

            #expect(result == nil)
        }

        @Test
        func `Single non-nil value`() {
            let result = Optional.first {
                42
            }

            #expect(result == 42)
        }

        @Test
        func `Single nil value`() {
            let value: String? = nil
            let result = Optional.first {
                value
            }

            #expect(result == nil)
        }

        @Test
        func `Empty block returns nil`() {
            let result: Int? = Optional.first {
            }

            #expect(result == nil)
        }
    }

    @Suite
    struct `Control Flow` {

        @Test
        func `Conditional inclusion - true branch`() {
            let useFirst = true
            let result = Optional.first {
                if useFirst {
                    42
                }
            }

            #expect(result == 42)
        }

        @Test
        func `Conditional inclusion - false branch`() {
            let useFirst = false
            let result: Int? = Optional.first {
                if useFirst {
                    42
                }
            }

            #expect(result == nil)
        }

        @Test
        func `If-else first branch`() {
            let condition = true
            let result = Optional.first {
                if condition {
                    "first"
                } else {
                    "second"
                }
            }

            #expect(result == "first")
        }

        @Test
        func `If-else second branch`() {
            let condition = false
            let result = Optional.first {
                if condition {
                    "first"
                } else {
                    "second"
                }
            }

            #expect(result == "second")
        }

        @Test
        func `For loop - first match wins`() {
            let values: [Int?] = [nil, nil, 42, 100]
            let result = Optional.first {
                for value in values {
                    value
                }
            }

            #expect(result == 42)
        }

        @Test
        func `For loop - all nil`() {
            let values: [Int?] = [nil, nil, nil]
            let result = Optional.first {
                for value in values {
                    value
                }
            }

            #expect(result == nil)
        }
    }

    @Suite
    struct `Expression Building` {

        @Test
        func `Non-optional expression is wrapped`() {
            let result = Optional.first {
                42
            }

            #expect(result == 42)
        }

        @Test
        func `Optional expression passes through`() {
            let value: Int? = 42
            let result = Optional.first {
                value
            }

            #expect(result == 42)
        }
    }

    @Suite
    struct `Static Method Tests` {

        @Test
        func `buildPartialBlock first`() {
            let result = Int?.Builder.buildPartialBlock(first: 42)
            #expect(result == 42)
        }

        @Test
        func `buildPartialBlock first void`() {
            let result = Int?.Builder.buildPartialBlock(first: ())
            #expect(result == nil)
        }

        @Test
        func `buildPartialBlock accumulated with first non-nil`() {
            let result = Int?.Builder.buildPartialBlock(accumulated: 42, next: 100)
            #expect(result == 42)
        }

        @Test
        func `buildPartialBlock accumulated with first nil`() {
            let result = Int?.Builder.buildPartialBlock(accumulated: nil, next: 100)
            #expect(result == 100)
        }

        @Test
        func `buildOptional some`() {
            let inner: Int? = 42
            let result = Int?.Builder.buildOptional(inner)
            #expect(result == 42)
        }

        @Test
        func `buildOptional none`() {
            let result = Int?.Builder.buildOptional(nil)
            #expect(result == nil)
        }

        @Test
        func `buildArray first non-nil`() {
            let components: [Int?] = [nil, 42, 100]
            let result = Int?.Builder.buildArray(components)
            #expect(result == 42)
        }

        @Test
        func `buildArray all nil`() {
            let components: [Int?] = [nil, nil, nil]
            let result = Int?.Builder.buildArray(components)
            #expect(result == nil)
        }
    }

    @Suite
    struct `Real-World Patterns` {

        @Test
        func `Fallback chain pattern`() {
            let cached: String? = nil
            let computed: String? = nil
            let defaultValue = "default"

            let result = Optional.first {
                cached
                computed
                defaultValue
            }

            #expect(result == "default")
        }

        @Test
        func `Configuration lookup pattern`() {
            let envVar: String? = nil
            let configFile: String? = "from-config"
            let hardcoded = "hardcoded"

            let result = Optional.first {
                envVar
                configFile
                hardcoded
            }

            #expect(result == "from-config")
        }
    }

    @Suite
    struct `Limited Availability` {

        @Test
        func `Limited availability passthrough`() {
            let result = Optional.first {
                if #available(macOS 26, iOS 26, *) {
                    42
                }
            }
            #expect(result == 42)
        }
    }
}
