// Axis+CaseIterable.swift
// CaseIterable conformance for Axis<N> via Finite.Indexable.

public import Algebra

// MARK: - Axis: Finite.Indexable

/// Extends `Axis` with `Finite.Indexable` and `CaseIterable` conformance.
///
/// By conforming to `Finite.Indexable`, `Axis<N>` automatically gains
/// `CaseIterable` conformance with a zero-allocation `Finite.Sequence` as
/// the `AllCases` type.
///
/// ## Why Finite.Indexable?
///
/// `Axis<N>` is isomorphic to `Fin<N>` — both represent exactly N distinct
/// values indexed from 0 to N-1. The `Finite.Indexable` protocol captures
/// this relationship, allowing `Axis` to share iteration infrastructure
/// with other finite types.
///
/// ## Theoretical Background
///
/// This conformance solves a **value-dependent type problem** — the set of
/// valid axes depends on a *value* (`N`), not just a *type*. In type theory,
/// this falls into the domain of **dependent types**.
///
/// Languages like Idris and Agda handle this natively through their `Fin n`
/// type. Swift's integer generic parameters (SE-0452) provide a limited form
/// of value-level parameterization, and `Finite.Indexable` bridges the gap
/// to enable generic finite iteration.
///
/// ## Design Approaches Considered
///
/// ### Approach 1: Manual Extension per Dimension
///
/// ```swift
/// extension Axis where N == 1 {
///     static var allCases: [Self] { [.primary] }
/// }
/// extension Axis where N == 2 {
///     static var allCases: [Self] { [.primary, .secondary] }
/// }
/// ```
///
/// **Trade-offs:**
/// - Type-safe at compile time
/// - Cannot formally conform to `CaseIterable` protocol
/// - Requires manual extension for each dimension
///
/// ### Approach 2: Runtime Array Computation
///
/// ```swift
/// extension Axis {
///     static var allCases: [Self] {
///         (0..<N).map { Self(unchecked: $0) }
///     }
/// }
/// ```
///
/// **Trade-offs:**
/// - Single implementation for all `N`
/// - Allocates a new array on every access
///
/// ### Approach 3: Finite.Indexable Protocol (Chosen Solution)
///
/// Conform to `Finite.Indexable` and use the generic `Finite.Sequence` type.
///
/// **Trade-offs:**
/// - Zero allocation for iteration
/// - Formal `CaseIterable` conformance
/// - `RandomAccessCollection` for O(1) subscripting
/// - Reusable infrastructure for other finite types
///
/// ## Comparison with Other Languages
///
/// | Language | Feature | Capability |
/// |----------|---------|------------|
/// | **Rust** | Const generics | Supported, but iteration requires nightly features |
/// | **C++** | `std::integer_sequence` | Compile-time via template metaprogramming |
/// | **Idris** | `Fin n` | Native dependent type with compile-time enumeration |
/// | **Haskell** | Type-level naturals | Via GHC extensions (`DataKinds`, `TypeLits`) |
/// | **Swift** | Integer generics | Runtime iteration via `Finite.Indexable` |
///
/// ## Usage
///
/// ```swift
/// // Iterate over all 3D axes
/// for axis in Axis<3>.allCases {
///     print(axis.rawValue)  // 0, 1, 2
/// }
///
/// // Access by index
/// let axes = Axis<4>.allCases
/// let third = axes[2]  // Axis<4> with rawValue 2
///
/// // Use with higher-order functions
/// let doubled = Axis<2>.allCases.map { $0.rawValue * 2 }  // [0, 2]
/// ```
///
/// ## References
///
/// - [SE-0452: Integer Generic Parameters](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0452-integer-generic-parameters.md)
/// - [SE-0143: Conditional Conformances](https://github.com/apple/swift-evolution/blob/master/proposals/0143-conditional-conformances.md)
/// - [Wikipedia: Dependent Types](https://en.wikipedia.org/wiki/Dependent_type)
/// - [Swift Forums: Integer Generic Parameters](https://forums.swift.org/t/integer-generic-parameters/74181)
/// - [Rust RFC 2000: Const Generics](https://rust-lang.github.io/rfcs/2000-const-generics.html)
/// - [HaskellWiki: Type Arithmetic](https://wiki.haskell.org/Type_arithmetic)
/// - [Idris Documentation: Fin Type](https://docs.idris-lang.org/en/latest/tutorial/typesfuns.html)
///
extension Axis: Finite.Indexable {
    /// The number of axes in N-dimensional space.
    @inlinable
    public static var finiteCount: Int { N }

    /// The index of this axis (0 to N-1).
    @inlinable
    public var finiteIndex: Int { rawValue }

    /// Creates an axis from its index without bounds checking.
    ///
    /// - Precondition: `index` must be in 0..<N
    @inlinable
    public init(unsafeFiniteIndex index: Int) {
        self.init(unchecked: index)
    }
}

// MARK: - Convenience Typealias

/// A sequence of all axes in N-dimensional space.
///
/// This is a convenience typealias for `Finite.Sequence<Axis<N>>`.
/// Both names can be used interchangeably.
public typealias AxisSequence<let N: Int> = Finite.Sequence<Axis<N>>
