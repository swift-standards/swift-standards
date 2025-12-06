// Direction.swift
// Direction along an axis.

/// Direction along an axis (positive or negative).
///
/// Represents the two possible directions along any axis,
/// independent of coordinate system conventions and dimension count.
/// This is the abstract notion of "which way" along an axis.
///
/// ## Mathematical Background
///
/// Direction is isomorphic to Z/2Z (the integers mod 2) or equivalently
/// the multiplicative group {-1, +1}. It represents a sign choice that
/// applies identically to any axis in any dimension.
///
/// ## Usage
///
/// ```swift
/// let direction: Direction = .positive
/// let reversed = direction.opposite  // .negative
///
/// // Also accessible via Axis<N>.Direction:
/// let dir: Axis<2>.Direction = .positive
/// ```
public enum Direction: Sendable, Hashable, Codable, CaseIterable {
    /// Positive direction (increasing coordinate values).
    case positive
    
    /// Negative direction (decreasing coordinate values).
    case negative
}

extension Direction {
    /// The opposite direction.
    @inlinable
    public var opposite: Direction {
        switch self {
        case .positive: return .negative
        case .negative: return .positive
        }
    }

    /// The sign multiplier for this direction.
    ///
    /// - `.positive` returns `1`
    /// - `.negative` returns `-1`
    @inlinable
    public var sign: Int {
        switch self {
        case .positive: return 1
        case .negative: return -1
        }
    }
}
