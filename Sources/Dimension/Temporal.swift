// Temporal.swift
// Temporal (W/T) axis orientation convention.

/// Temporal (W/T) axis orientation convention.
///
/// Determines how "past" and "future" map to the fourth coordinate:
/// - `.future`: T/W increases toward the future
/// - `.past`: T/W increases toward the past
///
/// This is a coordinate system convention for 4D+ spaces, commonly used
/// in physics (spacetime) and animation (time dimension).
///
/// ## Mathematical Background
///
/// In Minkowski spacetime, time is the fourth dimension with a special
/// metric signature. The convention for time direction affects causality
/// and the light cone structure.
///
/// ## Usage
///
/// ```swift
/// let orientation: Temporal = .future
///
/// // Also accessible via Axis<N>.Temporal (where N >= 4):
/// let tOrientation: Axis<4>.Temporal = .future
/// ```
public enum Temporal: Sendable, Hashable, Codable, CaseIterable {
    /// Time increases toward the future.
    ///
    /// Higher coordinate values represent later moments in time.
    case future

    /// Time increases toward the past.
    ///
    /// Higher coordinate values represent earlier moments in time.
    case past
}

extension Temporal {
    /// The opposite orientation.
    @inlinable
    public var opposite: Temporal {
        switch self {
        case .future: return .past
        case .past: return .future
        }
    }

    /// Returns the opposite orientation.
    ///
    /// - `!.future == .past`
    /// - `!.past == .future`
    @inlinable
    public static prefix func ! (value: Self) -> Self {
        value.opposite
    }
}
