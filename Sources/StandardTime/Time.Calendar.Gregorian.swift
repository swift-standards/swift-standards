// Time.Calendar.Gregorian.swift
// Time
//
// Core Gregorian calendar algorithms and constants
// Extracted from RFC 5322 and ISO 8601 common logic

extension Time.Calendar {
    /// Gregorian calendar algorithms and constants.
    ///
    /// Pure calendar logic shared across date-time formats (RFC 5322, ISO 8601, etc.).
    /// All algorithms are O(1) where possible, with zero Foundation dependency.
    public enum Gregorian {
        // Empty - all functionality in extensions
    }
}

// MARK: - Time Constants

extension Time.Calendar.Gregorian {
    /// Standard time unit conversions.
    public enum TimeConstants {
        /// Seconds in one minute (60)
        public static let secondsPerMinute = 60

        /// Seconds in one hour (3,600)
        public static let secondsPerHour = 3600

        /// Seconds in one day (86,400)
        public static let secondsPerDay = 86400

        /// Days in a common year (365)
        public static let daysPerCommonYear = 365

        /// Days in a leap year (366)
        public static let daysPerLeapYear = 366

        /// Days in a 4-year cycle (1,461)
        public static let daysPer4Years = 1461

        /// Days in a 100-year cycle (36,524)
        public static let daysPer100Years = 36524

        /// Days in a 400-year cycle (146,097)
        public static let daysPer400Years = 146_097
    }
}

// MARK: - Leap Year

extension Time.Calendar.Gregorian {
    /// Determines if a year is a leap year.
    ///
    /// Applies Gregorian rules: divisible by 4, except century years unless divisible by 400.
    ///
    /// ## Example
    ///
    /// ```swift
    /// Time.Calendar.Gregorian.isLeapYear(Time.Year(2000)) // true (÷400)
    /// Time.Calendar.Gregorian.isLeapYear(Time.Year(2100)) // false (÷100, not ÷400)
    /// Time.Calendar.Gregorian.isLeapYear(Time.Year(2024)) // true (÷4, not ÷100)
    /// ```
    @inlinable
    public static func isLeapYear(_ year: Time.Year) -> Bool {
        let y = year.rawValue
        return (y % 4 == 0 && y % 100 != 0) || (y % 400 == 0)
    }

    /// Determines if a year is a leap year (convenience overload).
    @inlinable
    public static func isLeapYear(_ year: Int) -> Bool {
        isLeapYear(Time.Year(year))
    }
}

// MARK: - Days in Month

extension Time.Calendar.Gregorian {
    /// Days in each month for a common (non-leap) year
    /// Index 0 = January, Index 11 = December
    @usableFromInline
    internal static let daysInCommonYearMonths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    /// Days in each month for a leap year
    /// Index 0 = January, Index 11 = December
    @usableFromInline
    internal static let daysInLeapYearMonths = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    /// Returns the number of days in a specific month.
    ///
    /// February varies by year (28 or 29 days depending on leap year).
    @inlinable
    public static func daysInMonth(_ year: Time.Year, _ month: Time.Month) -> Int {
        let monthArray = isLeapYear(year) ? daysInLeapYearMonths : daysInCommonYearMonths
        // SAFE: month.value is guaranteed to be in range 1-12 by Time.Month invariant
        return monthArray[month.rawValue - 1]
    }

    /// Returns array of days in each month for a given year (12 integers).
    @inlinable
    public static func daysInMonths(year: Int) -> [Int] {
        isLeapYear(year) ? daysInLeapYearMonths : daysInCommonYearMonths
    }

    /// Returns the number of days in a specific month (internal Int version).
    ///
    /// Internal convenience for epoch conversion code.
    ///
    /// - Warning: Caller must guarantee month is 1-12
    @inlinable
    internal static func daysInMonth(year: Int, month: Int) -> Int {
        let months = daysInMonths(year: year)
        // UNSAFE: Caller must guarantee month ∈ [1,12]
        return months[month - 1]
    }
}
