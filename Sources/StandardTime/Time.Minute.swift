// Time.Minute.swift
// Time
//
// Minute representation as a refinement type

extension Time {
    /// Minute of hour (0-59).
    ///
    /// Refinement type constraining integers to valid minute range.
    public struct Minute: Sendable, Equatable, Hashable, Comparable {
        /// Minute value (0-59)
        public let value: Int

        /// Creates a minute with validation.
        ///
        /// - Throws: `Minute.Error.invalidMinute` if value is not 0-59
        public init(_ value: Int) throws(Error) {
            guard (0...59).contains(value) else {
                throw Error.invalidMinute(value)
            }
            self.value = value
        }
    }
}

// MARK: - Error

extension Time.Minute {
    /// Validation errors for minute values.
    public enum Error: Swift.Error, Sendable, Equatable {
        /// Minute value is not in valid range (0-59)
        case invalidMinute(Int)
    }
}

// MARK: - Unchecked Initialization

extension Time.Minute {
    /// Creates a minute without validation (internal use only).
    ///
    /// - Warning: Only use when value is known to be valid (0-59)
    internal init(unchecked value: Int) {
        self.value = value
    }
}

// MARK: - Comparable

extension Time.Minute {
    public static func < (lhs: Time.Minute, rhs: Time.Minute) -> Bool {
        lhs.value < rhs.value
    }
}

extension Time.Minute {
    /// Zero minutes
    public static let zero = Time.Minute(unchecked: 0)
}
