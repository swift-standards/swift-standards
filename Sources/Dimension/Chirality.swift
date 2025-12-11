// Chirality.swift
// Handedness (left or right).

/// Handedness or chirality: left or right.
///
/// `Chirality` represents mirror-image asymmetry in coordinate systems, molecular structures, screw threads, or any left/right distinction. Mirror reflection swaps left and right chirality.
///
/// ## Example
///
/// ```swift
/// let system: Chirality = .right   // Right-handed coordinate system (standard)
/// let mirrored = !system           // .left
/// let hand: Chirality.Value<Point> = Pair(.right, point)
/// ```
public enum Chirality: Sendable, Hashable, Codable, CaseIterable {
    /// Left-handed (sinistral).
    case left

    /// Right-handed (dextral).
    case right
}

// MARK: - Opposite

extension Chirality {
    /// Returns the opposite chirality (mirror image).
    @inlinable
    public var opposite: Chirality {
        switch self {
        case .left: return .right
        case .right: return .left
        }
    }

    /// Returns the opposite chirality (prefix negation).
    @inlinable
    public static prefix func ! (value: Chirality) -> Chirality {
        value.opposite
    }

    /// Returns the mirrored chirality.
    @inlinable
    public var mirrored: Chirality { opposite }
}

// MARK: - Coordinate System

extension Chirality {
    /// Standard right-handed coordinate system (OpenGL, mathematics).
    public static var standard: Chirality { .right }

    /// Left-handed coordinate system (DirectX, some CAD systems).
    public static var directX: Chirality { .left }
}

// MARK: - Paired Value

extension Chirality {
    /// Value paired with chirality information.
    public typealias Value<Payload> = Pair<Chirality, Payload>
}
