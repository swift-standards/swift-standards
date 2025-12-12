import Testing

@testable import StandardLibraryExtensions

@Suite
struct `ContiguousArray.Builder Tests` {

    @Suite
    struct `Basic Construction` {

        @Test
        func `Single element`() {
            let array: ContiguousArray<Int> = ContiguousArray {
                42
            }
            #expect(array == [42])
        }

        @Test
        func `Multiple elements`() {
            let array: ContiguousArray<Int> = ContiguousArray {
                1
                2
                3
            }
            #expect(array == [1, 2, 3])
        }

        @Test
        func `Empty block`() {
            let array: ContiguousArray<Int> = ContiguousArray {
            }
            #expect(array.isEmpty)
        }

        @Test
        func `Mixed elements and arrays`() {
            let array: ContiguousArray<Int> = ContiguousArray {
                1
                [2, 3]
                4
            }
            #expect(array == [1, 2, 3, 4])
        }

        @Test
        func `Nested contiguous arrays`() {
            let nested: ContiguousArray<Int> = [10, 20]
            let array: ContiguousArray<Int> = ContiguousArray {
                1
                nested
                2
            }
            #expect(array == [1, 10, 20, 2])
        }
    }

    @Suite
    struct `Control Flow` {

        @Test
        func `Conditional inclusion - true`() {
            let include = true
            let array: ContiguousArray<Int> = ContiguousArray {
                1
                if include {
                    2
                }
                3
            }
            #expect(array == [1, 2, 3])
        }

        @Test
        func `Conditional inclusion - false`() {
            let include = false
            let array: ContiguousArray<Int> = ContiguousArray {
                1
                if include {
                    2
                }
                3
            }
            #expect(array == [1, 3])
        }

        @Test
        func `If-else first branch`() {
            let condition = true
            let array: ContiguousArray<String> = ContiguousArray {
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
            let array: ContiguousArray<String> = ContiguousArray {
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
            let array: ContiguousArray<Int> = ContiguousArray {
                for i in 1...3 {
                    i * 10
                }
            }
            #expect(array == [10, 20, 30])
        }
    }

    @Suite
    struct `Expression Building` {

        @Test
        func `Optional element - some`() {
            let value: Int? = 42
            let array: ContiguousArray<Int> = ContiguousArray {
                value
            }
            #expect(array == [42])
        }

        @Test
        func `Optional element - none`() {
            let value: Int? = nil
            let array: ContiguousArray<Int> = ContiguousArray {
                value
            }
            #expect(array.isEmpty)
        }

        @Test
        func `Regular array expression`() {
            let array: ContiguousArray<Int> = ContiguousArray {
                [1, 2, 3]
            }
            #expect(array == [1, 2, 3])
        }
    }

    @Suite
    struct `Static Method Tests` {

        @Test
        func `buildExpression single element`() {
            let result = ContiguousArray<Int>.Builder.buildExpression(42)
            #expect(result == [42])
        }

        @Test
        func `buildExpression array`() {
            let result = ContiguousArray<Int>.Builder.buildExpression([1, 2, 3])
            #expect(result == [1, 2, 3])
        }

        @Test
        func `buildPartialBlock first`() {
            let result = ContiguousArray<Int>.Builder.buildPartialBlock(first: [1, 2, 3])
            #expect(result == [1, 2, 3])
        }

        @Test
        func `buildPartialBlock first void`() {
            let result = ContiguousArray<Int>.Builder.buildPartialBlock(first: ())
            #expect(result.isEmpty)
        }

        @Test
        func `buildPartialBlock accumulated`() {
            let result = ContiguousArray<Int>.Builder.buildPartialBlock(
                accumulated: [1, 2],
                next: [3, 4]
            )
            #expect(result == [1, 2, 3, 4])
        }

        @Test
        func `buildOptional some`() {
            let result = ContiguousArray<Int>.Builder.buildOptional([1, 2, 3])
            #expect(result == [1, 2, 3])
        }

        @Test
        func `buildOptional none`() {
            let result = ContiguousArray<Int>.Builder.buildOptional(nil)
            #expect(result.isEmpty)
        }

        @Test
        func `buildArray`() {
            let result = ContiguousArray<Int>.Builder.buildArray([[1, 2], [3, 4]])
            #expect(result == [1, 2, 3, 4])
        }
    }

    @Suite
    struct `Limited Availability` {

        @Test
        func `Limited availability passthrough`() {
            let array: ContiguousArray<Int> = ContiguousArray {
                1
                if #available(macOS 26, iOS 26, *) {
                    2
                }
            }
            #expect(array == [1, 2])
        }
    }
}
