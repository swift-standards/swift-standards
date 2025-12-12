// Time.Epoch.Conversion.swift
// Time
//
// Core Unix epoch conversion algorithms
// Extracted from RFC 5322 and ISO 8601 common logic

extension Time.Epoch {
    /// Unix epoch conversion algorithms.
    ///
    /// Optimized O(1) algorithms for converting between Unix epoch seconds (1970-01-01 00:00:00 UTC)
    /// and calendar components. Uses pure arithmetic based on Gregorian calendar cycle structure.
    public enum Conversion {
        // Empty - all functionality in extensions
    }
}

// MARK: - Type-Safe Public API

extension Time.Epoch.Conversion {
    /// Calculates seconds since Unix epoch from time components.
    ///
    /// Returns whole seconds only. Use `components.totalNanoseconds` for sub-second precision.
    @inlinable
    public static func secondsSinceEpoch(from components: Time) -> Int {
        secondsSinceEpoch(
            year: components.year,
            month: components.month,
            day: components.day,
            hour: components.hour,
            minute: components.minute,
            second: components.second
        )
    }
}

// MARK: - Internal Type-Safe Implementation

extension Time.Epoch.Conversion {
    /// Calculates seconds since epoch from refined type components (internal).
    ///
    /// Type-safe version that guarantees all values are pre-validated.
    @inlinable
    internal static func secondsSinceEpoch(
        year: Time.Year,
        month: Time.Month,
        day: Time.Month.Day,
        hour: Time.Hour,
        minute: Time.Minute,
        second: Time.Second
    ) -> Int {
        let days = daysSinceEpoch(year: year, month: month, day: day)

        return days * Time.Calendar.Gregorian.TimeConstants.secondsPerDay + hour.value
            * Time.Calendar.Gregorian.TimeConstants.secondsPerHour + minute.value
            * Time.Calendar.Gregorian.TimeConstants.secondsPerMinute + second.value
    }

    /// Extracts date-time components from seconds since epoch (internal).
    ///
    /// Returns raw tuple with values guaranteed valid by algorithmic construction.
    @inlinable
    internal static func componentsRaw(
        fromSecondsSinceEpoch secondsSinceEpoch: Int
    ) -> (year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) {
        let totalDays = secondsSinceEpoch / Time.Calendar.Gregorian.TimeConstants.secondsPerDay
        let secondsInDay = secondsSinceEpoch % Time.Calendar.Gregorian.TimeConstants.secondsPerDay

        let hour = secondsInDay / Time.Calendar.Gregorian.TimeConstants.secondsPerHour
        let minute =
            (secondsInDay % Time.Calendar.Gregorian.TimeConstants.secondsPerHour)
            / Time.Calendar.Gregorian
            .TimeConstants.secondsPerMinute
        let second = secondsInDay % Time.Calendar.Gregorian.TimeConstants.secondsPerMinute

        // Calculate year, month, day from days since epoch
        let (year, remainingDays) = yearAndDays(fromDaysSinceEpoch: totalDays)

        // Calculate month and day
        let daysInMonths = Time.Calendar.Gregorian.daysInMonths(year: year)
        var month = 1
        var daysInCurrentMonth = remainingDays
        for daysInMonth in daysInMonths {
            if daysInCurrentMonth < daysInMonth {
                break
            }
            daysInCurrentMonth -= daysInMonth
            month += 1
        }

        let day = daysInCurrentMonth + 1

        return (year, month, day, hour, minute, second)
    }
}

// MARK: - Year and Days Calculation (Internal)

extension Time.Epoch.Conversion {
    /// Calculates year and remaining days from days since epoch (internal).
    ///
    /// O(1) algorithm using Gregorian calendar's 400-year cycle structure (exactly 146,097 days).
    @inlinable
    internal static func yearAndDays(
        fromDaysSinceEpoch days: Int
    ) -> (year: Int, remainingDays: Int) {
        // Gregorian calendar has a 400-year cycle with exactly 146097 days
        // This cycle contains: 97 leap years and 303 common years
        let cyclesOf400 = days / Time.Calendar.Gregorian.TimeConstants.daysPer400Years
        var remainingDays = days % Time.Calendar.Gregorian.TimeConstants.daysPer400Years

        // Within each 400-year cycle, 100-year periods vary:
        // - First 3 periods: 36524 days each (24 leap years, 76 common years)
        // - Last period: 36525 days (25 leap years because year x400 is always a leap year)
        // However, since 1970 is 30 years into a cycle, we need special handling

        // For epoch 1970, we're 30 years into the 1600-2000 cycle
        // So the relevant centuries starting from 1970 are: 2000, 2100, 2200, 2300...
        // 2000 is divisible by 400 (leap year), so 1970-2069 has 25 leap years = 36525 days
        // 2100, 2200, 2300 are not divisible by 400, so they have 24 leap years = 36524 days each

        var cyclesOf100: Int
        if remainingDays >= 36525 {  // First century (1970-2070) includes year 2000
            cyclesOf100 = 1
            remainingDays -= 36525
            // Add remaining centuries (each 36524 days)
            let additionalCenturies = min(
                remainingDays / Time.Calendar.Gregorian.TimeConstants.daysPer100Years,
                2
            )  // Max 2 more (to stay within 400-year cycle)
            cyclesOf100 += additionalCenturies
            remainingDays -=
                additionalCenturies * Time.Calendar.Gregorian.TimeConstants.daysPer100Years
        } else {
            cyclesOf100 = 0
        }

        // Within each 100-year period, 4-year periods have 1461 days
        // (1 leap year, 3 common years)
        // We use min(_, 24) to stay within the 100-year boundary
        let cyclesOf4 = min(remainingDays / Time.Calendar.Gregorian.TimeConstants.daysPer4Years, 24)
        remainingDays -= cyclesOf4 * Time.Calendar.Gregorian.TimeConstants.daysPer4Years

        // Handle remaining 0-3 years, accounting for possible leap year
        var year = 1970 + cyclesOf400 * 400 + cyclesOf100 * 100 + cyclesOf4 * 4

        // Process up to 3 remaining years
        for _ in 0..<3 {
            let daysInYear =
                Time.Calendar.Gregorian.isLeapYear(year)
                ? Time.Calendar.Gregorian.TimeConstants
                    .daysPerLeapYear : Time.Calendar.Gregorian.TimeConstants.daysPerCommonYear
            if remainingDays < daysInYear {
                break
            }
            remainingDays -= daysInYear
            year += 1
        }

        return (year, remainingDays)
    }
}

// MARK: - Days Since Epoch Calculation (Internal)

extension Time.Epoch.Conversion {
    /// Calculates days since Unix epoch for a given date (internal).
    ///
    /// O(1) algorithm using leap year counting formula (no year-by-year iteration).
    @inlinable
    internal static func daysSinceEpoch(
        year: Time.Year,
        month: Time.Month,
        day: Time.Month.Day
    ) -> Int {
        // Optimized calculation avoiding year-by-year iteration
        let yearsSince1970 = year.rawValue - 1970

        // Calculate leap years between 1970 and year (exclusive)
        // Count years divisible by 4, subtract those divisible by 100, add back those divisible by 400
        let leapYears: Int
        if yearsSince1970 > 0 {
            let yearBefore = year.rawValue - 1
            leapYears =
                (yearBefore / 4 - 1970 / 4) - (yearBefore / 100 - 1970 / 100)
                + (yearBefore / 400 - 1970 / 400)
        } else {
            leapYears = 0
        }

        var days =
            yearsSince1970 * Time.Calendar.Gregorian.TimeConstants.daysPerCommonYear + leapYears

        // Add days for complete months in current year
        let monthDays = Time.Calendar.Gregorian.daysInMonths(year: year.rawValue)
        // SAFE: month.rawValue guaranteed to be in range 1-12 by Time.Month invariant
        for m in 0..<(month.rawValue - 1) {
            days += monthDays[m]
        }

        // Add remaining days
        days += day.rawValue - 1

        return days
    }
}
