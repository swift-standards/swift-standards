// Temporal.swift
// Temporal (W/T) axis orientation and oriented values.

/// Time-axis orientation: future or past.
///
/// `Temporal` specifies which direction along the time axis is considered positive. Use it in spacetime physics (Minkowski space) or 4D graphics where the fourth coordinate represents time.
///
/// ## Example
///
/// ```swift
/// let forward: Temporal = .future  // Time flows forward
/// let backward: Temporal = .past   // Time flows backward
///
/// // Oriented duration with direction
/// let delta = Temporal.Value(.future, 10.0)
/// ```
public enum Temporal: Sendable, Hashable, Codable {
    /// Time-axis increases toward the future.
    case future

    /// Time-axis increases toward the past.
    case past
}

// MARK: - Orientation Conformance

extension Temporal: Orientation {
    /// Returns the canonical direction representation.
    @inlinable
    public var direction: Direction {
        switch self {
        case .future: return .positive
        case .past: return .negative
        }
    }

    /// Creates a temporal orientation from a canonical direction.
    @inlinable
    public init(direction: Direction) {
        switch direction {
        case .positive: self = .future
        case .negative: self = .past
        }
    }

    /// Returns the opposite orientation.
    @inlinable
    public var opposite: Temporal {
        switch self {
        case .future: return .past
        case .past: return .future
        }
    }

    /// All temporal orientations.
    public static let allCases: [Temporal] = [.future, .past]
}

// MARK: - Pattern Matching Support

extension Temporal {
    /// Whether orientation is future-directed.
    @inlinable
    public var isFuture: Bool { self == .future }

    /// Whether orientation is past-directed.
    @inlinable
    public var isPast: Bool { self == .past }
}

// MARK: - CustomStringConvertible

extension Temporal: CustomStringConvertible {
    public var description: String {
        switch self {
        case .future: return "future"
        case .past: return "past"
        }
    }
}
