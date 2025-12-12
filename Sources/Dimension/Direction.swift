// Direction.swift
// The canonical binary orientation.

/// Canonical axis direction: positive or negative.
///
/// `Direction` represents pure polarity without domain-specific interpretation. Use it as the universal orientation type, or convert to domain-specific types like `Horizontal`, `Vertical`, `Depth`, or `Temporal` for semantic clarity.
///
/// All orientation types are isomorphic to `Direction` and can freely convert to/from it. Mathematically, this is isomorphic to Z/2Z, Bool, or the multiplicative group {-1, +1}.
///
/// ## Example
///
/// ```swift
/// let dir: Direction = .positive
/// let reversed = !dir  // .negative
///
/// // Convert to domain-specific orientations
/// let horizontal = Horizontal(direction: dir)  // .rightward
/// let vertical = Vertical(direction: dir)      // .upward
/// ```
public enum Direction: Sendable, Hashable, Codable {
    /// Positive direction (increasing coordinate values).
    case positive

    /// Negative direction (decreasing coordinate values).
    case negative
}

// MARK: - Orientation Conformance (Static Implementation)

extension Direction {
    /// Returns the opposite of a direction.
    @inlinable
    public static func opposite(of direction: Direction) -> Direction {
        switch direction {
        case .positive: return .negative
        case .negative: return .positive
        }
    }
}

// MARK: - Orientation Conformance (Instance Convenience)

extension Direction: Orientation {
    /// Returns the opposite direction.
    @inlinable
    public var opposite: Direction {
        Direction.opposite(of: self)
    }

    /// Returns self (identity, since `Direction` is canonical).
    @inlinable
    public var direction: Direction { self }

    /// Creates a direction (identity conversion).
    @inlinable
    public init(direction: Direction) { self = direction }

    /// All direction cases.
    public static let allCases: [Direction] = [.positive, .negative]
}

// MARK: - Sign

extension Direction {
    /// Sign multiplier: `+1` for positive, `-1` for negative.
    @inlinable
    public var sign: Int {
        switch self {
        case .positive: return 1
        case .negative: return -1
        }
    }

    /// Creates a direction from a sign value.
    ///
    /// - Returns: `.positive` if sign ≥ 0, `.negative` otherwise.
    @inlinable
    public init(sign: Int) {
        self = sign >= 0 ? .positive : .negative
    }
}
