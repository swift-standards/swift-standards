import Testing

@testable import StandardLibraryExtensions

@Suite
struct `ClosedRange.Builder Tests` {

    @Suite
    struct `Basic Construction` {

        @Test
        func `Single range`() {
            let ranges = ClosedRange.build {
                1...5
            }
            #expect(ranges == [1...5])
        }

        @Test
        func `Multiple ranges`() {
            let ranges = ClosedRange.build {
                1...5
                10...15
                20...25
            }
            #expect(ranges == [1...5, 10...15, 20...25])
        }

        @Test
        func `Empty block`() {
            let ranges: [ClosedRange<Int>] = ClosedRange.build {
            }
            #expect(ranges.isEmpty)
        }

        @Test
        func `Single value becomes single-element range`() {
            let ranges = ClosedRange.build {
                5
            }
            #expect(ranges == [5...5])
        }

        @Test
        func `Mixed values and ranges`() {
            let ranges = ClosedRange.build {
                1
                3...5
                10
            }
            #expect(ranges == [1...1, 3...5, 10...10])
        }
    }

    @Suite
    struct `Control Flow` {

        @Test
        func `Conditional inclusion - true`() {
            let include = true
            let ranges = ClosedRange.build {
                1...5
                if include {
                    10...15
                }
            }
            #expect(ranges == [1...5, 10...15])
        }

        @Test
        func `Conditional inclusion - false`() {
            let include = false
            let ranges = ClosedRange.build {
                1...5
                if include {
                    10...15
                }
            }
            #expect(ranges == [1...5])
        }

        @Test
        func `If-else first branch`() {
            let condition = true
            let ranges = ClosedRange.build {
                if condition {
                    1...5
                } else {
                    10...15
                }
            }
            #expect(ranges == [1...5])
        }

        @Test
        func `If-else second branch`() {
            let condition = false
            let ranges = ClosedRange.build {
                if condition {
                    1...5
                } else {
                    10...15
                }
            }
            #expect(ranges == [10...15])
        }

        @Test
        func `For loop`() {
            let ranges = ClosedRange.build {
                for i in 0..<3 {
                    (i * 10)...(i * 10 + 5)
                }
            }
            #expect(ranges == [0...5, 10...15, 20...25])
        }
    }

    @Suite
    struct `Expression Building` {

        @Test
        func `Array of ranges`() {
            let existing = [1...5, 10...15]
            let ranges = ClosedRange.build {
                existing
                20...25
            }
            #expect(ranges == [1...5, 10...15, 20...25])
        }
    }

    @Suite
    struct `Static Method Tests` {

        @Test
        func `buildExpression range`() {
            let result = ClosedRange<Int>.Builder.buildExpression(1...5)
            #expect(result == [1...5])
        }

        @Test
        func `buildExpression single value`() {
            let result = ClosedRange<Int>.Builder.buildExpression(5)
            #expect(result == [5...5])
        }

        @Test
        func `buildPartialBlock first`() {
            let result = ClosedRange<Int>.Builder.buildPartialBlock(first: [1...5])
            #expect(result == [1...5])
        }

        @Test
        func `buildPartialBlock first void`() {
            let result = ClosedRange<Int>.Builder.buildPartialBlock(first: ())
            #expect(result.isEmpty)
        }

        @Test
        func `buildPartialBlock accumulated`() {
            let result = ClosedRange<Int>.Builder.buildPartialBlock(
                accumulated: [1...5],
                next: [10...15]
            )
            #expect(result == [1...5, 10...15])
        }

        @Test
        func `buildOptional some`() {
            let result = ClosedRange<Int>.Builder.buildOptional([1...5])
            #expect(result == [1...5])
        }

        @Test
        func `buildOptional none`() {
            let result = ClosedRange<Int>.Builder.buildOptional(nil)
            #expect(result.isEmpty)
        }

        @Test
        func `buildArray`() {
            let result = ClosedRange<Int>.Builder.buildArray([[1...5], [10...15]])
            #expect(result == [1...5, 10...15])
        }
    }

    @Suite
    struct `Different Bound Types` {

        @Test
        func `Double ranges`() {
            let ranges = ClosedRange.build {
                0.0...1.0
                2.0...3.0
            }
            #expect(ranges == [0.0...1.0, 2.0...3.0])
        }

        @Test
        func `Character ranges`() {
            let ranges = ClosedRange.build {
                Character("a")...Character("z")
                Character("A")...Character("Z")
            }
            #expect(ranges.count == 2)
            #expect(ranges[0] == Character("a")...Character("z"))
            #expect(ranges[1] == Character("A")...Character("Z"))
        }
    }

    @Suite
    struct `Limited Availability` {

        @Test
        func `Limited availability passthrough`() {
            let ranges = ClosedRange.build {
                1...5
                if #available(macOS 26, iOS 26, *) {
                    10...15
                }
            }
            #expect(ranges == [1...5, 10...15])
        }
    }
}
