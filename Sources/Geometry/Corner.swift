// Corner.swift
// Rectangle corners.

/// Corner of a rectangle.
///
/// The four vertices of a rectangle, using leading/trailing for
/// layout-direction-aware naming.
///
/// ## Convention
///
/// - Leading: left in LTR, right in RTL
/// - Trailing: right in LTR, left in RTL
/// - Top/Bottom: always consistent
///
/// ## Tagged Values
///
/// Use `Corner.Value<T>` to pair a value with its corner:
///
/// ```swift
/// let radius: Corner.Value<CGFloat> = .init(tag: .topLeading, value: 8)
/// ```
public enum Corner: Sendable, Hashable, Codable, CaseIterable {
    /// Top-leading corner (top-left in LTR).
    case topLeading

    /// Top-trailing corner (top-right in LTR).
    case topTrailing

    /// Bottom-leading corner (bottom-left in LTR).
    case bottomLeading

    /// Bottom-trailing corner (bottom-right in LTR).
    case bottomTrailing
}

// MARK: - Opposite

extension Corner {
    /// The diagonally opposite corner.
    @inlinable
    public var opposite: Corner {
        switch self {
        case .topLeading: return .bottomTrailing
        case .topTrailing: return .bottomLeading
        case .bottomLeading: return .topTrailing
        case .bottomTrailing: return .topLeading
        }
    }

    /// Returns the diagonally opposite corner.
    @inlinable
    public static prefix func ! (value: Corner) -> Corner {
        value.opposite
    }
}

// MARK: - Properties

extension Corner {
    /// True if this is a top corner.
    @inlinable
    public var isTop: Bool {
        self == .topLeading || self == .topTrailing
    }

    /// True if this is a bottom corner.
    @inlinable
    public var isBottom: Bool {
        self == .bottomLeading || self == .bottomTrailing
    }

    /// True if this is a leading corner.
    @inlinable
    public var isLeading: Bool {
        self == .topLeading || self == .bottomLeading
    }

    /// True if this is a trailing corner.
    @inlinable
    public var isTrailing: Bool {
        self == .topTrailing || self == .bottomTrailing
    }
}

// MARK: - Adjacent Corners

extension Corner {
    /// The corner horizontally adjacent to this one.
    @inlinable
    public var horizontalAdjacent: Corner {
        switch self {
        case .topLeading: return .topTrailing
        case .topTrailing: return .topLeading
        case .bottomLeading: return .bottomTrailing
        case .bottomTrailing: return .bottomLeading
        }
    }

    /// The corner vertically adjacent to this one.
    @inlinable
    public var verticalAdjacent: Corner {
        switch self {
        case .topLeading: return .bottomLeading
        case .topTrailing: return .bottomTrailing
        case .bottomLeading: return .topLeading
        case .bottomTrailing: return .topTrailing
        }
    }
}

// MARK: - Tagged Value

public import Algebra

extension Corner {
    /// A value paired with its corner.
    public typealias Value<Payload> = Tagged<Corner, Payload>
}
