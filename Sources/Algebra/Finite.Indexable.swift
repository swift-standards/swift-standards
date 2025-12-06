// Finite.Indexable.swift
// Protocol for types with finitely many indexed inhabitants.

// MARK: - Finite.Indexable

extension Finite {
    /// A type that has exactly N inhabitants, indexed by integers 0 to N-1.
    ///
    /// `Finite.Indexable` captures the essence of finite types that can be
    /// enumerated by their index. Any type conforming to this protocol
    /// automatically gains `CaseIterable` conformance through ``Finite/Sequence``.
    ///
    /// ## Type-Theoretic Interpretation
    ///
    /// A `Finite.Indexable` type with count N is isomorphic to `Fin<N>`.
    /// The protocol witnesses this isomorphism:
    /// - `init(finiteIndex:)` is the isomorphism `Fin<N> -> Self`
    /// - `finiteIndex` is the inverse `Self -> Fin<N>`
    ///
    /// This means every finitely indexable type is essentially a "renamed" `Fin<N>`.
    ///
    /// ## Automatic CaseIterable
    ///
    /// Types conforming to `Finite.Indexable` get `CaseIterable` conformance
    /// for free, with a zero-allocation ``Finite/Sequence`` as the `AllCases` type.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// struct CardSuit: Finite.Indexable {
    ///     static let finiteCount = 4
    ///     let finiteIndex: Int
    ///
    ///     init(unsafeFiniteIndex index: Int) {
    ///         self.finiteIndex = index
    ///     }
    ///
    ///     static let hearts = CardSuit(unsafeFiniteIndex: 0)
    ///     static let diamonds = CardSuit(unsafeFiniteIndex: 1)
    ///     static let clubs = CardSuit(unsafeFiniteIndex: 2)
    ///     static let spades = CardSuit(unsafeFiniteIndex: 3)
    /// }
    ///
    /// // Automatically iterable
    /// for suit in CardSuit.allCases { ... }
    /// ```
    ///
    /// ## For Integer-Generic Types
    ///
    /// Types parameterized by `<let N: Int>` can conform easily:
    ///
    /// ```swift
    /// extension Axis: Finite.Indexable {
    ///     public static var finiteCount: Int { N }
    ///     public var finiteIndex: Int { rawValue }
    ///     public init(unsafeFiniteIndex index: Int) {
    ///         self.init(unchecked: index)
    ///     }
    /// }
    /// ```
    ///
    public protocol Indexable: CaseIterable, Sendable {
        /// The number of distinct values of this type.
        static var finiteCount: Int { get }

        /// The index of this value (0 to finiteCount-1).
        var finiteIndex: Int { get }

        /// Creates a value from its index without bounds checking.
        ///
        /// - Precondition: `index` must be in 0..<finiteCount
        init(unsafeFiniteIndex index: Int)
    }
}

// MARK: - Default CaseIterable Implementation

extension Finite.Indexable {
    /// All values of this type, lazily enumerated.
    ///
    /// The `AllCases` associated type is inferred as `Finite.Sequence<Self>`.
    @inlinable
    public static var allCases: Finite.Sequence<Self> {
        Finite.Sequence()
    }
}

// MARK: - Safe Initializer

extension Finite.Indexable {
    /// Creates a value from its index, if within bounds.
    ///
    /// - Parameter index: An integer in 0..<finiteCount
    /// - Returns: The value at that index, or nil if out of bounds
    @inlinable
    public init?(finiteIndex index: Int) {
        guard index >= 0 && index < Self.finiteCount else { return nil }
        self.init(unsafeFiniteIndex: index)
    }
}
