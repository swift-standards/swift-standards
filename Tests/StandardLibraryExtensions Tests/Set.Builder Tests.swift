import Testing

@testable import StandardLibraryExtensions

@Suite
struct `Set.Builder Tests` {

    @Suite
    struct `Expression Building` {

        @Test
        func `Single element expression`() {
            let result = Set<String>.Builder.buildExpression("hello")
            #expect(result == ["hello"])
        }

        @Test
        func `Set expression`() {
            let inputSet: Set<Int> = [1, 2, 3]
            let result = Set<Int>.Builder.buildExpression(inputSet)
            #expect(result == inputSet)
        }

        @Test
        func `Array expression`() {
            let result = Set<Int>.Builder.buildExpression([1, 2, 3, 2, 1])
            #expect(result == [1, 2, 3])
        }

        @Test
        func `Optional element expression - some`() {
            let value: String? = "hello"
            let result = Set<String>.Builder.buildExpression(value)
            #expect(result == ["hello"])
        }

        @Test
        func `Optional element expression - none`() {
            let value: String? = nil
            let result = Set<String>.Builder.buildExpression(value)
            #expect(result == [])
        }
    }

    @Suite
    struct `Partial Block Building` {

        @Test
        func `First set`() {
            let inputSet: Set<Int> = [1, 2, 3]
            let result = Set<Int>.Builder.buildPartialBlock(first: inputSet)
            #expect(result == inputSet)
        }

        @Test
        func `First void`() {
            let result = Set<String>.Builder.buildPartialBlock(first: ())
            #expect(result.isEmpty)
        }

        @Test
        func `Accumulated set and next set`() {
            let accumulated: Set<Int> = [1, 2]
            let next: Set<Int> = [3, 4]
            let result = Set<Int>.Builder.buildPartialBlock(accumulated: accumulated, next: next)
            #expect(result == [1, 2, 3, 4])
        }

        @Test
        func `Overlapping sets merge correctly`() {
            let accumulated: Set<Int> = [1, 2, 3]
            let next: Set<Int> = [3, 4, 5]
            let result = Set<Int>.Builder.buildPartialBlock(accumulated: accumulated, next: next)
            #expect(result == [1, 2, 3, 4, 5])
            #expect(result.count == 5)
        }
    }

    @Suite
    struct `Control Flow` {

        @Test
        func `buildOptional with some set`() {
            let inputSet: Set<String>? = ["conditional"]
            let result = Set<String>.Builder.buildOptional(inputSet)
            #expect(result == ["conditional"])
        }

        @Test
        func `buildOptional with nil set`() {
            let inputSet: Set<String>? = nil
            let result = Set<String>.Builder.buildOptional(inputSet)
            #expect(result.isEmpty)
        }

        @Test
        func `buildEither first branch`() {
            let inputSet: Set<String> = ["first", "option"]
            let result = Set<String>.Builder.buildEither(first: inputSet)
            #expect(result == inputSet)
        }

        @Test
        func `buildEither second branch`() {
            let inputSet: Set<String> = ["second", "option"]
            let result = Set<String>.Builder.buildEither(second: inputSet)
            #expect(result == inputSet)
        }

        @Test
        func `buildArray merges all sets`() {
            let components: [Set<Int>] = [
                [1, 2],
                [3, 4],
                [2, 5],
            ]
            let result = Set<Int>.Builder.buildArray(components)
            #expect(result == [1, 2, 3, 4, 5])
            #expect(result.count == 5)
        }

        @Test
        func `buildLimitedAvailability`() {
            let inputSet: Set<Int> = [1, 2, 3]
            let result = Set<Int>.Builder.buildLimitedAvailability(inputSet)
            #expect(result == inputSet)
        }
    }

    @Suite
    struct `Set Extension Initialization` {

        @Test
        func `Set initialization with elements`() {
            let set = Set {
                "hello"
                "world"
                "hello"
            }
            #expect(set == ["hello", "world"])
            #expect(set.count == 2)
        }

        @Test
        func `Set initialization with mixed elements and sets`() {
            let existingSet: Set<Int> = [2, 3]
            let set = Set {
                1
                existingSet
                4
                existingSet
            }
            #expect(set == [1, 2, 3, 4])
            #expect(set.count == 4)
        }

        @Test
        func `Empty set initialization`() {
            let set = Set<String> {
            }
            #expect(set.isEmpty)
        }

        @Test
        func `Set initialization with conditionals`() {
            let includeExtra = true
            let set = Set {
                "always"
                if includeExtra {
                    "extra"
                }
            }
            #expect(set == ["always", "extra"])
        }

        @Test
        func `Set initialization with for loop`() {
            let set = Set {
                for i in 1...5 {
                    i
                }
            }
            #expect(set == [1, 2, 3, 4, 5])
        }
    }

    @Suite
    struct `Hashable Types Compatibility` {

        @Test
        func `String sets`() {
            let set = Set {
                "apple"
                "banana"
                "apple"
            }
            #expect(set == ["apple", "banana"])
        }

        @Test
        func `Integer sets`() {
            let set = Set {
                1
                2
                3
                1
            }
            #expect(set == [1, 2, 3])
        }

        @Test
        func `Custom hashable type`() {
            struct Person: Hashable {
                let name: String
                let age: Int
            }

            let alice = Person(name: "Alice", age: 30)
            let bob = Person(name: "Bob", age: 25)
            let aliceDuplicate = Person(name: "Alice", age: 30)

            let set = Set {
                alice
                bob
                aliceDuplicate
            }

            #expect(set.count == 2)
            #expect(set.contains(alice))
            #expect(set.contains(bob))
        }

        @Test
        func `Enum sets`() {
            enum Color: String, Hashable, CaseIterable {
                case red, green, blue
            }

            let set = Set {
                Color.red
                Color.green
                Color.blue
                Color.red
            }

            #expect(set == Set(Color.allCases))
            #expect(set.count == 3)
        }
    }

    @Suite
    struct `Edge Cases` {

        @Test
        func `Large set construction`() {
            let components: [Set<Int>] = (0..<100).map { i in
                Set([i, i + 1000])
            }

            let result = Set<Int>.Builder.buildArray(components)

            #expect(result.count == 200)
            #expect(result.contains(0))
            #expect(result.contains(99))
            #expect(result.contains(1000))
            #expect(result.contains(1099))
        }

        @Test
        func `Empty sets in array`() {
            let components: [Set<String>] = [
                ["a"],
                [],
                ["b"],
                [],
                ["c"],
            ]

            let result = Set<String>.Builder.buildArray(components)
            #expect(result == ["a", "b", "c"])
        }

        @Test
        func `All empty sets`() {
            let components: [Set<Int>] = [[], [], []]
            let result = Set<Int>.Builder.buildArray(components)
            #expect(result.isEmpty)
        }

        @Test
        func `Single element repeated`() {
            let components: [Set<String>] = [
                ["same"],
                ["same"],
                ["same"],
            ]

            let result = Set<String>.Builder.buildArray(components)
            #expect(result == ["same"])
            #expect(result.count == 1)
        }

        @Test
        func `Deeply nested conditionals`() {
            let a = true
            let b = false
            let c = true

            let set = Set {
                "start"
                if a {
                    "a"
                    if b {
                        "b"
                    } else {
                        "not-b"
                        if c {
                            "c"
                        }
                    }
                }
                "end"
            }

            #expect(set == ["start", "a", "not-b", "c", "end"])
        }
    }

    @Suite
    struct `Limited Availability` {

        @Test
        func `Limited availability passthrough`() {
            let set = Set {
                "always"
                if #available(macOS 26, iOS 26, *) {
                    "newer"
                }
            }
            #expect(set.contains("always"))
            #expect(set.contains("newer"))
        }
    }
}
