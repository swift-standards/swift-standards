import Testing

@testable import StandardLibraryExtensions

@Suite
struct `Dictionary.Builder Tests` {

    @Suite
    struct `Expression Building` {

        @Test
        func `Tuple expression`() {
            let dict: [String: Int] = Dictionary {
                ("key", 42)
            }
            #expect(dict == ["key": 42])
        }

        @Test
        func `Dictionary expression`() {
            let dict: [String: Int] = Dictionary {
                ["a": 1, "b": 2]
            }
            #expect(dict == ["a": 1, "b": 2])
        }

        @Test
        func `Array of tuples expression`() {
            let dict: [String: Int] = Dictionary {
                [("a", 1), ("b", 2), ("c", 3)]
            }
            #expect(dict == ["a": 1, "b": 2, "c": 3])
        }

        @Test
        func `Optional tuple expression - some`() {
            let pair: (String, Int)? = ("key", 42)
            let dict: [String: Int] = Dictionary {
                pair
            }
            #expect(dict == ["key": 42])
        }

        @Test
        func `Optional tuple expression - none`() {
            let pair: (String, Int)? = nil
            let dict: [String: Int] = Dictionary {
                pair
            }
            #expect(dict == [:])
        }
    }

    @Suite
    struct `Basic Construction` {

        @Test
        func `Basic tuple construction`() {
            let dict: [String: String] = Dictionary {
                ("key", "value")
            }
            #expect(dict == ["key": "value"])
        }

        @Test
        func `Multiple tuples`() {
            let dict: [String: Int] = Dictionary {
                ("a", 1)
                ("b", 2)
            }
            #expect(dict == ["a": 1, "b": 2])
        }

        @Test
        func `Dictionary literal construction`() {
            let dict: [String: String] = Dictionary {
                ["host": "localhost"]
            }
            #expect(dict == ["host": "localhost"])
        }

        @Test
        func `Dictionary merging`() {
            let existing = ["a": 1, "b": 2]
            let dict: [String: Int] = Dictionary {
                existing
                ("c", 3)
            }
            #expect(dict == ["a": 1, "b": 2, "c": 3])
        }

        @Test
        func `Empty dictionary`() {
            let dict: [String: Int] = Dictionary {
            }
            #expect(dict == [:])
        }
    }

    @Suite
    struct `Control Flow` {

        @Test
        func `Conditional elements - included`() {
            let includePort = true
            let dict: [String: String] = Dictionary {
                ("host", "localhost")
                if includePort {
                    ("port", "8080")
                }
            }
            #expect(dict == ["host": "localhost", "port": "8080"])
        }

        @Test
        func `Conditional elements - excluded`() {
            let includePort = false
            let dict: [String: String] = Dictionary {
                ("host", "localhost")
                if includePort {
                    ("port", "8080")
                }
            }
            #expect(dict == ["host": "localhost"])
        }

        @Test
        func `If-else first branch`() {
            let useProduction = true
            let dict: [String: String] = Dictionary {
                if useProduction {
                    ("env", "production")
                } else {
                    ("env", "development")
                }
            }
            #expect(dict == ["env": "production"])
        }

        @Test
        func `If-else second branch`() {
            let useProduction = false
            let dict: [String: String] = Dictionary {
                if useProduction {
                    ("env", "production")
                } else {
                    ("env", "development")
                }
            }
            #expect(dict == ["env": "development"])
        }

        @Test
        func `For loop`() {
            let dict: [String: Int] = Dictionary {
                for i in 1...3 {
                    ("key\(i)", i)
                }
            }
            #expect(dict == ["key1": 1, "key2": 2, "key3": 3])
        }
    }

    @Suite
    struct `Key Override Behavior` {

        @Test
        func `Later values override earlier`() {
            let dict: [String: String] = Dictionary {
                ("key", "first")
                ("key", "second")
            }
            #expect(dict == ["key": "second"])
        }

        @Test
        func `Merged dictionaries override`() {
            let dict: [String: Int] = Dictionary {
                ["a": 1, "b": 2]
                ["b": 20, "c": 3]
            }
            #expect(dict == ["a": 1, "b": 20, "c": 3])
        }
    }

    @Suite
    struct `Limited Availability` {

        @Test
        func `Limited availability passthrough`() {
            let dict: [String: String] = Dictionary {
                ("always", "present")
                if #available(macOS 26, iOS 26, *) {
                    ("newer", "feature")
                }
            }
            #expect(dict["always"] == "present")
            #expect(dict["newer"] == "feature")
        }
    }

    @Suite
    struct `Static Method Tests` {

        @Test
        func `buildExpression tuple`() {
            let result = [String: Int].Builder.buildExpression(("key", 42))
            #expect(result == ["key": 42])
        }

        @Test
        func `buildExpression dictionary`() {
            let result = [String: Int].Builder.buildExpression(["a": 1, "b": 2])
            #expect(result == ["a": 1, "b": 2])
        }

        @Test
        func `buildExpression array of tuples`() {
            let result = [String: Int].Builder.buildExpression([("a", 1), ("b", 2)])
            #expect(result == ["a": 1, "b": 2])
        }

        @Test
        func `buildExpression optional tuple some`() {
            let pair: (String, Int)? = ("key", 42)
            let result = [String: Int].Builder.buildExpression(pair)
            #expect(result == ["key": 42])
        }

        @Test
        func `buildExpression optional tuple none`() {
            let pair: (String, Int)? = nil
            let result = [String: Int].Builder.buildExpression(pair)
            #expect(result == [:])
        }

        @Test
        func `buildPartialBlock first`() {
            let result = [String: Int].Builder.buildPartialBlock(first: ["a": 1])
            #expect(result == ["a": 1])
        }

        @Test
        func `buildPartialBlock first void`() {
            let result = [String: Int].Builder.buildPartialBlock(first: ())
            #expect(result == [:])
        }

        @Test
        func `buildPartialBlock accumulated`() {
            let result = [String: Int].Builder.buildPartialBlock(
                accumulated: ["a": 1],
                next: ["b": 2]
            )
            #expect(result == ["a": 1, "b": 2])
        }

        @Test
        func `buildOptional some`() {
            let result = [String: Int].Builder.buildOptional(["a": 1])
            #expect(result == ["a": 1])
        }

        @Test
        func `buildOptional none`() {
            let result = [String: Int].Builder.buildOptional(nil)
            #expect(result == [:])
        }

        @Test
        func `buildEither first`() {
            let result = [String: Int].Builder.buildEither(first: ["a": 1])
            #expect(result == ["a": 1])
        }

        @Test
        func `buildEither second`() {
            let result = [String: Int].Builder.buildEither(second: ["b": 2])
            #expect(result == ["b": 2])
        }

        @Test
        func `buildArray`() {
            let result = [String: Int].Builder.buildArray([
                ["a": 1],
                ["b": 2],
                ["c": 3],
            ])
            #expect(result == ["a": 1, "b": 2, "c": 3])
        }

        @Test
        func `buildLimitedAvailability`() {
            let result = [String: Int].Builder.buildLimitedAvailability(["a": 1])
            #expect(result == ["a": 1])
        }
    }

    @Suite
    struct `Edge Cases` {

        @Test
        func `Large dictionary construction`() {
            let dict: [String: Int] = Dictionary {
                for i in 1...100 {
                    ("key\(i)", i)
                }
            }
            #expect(dict.count == 100)
            #expect(dict["key1"] == 1)
            #expect(dict["key100"] == 100)
        }

        @Test
        func `Mixed types as values`() {
            let dict: [String: Any] = Dictionary {
                ("string", "value" as Any)
                ("int", 42 as Any)
                ("bool", true as Any)
            }
            #expect(dict.count == 3)
        }

        @Test
        func `Nested conditionals`() {
            let a = true
            let b = false

            let dict: [String: String] = Dictionary {
                ("base", "value")
                if a {
                    ("a", "true")
                    if b {
                        ("b", "true")
                    } else {
                        ("b", "false")
                    }
                }
            }
            #expect(dict == ["base": "value", "a": "true", "b": "false"])
        }
    }
}
