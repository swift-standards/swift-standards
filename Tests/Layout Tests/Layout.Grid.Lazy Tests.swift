// Layout.Grid.Lazy Tests.swift
// Tests for Layout.Grid.Lazy

import Geometry
import Testing

@testable import Layout

@Suite("Layout.Grid.Lazy")
struct LazyGridTests {
    typealias TestLayout = Layout<Double, Void>
    typealias TestGrid<C> = TestLayout.Grid<C>

    // MARK: - Initialization

    @Test
    func `Lazy grid initializes with count columns`() {
        let grid = TestGrid<[String]>.Lazy(
            columns: .count(3),
            spacing: .init(row: 10, column: 20),
            content: ["a", "b", "c"]
        )

        if case .count(let n) = grid.columns {
            #expect(n == 3)
        } else {
            Issue.record("Expected .count columns")
        }
        #expect(grid.spacing.row == 10)
        #expect(grid.spacing.column == 20)
        #expect(grid.content == ["a", "b", "c"])
    }

    @Test
    func `Lazy grid initializes with fractional columns`() {
        let grid = TestGrid<[Int]>.Lazy(
            columns: .fractions([1, 2, 1]),
            spacing: .init(row: 5, column: 5),
            content: [1, 2, 3, 4]
        )

        if case .fractions(let f) = grid.columns {
            #expect(f == [1, 2, 1])
        } else {
            Issue.record("Expected .fractions columns")
        }
    }

    @Test
    func `Lazy grid initializes with autoFill`() {
        let grid = TestGrid<[String]>.Lazy(
            columns: .autoFill(minWidth: 200),
            spacing: .init(row: 10, column: 10),
            content: ["item"]
        )

        if case .autoFill(let minWidth) = grid.columns {
            #expect(minWidth == 200)
        } else {
            Issue.record("Expected .autoFill columns")
        }
    }

    @Test
    func `Lazy grid initializes with autoFit`() {
        let grid = TestGrid<[String]>.Lazy(
            columns: .autoFit(minWidth: 150),
            spacing: .init(row: 8, column: 8),
            content: ["item"]
        )

        if case .autoFit(let minWidth) = grid.columns {
            #expect(minWidth == 150)
        } else {
            Issue.record("Expected .autoFit columns")
        }
    }

    // MARK: - Convenience Initializers

    @Test
    func `Lazy grid with uniform spacing`() {
        let grid = TestGrid<[String]>.Lazy(
            columns: .count(2),
            spacing: 16.0,
            content: ["a", "b"]
        )

        #expect(grid.spacing.row == 16)
        #expect(grid.spacing.column == 16)
    }

    @Test
    func `Lazy grid factory method`() {
        let grid = TestGrid<[String]>.Lazy.columns(
            4,
            spacing: .init(row: 10, column: 10),
            content: ["a", "b", "c", "d"]
        )

        if case .count(let n) = grid.columns {
            #expect(n == 4)
        } else {
            Issue.record("Expected .count columns")
        }
    }

    @Test
    func `Lazy grid uniform factory`() {
        let grid = TestGrid<[String]>.Lazy.uniform(
            columns: 3,
            spacing: 12.0,
            content: ["a", "b", "c"]
        )

        if case .count(let n) = grid.columns {
            #expect(n == 3)
        } else {
            Issue.record("Expected .count columns")
        }
        #expect(grid.spacing.row == 12)
        #expect(grid.spacing.column == 12)
    }

    // MARK: - Functorial Map

    @Test
    func `Lazy grid content map`() throws {
        let grid = TestGrid<[Int]>.Lazy(
            columns: .count(2),
            spacing: .init(row: 10, column: 10),
            content: [1, 2, 3]
        )

        let mapped: TestGrid<[String]>.Lazy = try grid.map.content { items in
            items.map { String($0) }
        }

        #expect(mapped.content == ["1", "2", "3"])
        if case .count(let n) = mapped.columns {
            #expect(n == 2)
        }
        #expect(mapped.spacing.row == 10)
    }

    // MARK: - Protocol Conformances

    @Test("Lazy grid is Equatable")
    func equatable() {
        let grid1 = TestGrid<[String]>.Lazy(
            columns: .count(2),
            spacing: .init(row: 10, column: 10),
            content: ["a", "b"]
        )
        let grid2 = TestGrid<[String]>.Lazy(
            columns: .count(2),
            spacing: .init(row: 10, column: 10),
            content: ["a", "b"]
        )
        let grid3 = TestGrid<[String]>.Lazy(
            columns: .count(3),
            spacing: .init(row: 10, column: 10),
            content: ["a", "b"]
        )

        #expect(grid1 == grid2)
        #expect(grid1 != grid3)
    }

    @Test("Lazy grid is Hashable")
    func hashable() {
        let grid = TestGrid<[String]>.Lazy(
            columns: .count(2),
            spacing: .init(row: 10, column: 10),
            content: ["a", "b"]
        )

        var set = Set<TestGrid<[String]>.Lazy>()
        set.insert(grid)
        #expect(set.contains(grid))
    }
}
