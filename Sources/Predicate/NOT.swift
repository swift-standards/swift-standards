// NOT.swift
// Predicate negation operator.

/// Negates a predicate.
///
/// The resulting predicate returns the logical NOT of the original.
///
/// - Parameter predicate: The predicate to negate.
/// - Returns: A predicate that returns the negation.
///
/// - Example:
/// ```swift
/// let isEven: (Int) -> Bool = { $0 % 2 == 0 }
/// let isOdd = !isEven
///
/// isOdd(3)  // true
/// isOdd(4)  // false
/// ```
@inlinable
public prefix func ! <A>(
    predicate: @escaping (A) -> Bool
) -> (A) -> Bool {
    { a in predicate(a) == false }
}
