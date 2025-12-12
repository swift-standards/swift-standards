// Direction.swift
// Text/content layout direction.

/// Typealias for convenient access to Layout.Direction.
public typealias Direction = Layout<Never>.Direction

extension Layout {
    /// Text and content flow direction for internationalization.
    ///
    /// Determines how layout-relative terms (leading/trailing) map to absolute
    /// directions (left/right). Essential for properly supporting right-to-left
    /// languages like Arabic, Hebrew, and Persian.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let direction: Direction = .leftToRight  // English, Spanish, etc.
    /// let rtl: Direction = .rightToLeft        // Arabic, Hebrew, etc.
    ///
    /// // Leading adapts based on direction:
    /// // LTR: leading = left, trailing = right
    /// // RTL: leading = right, trailing = left
    /// ```
    public enum Direction: Sendable, Hashable, Codable, CaseIterable {
        /// Left-to-right layout (English, Spanish, French, etc.)
        case leftToRight

        /// Right-to-left layout (Arabic, Hebrew, Persian, etc.)
        case rightToLeft
    }
}

// MARK: - Aliases

extension Layout.Direction {
    /// Shorthand for left-to-right layout
    public static var ltr: Self { .leftToRight }

    /// Shorthand for right-to-left layout
    public static var rtl: Self { .rightToLeft }
}

// MARK: - Opposite

extension Layout.Direction {
    /// Returns the opposite layout direction.
    @inlinable
    public static func opposite(_ direction: Layout.Direction) -> Layout.Direction {
        switch direction {
        case .leftToRight: return .rightToLeft
        case .rightToLeft: return .leftToRight
        }
    }

    /// Returns the opposite layout direction.
    @inlinable
    public var opposite: Layout.Direction {
        Self.opposite(self)
    }
}
