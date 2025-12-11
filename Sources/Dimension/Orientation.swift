// Orientation.swift
// The abstract theory of binary orientation.

/// A binary type with exactly two opposite values.
///
/// `Orientation` represents any type with two mutually opposite states: `Direction`, `Horizontal`, `Vertical`, `Depth`, and `Temporal` all conform. Mathematically, any orientation type is isomorphic to Bool, Z/2Z, or the multiplicative group {-1, +1}.
///
/// All orientation types can convert to/from the canonical `Direction` type, making their isomorphism explicit. Use `opposite` or the `!` prefix operator to flip between the two states.
///
/// ## Example
///
/// ```swift
/// let h: Horizontal = .rightward
/// let flipped = !h                    // .leftward
/// let dir = h.direction               // .positive
/// let v = Vertical(direction: dir)    // .upward
/// ```
public protocol Orientation: Sendable, Hashable, CaseIterable where AllCases == [Self] {
    /// Returns the opposite orientation (involution: `x.opposite.opposite == x`).
    var opposite: Self { get }

    /// Returns the canonical direction representation.
    var direction: Direction { get }

    /// Creates an orientation from a canonical direction.
    init(direction: Direction)
}

// MARK: - Default Implementations

extension Orientation {
    /// Returns the opposite orientation (prefix negation, mirroring Bool).
    @inlinable
    public static prefix func ! (value: Self) -> Self {
        value.opposite
    }

    /// All cases, derived from `Direction.allCases`.
    @inlinable
    public static var allCases: [Self] {
        Direction.allCases.map { Self(direction: $0) }
    }
}

// MARK: - Generic Operations

extension Orientation {
    /// Creates an orientation from a boolean condition.
    ///
    /// - Returns: Positive orientation if `true`, negative if `false`.
    @inlinable
    public init(_ condition: Bool) {
        self.init(direction: condition ? Direction.positive : Direction.negative)
    }

    /// Whether orientation maps to positive direction.
    @inlinable
    public var isPositive: Bool {
        direction == Direction.positive
    }

    /// Whether orientation maps to negative direction.
    @inlinable
    public var isNegative: Bool {
        direction == Direction.negative
    }
}

/// A value paired with an orientation.
///
/// `Oriented` pairs an orientation with a scalar payload. Access the orientation via `.first` or `.0`, and the scalar via `.second` or `.1`.
///
/// ## Example
///
/// ```swift
/// let velocity: Oriented<Vertical, Double> = Pair(.upward, 9.8)
/// print(velocity.first)   // .upward
/// print(velocity.second)  // 9.8
/// ```
public typealias Oriented<O: Orientation, Scalar> = Pair<O, Scalar>

extension Orientation {
    public typealias Value<Scalar> = Oriented<Self, Scalar>
}
