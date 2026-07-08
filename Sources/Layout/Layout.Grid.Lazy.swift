// Layout.Grid.Lazy.swift
// A responsive grid that auto-sizes columns based on fractional units.

public import Geometry

extension Layout.Grid {
    /// A grid that sizes columns using fractional units, similar to CSS grid's `fr` unit.
    ///
    /// Unlike `Grid` which arranges content in explicit rows and columns,
    /// `Lazy` flows content into a column template defined by fractional ratios.
    /// Ideal for responsive layouts, card grids, or any content that should
    /// fill available space proportionally.
    ///
    /// ## Example
    ///
    /// ```swift
    /// enum PageSpace {}
    /// typealias PageGrid<C> = Layout<Double, PageSpace>.Grid<C>
    ///
    /// // Two-column layout: first column 1fr, second column 2fr
    /// let twoColumn = PageGrid<[Card]>.Lazy(
    ///     columns: .fractions([1, 2]),
    ///     spacing: .uniform(16.0),
    ///     content: cards
    /// )
    ///
    /// // Three equal columns
    /// let threeEqual = PageGrid<[Item]>.Lazy(
    ///     columns: .count(3),
    ///     spacing: .init(row: 20.0, column: 10.0),
    ///     content: items
    /// )
    ///
    /// // Auto-fill: as many 200pt columns as fit
    /// let autoFill = PageGrid<[Thumbnail]>.Lazy(
    ///     columns: .autoFill(minWidth: 200.0),
    ///     spacing: .uniform(8.0),
    ///     content: thumbnails
    /// )
    /// ```
    public struct Lazy {
        /// Column sizing configuration
        public var columns: Columns

        /// Spacing between rows and columns
        public var spacing: Gaps

        /// Content to arrange in the grid
        public var content: Content

        /// Creates a lazy grid with the specified configuration.
        @inlinable
        public init(
            columns: consuming Columns,
            spacing: consuming Gaps,
            content: consuming Content
        ) {
            self.columns = columns
            self.spacing = spacing
            self.content = content
        }
    }
}

// MARK: - Columns

extension Layout.Grid.Lazy {
    /// Column sizing configuration for lazy grids.
    ///
    /// Defines how columns are sized within the grid container.
    public enum Columns {
        /// Fixed number of equal-width columns.
        ///
        /// Equivalent to CSS: `grid-template-columns: repeat(n, 1fr)`
        case count(Int)

        /// Columns sized by fractional ratios.
        ///
        /// Each value represents a fraction of available space.
        /// `[1, 2, 1]` creates three columns where the middle is twice as wide.
        /// Equivalent to CSS: `grid-template-columns: 1fr 2fr 1fr`
        case fractions([Scalar])

        /// Auto-fill: create as many columns as fit, each at least `minWidth`.
        ///
        /// Empty tracks are preserved even when there's no content.
        /// Equivalent to CSS: `grid-template-columns: repeat(auto-fill, minmax(minWidth, 1fr))`
        case autoFill(minWidth: Scalar)

        /// Auto-fit: create as many columns as fit, collapsing empty tracks.
        ///
        /// Empty tracks collapse to zero width, allowing content to expand.
        /// Equivalent to CSS: `grid-template-columns: repeat(auto-fit, minmax(minWidth, 1fr))`
        case autoFit(minWidth: Scalar)
    }
}

extension Layout.Grid.Lazy.Columns: Sendable where Scalar: Sendable {}
extension Layout.Grid.Lazy.Columns: Equatable where Scalar: Equatable {}
extension Layout.Grid.Lazy.Columns: Hashable where Scalar: Hashable {}
#if !hasFeature(Embedded)
    extension Layout.Grid.Lazy.Columns: Codable where Scalar: Codable {}
#endif

// MARK: - Sendable

extension Layout.Grid.Lazy: Sendable where Scalar: Sendable, Content: Sendable {}

// MARK: - Equatable

extension Layout.Grid.Lazy: Equatable where Scalar: Equatable, Content: Equatable {}

// MARK: - Hashable

extension Layout.Grid.Lazy: Hashable where Scalar: Hashable, Content: Hashable {}

// MARK: - Codable
#if !hasFeature(Embedded)
    extension Layout.Grid.Lazy: Codable where Scalar: Codable, Content: Codable {}
#endif

// MARK: - Convenience Initializers

extension Layout.Grid.Lazy {
    /// Creates a lazy grid with equal-width columns.
    @inlinable
    public static func columns(
        _ count: Int,
        spacing: Layout<Scalar, Space>.Grid<Content>.Gaps,
        content: Content
    ) -> Self {
        Self(columns: .count(count), spacing: spacing, content: content)
    }
}

extension Layout.Grid.Lazy where Scalar: AdditiveArithmetic {
    /// Creates a lazy grid with uniform spacing.
    @inlinable
    public init(
        columns: consuming Columns,
        spacing: Layout<Scalar, Space>.Spacing,
        content: consuming Content
    ) {
        self.init(
            columns: columns,
            spacing: .uniform(spacing),
            content: content
        )
    }

    /// Creates a lazy grid with equal columns and uniform spacing.
    @inlinable
    public static func uniform(
        columns count: Int,
        spacing: Layout<Scalar, Space>.Spacing,
        content: Content
    ) -> Self {
        Self(columns: .count(count), spacing: .uniform(spacing), content: content)
    }
}

// MARK: - Functorial Map

extension Layout.Grid.Lazy {
    /// Returns the functorial transformation namespace for the given lazy grid.
    @inlinable
    public static func map(_ grid: borrowing Layout<Scalar, Space>.Grid<Content>.Lazy) -> Map {
        Map(grid: grid)
    }

    /// Namespace for functorial transformation operations.
    @inlinable
    public var map: Map { Self.map(self) }

    /// Functorial transformation operations for `Lazy`.
    public struct Map {
        @usableFromInline
        let grid: Layout<Scalar, Space>.Grid<Content>.Lazy

        @usableFromInline
        init(grid: borrowing Layout<Scalar, Space>.Grid<Content>.Lazy) {
            self.grid = copy grid
        }
    }
}

extension Layout.Grid.Lazy.Map {
    /// Transforms the content using the given closure.
    @inlinable
    public func content<Result, E: Error>(
        _ transform: (Content) throws(E) -> Result
    ) throws(E) -> Layout<Scalar, Space>.Grid<Result>.Lazy {
        Layout<Scalar, Space>.Grid<Result>.Lazy(
            columns: transformColumns(grid.columns),
            spacing: Layout<Scalar, Space>.Grid<Result>.Gaps(
                row: grid.spacing.row,
                column: grid.spacing.column
            ),
            content: try transform(grid.content)
        )
    }

    @usableFromInline
    func transformColumns<R>(
        _ columns: Layout<Scalar, Space>.Grid<Content>.Lazy.Columns
    ) -> Layout<Scalar, Space>.Grid<R>.Lazy.Columns {
        switch columns {
        case .count(let n):
            return .count(n)
        case .fractions(let f):
            return .fractions(f)
        case .autoFill(let minWidth):
            return .autoFill(minWidth: minWidth)
        case .autoFit(let minWidth):
            return .autoFit(minWidth: minWidth)
        }
    }
}
