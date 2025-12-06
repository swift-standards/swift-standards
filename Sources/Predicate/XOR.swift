// XOR.swift
// Predicate exclusive or operator.

/// Combines two predicates with logical XOR.
///
/// The resulting predicate returns `true` if exactly one predicate returns `true`.
///
/// - Parameters:
///   - lhs: First predicate.
///   - rhs: Second predicate.
/// - Returns: A predicate that returns the XOR of both predicates.
///
/// - Example:
/// ```swift
/// let isEven: (Int) -> Bool = { $0 % 2 == 0 }
/// let isPositive: (Int) -> Bool = { $0 > 0 }
/// let isEvenXorPositive = isEven ^ isPositive
///
/// isEvenXorPositive(4)   // false (both true)
/// isEvenXorPositive(3)   // true (positive only)
/// isEvenXorPositive(-4)  // true (even only)
/// isEvenXorPositive(-3)  // false (neither)
/// ```
@inlinable
public func ^ <A>(
    lhs: @escaping (A) -> Bool,
    rhs: @escaping (A) -> Bool
) -> (A) -> Bool {
    { a in lhs(a) != rhs(a) }
}
