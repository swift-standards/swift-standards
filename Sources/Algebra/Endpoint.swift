// Endpoint.swift
public import Dimension

/// Position in a sequence: start or end.
///
/// Identifies the beginning or ending position of a sequence, range, or linear
/// structure. Forms a Z₂ group under swap. Use when distinguishing first/last
/// positions in ordered collections.
///
/// ## Example
///
/// ```swift
/// let position: Endpoint = .start
/// print(position.opposite)   // end
/// print(!position)           // end
/// ```
public enum Endpoint: Sendable, Hashable, Codable, CaseIterable {
    /// Beginning of the sequence.
    case start

    /// End of the sequence.
    case end
}

// MARK: - Opposite

extension Endpoint {
    /// Opposite endpoint (start↔end).
    @inlinable
    public var opposite: Endpoint {
        switch self {
        case .start: return .end
        case .end: return .start
        }
    }

    /// Returns the opposite endpoint.
    @inlinable
    public static prefix func ! (value: Endpoint) -> Endpoint {
        value.opposite
    }
}

// MARK: - Aliases

extension Endpoint {
    /// Alias for start.
    public static var first: Endpoint { .start }

    /// Alias for end.
    public static var last: Endpoint { .end }

    /// Alias for start (head of list).
    public static var head: Endpoint { .start }

    /// Alias for end (tail of list).
    public static var tail: Endpoint { .end }
}

// MARK: - Tagged Value

extension Endpoint {
    /// A value paired with its endpoint position.
    public typealias Value<Payload> = Pair<Endpoint, Payload>
}
