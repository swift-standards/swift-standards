// Fin.swift
// The canonical finite type with exactly N inhabitants.

/// A value in the finite set {0, 1, ..., N-1}.
///
/// `Fin<N>` (short for "finite") is the canonical type representing exactly N
/// distinct values. It is the Swift equivalent of Idris's `Fin n` type and
/// serves as the foundation for any type that has a fixed, finite number of
/// inhabitants determined by a compile-time integer.
///
/// ## Type-Theoretic Background
///
/// In dependent type theory, `Fin n` is defined inductively:
/// ```
/// data Fin : Nat -> Type where
///     FZ : Fin (S k)           -- zero is in Fin (k+1)
///     FS : Fin k -> Fin (S k)  -- successor preserves membership
/// ```
///
/// This type is fundamental because:
/// - It provides **type-safe indexing** into fixed-size collections
/// - It represents **bounded natural numbers** at the type level
/// - It enables **exhaustive pattern matching** over finite domains
///
/// ## Relationship to Other Types
///
/// Many types are isomorphic to `Fin<N>`:
/// - `Axis<N>` (coordinate axes)
/// - `Bool` is isomorphic to `Fin<2>`
/// - `Ordering` (.less, .equal, .greater) is isomorphic to `Fin<3>`
/// - Array indices for `[T; N]` are `Fin<N>`
///
/// ## Usage
///
/// ```swift
/// // Create finite values
/// let zero: Fin<5> = .zero
/// let three = Fin<5>(3)!
///
/// // Iterate over all values
/// for i in Fin<4>.allCases {
///     print(i.rawValue)  // 0, 1, 2, 3
/// }
///
/// // Use as array index (type-safe)
/// let values = [10, 20, 30]
/// let index: Fin<3> = Fin(1)!
/// let value = values[index]  // 20
/// ```
///
/// ## References
///
/// - [Idris Fin Type](https://docs.idris-lang.org/en/latest/tutorial/typesfuns.html)
/// - [Agda Data.Fin](https://agda.github.io/agda-stdlib/Data.Fin.html)
/// - [Wikipedia: Dependent Types](https://en.wikipedia.org/wiki/Dependent_type)
///
public struct Fin<let N: Int>: Sendable, Hashable {
    /// The underlying integer value (0 to N-1).
    public let rawValue: Int

    /// Creates a finite value from an integer, if within bounds.
    ///
    /// - Parameter rawValue: An integer in the range 0..<N
    /// - Returns: The finite value, or nil if out of bounds
    @inlinable
    public init?(_ rawValue: Int) {
        guard rawValue >= 0 && rawValue < N else { return nil }
        self.rawValue = rawValue
    }

    /// Creates a finite value without bounds checking.
    ///
    /// - Precondition: `rawValue` must be in 0..<N
    @inlinable
    public init(unchecked rawValue: Int) {
        self.rawValue = rawValue
    }
}

// MARK: - Special Values

extension Fin {
    /// The zero value (first element).
    ///
    /// - Note: Ideally this would only be available when N >= 1, but Swift
    ///   does not yet support `where` clauses on properties.
    // FUTURE: public static var zero: Self where N >= 1 { ... }
    @inlinable
    public static var zero: Self {
        Self(unchecked: 0)
    }

    /// The maximum value (N - 1).
    ///
    /// - Note: Ideally this would only be available when N >= 1, but Swift
    ///   does not yet support `where` clauses on properties.
    // FUTURE: public static var max: Self where N >= 1 { ... }
    @inlinable
    public static var max: Self {
        Self(unchecked: N - 1)
    }

    /// The number of inhabitants of this type.
    @inlinable
    public static var count: Int { N }
}

// MARK: - Comparable

extension Fin: Comparable {
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

// MARK: - Codable

extension Fin: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(Int.self)
        guard let fin = Self(value) else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Value \(value) out of bounds for Fin<\(N)> (expected 0..<\(N))"
                )
            )
        }
        self = fin
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

// MARK: - Conversion

extension Fin {
    /// Converts this value to a `Fin` of a different domain.
    ///
    /// This is safe when M >= N, as every value in Fin<N> is also valid in Fin<M>.
    ///
    /// ```swift
    /// let small: Fin<3> = Fin(2)!
    /// let large: Fin<10> = small.injected()  // Still represents 2
    /// ```
    ///
    /// - Note: Ideally this would have a `where M >= N` constraint, but Swift
    ///   does not yet support comparison constraints on integer generic parameters.
    // FUTURE: public func injected<let M: Int>() -> Fin<M> where M >= N { ... }
    /// - Precondition: `rawValue` must be less than M
    @inlinable
    public func injected<let M: Int>() -> Fin<M> {
        Fin<M>(unchecked: rawValue)
    }

    /// Attempts to convert this value to a `Fin` of a smaller domain.
    ///
    /// Returns nil if the value is too large for the target domain.
    ///
    /// ```swift
    /// let large: Fin<10> = Fin(2)!
    /// let small: Fin<3>? = large.projected()  // Fin<3>(2)
    ///
    /// let tooBig: Fin<10> = Fin(5)!
    /// let failed: Fin<3>? = tooBig.projected()  // nil
    /// ```
    @inlinable
    public func projected<let M: Int>() -> Fin<M>? {
        Fin<M>(rawValue)
    }
}

// MARK: - Fin: Finite.Indexable

extension Fin: Finite.Indexable {
    /// The number of values in Fin<N>.
    @inlinable
    public static var finiteCount: Int { N }

    /// The index of this value.
    @inlinable
    public var finiteIndex: Int { rawValue }

    /// Creates a value from its index.
    @inlinable
    public init(unsafeFiniteIndex index: Int) {
        self.init(unchecked: index)
    }
}

// MARK: - Array Subscripting

extension Array {
    /// Accesses the element at a type-safe index.
    ///
    /// Using `Fin<N>` as an index guarantees the access is within bounds
    /// for arrays of exactly N elements.
    ///
    /// ```swift
    /// let colors = ["red", "green", "blue"]
    /// let index: Fin<3> = Fin(1)!
    /// print(colors[index])  // "green"
    /// ```
    @inlinable
    public subscript<let N: Int>(index: Fin<N>) -> Element {
        self[index.rawValue]
    }
}
