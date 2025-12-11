// Predicate+TernaryLogic.swift
// Three-valued logic lifting for predicates.

public import TernaryLogic

// MARK: - Three-Valued Evaluation

extension Predicate {
    /// Evaluates this predicate on an optional value with three-valued logic.
    ///
    /// Returns `.unknown` for `nil` input, following Strong Kleene semantics.
    /// This enables composable three-valued logic with optional values.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let isEven = Predicate<Int> { $0 % 2 == 0 }
    ///
    /// let a: Bool? = isEven(4)    // .some(true)
    /// let b: Bool? = isEven(nil)  // nil (unknown)
    ///
    /// // Compose with three-valued operators
    /// let x: Int? = 4
    /// let y: Int? = nil
    /// isEven(y) && isEven(x)  // nil && true = nil
    /// isEven(y) || isEven(x)  // nil || true = true
    /// ```
    @inlinable
    public func callAsFunction<L: TernaryLogic.`Protocol`>(_ value: T?) -> L {
        guard let value else { return .unknown }
        return evaluate(value) ? .true : .false
    }
}
