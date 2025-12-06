// AND.swift
// Strong Kleene AND operator for Bool?.

/// Strong Kleene three-valued logic AND.
///
/// Returns `false` if either operand is `false` (short-circuit),
/// `nil` if either operand is `nil` and neither is `false`,
/// `true` only if both operands are `true`.
///
/// ## Truth Table
///
/// | A     | B     | A && B |
/// |-------|-------|--------|
/// | false | false | false  |
/// | false | true  | false  |
/// | false | nil   | false  |
/// | true  | false | false  |
/// | true  | true  | true   |
/// | true  | nil   | nil    |
/// | nil   | false | false  |
/// | nil   | true  | nil    |
/// | nil   | nil   | nil    |
///
/// - Parameters:
///   - lhs: An optional Boolean value.
///   - rhs: An autoclosure returning an optional Boolean (lazy evaluation).
/// - Returns: The three-valued AND result.
/// - Note: The right operand is only evaluated if the left is not `false`.
@inlinable
public func && (
    lhs: Bool?,
    rhs: @autoclosure () throws -> Bool?
) rethrows -> Bool? {
    if lhs == false { return false }
    let rhs = try rhs()
    if rhs == false { return false }
    if lhs == nil || rhs == nil { return nil }
    return true
}
