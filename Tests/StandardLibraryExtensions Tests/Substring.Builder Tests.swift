import Testing

@testable import StandardLibraryExtensions

@Suite
struct `Substring.Builder Tests` {

    @Suite
    struct `Basic Construction` {

        @Test
        func `Single substring`() {
            let result: Substring = Substring {
                "Hello"
            }
            #expect(result == "Hello")
        }

        @Test
        func `Multiple substrings joined with newlines`() {
            let result: Substring = Substring {
                "First"
                "Second"
                "Third"
            }
            #expect(result == "First\nSecond\nThird")
        }

        @Test
        func `Empty block`() {
            let result: Substring = Substring {
            }
            #expect(result.isEmpty)
        }

        @Test
        func `Empty string`() {
            let result: Substring = Substring {
                ""
            }
            #expect(result.isEmpty)
        }

        @Test
        func `Mixed String and Substring`() {
            let sub: Substring = "World"
            let result: Substring = Substring {
                "Hello"
                sub
            }
            #expect(result == "Hello\nWorld")
        }
    }

    @Suite
    struct `Control Flow` {

        @Test
        func `Conditional inclusion - true`() {
            let include = true
            let result: Substring = Substring {
                "Start"
                if include {
                    "Middle"
                }
                "End"
            }
            #expect(result == "Start\nMiddle\nEnd")
        }

        @Test
        func `Conditional inclusion - false`() {
            let include = false
            let result: Substring = Substring {
                "Start"
                if include {
                    "Middle"
                }
                "End"
            }
            #expect(result == "Start\n\nEnd")
        }

        @Test
        func `If-else first branch`() {
            let condition = true
            let result: Substring = Substring {
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
            let result: Substring = Substring {
                if condition {
                    "first"
                } else {
                    "second"
                }
            }
            #expect(result == "second")
        }

        @Test
        func `For loop`() {
            let result: Substring = Substring {
                for i in 1...3 {
                    "Line \(i)"
                }
            }
            #expect(result == "Line 1\nLine 2\nLine 3")
        }
    }

    @Suite
    struct `Expression Building` {

        @Test
        func `Optional Substring - some`() {
            let value: Substring? = "Hello"
            let result: Substring = Substring {
                value
            }
            #expect(result == "Hello")
        }

        @Test
        func `Optional Substring - none`() {
            let value: Substring? = nil
            let result: Substring = Substring {
                value
            }
            #expect(result.isEmpty)
        }

        @Test
        func `Optional String - some`() {
            let value: String? = "Hello"
            let result: Substring = Substring {
                value
            }
            #expect(result == "Hello")
        }

        @Test
        func `Optional String - none`() {
            let value: String? = nil
            let result: Substring = Substring {
                value
            }
            #expect(result.isEmpty)
        }
    }

    @Suite
    struct `Static Method Tests` {

        @Test
        func `buildExpression Substring`() {
            let result = Substring.Builder.buildExpression(Substring("Hello"))
            #expect(result == "Hello")
        }

        @Test
        func `buildExpression String`() {
            let result = Substring.Builder.buildExpression("Hello")
            #expect(result == "Hello")
        }

        @Test
        func `buildPartialBlock first`() {
            let result = Substring.Builder.buildPartialBlock(first: "Hello")
            #expect(result == "Hello")
        }

        @Test
        func `buildPartialBlock first void`() {
            let result = Substring.Builder.buildPartialBlock(first: ())
            #expect(result.isEmpty)
        }

        @Test
        func `buildPartialBlock accumulated`() {
            let result = Substring.Builder.buildPartialBlock(accumulated: "First", next: "Second")
            #expect(result == "First\nSecond")
        }

        @Test
        func `buildPartialBlock accumulated empty`() {
            let result = Substring.Builder.buildPartialBlock(accumulated: "", next: "Second")
            #expect(result == "Second")
        }

        @Test
        func `buildOptional some`() {
            let result = Substring.Builder.buildOptional("Hello")
            #expect(result == "Hello")
        }

        @Test
        func `buildOptional none`() {
            let result = Substring.Builder.buildOptional(nil)
            #expect(result.isEmpty)
        }

        @Test
        func `buildArray`() {
            let result = Substring.Builder.buildArray(["First", "Second", "Third"])
            #expect(result == "First\nSecond\nThird")
        }

        @Test
        func `buildFinalResult`() {
            let result = Substring.Builder.buildFinalResult("Hello")
            #expect(result == "Hello")
            #expect(type(of: result) == Substring.self)
        }
    }

    @Suite
    struct `Limited Availability` {

        @Test
        func `Limited availability passthrough`() {
            let result: Substring = Substring {
                "Always"
                if #available(macOS 26, iOS 26, *) {
                    "Newer"
                }
            }
            #expect(result.contains("Always"))
            #expect(result.contains("Newer"))
        }
    }
}
