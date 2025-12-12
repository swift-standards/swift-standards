// Layout.Flow Tests.swift

import Testing

@testable import Layout

// MARK: - Flow Tests

@Suite("Layout.Flow")
struct FlowTests {
    @Test("Flow basic creation")
    func basicCreation() {
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

    @Test("Flow default alignments")
    func defaultAlignments() {
        let flow: Layout<Double>.Flow<[String]> = .init(
            spacing: .init(item: 8.0, line: 12.0),
            content: ["a", "b", "c"]
        )

        #expect(flow.alignment == .leading)
        #expect(flow.line.alignment == .top)
    }

    @Test("Flow uniform convenience")
    func uniformConvenience() {
        let flow: Layout<Double>.Flow<[String]> = .uniform(
            spacing: 10.0,
            content: ["a", "b", "c"]
        )

        #expect(flow.spacing.item == 10.0)
        #expect(flow.spacing.line == 10.0)
    }

    @Test("Flow Equatable")
    func equatable() {
        let a: Layout<Double>.Flow<[String]> = .uniform(spacing: 10, content: ["a"])
        let b: Layout<Double>.Flow<[String]> = .uniform(spacing: 10, content: ["a"])
        let c: Layout<Double>.Flow<[String]> = .uniform(spacing: 20, content: ["a"])

        #expect(a == b)
        #expect(a != c)
    }

    @Test("Flow map spacing")
    func mapSpacing() throws {
        let flow: Layout<Double>.Flow<[String]> = .uniform(spacing: 10, content: ["a"])

        let mapped: Layout<TestSpacing>.Flow<[String]> = try flow.map.spacing { TestSpacing($0) }
        #expect(mapped.spacing.item == TestSpacing(10))
        #expect(mapped.spacing.line == TestSpacing(10))
    }

    @Test("Flow is Sendable")
    func sendable() {
        let flow: Layout<Double>.Flow<[String]> = .uniform(spacing: 10, content: ["a"])
        let _: any Sendable = flow
    }
}

@Suite("Layout.Flow.Line")
struct FlowLineTests {
    @Test("Flow.Line top")
    func top() {
        let line: Layout<Double>.Flow<[String]>.Line = .top
        #expect(line.alignment == .top)
    }

    @Test("Flow.Line center")
    func center() {
        let line: Layout<Double>.Flow<[String]>.Line = .center
        #expect(line.alignment == .center)
    }

    @Test("Flow.Line bottom")
    func bottom() {
        let line: Layout<Double>.Flow<[String]>.Line = .bottom
        #expect(line.alignment == .bottom)
    }
}
