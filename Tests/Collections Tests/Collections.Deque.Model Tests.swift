// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-standards open source project
//
// Copyright (c) 2024-2025 Coen ten Thije Boonkkamp and the swift-standards project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

import Testing
@testable import StandardsCollections

@Suite("Collections.Deque - Model Tests")
struct DequeModelTests {

    @Test("Simple push and pop")
    func simplePushAndPop() throws {
        var deque = Collections.Deque<Int>()

        deque.push.back(1)
        deque.push.back(2)
        deque.push.back(3)

        #expect(deque.count == 3)

        let a = try deque.pop.back()
        #expect(a == 3)

        let b = try deque.pop.back()
        #expect(b == 2)

        let c = try deque.pop.back()
        #expect(c == 1)

        #expect(deque.isEmpty)
    }

    @Test("Front and back operations")
    func frontAndBackOperations() throws {
        var deque = Collections.Deque<Int>()

        deque.push.front(1)
        deque.push.back(2)
        deque.push.front(0)

        #expect(Array(deque) == [0, 1, 2])

        let front = try deque.pop.front()
        #expect(front == 0)

        let back = try deque.pop.back()
        #expect(back == 2)

        #expect(deque.count == 1)
        #expect(deque.peek.front == 1)
        #expect(deque.peek.back == 1)
    }

    @Test("Iteration matches array")
    func iterationMatchesArray() {
        var deque = Collections.Deque<Int>()
        var array: [Int] = []

        for i in 0..<20 {
            deque.push.back(i)
            array.append(i)
        }

        #expect(Array(deque) == array)
    }

    @Test("Interleaved operations")
    func interleavedOperations() throws {
        var deque = Collections.Deque<Int>()
        var array: [Int] = []

        // Build up
        for i in 0..<10 {
            if i % 2 == 0 {
                deque.push.back(i)
                array.append(i)
            } else {
                deque.push.front(i)
                array.insert(i, at: 0)
            }
        }

        #expect(Array(deque) == array)

        // Drain
        while !deque.isEmpty {
            let dequeValue = try deque.pop.front()
            let arrayValue = array.removeFirst()
            #expect(dequeValue == arrayValue)
        }
    }
}
