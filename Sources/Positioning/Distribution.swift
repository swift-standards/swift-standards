// Distribution.swift
// Space distribution along the main axis.

/// Defines how space is distributed among items along the main axis.
///
/// Use `Distribution` to control how remaining space (after accounting for item sizes
/// and minimum spacing) is allocated within a container. Choose `fill` for compact layouts,
/// or use `space(_:)` strategies to create visually balanced spacing patterns.
///
/// ## Example
///
/// ```swift
/// let compact: Distribution = .fill
/// let balanced: Distribution = .spaceBetween
/// let breathing: Distribution = .spaceEvenly
///
/// // Visual representation with three items:
/// // .fill:         [A  B  C      ]  // Compact with min spacing
/// // .spaceBetween: [A     B     C]  // Equal gaps, no edge space
/// // .spaceEvenly:  [  A   B   C  ]  // Equal space everywhere
/// ```
public enum Distribution: Sendable, Hashable, Codable {
    /// Packs items together with minimum spacing, no extra distribution.
    case fill

    /// Distributes remaining space according to the specified strategy.
    case space(Space)
}

// MARK: - Space

extension Distribution {
    /// Strategies for distributing remaining space among items.
    ///
    /// Use space distribution strategies to create different visual spacing patterns.
    /// `between` creates gaps only between items, `around` adds breathing room around each item,
    /// and `evenly` ensures uniform spacing throughout including edges.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let justified: Distribution.Space = .between
    /// let balanced: Distribution.Space = .around
    /// let uniform: Distribution.Space = .evenly
    ///
    /// // Visual comparison with three items:
    /// // .between: [A     B     C]  // Gaps between only
    /// // .around:  [ A    B    C ]  // Half-space at edges
    /// // .evenly:  [  A   B   C  ]  // Full space everywhere
    /// ```
    public enum Space: Sendable, Hashable, Codable, CaseIterable {
        /// Distributes space only between items, leaving no space at container edges.
        case between

        /// Distributes equal space around each item, resulting in half-space at edges.
        case around

        /// Distributes space evenly between items and at both container edges.
        case evenly
    }
}

// MARK: - Convenience

extension Distribution {
    /// Distributes space only between items, leaving no space at container edges.
    @inlinable
    public static var spaceBetween: Self { .space(.between) }

    /// Distributes equal space around each item, resulting in half-space at edges.
    @inlinable
    public static var spaceAround: Self { .space(.around) }

    /// Distributes space evenly between items and at both container edges.
    @inlinable
    public static var spaceEvenly: Self { .space(.evenly) }
}

// MARK: - CaseIterable

extension Distribution: CaseIterable {
    public static var allCases: [Distribution] {
        [.fill, .space(.between), .space(.around), .space(.evenly)]
    }
}
