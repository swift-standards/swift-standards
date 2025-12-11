// Monotonicity.swift
public import Dimension

/// Monotonic behavior: increasing, decreasing, or constant.
///
/// Describes how a function's output changes relative to its input. Monotone
/// functions preserve or reverse order. Use when classifying functions or
/// sequences by their ordering properties.
///
/// ## Example
///
/// ```swift
/// let behavior: Monotonicity = .increasing
/// print(behavior.reversed)         // decreasing
/// print(behavior.isNonDecreasing)  // true
/// ```
public enum Monotonicity: Sendable, Hashable, Codable, CaseIterable {
    /// Output increases as input increases.
    case increasing

    /// Output decreases as input increases.
    case decreasing

    /// Output remains the same regardless of input.
    case constant
}

// MARK: - Reversal

extension Monotonicity {
    /// Reversed monotonicity (swaps increasing↔decreasing, preserves constant).
    @inlinable
    public var reversed: Monotonicity {
        switch self {
        case .increasing: return .decreasing
        case .decreasing: return .increasing
        case .constant: return .constant
        }
    }

    /// Returns the reversed monotonicity.
    @inlinable
    public static prefix func ! (value: Monotonicity) -> Monotonicity {
        value.reversed
    }
}

// MARK: - Composition

extension Monotonicity {
    /// Monotonicity of composing two monotonic functions (f ∘ g).
    @inlinable
    public func composing(_ other: Monotonicity) -> Monotonicity {
        switch (self, other) {
        case (.constant, _), (_, .constant): return .constant
        case (.increasing, .increasing), (.decreasing, .decreasing): return .increasing
        case (.increasing, .decreasing), (.decreasing, .increasing): return .decreasing
        }
    }
}

// MARK: - Properties

extension Monotonicity {
    /// Whether the monotonicity is strictly `.increasing`.
    @inlinable
    public var isIncreasing: Bool { self == .increasing }

    /// Whether the monotonicity is strictly `.decreasing`.
    @inlinable
    public var isDecreasing: Bool { self == .decreasing }

    /// Whether the monotonicity is `.constant`.
    @inlinable
    public var isConstant: Bool { self == .constant }

    /// Whether the monotonicity is non-decreasing (`.increasing` or `.constant`).
    @inlinable
    public var isNonDecreasing: Bool { self != .decreasing }

    /// Whether the monotonicity is non-increasing (`.decreasing` or `.constant`).
    @inlinable
    public var isNonIncreasing: Bool { self != .increasing }
}

// MARK: - Tagged Value

extension Monotonicity {
    /// A value paired with its monotonicity.
    public typealias Value<Payload> = Pair<Monotonicity, Payload>
}
