import Testing

@testable import StandardLibraryExtensions

@Suite
struct `ArraySlice.Builder Tests` {

    @Suite
    struct `Basic Construction` {

        @Test
        func `Single element`() {
            let slice: ArraySlice<Int> = ArraySlice {
                42
            }
            #expect(Array(slice) == [42])
        }

        @Test
        func `Multiple elements`() {
            let slice: ArraySlice<Int> = ArraySlice {
                1
                2
                3
            }
            #expect(Array(slice) == [1, 2, 3])
        }

        @Test
        func `Empty block`() {
            let slice: ArraySlice<Int> = ArraySlice {
            }
            #expect(slice.isEmpty)
        }

        @Test
        func `Mixed elements and arrays`() {
            let slice: ArraySlice<Int> = ArraySlice {
                1
                [2, 3]
                4
            }
            #expect(Array(slice) == [1, 2, 3, 4])
        }

        @Test
        func `Nested slices`() {
            let nested: ArraySlice<Int> = [10, 20]
            let slice: ArraySlice<Int> = ArraySlice {
                1
                nested
                2
            }
            #expect(Array(slice) == [1, 10, 20, 2])
        }
    }

    @Suite
    struct `Control Flow` {

        @Test
        func `Conditional inclusion - true`() {
            let include = true
            let slice: ArraySlice<Int> = ArraySlice {
                1
                if include {
                    2
                }
                3
            }
            #expect(Array(slice) == [1, 2, 3])
        }

        @Test
        func `Conditional inclusion - false`() {
            let include = false
            let slice: ArraySlice<Int> = ArraySlice {
                1
                if include {
                    2
                }
                3
            }
            #expect(Array(slice) == [1, 3])
        }

        @Test
        func `If-else first branch`() {
            let condition = true
            let slice: ArraySlice<String> = ArraySlice {
                if condition {
                    "first"
                } else {
                    "second"
                }
            }
            #expect(Array(slice) == ["first"])
        }

        @Test
        func `If-else second branch`() {
            let condition = false
            let slice: ArraySlice<String> = ArraySlice {
                if condition {
                    "first"
                } else {
                    "second"
                }
            }
            #expect(Array(slice) == ["second"])
        }

        @Test
        func `For loop`() {
            let slice: ArraySlice<Int> = ArraySlice {
                for i in 1...3 {
                    i * 10
                }
            }
            #expect(Array(slice) == [10, 20, 30])
        }
    }

    @Suite
    struct `Expression Building` {

        @Test
        func `Optional element - some`() {
            let value: Int? = 42
            let slice: ArraySlice<Int> = ArraySlice {
                value
            }
            #expect(Array(slice) == [42])
        }

        @Test
        func `Optional element - none`() {
            let value: Int? = nil
            let slice: ArraySlice<Int> = ArraySlice {
                value
            }
            #expect(slice.isEmpty)
        }

        @Test
        func `Regular array expression`() {
            let slice: ArraySlice<Int> = ArraySlice {
                [1, 2, 3]
            }
            #expect(Array(slice) == [1, 2, 3])
        }
    }

    @Suite
    struct `Static Method Tests` {

        @Test
        func `buildExpression single element`() {
            let result = ArraySlice<Int>.Builder.buildExpression(42)
            #expect(result == [42])
        }

        @Test
        func `buildExpression array`() {
            let result = ArraySlice<Int>.Builder.buildExpression([1, 2, 3])
            #expect(result == [1, 2, 3])
        }

        @Test
        func `buildPartialBlock first`() {
            let result = ArraySlice<Int>.Builder.buildPartialBlock(first: [1, 2, 3])
            #expect(result == [1, 2, 3])
        }

        @Test
        func `buildPartialBlock first void`() {
            let result = ArraySlice<Int>.Builder.buildPartialBlock(first: ())
            #expect(result.isEmpty)
        }

        @Test
        func `buildPartialBlock accumulated`() {
            let result = ArraySlice<Int>.Builder.buildPartialBlock(
                accumulated: [1, 2],
                next: [3, 4]
            )
            #expect(result == [1, 2, 3, 4])
        }

        @Test
        func `buildOptional some`() {
            let result = ArraySlice<Int>.Builder.buildOptional([1, 2, 3])
            #expect(result == [1, 2, 3])
        }

        @Test
        func `buildOptional none`() {
            let result = ArraySlice<Int>.Builder.buildOptional(nil)
            #expect(result.isEmpty)
        }

        @Test
        func `buildArray`() {
            let result = ArraySlice<Int>.Builder.buildArray([[1, 2], [3, 4]])
            #expect(result == [1, 2, 3, 4])
        }

        @Test
        func `buildFinalResult`() {
            let result = ArraySlice<Int>.Builder.buildFinalResult([1, 2, 3])
            #expect(Array(result) == [1, 2, 3])
            #expect(type(of: result) == ArraySlice<Int>.self)
        }
    }

    @Suite
    struct `Limited Availability` {

        @Test
        func `Limited availability passthrough`() {
            let slice: ArraySlice<Int> = ArraySlice {
                1
                if #available(macOS 26, iOS 26, *) {
                    2
                }
            }
            #expect(Array(slice) == [1, 2])
        }
    }
}
