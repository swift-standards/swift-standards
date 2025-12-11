// Time.TimezoneOffset.swift
// Time
//
// Type-safe timezone offset representation

extension Time {
    /// Timezone offset from UTC in seconds.
    ///
    /// Positive values represent timezones east of UTC (ahead), negative values west (behind).
    /// Construct from hours/minutes or raw seconds.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let utc = Time.TimezoneOffset.utc
    /// let est = Time.TimezoneOffset(hours: -5) // EST: -5:00
    /// let ist = Time.TimezoneOffset(hours: 5, minutes: 30) // IST: +5:30
    /// print(ist.description) // "+05:30"
    /// ```
    public struct TimezoneOffset: Sendable, Equatable, Hashable, Codable {
        /// Offset in seconds from UTC (positive = east, negative = west)
        public let seconds: Int

        /// Creates timezone offset from seconds.
        public init(seconds: Int) {
            self.seconds = seconds
        }

        /// Creates timezone offset from hours and minutes.
        ///
        /// Sign of minutes follows the sign of hours.
        public init(hours: Int, minutes: Int = 0) {
            let sign = hours < 0 ? -1 : 1
            self.seconds =
                hours * Time.Calendar.Gregorian.TimeConstants.secondsPerHour + sign * minutes
                * Time.Calendar.Gregorian.TimeConstants.secondsPerMinute
        }

        /// UTC timezone offset (zero)
        public static let utc = TimezoneOffset(seconds: 0)

        /// Hour component of the offset
        public var hours: Int {
            seconds / Time.Calendar.Gregorian.TimeConstants.secondsPerHour
        }

        /// Minute component of the offset (0-59)
        public var minutes: Int {
            abs(seconds % Time.Calendar.Gregorian.TimeConstants.secondsPerHour)
                / Time.Calendar.Gregorian.TimeConstants.secondsPerMinute
        }

        /// Whether this is UTC (zero offset)
        public var isUTC: Bool {
            seconds == 0
        }
    }
}

// MARK: - CustomStringConvertible

extension Time.TimezoneOffset: CustomStringConvertible {
    /// Formats as +HH:MM or -HH:MM.
    public var description: String {
        if seconds == 0 {
            return "+00:00"
        }

        let sign = seconds >= 0 ? "+" : "-"
        let absHours = abs(hours)
        let absMinutes = minutes

        let hourStr = absHours < 10 ? "0\(absHours)" : "\(absHours)"
        let minStr = absMinutes < 10 ? "0\(absMinutes)" : "\(absMinutes)"

        return "\(sign)\(hourStr):\(minStr)"
    }
}

// MARK: - Comparable

extension Time.TimezoneOffset: Comparable {
    public static func < (lhs: Time.TimezoneOffset, rhs: Time.TimezoneOffset) -> Bool {
        lhs.seconds < rhs.seconds
    }
}
