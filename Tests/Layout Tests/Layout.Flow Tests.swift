// Layout.Flow Tests.swift

import Testing

@testable import Layout

// MARK: - Flow Tests

@Suite
struct `Layout.Flow Tests` {
    @Test
    func `Flow basic creation`() {
        let flow: Layout<Double>.Flow<[String]> = .init(
            spacing: .init(item: 8.0, line: 12.0),
            alignment: .leading,
            line: .top,
            content: ["a", "b", "c"]
        )

        #expect(flow.spacing.item == 8.0)
        #expect(flow.spacing.line == 12.0)
        #expect(flow.alignment == .leading)
        #expect(flow.line.alignment == .top)
    }

    @Test
    func `Flow default alignments`() {
        let flow: Layout<Double>.Flow<[String]> = .init(
            spacing: .init(item: 8.0, line: 12.0),
            content: ["a", "b", "c"]
        )

        #expect(flow.alignment == .leading)
        #expect(flow.line.alignment == .top)
    }

    @Test
    func `Flow uniform convenience`() {
        let flow: Layout<Double>.Flow<[String]> = .uniform(
            spacing: 10.0,
            content: ["a", "b", "c"]
        )

        #expect(flow.spacing.item == 10.0)
        #expect(flow.spacing.line == 10.0)
    }

    @Test
    func `Flow Equatable`() {
        let a: Layout<Double>.Flow<[String]> = .uniform(spacing: 10, content: ["a"])
        let b: Layout<Double>.Flow<[String]> = .uniform(spacing: 10, content: ["a"])
        let c: Layout<Double>.Flow<[String]> = .uniform(spacing: 20, content: ["a"])

        #expect(a == b)
        #expect(a != c)
    }

    @Test
    func `Flow map spacing`() throws {
        let flow: Layout<Double>.Flow<[String]> = .uniform(spacing: 10, content: ["a"])

        let mapped: Layout<TestSpacing>.Flow<[String]> = try flow.map.spacing { TestSpacing($0) }
        #expect(mapped.spacing.item == TestSpacing(10))
        #expect(mapped.spacing.line == TestSpacing(10))
    }

    @Test
    func `Flow is Sendable`() {
        let flow: Layout<Double>.Flow<[String]> = .uniform(spacing: 10, content: ["a"])
        let _: any Sendable = flow
    }
}

@Suite
struct `Layout.Flow.Line` {
    @Test
    func `Flow.Line top`() {
        let line: Layout<Double>.Flow<[String]>.Line = .top
        #expect(line.alignment == .top)
    }

    @Test
    func `Flow.Line center`() {
        let line: Layout<Double>.Flow<[String]>.Line = .center
        #expect(line.alignment == .center)
    }

    @Test
    func `Flow.Line bottom`() {
        let line: Layout<Double>.Flow<[String]>.Line = .bottom
        #expect(line.alignment == .bottom)
    }
}
