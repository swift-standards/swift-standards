// Time.Second.swift
// Time
//
// Second representation as a refinement type

extension Time {
    /// Second of minute (0-60, allowing leap second).
    ///
    /// Refinement type constraining integers to valid second range.
    /// Range is 0-60 to accommodate leap seconds.
    public struct Second: Sendable, Equatable, Hashable, Comparable {
        /// Second value (0-60)
        public let value: Int

        /// Creates a second with validation.
        ///
        /// - Throws: `Second.Error.invalidSecond` if value is not 0-60
        public init(_ value: Int) throws(Error) {
            guard (0...60).contains(value) else {
                throw Error.invalidSecond(value)
            }
            self.value = value
        }
    }
}

// MARK: - Error

extension Time.Second {
    /// Validation errors for second values.
    public enum Error: Swift.Error, Sendable, Equatable {
        /// Second value is not in valid range (0-60, allowing leap second)
        case invalidSecond(Int)
    }
}

// MARK: - Unchecked Initialization

extension Time.Second {
    /// Creates a second without validation (internal use only).
    ///
    /// - Warning: Only use when value is known to be valid (0-60)
    internal init(unchecked value: Int) {
        self.value = value
    }
}

// MARK: - Comparable

extension Time.Second {
    public static func < (lhs: Time.Second, rhs: Time.Second) -> Bool {
        lhs.value < rhs.value
    }
}

extension Time.Second {
    /// Zero seconds
    public static let zero = Time.Second(unchecked: 0)
}
