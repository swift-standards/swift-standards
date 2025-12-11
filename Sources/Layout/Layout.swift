// Layout
//
// Type-safe layout primitives parameterized by spacing type.

/// Namespace for layout primitives that arrange content in space.
///
/// Provides container types (`Stack`, `Grid`, `Flow`) parameterized by spacing
/// type, enabling type-safe dimensional calculations. The spacing type determines
/// the unit used for gaps between elements (points, pixels, etc.).
///
/// ## Example
///
/// ```swift
/// // Define your spacing unit
/// struct Points: AdditiveArithmetic { /* ... */ }
///
/// // Create specialized layout types
/// typealias PageStack<C> = Layout<Points>.Stack<C>
/// typealias PageGrid<C> = Layout<Points>.Grid<C>
/// typealias PageFlow<C> = Layout<Points>.Flow<C>
///
/// // Use them in your layouts
/// let vstack = PageStack<[View]>.vertical(
///     spacing: Points(16),
///     alignment: .leading,
///     content: views
/// )
/// ```
///
/// ## Note
///
/// Supports both copyable and non-copyable spacing types for maximum flexibility.
public enum Layout<Spacing: ~Copyable>: ~Copyable {}

extension Layout: Copyable where Spacing: Copyable {}
extension Layout: Sendable where Spacing: Sendable {}
