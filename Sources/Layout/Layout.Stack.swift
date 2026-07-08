// Layout.Stack.swift
// A sequential arrangement of content along an axis.

public import Dimension

extension Layout {
    /// A linear arrangement of content along a horizontal or vertical axis.
    ///
    /// Arranges items sequentially with consistent spacing, similar to CSS flexbox
    /// or SwiftUI's `HStack`/`VStack`. Use this for navigation bars, button groups,
    /// form layouts, or any linear content arrangement.
    ///
    /// ## Example
    ///
    /// ```swift
    /// enum PageSpace {}
    ///
    /// // Vertical form fields
    /// let form = Layout<Double, PageSpace>.Stack<[Field]>.vertical(
    ///     spacing: 12.0,
    ///     alignment: .leading,  // Left-aligned fields
    ///     content: formFields
    /// )
    ///
    /// // Horizontal toolbar buttons
    /// let toolbar = Layout<Double, PageSpace>.Stack<[Button]>.horizontal(
    ///     spacing: 8.0,
    ///     alignment: .center,  // Vertically centered buttons
    ///     content: actions
    /// )
    /// ```
    public struct Stack<Content> {
        /// Axis along which content flows (`.primary` for horizontal, `.secondary` for vertical)
        public var axis: Axis<2>

        /// Spacing between adjacent items (non-directional magnitude).
        /// Projects to Width or Height based on axis at render time.
        public var spacing: Spacing

        /// Cross-axis alignment (vertical for horizontal stack, horizontal for vertical stack)
        public var alignment: Cross.Alignment

        /// Content to arrange
        public var content: Content

        /// Creates a stack with the specified configuration.
        @inlinable
        public init(
            axis: consuming Axis<2>,
            spacing: consuming Spacing,
            alignment: consuming Cross.Alignment,
            content: consuming Content
        ) {
            self.axis = axis
            self.spacing = spacing
            self.alignment = alignment
            self.content = content
        }
    }
}

// MARK: - Sendable

extension Layout.Stack: Sendable where Scalar: Sendable, Content: Sendable {}

// MARK: - Equatable

extension Layout.Stack: Equatable where Scalar: Equatable, Content: Equatable {}

// MARK: - Hashable

extension Layout.Stack: Hashable where Scalar: Hashable, Content: Hashable {}

// MARK: - Codable
#if !hasFeature(Embedded)
    extension Layout.Stack: Codable where Scalar: Codable, Content: Codable {}
#endif

// MARK: - Convenience Initializers

extension Layout.Stack {
    /// Creates a vertical stack (items flow top to bottom).
    @inlinable
    public static func vertical(
        spacing: Layout.Spacing,
        alignment: Cross.Alignment = .center,
        content: Content
    ) -> Self {
        Self(axis: .secondary, spacing: spacing, alignment: alignment, content: content)
    }

    /// Creates a horizontal stack (items flow leading to trailing).
    @inlinable
    public static func horizontal(
        spacing: Layout.Spacing,
        alignment: Cross.Alignment = .center,
        content: Content
    ) -> Self {
        Self(axis: .primary, spacing: spacing, alignment: alignment, content: content)
    }
}

// MARK: - Functorial Map

extension Layout.Stack {
    /// Namespace for functorial transformation operations.
    @inlinable
    public static func map(_ stack: borrowing Layout<Scalar, Space>.Stack<Content>) -> Map {
        Map(stack: stack)
    }

    /// Namespace for functorial transformation operations.
    @inlinable
    public var map: Map { Self.map(self) }

    /// Functorial transformation operations for `Stack`.
    public struct Map {
        @usableFromInline
        let stack: Layout<Scalar, Space>.Stack<Content>

        @usableFromInline
        init(stack: borrowing Layout<Scalar, Space>.Stack<Content>) {
            self.stack = copy stack
        }
    }
}

extension Layout.Stack.Map {
    /// Transforms the content using the given closure.
    @inlinable
    public func content<Result, E: Error>(
        _ transform: (Content) throws(E) -> Result
    ) throws(E) -> Layout<Scalar, Space>.Stack<Result> {
        Layout<Scalar, Space>.Stack<Result>(
            axis: stack.axis,
            spacing: stack.spacing,
            alignment: stack.alignment,
            content: try transform(stack.content)
        )
    }
}
