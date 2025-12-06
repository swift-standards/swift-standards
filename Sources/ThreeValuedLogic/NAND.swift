// NAND.swift
// Strong Kleene NAND operator for Bool?.

// Custom infix operator for NAND
infix operator !&& : LogicalConjunctionPrecedence

/// Strong Kleene three-valued logic NAND (NOT AND).
///
/// Returns the negation of the AND result.
///
/// ## Truth Table
///
/// | A     | B     | A !&& B |
/// |-------|-------|---------|
/// | false | false | true    |
/// | false | true  | true    |
/// | false | nil   | true    |
/// | true  | false | true    |
/// | true  | true  | false   |
/// | true  | nil   | nil     |
/// | nil   | false | true    |
/// | nil   | true  | nil     |
/// | nil   | nil   | nil     |
///
/// - Parameters:
///   - lhs: An optional Boolean value.
///   - rhs: An autoclosure returning an optional Boolean (lazy evaluation).
/// - Returns: The three-valued NAND result.
@inlinable
public func !&& (
    lhs: Bool?,
    rhs: @autoclosure () throws -> Bool?
) rethrows -> Bool? {
    try !(lhs && rhs())
}
