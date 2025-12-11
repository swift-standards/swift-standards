// Time.Millisecond.swift
// Time
//
// Millisecond representation as a refinement type

extension Time {
    /// Millisecond component (0-999).
    ///
    /// Represents 10^-3 seconds. Refinement type for type-safe sub-second precision.
    public struct Millisecond: Sendable, Equatable, Hashable, Comparable {
        /// Millisecond value (0-999)
        public let value: Int

        /// Creates a millisecond with validation.
        ///
        /// - Throws: `Millisecond.Error.invalidMillisecond` if value is not 0-999
        public init(_ value: Int) throws(Error) {
            guard (0...999).contains(value) else {
                throw Error.invalidMillisecond(value)
            }
            self.value = value
        }
    }
}

// MARK: - Error

extension Time.Millisecond {
    /// Validation errors for millisecond values.
    public enum Error: Swift.Error, Sendable, Equatable {
        /// Millisecond value is not in valid range (0-999)
        case invalidMillisecond(Int)
    }
}

// MARK: - Unchecked Initialization

extension Time.Millisecond {
    /// Creates a millisecond without validation (internal use only).
    ///
    /// - Warning: Only use when value is known to be valid (0-999)
    internal init(unchecked value: Int) {
        self.value = value
    }
}

// MARK: - Comparable

extension Time.Millisecond {
    public static func < (lhs: Time.Millisecond, rhs: Time.Millisecond) -> Bool {
        lhs.value < rhs.value
    }
}

// MARK: - Constants

extension Time.Millisecond {
    /// Zero milliseconds
    public static let zero = Time.Millisecond(unchecked: 0)
}
