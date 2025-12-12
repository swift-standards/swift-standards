import Testing

@testable import StandardLibraryExtensions

@Suite
struct `Array.Builder Tests` {

    @Suite
    struct `Expression Building` {

        @Test
        func `Single element expression`() {
            let array: [Int] = Array {
                42
            }
            #expect(array == [42])
        }

        @Test
        func `Array expression`() {
            let array: [Int] = Array {
                [1, 2, 3]
            }
            #expect(array == [1, 2, 3])
        }

        @Test
        func `Mixed expressions`() {
            let array: [Int] = Array {
                1
                [2, 3]
                4
            }
            #expect(array == [1, 2, 3, 4])
        }

        @Test
        func `Optional element expression - some`() {
            let value: Int? = 42
            let array: [Int] = Array {
                value
            }
            #expect(array == [42])
        }

        @Test
        func `Optional element expression - none`() {
            let value: Int? = nil
            let array: [Int] = Array {
                value
            }
            #expect(array == [])
        }
    }

    @Suite
    struct `Block Building` {

        @Test
        func `Empty block`() {
            let array: [Int] = Array {
            }
            #expect(array.isEmpty)
        }

        @Test
        func `Single component block`() {
            let array: [String] = Array {
                "hello"
            }
            #expect(array == ["hello"])
        }

        @Test
        func `Multiple component block`() {
            let array: [String] = Array {
                "hello"
                "world"
                "test"
            }
            #expect(array == ["hello", "world", "test"])
        }

        @Test
        func `Nested arrays in block`() {
            let array: [Int] = Array {
                [1, 2]
                [3, 4]
                [5, 6]
            }
            #expect(array == [1, 2, 3, 4, 5, 6])
        }
    }

    @Suite
    struct `Control Flow` {

        @Test
        func `Optional elements - some`() {
            let shouldInclude = true
            let array: [String] = Array {
                "always"
                if shouldInclude {
                    "conditional"
                }
                "end"
            }
            #expect(array == ["always", "conditional", "end"])
        }

        @Test
        func `Optional elements - none`() {
            let shouldInclude = false
            let array: [String] = Array {
                "always"
                if shouldInclude {
                    "conditional"
                }
                "end"
            }
            #expect(array == ["always", "end"])
        }

        @Test
        func `If-else first branch`() {
            let condition = true
            let array: [String] = Array {
                if condition {
                    "first"
                } else {
                    "second"
                }
            }
            #expect(array == ["first"])
        }

        @Test
        func `If-else second branch`() {
            let condition = false
            let array: [String] = Array {
                if condition {
                    "first"
                } else {
                    "second"
                }
            }
            #expect(array == ["second"])
        }

        @Test
        func `For loop`() {
            let array: [Int] = Array {
                for i in 1...3 {
                    i * 2
                }
            }
            #expect(array == [2, 4, 6])
        }

        @Test
        func `Complex for loop with nested arrays`() {
            let array: [Int] = Array {
                0
                for i in 1...2 {
                    [i, i + 10]
                }
                100
            }
            #expect(array == [0, 1, 11, 2, 12, 100])
        }
    }

    @Suite
    struct `Limited Availability` {

        @Test
        func `Limited availability passthrough`() {
            let array: [String] = Array {
                "available"
                if #available(macOS 26, iOS 26, *) {
                    "newer"
                }
            }
            #expect(array.contains("available"))
            #expect(array.contains("newer"))
        }
    }

    @Suite
    struct `Type Inference` {

        @Test
        func `String type inference`() {
            let array = Array {
                "hello"
                "world"
            }
            #expect(array == ["hello", "world"])
        }

        @Test
        func `Int type inference`() {
            let array = Array {
                1
                2
                3
            }
            #expect(array == [1, 2, 3])
        }

        @Test
        func `Mixed numeric types promote to common type`() {
            let array: [Double] = Array {
                1.0
                2.5
                3
            }
            #expect(array == [1.0, 2.5, 3.0])
        }
    }

    @Suite
    struct `Edge Cases` {

        @Test
        func `Deeply nested conditionals`() {
            let a = true
            let b = false
            let c = true

            let array: [String] = Array {
                "start"
                if a {
                    "a-true"
                    if b {
                        "b-true"
                    } else {
                        "b-false"
                        if c {
                            "c-true"
                        }
                    }
                }
                "end"
            }
            #expect(array == ["start", "a-true", "b-false", "c-true", "end"])
        }

        @Test
        func `Empty arrays in builder`() {
            let array: [Int] = Array {
                [1, 2]
                []
                [3, 4]
                []
            }
            #expect(array == [1, 2, 3, 4])
        }

        @Test
        func `Large array construction`() {
            let array: [Int] = Array {
                for i in 1...100 {
                    i
                }
            }
            #expect(array.count == 100)
            #expect(array.first == 1)
            #expect(array.last == 100)
        }

        @Test
        func `Alternating types with Optional`() {
            let array: [Int?] = Array {
                1
                nil
                2
                nil
                3
            }
            #expect(array == [1, nil, 2, nil, 3])
        }
    }

    @Suite
    struct `Static Method Tests` {

        @Test
        func `buildExpression single element`() {
            let result = [Int].Builder.buildExpression(42)
            #expect(result == [42])
        }

        @Test
        func `buildExpression array`() {
            let result = [Int].Builder.buildExpression([1, 2, 3])
            #expect(result == [1, 2, 3])
        }

        @Test
        func `buildExpression optional some`() {
            let value: Int? = 42
            let result = [Int].Builder.buildExpression(value)
            #expect(result == [42])
        }

        @Test
        func `buildExpression optional none`() {
            let value: Int? = nil
            let result = [Int].Builder.buildExpression(value)
            #expect(result == [])
        }

        @Test
        func `buildPartialBlock first`() {
            let result = [Int].Builder.buildPartialBlock(first: [1, 2, 3])
            #expect(result == [1, 2, 3])
        }

        @Test
        func `buildPartialBlock first void`() {
            let result = [Int].Builder.buildPartialBlock(first: ())
            #expect(result == [])
        }

        @Test
        func `buildPartialBlock accumulated`() {
            let result = [Int].Builder.buildPartialBlock(accumulated: [1, 2], next: [3, 4])
            #expect(result == [1, 2, 3, 4])
        }

        @Test
        func `buildOptional some`() {
            let result = [Int].Builder.buildOptional([1, 2, 3])
            #expect(result == [1, 2, 3])
        }

        @Test
        func `buildOptional none`() {
            let result = [Int].Builder.buildOptional(nil)
            #expect(result == [])
        }

        @Test
        func `buildEither first`() {
            let result = [Int].Builder.buildEither(first: [1, 2])
            #expect(result == [1, 2])
        }

        @Test
        func `buildEither second`() {
            let result = [Int].Builder.buildEither(second: [3, 4])
            #expect(result == [3, 4])
        }

        @Test
        func `buildArray`() {
            let result = [Int].Builder.buildArray([[1, 2], [3, 4], [5, 6]])
            #expect(result == [1, 2, 3, 4, 5, 6])
        }

        @Test
        func `buildLimitedAvailability`() {
            let result = [Int].Builder.buildLimitedAvailability([1, 2, 3])
            #expect(result == [1, 2, 3])
        }
    }
}
