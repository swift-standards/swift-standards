// Boundary.swift
public import Dimension

/// Inclusivity of an interval endpoint: open or closed.
///
/// Determines whether an endpoint value is included in the interval. Closed
/// means included (≤ or ≥), open means excluded (< or >). Forms a Z₂ group
/// under toggle. Combine with `Bound` for complete endpoint specification.
///
/// ## Example
///
/// ```swift
/// let boundary: Boundary = .closed
/// print(boundary.isInclusive)   // true
/// print(boundary.opposite)      // open
/// ```
public enum Boundary: Sendable, Hashable, Codable, CaseIterable {
    /// Endpoint is included (≤ or ≥).
    case closed

    /// Endpoint is excluded (< or >).
    case open
}

// MARK: - Opposite

extension Boundary {
    /// Opposite boundary type (closed↔open).
    @inlinable
    public var opposite: Boundary {
        switch self {
        case .closed: return .open
        case .open: return .closed
        }
    }

    /// Returns the opposite boundary type.
    @inlinable
    public static prefix func ! (value: Boundary) -> Boundary {
        value.opposite
    }

    /// Opposite boundary type (closed↔open).
    @inlinable
    public var toggled: Boundary { opposite }
}

// MARK: - Properties

extension Boundary {
    /// Whether the boundary is inclusive (endpoint included in interval).
    @inlinable
    public var isInclusive: Bool { self == .closed }

    /// Whether the boundary is exclusive (endpoint excluded from interval).
    @inlinable
    public var isExclusive: Bool { self == .open }
}

// MARK: - Tagged Value

extension Boundary {
    /// A value paired with its boundary type.
    public typealias Value<Payload> = Pair<Boundary, Payload>
}
