// Time.Clock.Instant.Error.swift
// StandardTime
//
// Error type for clock instant operations.

extension Time.Clock {
    /// Errors that can occur during clock instant operations.
    public enum InstantError: Swift.Error, Sendable, Equatable {
        /// The operation resulted in an overflow.
        case overflow
    }
}
