// OR.swift
// Strong Kleene OR operator for Bool?.

/// Strong Kleene three-valued logic OR.
///
/// Returns `true` if either operand is `true` (short-circuit),
/// `nil` if either operand is `nil` and neither is `true`,
/// `false` only if both operands are `false`.
///
/// ## Truth Table
///
/// | A     | B     | A \|\| B |
/// |-------|-------|----------|
/// | false | false | false    |
/// | false | true  | true     |
/// | false | nil   | nil      |
/// | true  | false | true     |
/// | true  | true  | true     |
/// | true  | nil   | true     |
/// | nil   | false | nil      |
/// | nil   | true  | true     |
/// | nil   | nil   | nil      |
///
/// - Parameters:
///   - lhs: An optional Boolean value.
///   - rhs: An autoclosure returning an optional Boolean (lazy evaluation).
/// - Returns: The three-valued OR result.
/// - Note: The right operand is only evaluated if the left is not `true`.
@inlinable
public func || (
    lhs: Bool?,
    rhs: @autoclosure () throws -> Bool?
) rethrows -> Bool? {
    if lhs == true { return true }
    let rhs = try rhs()
    if rhs == true { return true }
    if lhs == nil || rhs == nil { return nil }
    return false
}
