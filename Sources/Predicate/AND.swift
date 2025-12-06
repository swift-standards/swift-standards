// AND.swift
// Predicate conjunction operator.

/// Combines two predicates with logical AND.
///
/// The resulting predicate returns `true` only if both predicates return `true`.
///
/// - Parameters:
///   - lhs: First predicate.
///   - rhs: Second predicate.
/// - Returns: A predicate that returns the AND of both predicates.
///
/// - Example:
/// ```swift
/// let isEven: (Int) -> Bool = { $0 % 2 == 0 }
/// let isPositive: (Int) -> Bool = { $0 > 0 }
/// let isEvenAndPositive = isEven && isPositive
///
/// isEvenAndPositive(4)   // true
/// isEvenAndPositive(-4)  // false
/// isEvenAndPositive(3)   // false
/// ```
@inlinable
public func && <A>(
    lhs: @escaping (A) -> Bool,
    rhs: @escaping (A) -> Bool
) -> (A) -> Bool {
    { a in lhs(a) && rhs(a) }
}
