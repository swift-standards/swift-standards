import Testing

@testable import StandardLibraryExtensions

@Suite
struct `Result.Builder Tests` {

    enum TestError: Error, Equatable {
        case first
        case second
        case third
    }

    @Suite
    struct `Result.Builder (First Success)` {

        @Test
        func `Returns first success`() {
            let result: Result<Int, TestError> = Result.first {
                Result<Int, TestError>.failure(.first)
                Result<Int, TestError>.success(42)
                Result<Int, TestError>.success(100)
            }

            #expect(result == .success(42))
        }

        @Test
        func `Returns last failure when all fail`() {
            let result: Result<Int, TestError> = Result.first {
                Result<Int, TestError>.failure(.first)
                Result<Int, TestError>.failure(.second)
                Result<Int, TestError>.failure(.third)
            }

            #expect(result == .failure(.third))
        }

        @Test
        func `Direct success value`() {
            let result: Result<Int, TestError> = Result.first {
                42
            }

            #expect(result == .success(42))
        }

        @Test
        func `If-else first branch`() {
            let condition = true
            let result: Result<String, TestError> = Result.first {
                if condition {
                    Result<String, TestError>.success("first")
                } else {
                    Result<String, TestError>.success("second")
                }
            }

            #expect(result == .success("first"))
        }

        @Test
        func `If-else second branch`() {
            let condition = false
            let result: Result<String, TestError> = Result.first {
                if condition {
                    Result<String, TestError>.success("first")
                } else {
                    Result<String, TestError>.success("second")
                }
            }

            #expect(result == .success("second"))
        }
    }

    @Suite
    struct `Result.AllBuilder (Collect All)` {

        @Test
        func `Collects all successes`() {
            let result: Result<[Int], TestError> = Result.all {
                Result<Int, TestError>.success(1)
                Result<Int, TestError>.success(2)
                Result<Int, TestError>.success(3)
            }

            #expect(result == .success([1, 2, 3]))
        }

        @Test
        func `Fails on first error`() {
            let result: Result<[Int], TestError> = Result.all {
                Result<Int, TestError>.success(1)
                Result<Int, TestError>.failure(.second)
                Result<Int, TestError>.success(3)
            }

            #expect(result == .failure(.second))
        }

        @Test
        func `Empty block returns empty array`() {
            let result: Result<[Int], TestError> = Result.all {
            }

            #expect(result == .success([]))
        }

        @Test
        func `Direct values are wrapped`() {
            let result: Result<[Int], TestError> = Result.all {
                1
                2
                3
            }

            #expect(result == .success([1, 2, 3]))
        }

        @Test
        func `For loop collects all`() {
            let result: Result<[Int], TestError> = Result.all {
                for i in 1...3 {
                    Result<Int, TestError>.success(i * 10)
                }
            }

            #expect(result == .success([10, 20, 30]))
        }

        @Test
        func `For loop fails on error`() {
            let result: Result<[Int], TestError> = Result.all {
                for i in 1...3 {
                    if i == 2 {
                        Result<Int, TestError>.failure(.second)
                    } else {
                        Result<Int, TestError>.success(i * 10)
                    }
                }
            }

            #expect(result == .failure(.second))
        }

        @Test
        func `Conditional inclusion - some`() {
            let include = true
            let result: Result<[Int], TestError> = Result.all {
                Result<Int, TestError>.success(1)
                if include {
                    Result<Int, TestError>.success(2)
                }
                Result<Int, TestError>.success(3)
            }

            #expect(result == .success([1, 2, 3]))
        }

        @Test
        func `Conditional inclusion - none`() {
            let include = false
            let result: Result<[Int], TestError> = Result.all {
                Result<Int, TestError>.success(1)
                if include {
                    Result<Int, TestError>.success(2)
                }
                Result<Int, TestError>.success(3)
            }

            #expect(result == .success([1, 3]))
        }
    }

    @Suite
    struct `Static Method Tests` {

        @Test
        func `buildExpression success value`() {
            let result = Result<Int, TestError>.Builder.First.buildExpression(42)
            #expect(result == .success(42))
        }

        @Test
        func `buildExpression result passthrough`() {
            let input = Result<Int, TestError>.failure(.first)
            let result = Result<Int, TestError>.Builder.First.buildExpression(input)
            #expect(result == .failure(.first))
        }

        @Test
        func `buildPartialBlock accumulated success keeps success`() {
            let result = Result<Int, TestError>.Builder.First.buildPartialBlock(
                accumulated: .success(42),
                next: .success(100)
            )
            #expect(result == .success(42))
        }

        @Test
        func `buildPartialBlock accumulated failure tries next`() {
            let result = Result<Int, TestError>.Builder.First.buildPartialBlock(
                accumulated: .failure(.first),
                next: .success(100)
            )
            #expect(result == .success(100))
        }

        @Test
        func `buildEither first`() {
            let result = Result<Int, TestError>.Builder.First.buildEither(first: .success(42))
            #expect(result == .success(42))
        }

        @Test
        func `buildEither second`() {
            let result = Result<Int, TestError>.Builder.First.buildEither(second: .failure(.second))
            #expect(result == .failure(.second))
        }
    }

    @Suite
    struct `Limited Availability` {

        @Test
        func `Limited availability passthrough - first`() {
            let result: Result<Int, TestError> = Result.first {
                Result<Int, TestError>.failure(.first)
                if #available(macOS 26, iOS 26, *) {
                    Result<Int, TestError>.success(42)
                }
            }
            #expect(result == .success(42))
        }

        @Test
        func `Limited availability passthrough - all`() {
            let result: Result<[Int], TestError> = Result.all {
                Result<Int, TestError>.success(1)
                if #available(macOS 26, iOS 26, *) {
                    Result<Int, TestError>.success(2)
                }
            }
            #expect(result == .success([1, 2]))
        }
    }
}
