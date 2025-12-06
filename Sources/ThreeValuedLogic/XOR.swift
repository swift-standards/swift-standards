// XOR.swift
// Strong Kleene XOR operator for Bool?.

/// Strong Kleene three-valued logic XOR.
///
/// Returns `nil` if either operand is `nil`,
/// otherwise returns `true` if exactly one operand is `true`.
///
/// ## Truth Table
///
/// | A     | B     | A ^ B |
/// |-------|-------|-------|
/// | false | false | false |
/// | false | true  | true  |
/// | false | nil   | nil   |
/// | true  | false | true  |
/// | true  | true  | false |
/// | true  | nil   | nil   |
/// | nil   | false | nil   |
/// | nil   | true  | nil   |
/// | nil   | nil   | nil   |
///
/// - Parameters:
///   - lhs: An optional Boolean value.
///   - rhs: An optional Boolean value.
/// - Returns: The three-valued XOR result.
@inlinable
public func ^ (lhs: Bool?, rhs: Bool?) -> Bool? {
    guard let lhs, let rhs else { return nil }
    return lhs != rhs
}
