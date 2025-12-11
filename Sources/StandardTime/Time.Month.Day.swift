// Time.Month.Day.swift
// Time
//
// Day-of-month representation as a dependent refinement type

extension Time.Month {
    /// Day within a month (1-31, validated against month/year).
    ///
    /// Dependent refinement type—valid range depends on the month and year context.
    /// For example, February 29 is only valid in leap years.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let year = Time.Year(2024)
    /// let feb = Time.Month.february
    /// let day = try Time.Month.Day(29, in: feb, year: year) // Valid in leap year
    /// ```
    public struct Day: Sendable, Equatable, Hashable, Comparable {
        /// Day value (1-31)
        public let rawValue: Int

        /// Creates a day with validation against month and year.
        ///
        /// Validates that the day exists in the given month/year combination.
        ///
        /// - Throws: `Day.Error.invalidDay` if day is invalid for the month/year
        public init(_ value: Int, in month: Time.Month, year: Time.Year) throws(Error) {
            let maxDay = month.days(in: year)
            guard (1...maxDay).contains(value) else {
                throw Error.invalidDay(value, month: month, year: year)
            }
            self.rawValue = value
        }
    }
}

// MARK: - Error

extension Time.Month.Day {
    /// Validation errors for day values.
    public enum Error: Swift.Error, Sendable, Equatable {
        /// Day value is not valid for the given month and year
        case invalidDay(Int, month: Time.Month, year: Time.Year)
    }
}

// MARK: - Unchecked Initialization

extension Time.Month.Day {
    /// Creates a day without validation (internal use only).
    ///
    /// - Warning: Only use when value is known to be valid for the context
    internal init(unchecked value: Int) {
        self.rawValue = value
    }
}

// MARK: - Comparable

extension Time.Month.Day {
    public static func < (lhs: Time.Month.Day, rhs: Time.Month.Day) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

// MARK: - Int Comparison

extension Time.Month.Day {
    /// Compare day with integer value
    public static func == (lhs: Time.Month.Day, rhs: Int) -> Bool {
        lhs.rawValue == rhs
    }

    /// Compare integer value with day
    public static func == (lhs: Int, rhs: Time.Month.Day) -> Bool {
        lhs == rhs.rawValue
    }
}
