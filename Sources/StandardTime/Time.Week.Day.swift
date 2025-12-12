// Time.Weekday.swift
// Time
//
// Weekday representation with initializer-based calculation
// Supports different numbering conventions (ISO 8601 and Gregorian/Western)

extension Time {
    public typealias Weekday = Time.Week.Day
}

extension Time.Week {
    /// Day of the week (Sunday through Saturday).
    ///
    /// Format-agnostic representation of weekdays. Calculate from calendar dates using
    /// Zeller's congruence algorithm. Numbering and localized names are format-specific.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let weekday = try Time.Weekday(year: 2024, month: 1, day: 15)
    /// print(weekday) // .monday
    ///
    /// // Or with refined types
    /// let year = Time.Year(2024)
    /// let month = try Time.Month(1)
    /// let day = try Time.Month.Day(15, in: month, year: year)
    /// let weekday2 = Time.Weekday(year: year, month: month, day: day)
    /// ```
    public enum Day: Sendable, Equatable, Hashable, CaseIterable {
        case sunday
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
    }
}

extension Time.Week.Day {
    /// Validation errors when calculating weekday from date components.
    public enum Error: Swift.Error, Sendable, Equatable {
        /// Month value is not in valid range (1-12)
        case invalidMonth(Int)

        /// Day value is not valid for the given month and year
        case invalidDay(Int, month: Int, year: Int)
    }
}

extension Time.Weekday {

    /// Calculates the weekday for a given date using Zeller's congruence.
    ///
    /// Cannot fail because all parameters are pre-validated refined types.
    @inlinable
    public init(
        year: Time.Year,
        month: Time.Month,
        day: Time.Month.Day
    ) {
        self = Self.calculate(year: year, month: month, day: day)
    }

    /// Calculates the weekday for a given date using Zeller's congruence.
    ///
    /// Static function that implements the core algorithm. Cannot fail because all parameters are pre-validated refined types.
    @inlinable
    public static func calculate(
        year: Time.Year,
        month: Time.Month,
        day: Time.Month.Day
    ) -> Time.Weekday {
        var y = year.rawValue
        var m = month.rawValue

        // Zeller's congruence: treat Jan/Feb as months 13/14 of previous year
        if m < 3 {
            m += 12
            y -= 1
        }

        let q = day.rawValue
        let K = y % 100
        let J = y / 100

        // Zeller's formula
        let h = (q + ((13 * (m + 1)) / 5) + K + (K / 4) + (J / 4) - (2 * J)) % 7

        // Convert from Zeller's (0=Saturday) to Gregorian (0=Sunday)
        // Modulo 7 always returns 0-6, so this switch is exhaustive
        let gregorianDay = (h + 6) % 7

        switch gregorianDay {
        case 0: return .sunday
        case 1: return .monday
        case 2: return .tuesday
        case 3: return .wednesday
        case 4: return .thursday
        case 5: return .friday
        default: return .saturday  // Must be 6 (only remaining case)
        }
    }

    /// Calculates the weekday for a given date from raw integers.
    ///
    /// Validates date components before calculating weekday.
    ///
    /// - Throws: `Time.Weekday.Error` if date components are invalid
    public init(year: Int, month: Int, day: Int) throws(Error) {
        let y = Time.Year(year)

        guard let m = try? Time.Month(month) else {
            throw Error.invalidMonth(month)
        }

        guard let d = try? Time.Month.Day(day, in: m, year: y) else {
            throw Error.invalidDay(day, month: month, year: year)
        }

        self.init(year: y, month: m, day: d)
    }
}
