// Layout.Grid Tests.swift

import Testing

@testable import Layout

// MARK: - Grid Tests

@Suite
struct `Layout.Grid` {
    @Test
    func `Grid basic creation`() {
        let grid: Layout<Double>.Grid<[[Int]]> = .init(
            spacing: .init(row: 10.0, column: 8.0),
            alignment: .center,
            content: [[1, 2], [3, 4]]
        )

        #expect(grid.spacing.row == 10.0)
        #expect(grid.spacing.column == 8.0)
        #expect(grid.alignment == .center)
    }

    @Test
    func `Grid uniform convenience`() {
        let grid: Layout<Double>.Grid<[[Int]]> = .uniform(
            spacing: 10.0,
            content: [[1, 2], [3, 4]]
        )

        #expect(grid.spacing.row == 10.0)
        #expect(grid.spacing.column == 10.0)
    }

    @Test
    func `Grid default alignment`() {
        let grid: Layout<Double>.Grid<[[Int]]> = .init(
            spacing: .init(row: 10.0, column: 8.0),
            content: [[1, 2], [3, 4]]
        )

        #expect(grid.alignment == .center)
    }

    @Test
    func `Grid Equatable`() {
        let a: Layout<Double>.Grid<[[Int]]> = .uniform(spacing: 10, content: [[1, 2]])
        let b: Layout<Double>.Grid<[[Int]]> = .uniform(spacing: 10, content: [[1, 2]])
        let c: Layout<Double>.Grid<[[Int]]> = .uniform(spacing: 20, content: [[1, 2]])

        #expect(a == b)
        #expect(a != c)
    }

    @Test
    func `Grid map spacing`() throws {
        let grid: Layout<Double>.Grid<[[Int]]> = .uniform(spacing: 10, content: [[1, 2]])

        let mapped: Layout<TestSpacing>.Grid<[[Int]]> = try grid.map.spacing { TestSpacing($0) }
        #expect(mapped.spacing.row == TestSpacing(10))
        #expect(mapped.spacing.column == TestSpacing(10))
    }

    @Test
    func `Grid is Sendable`() {
        let grid: Layout<Double>.Grid<[[Int]]> = .uniform(spacing: 10, content: [[1, 2]])
        let _: any Sendable = grid
    }
}
