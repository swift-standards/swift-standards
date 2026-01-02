//
//  Parsing.Constraint.Error.swift
//  swift-standards
//
//  Errors from validation constraints.
//

extension Parsing.Constraint {
    /// Errors from validation constraints on parsed values or counts.
    ///
    /// Used by parsers that enforce constraints:
    /// - `Many` enforcing minimum/maximum element counts
    /// - `Filter` validating parsed output
    /// - Range validators checking numeric bounds
    public enum Error: Swift.Error, Sendable, Equatable {
        /// Element count below minimum requirement.
        ///
        /// - Parameters:
        ///   - expected: The minimum required count
        ///   - got: The actual count achieved
        case countTooLow(expected: Int, got: Int)

        /// Element count above maximum allowed.
        ///
        /// - Parameters:
        ///   - expected: The maximum allowed count
        ///   - got: The actual count achieved
        case countTooHigh(expected: Int, got: Int)

        /// Value failed a validation predicate.
        ///
        /// - Parameters:
        ///   - value: String representation of the failing value
        ///   - reason: Description of why validation failed
        case validationFailed(value: String, reason: String)
    }
}
