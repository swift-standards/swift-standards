// Time.Calendar.swift
// Time
//
// Calendar system as a first-class value

extension Time {
    /// A calendar system as a first-class value.
    ///
    /// Represents calendar systems polymorphically through their defining algorithms.
    /// Use this to perform calendar calculations that work with different calendar systems.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let calendar = Time.Calendar.gregorian
    /// let year = Time.Year(2024)
    /// let isLeap = calendar.isLeapYear(year) // true
    ///
    /// let month = try Time.Month(2)
    /// let days = calendar.daysInMonth(year, month) // 29
    /// ```
    public struct Calendar: Sendable {
        /// Determines if a year is a leap year
        public let isLeapYear: @Sendable (Time.Year) -> Bool

        /// Returns the number of days in a specific month
        public let daysInMonth: @Sendable (Time.Year, Time.Month) -> Int

        /// Creates a calendar with custom algorithms.
        ///
        /// Define a calendar system by providing its leap year and days-in-month logic.
        public init(
            isLeapYear: @escaping @Sendable (Time.Year) -> Bool,
            daysInMonth: @escaping @Sendable (Time.Year, Time.Month) -> Int
        ) {
            self.isLeapYear = isLeapYear
            self.daysInMonth = daysInMonth
        }
    }
}

// MARK: - Standard Calendars

extension Time.Calendar {
    /// The Gregorian calendar (established 1582, current international standard).
    ///
    /// Implements leap year rules: divisible by 4, except century years unless divisible by 400.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let calendar = Time.Calendar.gregorian
    /// let year = Time.Year(2024)
    /// calendar.isLeapYear(year) // true
    ///
    /// let month = try Time.Month(2)
    /// calendar.daysInMonth(year, month) // 29
    /// ```
    public static let gregorian = Time.Calendar(
        isLeapYear: Time.Calendar.Gregorian.isLeapYear,
        daysInMonth: Time.Calendar.Gregorian.daysInMonth
    )
}
