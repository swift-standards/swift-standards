import Testing

@testable import StandardLibraryExtensions

@Suite
struct `Range.Builder Tests` {

    @Suite
    struct `Basic Construction` {

        @Test
        func `Single range`() {
            let ranges = Range.build {
                0..<5
            }
            #expect(ranges == [0..<5])
        }

        @Test
        func `Multiple ranges`() {
            let ranges = Range.build {
                0..<5
                10..<15
                20..<25
            }
            #expect(ranges == [0..<5, 10..<15, 20..<25])
        }

        @Test
        func `Empty block`() {
            let ranges: [Range<Int>] = Range.build {
            }
            #expect(ranges.isEmpty)
        }
    }

    @Suite
    struct `Control Flow` {

        @Test
        func `Conditional inclusion - true`() {
            let include = true
            let ranges = Range.build {
                0..<5
                if include {
                    10..<15
                }
            }
            #expect(ranges == [0..<5, 10..<15])
        }

        @Test
        func `Conditional inclusion - false`() {
            let include = false
            let ranges = Range.build {
                0..<5
                if include {
                    10..<15
                }
            }
            #expect(ranges == [0..<5])
        }

        @Test
        func `If-else first branch`() {
            let condition = true
            let ranges = Range.build {
                if condition {
                    0..<5
                } else {
                    10..<15
                }
            }
            #expect(ranges == [0..<5])
        }

        @Test
        func `If-else second branch`() {
            let condition = false
            let ranges = Range.build {
                if condition {
                    0..<5
                } else {
                    10..<15
                }
            }
            #expect(ranges == [10..<15])
        }

        @Test
        func `For loop`() {
            let ranges = Range.build {
                for i in 0..<3 {
                    (i * 10)..<(i * 10 + 5)
                }
            }
            #expect(ranges == [0..<5, 10..<15, 20..<25])
        }
    }

    @Suite
    struct `Expression Building` {

        @Test
        func `Array of ranges`() {
            let existing = [0..<5, 10..<15]
            let ranges = Range.build {
                existing
                20..<25
            }
            #expect(ranges == [0..<5, 10..<15, 20..<25])
        }
    }

    @Suite
    struct `Static Method Tests` {

        @Test
        func `buildExpression range`() {
            let result = Range<Int>.Builder.buildExpression(0..<5)
            #expect(result == [0..<5])
        }

        @Test
        func `buildPartialBlock first`() {
            let result = Range<Int>.Builder.buildPartialBlock(first: [0..<5])
            #expect(result == [0..<5])
        }

        @Test
        func `buildPartialBlock first void`() {
            let result = Range<Int>.Builder.buildPartialBlock(first: ())
            #expect(result.isEmpty)
        }

        @Test
        func `buildPartialBlock accumulated`() {
            let result = Range<Int>.Builder.buildPartialBlock(accumulated: [0..<5], next: [10..<15])
            #expect(result == [0..<5, 10..<15])
        }

        @Test
        func `buildOptional some`() {
            let result = Range<Int>.Builder.buildOptional([0..<5])
            #expect(result == [0..<5])
        }

        @Test
        func `buildOptional none`() {
            let result = Range<Int>.Builder.buildOptional(nil)
            #expect(result.isEmpty)
        }

        @Test
        func `buildArray`() {
            let result = Range<Int>.Builder.buildArray([[0..<5], [10..<15]])
            #expect(result == [0..<5, 10..<15])
        }
    }

    @Suite
    struct `Different Bound Types` {

        @Test
        func `Double ranges`() {
            let ranges = Range.build {
                0.0..<1.0
                2.0..<3.0
            }
            #expect(ranges == [0.0..<1.0, 2.0..<3.0])
        }

        @Test
        func `String Index ranges`() {
            let str = "Hello, World!"
            let ranges = Range.build {
                str.startIndex..<str.index(str.startIndex, offsetBy: 5)
            }
            #expect(ranges.count == 1)
        }
    }

    @Suite
    struct `Limited Availability` {

        @Test
        func `Limited availability passthrough`() {
            let ranges = Range.build {
                0..<5
                if #available(macOS 26, iOS 26, *) {
                    10..<15
                }
            }
            #expect(ranges == [0..<5, 10..<15])
        }
    }
}
