// Edge.swift
// Rectangle edges.

/// Edge of a rectangle.
///
/// The four sides of a rectangle, using leading/trailing for
/// layout-direction-aware naming.
///
/// ## Convention
///
/// - Leading: left edge in LTR, right edge in RTL
/// - Trailing: right edge in LTR, left edge in RTL
/// - Top/Bottom: always consistent
///
/// ## Tagged Values
///
/// Use `Edge.Value<T>` to pair an offset with its edge:
///
/// ```swift
/// let inset: Edge.Value<CGFloat> = .init(tag: .top, value: 20)
/// ```
public enum Edge: Sendable, Hashable, Codable, CaseIterable {
    /// Top edge.
    case top

    /// Leading edge (left in LTR).
    case leading

    /// Bottom edge.
    case bottom

    /// Trailing edge (right in LTR).
    case trailing
}

// MARK: - Opposite

extension Edge {
    /// The opposite edge.
    @inlinable
    public var opposite: Edge {
        switch self {
        case .top: return .bottom
        case .leading: return .trailing
        case .bottom: return .top
        case .trailing: return .leading
        }
    }

    /// Returns the opposite edge.
    @inlinable
    public static prefix func ! (value: Edge) -> Edge {
        value.opposite
    }
}

// MARK: - Orientation

extension Edge {
    /// True if this is a horizontal edge (top/bottom).
    @inlinable
    public var isHorizontal: Bool {
        self == .top || self == .bottom
    }

    /// True if this is a vertical edge (leading/trailing).
    @inlinable
    public var isVertical: Bool {
        self == .leading || self == .trailing
    }
}

// MARK: - Adjacent Corners

extension Edge {
    /// The two corners that bound this edge.
    @inlinable
    public var corners: (Corner, Corner) {
        switch self {
        case .top: return (.topLeading, .topTrailing)
        case .leading: return (.topLeading, .bottomLeading)
        case .bottom: return (.bottomLeading, .bottomTrailing)
        case .trailing: return (.topTrailing, .bottomTrailing)
        }
    }
}

// MARK: - Tagged Value

public import Algebra

extension Edge {
    /// A value paired with its edge.
    public typealias Value<Payload> = Tagged<Edge, Payload>
}
