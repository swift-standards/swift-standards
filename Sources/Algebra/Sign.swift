// Sign.swift
public import Dimension

/// Three-valued sign: positive, negative, or zero.
///
/// Complete numeric classification including zero as a distinct case. Forms a
/// monoid under multiplication with identity `positive` and absorbing element
/// `zero`. Use when working with signed numbers or implementing signum functions.
///
/// ## Example
///
/// ```swift
/// let s = Sign(-5.0)
/// print(s)                       // negative
/// print(s.negated)               // positive
/// print(s.multiplying(.positive)) // negative
/// ```
public enum Sign: Sendable, Hashable, Codable, CaseIterable {
    /// Greater than zero.
    case positive

    /// Less than zero.
    case negative

    /// Equal to zero.
    case zero
}

// MARK: - Negation

extension Sign {
    /// Negated sign (swaps positive↔negative, preserves zero).
    @inlinable
    public var negated: Sign {
        switch self {
        case .positive: return .negative
        case .negative: return .positive
        case .zero: return .zero
        }
    }

    /// Returns the negated sign.
    @inlinable
    public static prefix func - (value: Sign) -> Sign {
        value.negated
    }
}

// MARK: - Multiplication

extension Sign {
    /// Sign of multiplying two signed values (p×p=p, n×n=p, p×n=n, z×_=z).
    @inlinable
    public func multiplying(_ other: Sign) -> Sign {
        switch (self, other) {
        case (.zero, _), (_, .zero): return .zero
        case (.positive, .positive), (.negative, .negative): return .positive
        case (.positive, .negative), (.negative, .positive): return .negative
        }
    }
}

// MARK: - Numeric Detection

extension Sign {
    /// Creates a sign from a comparable arithmetic value.
    @inlinable
    public init<T: Comparable & AdditiveArithmetic>(_ value: T) {
        if value > .zero {
            self = .positive
        } else if value < .zero {
            self = .negative
        } else {
            self = .zero
        }
    }
}

// MARK: - Tagged Value

extension Sign {
    /// A value paired with its sign.
    public typealias Value<Payload> = Pair<Sign, Payload>
}
