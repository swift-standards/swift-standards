import Testing

@testable import StandardLibraryExtensions

@Suite
struct `CollectionOfOne.Builder Tests` {

    @Suite
    struct `Basic Construction` {

        @Test
        func `Single element`() {
            let collection: CollectionOfOne<Int> = CollectionOfOne {
                42
            }
            #expect(collection.first == 42)
            #expect(collection.count == 1)
        }

        @Test
        func `Single string element`() {
            let collection: CollectionOfOne<String> = CollectionOfOne {
                "Hello"
            }
            #expect(collection.first == "Hello")
        }
    }

    @Suite
    struct `Control Flow` {

        @Test
        func `If-else first branch`() {
            let condition = true
            let collection: CollectionOfOne<String> = CollectionOfOne {
                if condition {
                    "first"
                } else {
                    "second"
                }
            }
            #expect(collection.first == "first")
        }

        @Test
        func `If-else second branch`() {
            let condition = false
            let collection: CollectionOfOne<String> = CollectionOfOne {
                if condition {
                    "first"
                } else {
                    "second"
                }
            }
            #expect(collection.first == "second")
        }

        @Test
        func `Nested if-else`() {
            let a = false
            let b = true

            let collection: CollectionOfOne<String> = CollectionOfOne {
                if a {
                    "a"
                } else {
                    if b {
                        "b"
                    } else {
                        "c"
                    }
                }
            }
            #expect(collection.first == "b")
        }
    }

    @Suite
    struct `Static Method Tests` {

        @Test
        func `buildExpression`() {
            let result = CollectionOfOne<Int>.Builder.buildExpression(42)
            #expect(result == 42)
        }

        @Test
        func `buildBlock`() {
            let result = CollectionOfOne<Int>.Builder.buildBlock(42)
            #expect(result == 42)
        }

        @Test
        func `buildEither first`() {
            let result = CollectionOfOne<Int>.Builder.buildEither(first: 42)
            #expect(result == 42)
        }

        @Test
        func `buildEither second`() {
            let result = CollectionOfOne<Int>.Builder.buildEither(second: 100)
            #expect(result == 100)
        }

        @Test
        func `buildFinalResult`() {
            let result = CollectionOfOne<Int>.Builder.buildFinalResult(42)
            #expect(result.first == 42)
            #expect(result.count == 1)
        }
    }

    @Suite
    struct `Collection Conformance` {

        @Test
        func `Iteration`() {
            let collection: CollectionOfOne<Int> = CollectionOfOne {
                42
            }

            var values: [Int] = []
            for value in collection {
                values.append(value)
            }

            #expect(values == [42])
        }

        @Test
        func `Count is always one`() {
            let collection: CollectionOfOne<String> = CollectionOfOne {
                "value"
            }
            #expect(collection.count == 1)
        }

        @Test
        func `isEmpty is always false`() {
            let collection: CollectionOfOne<Int> = CollectionOfOne {
                0
            }
            #expect(collection.isEmpty == false)
        }

        @Test
        func `First and last are same`() {
            let collection: CollectionOfOne<Int> = CollectionOfOne {
                42
            }
            #expect(collection.first == collection.last)
        }
    }

    @Suite
    struct `Real-World Patterns` {

        @Test
        func `Configuration value selection`() {
            let isDebug = false

            let config: CollectionOfOne<String> = CollectionOfOne {
                if isDebug {
                    "debug-endpoint"
                } else {
                    "production-endpoint"
                }
            }

            #expect(config.first == "production-endpoint")
        }

        @Test
        func `Default value selection`() {
            let hasCustomValue = true
            let customValue = 100

            let value: CollectionOfOne<Int> = CollectionOfOne {
                if hasCustomValue {
                    customValue
                } else {
                    42
                }
            }

            #expect(value.first == 100)
        }
    }

    @Suite
    struct `Limited Availability` {

        @Test
        func `Limited availability passthrough`() {
            let collection: CollectionOfOne<Int> = CollectionOfOne {
                if #available(macOS 26, iOS 26, *) {
                    42
                } else {
                    0
                }
            }
            #expect(collection.first == 42)
        }
    }
}
