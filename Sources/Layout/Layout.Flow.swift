// Layout.Flow.swift
// A wrapping layout that flows content to the next line when full.

public import Dimension
public import Geometry

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
    /// enum PageSpace {}
    ///
    /// // Tag cloud with wrapping
    /// let tags = Layout<Double, PageSpace>.Flow<[Tag]>(
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
    /// Uses dimensionally-typed spacing: `Width` for horizontal item gaps,
    /// `Height` for vertical line gaps.
    public struct Gaps {
        /// Spacing between items on the same line (horizontal gap)
        public var item: Layout.Width

        /// Spacing between lines (vertical gap)
        public var line: Layout.Height

        /// Creates spacing with the specified item and line values.
        @inlinable
        public init(item: Layout.Width, line: Layout.Height) {
            self.item = item
            self.line = line
        }
    }
}

extension Layout.Flow.Gaps: Sendable where Scalar: Sendable {}
extension Layout.Flow.Gaps: Equatable where Scalar: Equatable {}
extension Layout.Flow.Gaps: Hashable where Scalar: Hashable {}
#if !hasFeature(Embedded)
    extension Layout.Flow.Gaps: Codable where Scalar: Codable {}
#endif

extension Layout.Flow.Gaps where Scalar: AdditiveArithmetic {
    /// Creates uniform spacing (identical magnitude for items and lines).
    @inlinable
    public static func uniform(_ value: Layout.Spacing) -> Self {
        Self(item: value.width, line: value.height)
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

extension Layout.Flow: Sendable where Scalar: Sendable, Content: Sendable {}

// MARK: - Equatable

extension Layout.Flow: Equatable where Scalar: Equatable, Content: Equatable {}

// MARK: - Hashable

extension Layout.Flow: Hashable where Scalar: Hashable, Content: Hashable {}

// MARK: - Codable
#if !hasFeature(Embedded)
    extension Layout.Flow: Codable where Scalar: Codable, Content: Codable {}
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

extension Layout.Flow where Scalar: AdditiveArithmetic {
    /// Creates a flow layout with uniform spacing (same magnitude for items and lines).
    @inlinable
    public static func uniform(
        spacing: Layout.Spacing,
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
    /// Returns the functorial transformation namespace for the given flow.
    @inlinable
    public static func map(_ flow: borrowing Layout<Scalar, Space>.Flow<Content>) -> Map {
        Map(flow: flow)
    }

    /// Namespace for functorial transformation operations.
    @inlinable
    public var map: Map { Self.map(self) }

    /// Functorial transformation operations for `Flow`.
    public struct Map {
        @usableFromInline
        let flow: Layout<Scalar, Space>.Flow<Content>

        @usableFromInline
        init(flow: borrowing Layout<Scalar, Space>.Flow<Content>) {
            self.flow = copy flow
        }
    }
}

extension Layout.Flow.Map {
    /// Transforms the content using the given closure.
    @inlinable
    public func content<Result, E: Error>(
        _ transform: (Content) throws(E) -> Result
    ) throws(E) -> Layout<Scalar, Space>.Flow<Result> {
        Layout<Scalar, Space>.Flow<Result>(
            spacing: Layout<Scalar, Space>.Flow<Result>.Gaps(
                item: flow.spacing.item,
                line: flow.spacing.line
            ),
            alignment: flow.alignment,
            line: Layout<Scalar, Space>.Flow<Result>.Line(alignment: flow.line.alignment),
            content: try transform(flow.content)
        )
    }
}
