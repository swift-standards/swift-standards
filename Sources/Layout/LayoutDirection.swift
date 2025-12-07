// LayoutDirection.swift
// Text/content layout direction.

/// Layout direction for text and content flow.
///
/// Determines how "leading" and "trailing" map to "left" and "right".
///
/// ## Convention
///
/// - `.leftToRight`: leading = left, trailing = right (e.g., English)
/// - `.rightToLeft`: leading = right, trailing = left (e.g., Arabic, Hebrew)
public enum LayoutDirection: Sendable, Hashable, Codable, CaseIterable {
    /// Left-to-right layout (leading = left).
    case leftToRight

    /// Right-to-left layout (leading = right).
    case rightToLeft
}

// MARK: - Aliases

extension LayoutDirection {
    /// Left-to-right layout.
    public static var ltr: Self { .leftToRight }

    /// Right-to-left layout.
    public static var rtl: Self { .rightToLeft }
}

// MARK: - Opposite

extension LayoutDirection {
    /// The opposite layout direction.
    @inlinable
    public var opposite: LayoutDirection {
        switch self {
        case .leftToRight: return .rightToLeft
        case .rightToLeft: return .leftToRight
        }
    }
}
