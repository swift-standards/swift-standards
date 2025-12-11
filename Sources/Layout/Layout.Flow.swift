// Layout.Flow.swift
// A wrapping layout that flows content to the next line when full.

public import Dimension

extension Layout {
    /// A wrapping layout that reflows content to the next line when space runs out.
    ///
    /// Arranges items horizontally until the container width is exhausted, then
    /// wraps to a new line. Ideal for tag clouds, toolbar items that overflow,
    /// or responsive content that adapts to container width. Similar to CSS flexbox
    /// with `flex-wrap: wrap`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Tag cloud with wrapping
    /// let tags = Layout<Double>.Flow<[Tag]>(
    ///     spacing: .init(item: 8.0, line: 12.0),
    ///     alignment: .leading,
    ///     line: .top,
    ///     content: ["Swift", "Concurrency", "Performance", ...]
    /// )
    /// // Renders as:
    /// // [Swift] [Concurrency] [Performance]
    /// // [Memory] [Safety]
    /// ```
    public struct Flow<Content> {
        /// Spacing between items and between lines
        public var spacing: Gaps

        /// Horizontal alignment of items within each line
        public var alignment: Horizontal.Alignment

        /// Vertical alignment of lines within the container
        public var line: Line

        /// Content to arrange
        public var content: Content

        /// Creates a flow layout with the specified configuration.
        @inlinable
        public init(
            spacing: consuming Gaps,
            alignment: consuming Horizontal.Alignment,
            line: consuming Line,
            content: consuming Content
        ) {
            self.spacing = spacing
            self.alignment = alignment
            self.line = line
            self.content = content
        }
    }
}

// MARK: - Gaps

extension Layout.Flow {
    /// Spacing configuration for horizontal and vertical gaps in a flow layout.
    ///
    /// Separately controls spacing between items on the same line (horizontal)
    /// and spacing between lines (vertical).
    public struct Gaps {
        /// Spacing between items on the same line (horizontal gap)
        public var item: Spacing

        /// Spacing between lines (vertical gap)
        public var line: Spacing

        /// Creates spacing with the specified item and line values.
        @inlinable
        public init(item: Spacing, line: Spacing) {
            self.item = item
            self.line = line
        }
    }
}

extension Layout.Flow.Gaps: Sendable where Spacing: Sendable {}
extension Layout.Flow.Gaps: Equatable where Spacing: Equatable {}
extension Layout.Flow.Gaps: Hashable where Spacing: Hashable {}
#if Codable
    extension Layout.Flow.Gaps: Codable where Spacing: Codable {}
#endif

extension Layout.Flow.Gaps where Spacing: AdditiveArithmetic {
    /// Creates uniform spacing (identical for items and lines).
    @inlinable
    public static func uniform(_ value: Spacing) -> Self {
        Self(item: value, line: value)
    }
}

// MARK: - Line

extension Layout.Flow {
    /// Line configuration controlling vertical alignment in a flow layout.
    public struct Line: Sendable, Hashable, Codable {
        /// Vertical alignment of wrapped lines within the container
        public var alignment: Vertical.Alignment

        /// Creates line configuration with the specified alignment.
        @inlinable
        public init(alignment: Vertical.Alignment) {
            self.alignment = alignment
        }
    }
}

extension Layout.Flow.Line {
    /// Aligns lines to the top of the container
    @inlinable
    public static var top: Self { Self(alignment: .top) }

    /// Centers lines vertically within the container
    @inlinable
    public static var center: Self { Self(alignment: .center) }

    /// Aligns lines to the bottom of the container
    @inlinable
    public static var bottom: Self { Self(alignment: .bottom) }
}

// MARK: - Sendable

extension Layout.Flow: Sendable where Spacing: Sendable, Content: Sendable {}

// MARK: - Equatable

extension Layout.Flow: Equatable where Spacing: Equatable, Content: Equatable {}

// MARK: - Hashable

extension Layout.Flow: Hashable where Spacing: Hashable, Content: Hashable {}

// MARK: - Codable
#if Codable
    extension Layout.Flow: Codable where Spacing: Codable, Content: Codable {}
#endif

// MARK: - Convenience Initializers

extension Layout.Flow {
    /// Creates a flow layout with default alignments (leading, top).
    @inlinable
    public init(
        spacing: consuming Gaps,
        content: consuming Content
    ) {
        self.init(
            spacing: spacing,
            alignment: .leading,
            line: .top,
            content: content
        )
    }
}

extension Layout.Flow where Spacing: AdditiveArithmetic {
    /// Creates a flow layout with uniform spacing (same for items and lines).
    @inlinable
    public static func uniform(
        spacing: Spacing,
        alignment: Horizontal.Alignment = .leading,
        content: Content
    ) -> Self {
        Self(
            spacing: .uniform(spacing),
            alignment: alignment,
            line: .top,
            content: content
        )
    }
}

// MARK: - Functorial Map

extension Layout.Flow {
    /// Creates a flow by transforming the spacing unit of another flow.
    @inlinable
    public init<U, E: Error>(
        transforming other: borrowing Layout<U>.Flow<Content>,
        spacing transform: (U) throws(E) -> Spacing
    ) throws(E) {
        self.init(
            spacing: Gaps(
                item: try transform(other.spacing.item),
                line: try transform(other.spacing.line)
            ),
            alignment: other.alignment,
            line: Line(alignment: other.line.alignment),
            content: other.content
        )
    }
}

extension Layout.Flow {
    /// Namespace for functorial transformation operations.
    @inlinable
    public var map: Map { Map(flow: self) }

    /// Functorial transformation operations for `Flow`.
    public struct Map {
        @usableFromInline
        let flow: Layout<Spacing>.Flow<Content>

        @usableFromInline
        init(flow: Layout<Spacing>.Flow<Content>) {
            self.flow = flow
        }

        /// Transforms the spacing type using the given closure.
        @inlinable
        public func spacing<Result, E: Error>(
            _ transform: (Spacing) throws(E) -> Result
        ) throws(E) -> Layout<Result>.Flow<Content> {
            Layout<Result>.Flow<Content>(
                spacing: Layout<Result>.Flow<Content>.Gaps(
                    item: try transform(flow.spacing.item),
                    line: try transform(flow.spacing.line)
                ),
                alignment: flow.alignment,
                line: Layout<Result>.Flow<Content>.Line(alignment: flow.line.alignment),
                content: flow.content
            )
        }

        /// Transforms the content using the given closure.
        @inlinable
        public func content<Result, E: Error>(
            _ transform: (Content) throws(E) -> Result
        ) throws(E) -> Layout<Spacing>.Flow<Result> {
            Layout<Spacing>.Flow<Result>(
                spacing: Layout<Spacing>.Flow<Result>.Gaps(
                    item: flow.spacing.item,
                    line: flow.spacing.line
                ),
                alignment: flow.alignment,
                line: Layout<Spacing>.Flow<Result>.Line(alignment: flow.line.alignment),
                content: try transform(flow.content)
            )
        }
    }
}
