// OR.swift
// Predicate disjunction operator.

/// Combines two predicates with logical OR.
///
/// The resulting predicate returns `true` if either predicate returns `true`.
///
/// - Parameters:
///   - lhs: First predicate.
///   - rhs: Second predicate.
/// - Returns: A predicate that returns the OR of both predicates.
///
/// - Example:
/// ```swift
/// let isEven: (Int) -> Bool = { $0 % 2 == 0 }
/// let isNegative: (Int) -> Bool = { $0 < 0 }
/// let isEvenOrNegative = isEven || isNegative
///
/// isEvenOrNegative(4)    // true
/// isEvenOrNegative(-3)   // true
/// isEvenOrNegative(3)    // false
/// ```
@inlinable
public func || <A>(
    lhs: @escaping (A) -> Bool,
    rhs: @escaping (A) -> Bool
) -> (A) -> Bool {
    { a in lhs(a) || rhs(a) }
}
