//
//  Parsing.Match.Error.swift
//  swift-standards
//
//  Errors from literal and pattern matching operations.
//

extension Parsing.Match {
    /// Errors from literal and pattern matching operations.
    ///
    /// Used by parsers that match specific input against expected values:
    /// - `Literal` parsers matching exact sequences
    /// - `Predicate`-based parsers matching conditions
    /// - Array/String parsers matching content
    public enum Error: Swift.Error, Sendable, Equatable {
        /// Expected a specific literal that wasn't found.
        ///
        /// - Parameters:
        ///   - expected: Description of what was expected
        ///   - found: What was actually found in the input
        case literalMismatch(expected: String, found: String)

        /// Expected a value satisfying a predicate.
        ///
        /// - Parameter description: Description of the predicate that failed
        case predicateFailed(description: String)

        /// Expected specific byte sequence.
        ///
        /// - Parameters:
        ///   - expected: The expected bytes
        ///   - found: The actual bytes found
        case byteMismatch(expected: [UInt8], found: [UInt8])

        /// Expected end of input but found more.
        ///
        /// - Parameter remaining: Number of remaining elements
        case expectedEnd(remaining: Int)
    }
}
