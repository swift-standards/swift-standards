// Gradient.swift
public import Dimension

/// Direction of change: ascending or descending.
///
/// Binary classification of whether values are increasing or decreasing. Related
/// to the sign of the first derivative. Forms a Z₂ group under reversal. Use
/// when tracking directional trends in ordered data.
///
/// ## Example
///
/// ```swift
/// let trend: Gradient = .ascending
/// print(trend.opposite)      // descending
/// print(!trend)              // descending
/// ```
public enum Gradient: Sendable, Hashable, Codable, CaseIterable {
    /// Values are increasing (positive slope).
    case ascending

    /// Values are decreasing (negative slope).
    case descending
}

// MARK: - Opposite

extension Gradient {
    /// Opposite gradient direction (ascending↔descending).
    @inlinable
    public var opposite: Gradient {
        switch self {
        case .ascending: return .descending
        case .descending: return .ascending
        }
    }

    /// Returns the opposite gradient.
    @inlinable
    public static prefix func ! (value: Gradient) -> Gradient {
        value.opposite
    }
}

// MARK: - Aliases

extension Gradient {
    /// Alias for ascending.
    public static var rising: Gradient { .ascending }

    /// Alias for descending.
    public static var falling: Gradient { .descending }

    /// Alias for ascending.
    public static var up: Gradient { .ascending }

    /// Alias for descending.
    public static var down: Gradient { .descending }
}

// MARK: - Tagged Value

extension Gradient {
    /// A value paired with its gradient direction.
    public typealias Value<Payload> = Pair<Gradient, Payload>
}
