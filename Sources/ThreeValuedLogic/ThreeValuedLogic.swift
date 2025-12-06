// ThreeValuedLogic.swift
// Strong Kleene three-valued logic for Bool?.

/// Three-valued logic operators for `Bool?` using Strong Kleene semantics.
///
/// Strong Kleene logic (K3) extends classical boolean logic with a third
/// value representing "unknown" (`nil`). It preserves classical logic
/// for known values while propagating uncertainty appropriately.
///
/// ## Semantics
///
/// Strong Kleene logic allows definite conclusions when possible:
/// - `false && unknown = false` (short-circuits)
/// - `true || unknown = true` (short-circuits)
/// - `unknown && unknown = unknown`
///
/// This matches SQL NULL semantics and is useful for:
/// - Database queries with nullable columns
/// - Legal/regulatory logic with incomplete information
/// - Decision trees with uncertain inputs
///
/// ## Comparison with Weak Kleene
///
/// Weak Kleene (Bochvar) propagates `nil` whenever any operand is `nil`.
/// Strong Kleene short-circuits when a definite conclusion is possible.
///
/// | Logic  | `false && nil` | `true \|\| nil` |
/// |--------|----------------|-----------------|
/// | Strong |     `false`    |     `true`      |
/// | Weak   |     `nil`      |     `nil`       |
///
/// ## Example
///
/// ```swift
/// let a: Bool? = true
/// let b: Bool? = false
/// let c: Bool? = nil
///
/// a && b  // false (definite)
/// a && c  // nil (uncertain)
/// b && c  // false (short-circuit on false)
/// a || c  // true (short-circuit on true)
/// b || c  // nil (uncertain)
/// !c      // nil (uncertain)
/// ```
public enum ThreeValuedLogic {}
