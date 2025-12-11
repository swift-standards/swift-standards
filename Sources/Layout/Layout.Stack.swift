// Layout.Stack.swift
// A sequential arrangement of content along an axis.

public import Dimension
import Geometry

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
    /// // Vertical form fields
    /// let form = Layout<Double>.Stack<[Field]>.vertical(
    ///     spacing: 12.0,
    ///     alignment: .leading,  // Left-aligned fields
    ///     content: formFields
    /// )
    ///
    /// // Horizontal toolbar buttons
    /// let toolbar = Layout<Double>.Stack<[Button]>.horizontal(
    ///     spacing: 8.0,
    ///     alignment: .center,  // Vertically centered buttons
    ///     content: actions
    /// )
    /// ```
    public struct Stack<Content> {
        /// Axis along which content flows (`.primary` for horizontal, `.secondary` for vertical)
        public var axis: Axis<2>

        /// Spacing between adjacent items
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

extension Layout.Stack: Sendable where Spacing: Sendable, Content: Sendable {}

// MARK: - Equatable

extension Layout.Stack: Equatable where Spacing: Equatable, Content: Equatable {}

// MARK: - Hashable

extension Layout.Stack: Hashable where Spacing: Hashable, Content: Hashable {}

// MARK: - Codable
#if Codable
    extension Layout.Stack: Codable where Spacing: Codable, Content: Codable {}
#endif
// MARK: - Convenience Initializers

extension Layout.Stack {
    /// Creates a vertical stack (items flow top to bottom).
    @inlinable
    public static func vertical(
        spacing: Spacing,
        alignment: Cross.Alignment = .center,
        content: Content
    ) -> Self {
        Self(axis: .secondary, spacing: spacing, alignment: alignment, content: content)
    }

    /// Creates a horizontal stack (items flow leading to trailing).
    @inlinable
    public static func horizontal(
        spacing: Spacing,
        alignment: Cross.Alignment = .center,
        content: Content
    ) -> Self {
        Self(axis: .primary, spacing: spacing, alignment: alignment, content: content)
    }
}

// MARK: - Functorial Map

extension Layout.Stack {
    /// Creates a stack by transforming the spacing unit of another stack.
    @inlinable
    public init<U, E: Error>(
        transforming other: borrowing Layout<U>.Stack<Content>,
        spacing transform: (U) throws(E) -> Spacing
    ) throws(E) {
        self.init(
            axis: other.axis,
            spacing: try transform(other.spacing),
            alignment: other.alignment,
            content: other.content
        )
    }
}

extension Layout.Stack {
    /// Namespace for functorial transformation operations.
    @inlinable
    public var map: Map { Map(stack: self) }

    /// Functorial transformation operations for `Stack`.
    public struct Map {
        @usableFromInline
        let stack: Layout<Spacing>.Stack<Content>

        @usableFromInline
        init(stack: Layout<Spacing>.Stack<Content>) {
            self.stack = stack
        }

        /// Transforms the spacing type using the given closure.
        @inlinable
        public func spacing<Result, E: Error>(
            _ transform: (Spacing) throws(E) -> Result
        ) throws(E) -> Layout<Result>.Stack<Content> {
            Layout<Result>.Stack<Content>(
                axis: stack.axis,
                spacing: try transform(stack.spacing),
                alignment: stack.alignment,
                content: stack.content
            )
        }

        /// Transforms the content using the given closure.
        @inlinable
        public func content<Result, E: Error>(
            _ transform: (Content) throws(E) -> Result
        ) throws(E) -> Layout<Spacing>.Stack<Result> {
            Layout<Spacing>.Stack<Result>(
                axis: stack.axis,
                spacing: stack.spacing,
                alignment: stack.alignment,
                content: try transform(stack.content)
            )
        }
    }
}
