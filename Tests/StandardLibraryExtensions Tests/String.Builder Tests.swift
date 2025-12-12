import Testing

@testable import StandardLibraryExtensions

@Suite
struct `String.Builder Tests` {

    @Suite
    struct `Expression Building` {

        @Test
        func `String expression`() {
            let result = String.Builder.buildExpression("Hello")
            #expect(result == "Hello")
        }

        @Test
        func `Optional string expression - some`() {
            let value: String? = "Hello"
            let result = String.Builder.buildExpression(value)
            #expect(result == "Hello")
        }

        @Test
        func `Optional string expression - none`() {
            let value: String? = nil
            let result = String.Builder.buildExpression(value)
            #expect(result.isEmpty)
        }
    }

    @Suite
    struct `Basic String Building` {

        @Test
        func `Single string`() {
            let result = String {
                "Hello World"
            }
            #expect(result == "Hello World")
        }

        @Test
        func `Multiple strings joined with newlines`() {
            let result = String {
                "First line"
                "Second line"
                "Third line"
            }
            #expect(result == "First line\nSecond line\nThird line")
        }

        @Test
        func `Empty string building`() {
            let result = String {
                ""
            }
            #expect(result.isEmpty)
        }

        @Test
        func `Empty block`() {
            let result = String {
            }
            #expect(result.isEmpty)
        }
    }

    @Suite
    struct `Control Flow` {

        @Test
        func `Conditional strings - if true`() {
            let includeGreeting = true
            let result = String {
                if includeGreeting {
                    "Hello"
                } else {
                    "Goodbye"
                }
                "World"
            }
            #expect(result == "Hello\nWorld")
        }

        @Test
        func `Conditional strings - if false`() {
            let includeGreeting = false
            let result = String {
                if includeGreeting {
                    "Hello"
                } else {
                    "Goodbye"
                }
                "World"
            }
            #expect(result == "Goodbye\nWorld")
        }

        @Test
        func `Optional strings - some`() {
            let optionalLine: String? = "Optional content"
            let result = String {
                "Start"
                if let line = optionalLine {
                    line
                }
                "End"
            }
            #expect(result == "Start\nOptional content\nEnd")
        }

        @Test
        func `Optional strings - none`() {
            let optionalLine: String? = nil
            let result = String {
                "Start"
                if let line = optionalLine {
                    line
                }
                "End"
            }
            #expect(result == "Start\n\nEnd")
        }

        @Test
        func `For loop string building`() {
            let result = String {
                "Header"
                for i in 1...3 {
                    "Item \(i)"
                }
                "Footer"
            }
            #expect(result == "Header\nItem 1\nItem 2\nItem 3\nFooter")
        }
    }

    @Suite
    struct `Real-World Usage Patterns` {

        @Test
        func `Building configuration text`() {
            let debugMode = true
            let version = "1.0.0"

            let config = String {
                "Application Configuration"
                "Version: \(version)"
                if debugMode {
                    "Debug Mode: Enabled"
                    "Log Level: Verbose"
                } else {
                    "Debug Mode: Disabled"
                    "Log Level: Error"
                }
                "Status: Ready"
            }

            let expected = """
                Application Configuration
                Version: 1.0.0
                Debug Mode: Enabled
                Log Level: Verbose
                Status: Ready
                """
            #expect(config == expected)
        }

        @Test
        func `Building error messages`() {
            let errors = ["Invalid input", "Missing field", "Timeout occurred"]

            let errorReport = String {
                "Error Report:"
                "============"
                for error in errors {
                    "• \(error)"
                }
                "Total errors: \(errors.count)"
            }

            let expected = """
                Error Report:
                ============
                • Invalid input
                • Missing field
                • Timeout occurred
                Total errors: 3
                """
            #expect(errorReport == expected)
        }

        @Test
        func `Building formatted output`() {
            let items = ["Apple", "Banana", "Cherry"]
            let showNumbers = true

            let output = String {
                "Item List:"
                "---------"
                for (index, item) in items.enumerated() {
                    if showNumbers {
                        "\(index + 1). \(item)"
                    } else {
                        "- \(item)"
                    }
                }
            }

            let expected = """
                Item List:
                ---------
                1. Apple
                2. Banana
                3. Cherry
                """
            #expect(output == expected)
        }
    }

    @Suite
    struct `Edge Cases` {

        @Test
        func `Empty strings in builder`() {
            let result = String {
                "Start"
                ""
                "Middle"
                ""
                "End"
            }
            #expect(result == "Start\n\nMiddle\n\nEnd")
        }

        @Test
        func `Nested conditionals`() {
            let condition1 = true
            let condition2 = false

            let result = String {
                "Begin"
                if condition1 {
                    "Condition 1 is true"
                    if condition2 {
                        "Condition 2 is also true"
                    } else {
                        "But condition 2 is false"
                    }
                }
                "End"
            }

            let expected = """
                Begin
                Condition 1 is true
                But condition 2 is false
                End
                """
            #expect(result == expected)
        }

        @Test
        func `Large string building`() {
            let result = String {
                "Large String Test"
                for i in 1...100 {
                    "Line \(i)"
                }
                "End of large string"
            }

            let lines = result.split(separator: "\n", omittingEmptySubsequences: false)
            #expect(lines.count == 102)
            #expect(lines.first == "Large String Test")
            #expect(lines.last == "End of large string")
            #expect(lines[1] == "Line 1")
            #expect(lines[100] == "Line 100")
        }

        @Test
        func `Special characters and unicode`() {
            let result = String {
                "Special Characters Test"
                "Emoji: 🚀 🎉 ✨"
                "Unicode: áéíóú ñ"
                "Symbols: @#$%^&*()"
                "Quotes: \"Hello\" 'World'"
            }

            #expect(result.contains("🚀"))
            #expect(result.contains("áéíóú"))
            #expect(result.contains("\"Hello\""))
        }
    }

    @Suite
    struct `Static Method Tests` {

        @Test
        func `buildPartialBlock first`() {
            let result = String.Builder.buildPartialBlock(first: "First string")
            #expect(result == "First string")
        }

        @Test
        func `buildPartialBlock first void`() {
            let result = String.Builder.buildPartialBlock(first: ())
            #expect(result.isEmpty)
        }

        @Test
        func `buildPartialBlock accumulated and next`() {
            let result = String.Builder.buildPartialBlock(accumulated: "First", next: "Second")
            #expect(result == "First\nSecond")
        }

        @Test
        func `buildPartialBlock accumulated empty and next`() {
            let result = String.Builder.buildPartialBlock(accumulated: "", next: "Second")
            #expect(result == "Second")
        }

        @Test
        func `buildEither first`() {
            let result = String.Builder.buildEither(first: "First option")
            #expect(result == "First option")
        }

        @Test
        func `buildEither second`() {
            let result = String.Builder.buildEither(second: "Second option")
            #expect(result == "Second option")
        }

        @Test
        func `buildOptional with value`() {
            let result = String.Builder.buildOptional("Some value")
            #expect(result == "Some value")
        }

        @Test
        func `buildOptional with nil`() {
            let result = String.Builder.buildOptional(nil)
            #expect(result.isEmpty)
        }

        @Test
        func `buildArray`() {
            let components = ["Line 1", "Line 2", "Line 3"]
            let result = String.Builder.buildArray(components)
            #expect(result == "Line 1\nLine 2\nLine 3")
        }

        @Test
        func `buildArray with empty array`() {
            let result = String.Builder.buildArray([])
            #expect(result.isEmpty)
        }

        @Test
        func `buildLimitedAvailability`() {
            let result = String.Builder.buildLimitedAvailability("Available content")
            #expect(result == "Available content")
        }
    }

    @Suite
    struct `Limited Availability` {

        @Test
        func `Limited availability passthrough`() {
            let result = String {
                "Always present"
                if #available(macOS 26, iOS 26, *) {
                    "Newer feature"
                }
            }
            #expect(result.contains("Always present"))
            #expect(result.contains("Newer feature"))
        }
    }
}
