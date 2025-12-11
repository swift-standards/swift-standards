// Enumerable.swift
// Protocol for types with finitely many indexed inhabitants.

/// A finite type with indexed, enumerable values.
///
/// `Enumerable` types have exactly `caseCount` distinct values, each with a unique index 0..<caseCount. Conforming types automatically gain `CaseIterable` with a zero-allocation `RandomAccessCollection`.
///
/// Any `Enumerable` type with N cases is isomorphic to `Ordinal<N>`: `init(caseIndex:)` maps from `Ordinal<N>` to `Self`, while `caseIndex` provides the inverse.
///
/// ## Example
///
/// ```swift
/// struct CardSuit: Enumerable {
///     static let caseCount = 4
///     let caseIndex: Int
///     init(caseIndex: Int) { self.caseIndex = caseIndex }
///
///     static let hearts = CardSuit(caseIndex: 0)
///     // ... define other suits
/// }
///
/// for suit in CardSuit.allCases { ... }  // Automatic iteration
/// ```
public protocol Enumerable: CaseIterable, Sendable {
    /// Number of distinct values of this type.
    static var caseCount: Int { get }

    /// Index of this value (0 to caseCount-1).
    var caseIndex: Int { get }

    /// Creates a value from its index.
    ///
    /// - Precondition: `caseIndex` must be in 0..<caseCount
    init(caseIndex: Int)
}

// MARK: - Default CaseIterable Implementation

extension Enumerable {
    /// All values of this type (zero-allocation sequence).
    @inlinable
    public static var allCases: Enumeration<Self> {
        Enumeration()
    }
}

// MARK: - Safe Initializer

extension Enumerable {
    /// Creates a value from its index, if within bounds.
    ///
    /// - Returns: The value at that index, or `nil` if out of bounds.
    @inlinable
    public init?(validatingCaseIndex index: Int) {
        guard index >= 0 && index < Self.caseCount else { return nil }
        self.init(caseIndex: index)
    }
}
