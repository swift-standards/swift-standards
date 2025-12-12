// Ordinal.swift
// The canonical finite type with exactly N inhabitants.

/// A value in the finite set {0, 1, ..., N-1}.
///
/// `Ordinal<N>` is the canonical type with exactly N distinct values, indexed 0 through N-1. It represents the von Neumann ordinal (set theory) or `Fin n` (type theory).
///
/// Use it as a type-safe array index, to represent any N-valued enumeration, or as the foundation for finite types. Many types are isomorphic to `Ordinal<N>`: `Bool ≅ Ordinal<2>`, `Axis<N> ≅ Ordinal<N>`, etc.
///
/// ## Example
///
/// ```swift
/// let index: Ordinal<3> = Ordinal(1)!
/// let values = [10, 20, 30]
/// print(values[index])  // 20
///
/// // Iterate all values
/// for i in Ordinal<4>.allCases { print(i.rawValue) }  // 0, 1, 2, 3
/// ```
public struct Ordinal<let N: Int>: Sendable, Hashable {
    /// Underlying integer value (0 to N-1).
    public let rawValue: Int

    /// Creates an ordinal from an integer, if within bounds.
    ///
    /// - Returns: The ordinal, or `nil` if out of bounds.
    @inlinable
    public init?(_ rawValue: Int) {
        guard rawValue >= 0 && rawValue < N else { return nil }
        self.rawValue = rawValue
    }

    /// Creates an ordinal without bounds checking.
    ///
    /// - Precondition: `rawValue` must be in 0..<N
    @inlinable
    public init(unchecked rawValue: Int) {
        self.rawValue = rawValue
    }
}

// MARK: - Special Values

extension Ordinal {
    /// Zero value (first element, index 0).
    @inlinable
    public static var zero: Self {
        Self(unchecked: 0)
    }

    /// Maximum value (N - 1).
    @inlinable
    public static var max: Self {
        Self(unchecked: N - 1)
    }

    /// Number of inhabitants of this type.
    @inlinable
    public static var count: Int { N }
}

// MARK: - Comparable

extension Ordinal: Comparable {
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

// MARK: - Codable

#if Codable
    extension Ordinal: Codable {
        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            let value = try container.decode(Int.self)
            guard let ordinal = Self(value) else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription:
                            "Value \(value) out of bounds for Ordinal<\(N)> (expected 0..<\(N))"
                    )
                )
            }
            self = ordinal
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(rawValue)
        }
    }
#endif

// MARK: - Conversion (Static Implementation)

extension Ordinal {
    /// Injects an ordinal into a larger domain (safe upcast).
    ///
    /// - Precondition: `rawValue` must be less than M
    @inlinable
    public static func injected<let M: Int>(_ ordinal: Ordinal) -> Ordinal<M> {
        Ordinal<M>(unchecked: ordinal.rawValue)
    }

    /// Attempts to project an ordinal into a smaller domain.
    ///
    /// - Returns: The converted ordinal, or `nil` if value is too large.
    @inlinable
    public static func projected<let M: Int>(_ ordinal: Ordinal) -> Ordinal<M>? {
        Ordinal<M>(ordinal.rawValue)
    }
}

// MARK: - Conversion (Instance Convenience)

extension Ordinal {
    /// Converts to an `Ordinal` of a larger domain (safe upcast).
    ///
    /// - Precondition: `rawValue` must be less than M
    @inlinable
    public func injected<let M: Int>() -> Ordinal<M> {
        Self.injected(self)
    }

    /// Attempts to convert to an `Ordinal` of a smaller domain.
    ///
    /// - Returns: The converted ordinal, or `nil` if value is too large.
    @inlinable
    public func projected<let M: Int>() -> Ordinal<M>? {
        Self.projected(self)
    }
}

// MARK: - Ordinal: Enumerable

extension Ordinal: Enumerable {
    /// Number of values in `Ordinal<N>`.
    @inlinable
    public static var caseCount: Int { N }

    /// Index of this value.
    @inlinable
    public var caseIndex: Int { rawValue }

    /// Creates a value from its index.
    @inlinable
    public init(caseIndex: Int) {
        self.init(unchecked: caseIndex)
    }
}

// MARK: - Array Subscripting

extension Array {
    /// Accesses an element at a type-safe ordinal index.
    @inlinable
    public subscript<let N: Int>(index: Ordinal<N>) -> Element {
        self[index.rawValue]
    }
}

// MARK: - Type Alias

/// Type alias for `Ordinal` using the traditional type-theoretic name `Fin n`.
public typealias Fin = Ordinal
