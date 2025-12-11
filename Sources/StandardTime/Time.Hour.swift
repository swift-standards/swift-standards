// Time.Hour.swift
// Time
//
// Hour representation as a refinement type

extension Time {
    /// Hour of day (0-23).
    ///
    /// Refinement type constraining integers to valid hour range.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let hour = try Time.Hour(14) // 2 PM
    /// let midnight = Time.Hour.zero
    /// ```
    public struct Hour: Sendable, Equatable, Hashable, Comparable {
        /// Hour value (0-23)
        public let value: Int

        /// Creates an hour with validation.
        ///
        /// - Throws: `Hour.Error.invalidHour` if value is not 0-23
        public init(_ value: Int) throws(Error) {
            guard (0...23).contains(value) else {
                throw Error.invalidHour(value)
            }
            self.value = value
        }
    }
}

// MARK: - Error

extension Time.Hour {
    /// Validation errors for hour values.
    public enum Error: Swift.Error, Sendable, Equatable {
        /// Hour value is not in valid range (0-23)
        case invalidHour(Int)
    }
}

// MARK: - Unchecked Initialization

extension Time.Hour {
    /// Creates an hour without validation (internal use only).
    ///
    /// - Warning: Only use when value is known to be valid (0-23)
    internal init(unchecked value: Int) {
        self.value = value
    }
}

// MARK: - Comparable

extension Time.Hour {
    public static func < (lhs: Time.Hour, rhs: Time.Hour) -> Bool {
        lhs.value < rhs.value
    }
}

// MARK: - Constants

extension Time.Hour {
    /// Zero hours (midnight)
    public static let zero = Time.Hour(unchecked: 0)
}
