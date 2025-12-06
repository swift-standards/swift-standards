// Predicate.swift
// Predicate composition operators.

/// Operators for composing predicates (functions returning Bool).
///
/// A predicate is any function `(A) -> Bool` that tests a condition.
/// This module provides logical operators to combine predicates
/// without manually writing closure composition.
///
/// ## Example
///
/// ```swift
/// let isEven: (Int) -> Bool = { $0 % 2 == 0 }
/// let isPositive: (Int) -> Bool = { $0 > 0 }
///
/// let isEvenAndPositive = isEven && isPositive
/// let isEvenOrPositive = isEven || isPositive
/// let isOdd = !isEven
///
/// isEvenAndPositive(4)   // true
/// isEvenAndPositive(-4)  // false
/// isOdd(3)               // true
/// ```
///
/// ## Use Cases
///
/// - Filtering collections: `array.filter(isEven && isPositive)`
/// - Form validation: `validate(isNotEmpty && isValidEmail)`
/// - Access control: `hasPermission(isAdmin || isOwner)`
public enum Predicate {}
