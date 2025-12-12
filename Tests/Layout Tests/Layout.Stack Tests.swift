// Layout.Stack Tests.swift

import Testing

@testable import Geometry
@testable import Layout

// MARK: - Stack Tests

@Suite("Layout.Stack")
struct StackTests {
    @Test("Stack vertical convenience")
    func verticalConvenience() {
        let stack: Layout<Double>.Stack<[Int]> = .vertical(
            spacing: 10.0,
            alignment: .leading,
            content: [1, 2, 3]
        )

        #expect(stack.axis == .secondary)
        #expect(stack.spacing == 10.0)
        #expect(stack.alignment == .leading)
        #expect(stack.content == [1, 2, 3])
    }

    @Test("Stack horizontal convenience")
    func horizontalConvenience() {
        let stack: Layout<Double>.Stack<[Int]> = .horizontal(
            spacing: 8.0,
            alignment: .center,
            content: [1, 2, 3]
        )

        #expect(stack.axis == .primary)
        #expect(stack.spacing == 8.0)
        #expect(stack.alignment == .center)
    }

    @Test("Stack default alignment")
    func defaultAlignment() {
        let stack: Layout<Double>.Stack<[Int]> = .vertical(
            spacing: 10.0,
            content: [1, 2, 3]
        )

        #expect(stack.alignment == .center)
    }

    @Test("Stack with custom spacing type")
    func customSpacingType() {
        let stack: Layout<TestSpacing>.Stack<[String]> = .vertical(
            spacing: TestSpacing(10),
            alignment: .trailing,
            content: ["a", "b", "c"]
        )

        #expect(stack.spacing == TestSpacing(10))
    }

    @Test("Stack Equatable")
    func equatable() {
        let a: Layout<Double>.Stack<[Int]> = .vertical(spacing: 10, content: [1, 2])
        let b: Layout<Double>.Stack<[Int]> = .vertical(spacing: 10, content: [1, 2])
        let c: Layout<Double>.Stack<[Int]> = .vertical(spacing: 20, content: [1, 2])

        #expect(a == b)
        #expect(a != c)
    }

    @Test("Stack map spacing")
    func mapSpacing() throws {
        let stack: Layout<Double>.Stack<[Int]> = .vertical(
            spacing: 10.0,
            content: [1, 2, 3]
        )

        let mapped: Layout<TestSpacing>.Stack<[Int]> = try stack.map.spacing { TestSpacing($0) }
        #expect(mapped.spacing == TestSpacing(10))
        #expect(mapped.content == [1, 2, 3])
    }

    @Test("Stack map content")
    func mapContent() throws {
        let stack: Layout<Double>.Stack<[Int]> = .vertical(
            spacing: 10.0,
            content: [1, 2, 3]
        )

        let mapped: Layout<Double>.Stack<[String]> = try stack.map.content { $0.map { String($0) } }
        #expect(mapped.content == ["1", "2", "3"])
        #expect(mapped.spacing == 10.0)
    }

    @Test("Stack is Sendable")
    func sendable() {
        let stack: Layout<Double>.Stack<[Int]> = .vertical(spacing: 10, content: [1, 2])
        let _: any Sendable = stack
    }

    @Test("Stack is Hashable")
    func hashable() {
        let stack: Layout<Double>.Stack<[Int]> = .vertical(spacing: 10, content: [1, 2])
        var set = Set<Layout<Double>.Stack<[Int]>>()
        set.insert(stack)
        #expect(set.count == 1)
    }
}
