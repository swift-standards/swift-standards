// NOR.swift
// Strong Kleene NOR operator for Bool?.

// Custom infix operator for NOR
infix operator !|| : LogicalDisjunctionPrecedence

/// Strong Kleene three-valued logic NOR (NOT OR).
///
/// Returns the negation of the OR result.
///
/// ## Truth Table
///
/// | A     | B     | A !\|\| B |
/// |-------|-------|-----------|
/// | false | false | true      |
/// | false | true  | false     |
/// | false | nil   | nil       |
/// | true  | false | false     |
/// | true  | true  | false     |
/// | true  | nil   | false     |
/// | nil   | false | nil       |
/// | nil   | true  | false     |
/// | nil   | nil   | nil       |
///
/// - Parameters:
///   - lhs: An optional Boolean value.
///   - rhs: An autoclosure returning an optional Boolean (lazy evaluation).
/// - Returns: The three-valued NOR result.
@inlinable
public func !|| (
    lhs: Bool?,
    rhs: @autoclosure () throws -> Bool?
) rethrows -> Bool? {
    try !(lhs || rhs())
}
