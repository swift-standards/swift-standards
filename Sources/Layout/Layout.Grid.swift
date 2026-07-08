// Layout.Grid.swift
// A two-dimensional arrangement of content in rows and columns.

public import Geometry

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
    /// enum PageSpace {}
    ///
    /// // Photo gallery grid
    /// let gallery = Layout<Double, PageSpace>.Grid<[[Photo]]>(
    ///     spacing: .init(row: 16.0, column: 16.0),
    ///     alignment: .center,
    ///     content: photoRows
    /// )
    ///
    /// // Form with uniform spacing
    /// let form = Layout<Double, PageSpace>.Grid<[[Field]]>.uniform(
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
    /// Uses dimensionally-typed spacing: `Height` for vertical row gaps,
    /// `Width` for horizontal column gaps.
    public struct Gaps {
        /// Spacing between rows (vertical gap)
        public var row: Layout.Height

        /// Spacing between columns (horizontal gap)
        public var column: Layout.Width

        /// Creates spacing with the specified row and column values.
        @inlinable
        public init(row: Layout.Height, column: Layout.Width) {
            self.row = row
            self.column = column
        }
    }
}

extension Layout.Grid.Gaps: Sendable where Scalar: Sendable {}
extension Layout.Grid.Gaps: Equatable where Scalar: Equatable {}
extension Layout.Grid.Gaps: Hashable where Scalar: Hashable {}
#if !hasFeature(Embedded)
    extension Layout.Grid.Gaps: Codable where Scalar: Codable {}
#endif

extension Layout.Grid.Gaps where Scalar: AdditiveArithmetic {
    /// Creates uniform spacing (identical magnitude for rows and columns).
    @inlinable
    public static func uniform(_ value: Layout.Spacing) -> Self {
        Self(row: value.height, column: value.width)
    }
}

// MARK: - Sendable

extension Layout.Grid: Sendable where Scalar: Sendable, Content: Sendable {}

// MARK: - Equatable

extension Layout.Grid: Equatable where Scalar: Equatable, Content: Equatable {}

// MARK: - Hashable

extension Layout.Grid: Hashable where Scalar: Hashable, Content: Hashable {}

// MARK: - Codable
#if !hasFeature(Embedded)
    extension Layout.Grid: Codable where Scalar: Codable, Content: Codable {}
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

extension Layout.Grid where Scalar: AdditiveArithmetic {
    /// Creates a grid with uniform spacing (same magnitude for rows and columns).
    @inlinable
    public static func uniform(
        spacing: Layout.Spacing,
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
    /// Returns the functorial transformation namespace for the given grid.
    @inlinable
    public static func map(_ grid: borrowing Layout<Scalar, Space>.Grid<Content>) -> Map {
        Map(grid: grid)
    }

    /// Namespace for functorial transformation operations.
    @inlinable
    public var map: Map { Self.map(self) }

    /// Functorial transformation operations for `Grid`.
    public struct Map {
        @usableFromInline
        let grid: Layout<Scalar, Space>.Grid<Content>

        @usableFromInline
        init(grid: borrowing Layout<Scalar, Space>.Grid<Content>) {
            self.grid = copy grid
        }
    }
}

extension Layout.Grid.Map {
    /// Transforms the content using the given closure.
    @inlinable
    public func content<Result, E: Error>(
        _ transform: (Content) throws(E) -> Result
    ) throws(E) -> Layout<Scalar, Space>.Grid<Result> {
        Layout<Scalar, Space>.Grid<Result>(
            spacing: Layout<Scalar, Space>.Grid<Result>.Gaps(
                row: grid.spacing.row,
                column: grid.spacing.column
            ),
            alignment: grid.alignment,
            content: try transform(grid.content)
        )
    }
}
