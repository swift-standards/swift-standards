// NOT.swift
// Strong Kleene NOT operator for Bool?.

/// Strong Kleene three-valued logic NOT.
///
/// Returns `nil` if the operand is `nil`, otherwise returns the negation.
///
/// ## Truth Table
///
/// | A     | !A    |
/// |-------|-------|
/// | false | true  |
/// | true  | false |
/// | nil   | nil   |
///
/// - Parameter value: An optional Boolean value.
/// - Returns: The negation, or `nil` if the input is `nil`.
@inlinable
public prefix func ! (value: Bool?) -> Bool? {
    guard let value else { return nil }
    return value == false
}
