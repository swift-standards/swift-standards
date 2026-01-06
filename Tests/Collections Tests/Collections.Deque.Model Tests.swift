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

    /// Reference model using Array for comparison.
    struct ArrayModel<Element> {
        var elements: [Element] = []

        var count: Int { elements.count }
        var isEmpty: Bool { elements.isEmpty }

        mutating func pushBack(_ element: Element) {
            elements.append(element)
        }

        mutating func pushFront(_ element: Element) {
            elements.insert(element, at: 0)
        }

        mutating func popBack() -> Element? {
            elements.isEmpty ? nil : elements.removeLast()
        }

        mutating func popFront() -> Element? {
            elements.isEmpty ? nil : elements.removeFirst()
        }

        func peekBack() -> Element? {
            elements.last
        }

        func peekFront() -> Element? {
            elements.first
        }

        subscript(index: Int) -> Element {
            elements[index]
        }
    }

    // MARK: - Basic Operations

    @Test("Push back matches model")
    func pushBackMatchesModel() {
        var deque = Collections.Deque<Int>()
        var model = ArrayModel<Int>()

        for i in 0..<500 {
            deque.push.back(i)
            model.pushBack(i)
        }

        #expect(deque.count == model.count)
        #expect(Array(deque) == model.elements)
    }

    @Test("Push front matches model")
    func pushFrontMatchesModel() {
        var deque = Collections.Deque<Int>()
        var model = ArrayModel<Int>()

        for i in 0..<500 {
            deque.push.front(i)
            model.pushFront(i)
        }

        #expect(deque.count == model.count)
        #expect(Array(deque) == model.elements)
    }

    @Test("Pop back matches model")
    func popBackMatchesModel() throws {
        var deque = Collections.Deque(0..<500)
        var model = ArrayModel<Int>()
        for i in 0..<500 { model.pushBack(i) }

        for _ in 0..<250 {
            let d = try deque.pop.back()
            let m = model.popBack()
            #expect(d == m)
        }

        #expect(deque.count == model.count)
        #expect(Array(deque) == model.elements)
    }

    @Test("Pop front matches model")
    func popFrontMatchesModel() throws {
        var deque = Collections.Deque(0..<500)
        var model = ArrayModel<Int>()
        for i in 0..<500 { model.pushBack(i) }

        for _ in 0..<250 {
            let d = try deque.pop.front()
            let m = model.popFront()
            #expect(d == m)
        }

        #expect(deque.count == model.count)
        #expect(Array(deque) == model.elements)
    }

    // MARK: - Mixed Operations

    @Test("Mixed push operations")
    func mixedPushOperations() {
        var deque = Collections.Deque<Int>()
        var model = ArrayModel<Int>()

        // Alternating pattern
        for i in 0..<500 {
            if i % 2 == 0 {
                deque.push.back(i)
                model.pushBack(i)
            } else {
                deque.push.front(i)
                model.pushFront(i)
            }
        }

        #expect(Array(deque) == model.elements)
    }

    @Test("Mixed pop operations")
    func mixedPopOperations() throws {
        var deque = Collections.Deque(0..<500)
        var model = ArrayModel<Int>()
        for i in 0..<500 { model.pushBack(i) }

        // Alternating pop pattern
        for i in 0..<250 {
            if i % 2 == 0 {
                let d = try deque.pop.front()
                let m = model.popFront()
                #expect(d == m)
            } else {
                let d = try deque.pop.back()
                let m = model.popBack()
                #expect(d == m)
            }
        }

        #expect(Array(deque) == model.elements)
    }

    // MARK: - Index Access

    @Test("Index access matches model")
    func indexAccessMatchesModel() {
        let deque = Collections.Deque(0..<500)
        var model = ArrayModel<Int>()
        for i in 0..<500 { model.pushBack(i) }

        for i in 0..<500 {
            #expect(deque[i] == model[i])
        }
    }

    // MARK: - Iteration

    @Test("Forward iteration matches model")
    func forwardIterationMatchesModel() {
        let deque = Collections.Deque(0..<500)
        var model = ArrayModel<Int>()
        for i in 0..<500 { model.pushBack(i) }

        var dequeElements: [Int] = []
        for element in deque {
            dequeElements.append(element)
        }

        #expect(dequeElements == model.elements)
    }

    @Test("Reverse iteration matches model")
    func reverseIterationMatchesModel() {
        let deque = Collections.Deque(0..<500)
        var model = ArrayModel<Int>()
        for i in 0..<500 { model.pushBack(i) }

        let reversedDeque = Array(deque.reversed())
        let reversedModel = Array(model.elements.reversed())

        #expect(reversedDeque == reversedModel)
    }

    // MARK: - Edge Cases

    @Test("Empty deque operations")
    func emptyDequeOperations() {
        let deque = Collections.Deque<Int>()
        let model = ArrayModel<Int>()

        #expect(deque.isEmpty == model.isEmpty)
        #expect(deque.count == model.count)
        #expect(deque.peek.front == model.peekFront())
        #expect(deque.peek.back == model.peekBack())
    }

    @Test("Single element operations")
    func singleElementOperations() throws {
        var deque = Collections.Deque<Int>()
        var model = ArrayModel<Int>()

        deque.push.back(42)
        model.pushBack(42)

        #expect(deque.count == 1)
        #expect(deque.peek.front == model.peekFront())
        #expect(deque.peek.back == model.peekBack())

        let d = try deque.pop.back()
        let m = model.popBack()
        #expect(d == m)
        #expect(deque.isEmpty)
    }

    @Test("Ring buffer wraparound via init and pop/push cycle")
    func ringBufferWraparound() throws {
        // Start with 100 elements
        var deque = Collections.Deque(0..<100)
        var model = ArrayModel<Int>()
        for i in 0..<100 { model.pushBack(i) }

        // Pop from front and push to back 500 times - tests ring buffer wraparound
        for i in 100..<600 {
            _ = try deque.pop.front()
            _ = model.popFront()
            deque.push.back(i)
            model.pushBack(i)
        }

        #expect(deque.count == model.count)
        #expect(Array(deque) == model.elements)
    }

    // MARK: - Large Capacity via Init

    @Test("Large deque via init from sequence")
    func largeDequeViaInit() {
        let deque = Collections.Deque(0..<1000)
        var model = ArrayModel<Int>()
        for i in 0..<1000 { model.pushBack(i) }

        #expect(deque.count == model.count)
        #expect(deque.count == 1000)

        // Spot check
        #expect(deque[0] == model[0])
        #expect(deque[500] == model[500])
        #expect(deque[999] == model[999])

        // Iteration
        #expect(Array(deque) == model.elements)
    }
}
