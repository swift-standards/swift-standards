// Layout.Grid.swift
// A two-dimensional arrangement of content in rows and columns.

extension Layout {
    /// A two-dimensional arrangement of content in rows and columns.
    ///
    /// Arranges content in a regular table-like structure with configurable spacing
    /// and alignment. Ideal for data tables, image galleries, form layouts, or any
    /// content requiring precise row/column alignment.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Photo gallery grid
    /// let gallery = Layout<Double>.Grid<[[Photo]]>(
    ///     spacing: .init(row: 16.0, column: 16.0),
    ///     alignment: .center,
    ///     content: photoRows
    /// )
    ///
    /// // Form with uniform spacing
    /// let form = Layout<Double>.Grid<[[Field]]>.uniform(
    ///     spacing: 12.0,
    ///     alignment: .leading,
    ///     content: formRows
    /// )
    /// ```
    public struct Grid<Content> {
        /// Spacing between rows and columns
        public var spacing: Gaps

        /// Alignment within each grid cell
        public var alignment: Alignment

        /// Grid content (typically a 2D array or similar structure)
        public var content: Content

        /// Creates a grid with the specified configuration.
        @inlinable
        public init(
            spacing: consuming Gaps,
            alignment: consuming Alignment,
            content: consuming Content
        ) {
            self.spacing = spacing
            self.alignment = alignment
            self.content = content
        }
    }
}

// MARK: - Gaps

extension Layout.Grid {
    /// Spacing configuration for rows and columns in a grid.
    ///
    /// Separately controls vertical spacing between rows and horizontal spacing
    /// between columns.
    public struct Gaps {
        /// Spacing between rows (vertical gap)
        public var row: Spacing

        /// Spacing between columns (horizontal gap)
        public var column: Spacing

        /// Creates spacing with the specified row and column values.
        @inlinable
        public init(row: Spacing, column: Spacing) {
            self.row = row
            self.column = column
        }
    }
}

extension Layout.Grid.Gaps: Sendable where Spacing: Sendable {}
extension Layout.Grid.Gaps: Equatable where Spacing: Equatable {}
extension Layout.Grid.Gaps: Hashable where Spacing: Hashable {}
#if Codable
    extension Layout.Grid.Gaps: Codable where Spacing: Codable {}
#endif

extension Layout.Grid.Gaps where Spacing: AdditiveArithmetic {
    /// Creates uniform spacing (identical for rows and columns).
    @inlinable
    public static func uniform(_ value: Spacing) -> Self {
        Self(row: value, column: value)
    }
}

// MARK: - Sendable

extension Layout.Grid: Sendable where Spacing: Sendable, Content: Sendable {}

// MARK: - Equatable

extension Layout.Grid: Equatable where Spacing: Equatable, Content: Equatable {}

// MARK: - Hashable

extension Layout.Grid: Hashable where Spacing: Hashable, Content: Hashable {}

// MARK: - Codable
#if Codable
    extension Layout.Grid: Codable where Spacing: Codable, Content: Codable {}
#endif

// MARK: - Convenience Initializers

extension Layout.Grid {
    /// Creates a grid with default center alignment.
    @inlinable
    public init(
        spacing: consuming Gaps,
        content: consuming Content
    ) {
        self.init(
            spacing: spacing,
            alignment: .center,
            content: content
        )
    }
}

extension Layout.Grid where Spacing: AdditiveArithmetic {
    /// Creates a grid with uniform spacing (same for rows and columns).
    @inlinable
    public static func uniform(
        spacing: Spacing,
        alignment: Alignment = .center,
        content: Content
    ) -> Self {
        Self(
            spacing: .uniform(spacing),
            alignment: alignment,
            content: content
        )
    }
}

// MARK: - Functorial Map

extension Layout.Grid {
    /// Creates a grid by transforming the spacing unit of another grid.
    @inlinable
    public init<U, E: Error>(
        transforming other: borrowing Layout<U>.Grid<Content>,
        spacing transform: (U) throws(E) -> Spacing
    ) throws(E) {
        self.init(
            spacing: Gaps(
                row: try transform(other.spacing.row),
                column: try transform(other.spacing.column)
            ),
            alignment: other.alignment,
            content: other.content
        )
    }
}

extension Layout.Grid {
    /// Returns the functorial transformation namespace for the given grid.
    @inlinable
    public static func map(_ grid: Layout<Spacing>.Grid<Content>) -> Map {
        Map(grid: grid)
    }

    /// Namespace for functorial transformation operations.
    @inlinable
    public var map: Map { Self.map(self) }

    /// Functorial transformation operations for `Grid`.
    public struct Map {
        @usableFromInline
        let grid: Layout<Spacing>.Grid<Content>

        @usableFromInline
        init(grid: Layout<Spacing>.Grid<Content>) {
            self.grid = grid
        }

        /// Transforms the spacing type using the given closure.
        @inlinable
        public func spacing<Result, E: Error>(
            _ transform: (Spacing) throws(E) -> Result
        ) throws(E) -> Layout<Result>.Grid<Content> {
            Layout<Result>.Grid<Content>(
                spacing: Layout<Result>.Grid<Content>.Gaps(
                    row: try transform(grid.spacing.row),
                    column: try transform(grid.spacing.column)
                ),
                alignment: grid.alignment,
                content: grid.content
            )
        }

        /// Transforms the content using the given closure.
        @inlinable
        public func content<Result, E: Error>(
            _ transform: (Content) throws(E) -> Result
        ) throws(E) -> Layout<Spacing>.Grid<Result> {
            Layout<Spacing>.Grid<Result>(
                spacing: Layout<Spacing>.Grid<Result>.Gaps(
                    row: grid.spacing.row,
                    column: grid.spacing.column
                ),
                alignment: grid.alignment,
                content: try transform(grid.content)
            )
        }
    }
}
