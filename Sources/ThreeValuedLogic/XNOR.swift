// XNOR.swift
// Strong Kleene XNOR operator for Bool?.

// Custom infix operator for XNOR
infix operator !^ : ComparisonPrecedence

/// Strong Kleene three-valued logic XNOR (NOT XOR, equivalence).
///
/// Returns `nil` if either operand is `nil`,
/// otherwise returns `true` if both operands have the same value.
///
/// ## Truth Table
///
/// | A     | B     | A !^ B |
/// |-------|-------|--------|
/// | false | false | true   |
/// | false | true  | false  |
/// | false | nil   | nil    |
/// | true  | false | false  |
/// | true  | true  | true   |
/// | true  | nil   | nil    |
/// | nil   | false | nil    |
/// | nil   | true  | nil    |
/// | nil   | nil   | nil    |
///
/// - Parameters:
///   - lhs: An optional Boolean value.
///   - rhs: An optional Boolean value.
/// - Returns: The three-valued XNOR result.
@inlinable
public func !^ (lhs: Bool?, rhs: Bool?) -> Bool? {
    guard let lhs, let rhs else { return nil }
    return lhs == rhs
}
