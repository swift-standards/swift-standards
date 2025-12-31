// Time.Julian.Day+Time.swift
// StandardTime
//
// Conversions between Time and Julian Day

public import Dimension

// MARK: - Time → Julian Day

extension Tagged where Tag == Coordinate.X<Time.Julian.Space>, RawValue == Double {
    /// Creates a Julian Day from a Time value.
    ///
    /// Uses the standard algorithm for proleptic Gregorian calendar.
    ///
    /// - Parameter time: The time to convert
    public init(_ time: Time) {
        self = Self.from(time)
    }

    /// Converts a Time value to Julian Day.
    ///
    /// Algorithm: Fliegel & Van Flandern (1968), extended for sub-day precision.
    public static func from(_ time: Time) -> Self {
        let year = time.year.rawValue
        let month = time.month.rawValue
        let day = time.day.rawValue

        // Adjust year and month for algorithm (Jan/Feb are months 13/14 of previous year)
        let a = (14 - month) / 12
        let y = year + 4800 - a
        let m = month + 12 * a - 3

        // Julian Day Number at noon
        let jdn = day + (153 * m + 2) / 5 + 365 * y + y / 4 - y / 100 + y / 400 - 32045

        // Add fractional day (JD starts at noon, so subtract 0.5 then add time fraction)
        let dayFraction = (Double(time.hour.value) - 12.0) / 24.0
            + Double(time.minute.value) / 1440.0
            + Double(time.second.value) / 86400.0
            + Double(time.totalNanoseconds) / 86_400_000_000_000.0

        return Self(Double(jdn) + dayFraction)
    }
}

// MARK: - Julian Day → Time

extension Time {
    /// Creates a Time from a Julian Day.
    ///
    /// - Parameter julianDay: The Julian Day to convert
    public init(_ julianDay: Time.Julian.Day) {
        self = Self.from(julianDay)
    }

    /// Converts a Julian Day to Time.
    ///
    /// Algorithm: Richards (Explanatory Supplement to the Astronomical Almanac, 3rd ed.)
    public static func from(_ julianDay: Time.Julian.Day) -> Self {
        let jd = julianDay._rawValue

        // Extract fractional day for time components
        // JD starts at noon, so JD.0 = noon, JD.5 = midnight
        let jdPlus = jd + 0.5
        let z = Int(jdPlus.rounded(.down))
        let f = jdPlus - Double(z)

        // Richards algorithm for Gregorian calendar
        let y = 4716
        let j = 1401
        let m = 2
        let n = 12
        let r = 4
        let p = 1461
        let v = 3
        let u = 5
        let s = 153
        let w = 2
        let b = 274277
        let c = -38

        let f1 = z + j + (((4 * z + b) / 146097) * 3) / 4 + c
        let e = r * f1 + v
        let g = (e % p) / r
        let h = u * g + w
        let day = (h % s) / u + 1
        let month = ((h / s + m) % n) + 1
        let year = e / p - y + (n + m - month) / n

        // Extract time components from fractional day (f is fraction from midnight)
        let totalSeconds = f * 86400.0
        let hour = Int(totalSeconds / 3600.0)
        let remainingAfterHour = totalSeconds - Double(hour * 3600)
        let minute = Int(remainingAfterHour / 60.0)
        let remainingAfterMinute = remainingAfterHour - Double(minute * 60)
        let second = Int(remainingAfterMinute)
        let nanoseconds = Int((remainingAfterMinute - Double(second)) * 1_000_000_000)

        return Time(
            __unchecked: (),
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second,
            millisecond: nanoseconds / 1_000_000,
            microsecond: (nanoseconds % 1_000_000) / 1000,
            nanosecond: nanoseconds % 1000
        )
    }
}

// MARK: - Time Convenience

extension Time {
    /// The Julian Day representation of this time.
    public var julianDay: Time.Julian.Day {
        Time.Julian.Day(self)
    }
}
