// Time.swift
// Time
//
// Absolute UTC time value with nanosecond precision

/// Absolute UTC time with nanosecond precision.
///
/// Represents a specific moment in time using Gregorian calendar components with complete type safety.
/// Use this for calendar-based operations (year, month, day). For timeline arithmetic, convert to `Instant`.
///
/// ## Example
///
/// ```swift
/// // Type-safe construction with validated components
/// let year = Time.Year(2024)
/// let month = try Time.Month(11)
/// let day = try Time.Month.Day(22, in: month, year: year)
/// let time = Time(year: year, month: month, day: day, hour: .zero, minute: .zero, second: .zero)
///
/// // Convenience with raw integers
/// let time2 = try Time(year: 2024, month: 11, day: 22, hour: 14, minute: 30, second: 0)
/// print(time2.weekday) // .friday
/// ```
public struct Time: Sendable, Equatable, Hashable {
    /// Year value
    public let year: Time.Year

    /// Month value (1-12)
    public let month: Time.Month

    /// Day of month (1-31, validated for month/year)
    public let day: Time.Month.Day

    /// Hour of day (0-23)
    public let hour: Time.Hour

    /// Minute of hour (0-59)
    public let minute: Time.Minute

    /// Second of minute (0-60, allowing leap second)
    public let second: Time.Second

    /// Millisecond component (0-999)
    public let millisecond: Time.Millisecond

    /// Microsecond component (0-999)
    public let microsecond: Time.Microsecond

    /// Nanosecond component (0-999)
    public let nanosecond: Time.Nanosecond

    /// Creates time from pre-validated components.
    ///
    /// Cannot fail because all parameters are refined types that guarantee validity.
    /// Use the throwing initializer if you have raw integer values.
    public init(
        year: Time.Year,
        month: Time.Month,
        day: Time.Month.Day,
        hour: Time.Hour = .zero,
        minute: Time.Minute = .zero,
        second: Time.Second = .zero,
        millisecond: Time.Millisecond = .zero,
        microsecond: Time.Microsecond = .zero,
        nanosecond: Time.Nanosecond = .zero
    ) {
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
        self.second = second
        self.millisecond = millisecond
        self.microsecond = microsecond
        self.nanosecond = nanosecond
    }
}

// MARK: - Unchecked Initialization

extension Time {
    /// Creates time without validation (internal use only).
    ///
    /// Bypasses all validation checks. Only use when values are guaranteed valid by construction
    /// (e.g., computed from epoch seconds).
    ///
    /// - Warning: Invalid values will create an invalid `Time` instance
    internal static func unchecked(
        year: Int,
        month: Int,
        day: Int,
        hour: Int,
        minute: Int,
        second: Int,
        millisecond: Int = 0,
        microsecond: Int = 0,
        nanosecond: Int = 0
    ) -> Self {
        Self(
            year: Time.Year(year),
            month: Time.Month(unchecked: month),
            day: Time.Month.Day(unchecked: day),
            hour: Time.Hour(unchecked: hour),
            minute: Time.Minute(unchecked: minute),
            second: Time.Second(unchecked: second),
            millisecond: Time.Millisecond(unchecked: millisecond),
            microsecond: Time.Microsecond(unchecked: microsecond),
            nanosecond: Time.Nanosecond(unchecked: nanosecond)
        )
    }
}

// MARK: - Convenience Initializers

extension Time {
    /// Creates time from raw integer values with validation.
    ///
    /// Validates all components and constructs refined types. Use this when you have
    /// unvalidated integer values instead of pre-constructed refined types.
    ///
    /// - Throws: `Time.Error` if any component is out of valid range
    public init(
        year: Int,
        month: Int,
        day: Int,
        hour: Int,
        minute: Int,
        second: Int,
        millisecond: Int = 0,
        microsecond: Int = 0,
        nanosecond: Int = 0
    ) throws(Error) {
        let y = Time.Year(year)

        guard let m = try? Time.Month(month) else {
            throw Error.monthOutOfRange(month)
        }

        guard let d = try? Time.Month.Day(day, in: m, year: y) else {
            throw Error.dayOutOfRange(day, month: month, year: year)
        }

        guard let h = try? Time.Hour(hour) else {
            throw Error.hourOutOfRange(hour)
        }

        guard let min = try? Time.Minute(minute) else {
            throw Error.minuteOutOfRange(minute)
        }

        guard let s = try? Time.Second(second) else {
            throw Error.secondOutOfRange(second)
        }

        guard let ms = try? Time.Millisecond(millisecond) else {
            throw Error.millisecondOutOfRange(millisecond)
        }

        guard let us = try? Time.Microsecond(microsecond) else {
            throw Error.microsecondOutOfRange(microsecond)
        }

        guard let ns = try? Time.Nanosecond(nanosecond) else {
            throw Error.nanosecondOutOfRange(nanosecond)
        }

        self.init(
            year: y,
            month: m,
            day: d,
            hour: h,
            minute: min,
            second: s,
            millisecond: ms,
            microsecond: us,
            nanosecond: ns
        )
    }
}

extension Time {

    /// Creates time from seconds since Unix epoch.
    ///
    /// Converts Unix timestamp to calendar components. Sub-second precision is set to zero.
    public init(secondsSinceEpoch: Int) {
        let (year, month, day, hour, minute, second) = Time.Epoch.Conversion
            .componentsRaw(fromSecondsSinceEpoch: secondsSinceEpoch)

        // SAFE: componentsRaw guarantees valid values by construction
        self = .unchecked(
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second,
            millisecond: 0,
            microsecond: 0,
            nanosecond: 0
        )
    }

    /// Creates time from seconds since Unix epoch with nanosecond precision.
    ///
    /// Converts Unix timestamp with nanosecond fraction to calendar components.
    ///
    /// - Parameters:
    ///   - secondsSinceEpoch: Seconds since Unix epoch
    ///   - nanoseconds: Nanosecond fraction (0-999,999,999)
    /// - Throws: `Time.Error.nanosecondOutOfRange` if nanoseconds is invalid
    public init(secondsSinceEpoch: Int, nanoseconds: Int) throws(Error) {
        guard nanoseconds >= 0 && nanoseconds < 1_000_000_000 else {
            throw Error.nanosecondOutOfRange(nanoseconds)
        }

        let (year, month, day, hour, minute, second) = Time.Epoch.Conversion
            .componentsRaw(fromSecondsSinceEpoch: secondsSinceEpoch)

        // Extract millisecond, microsecond, nanosecond from total nanoseconds
        let millisecond = nanoseconds / 1_000_000
        let microsecond = (nanoseconds % 1_000_000) / 1_000
        let nanosecond = nanoseconds % 1_000

        // SAFE: componentsRaw guarantees valid values by construction
        // SAFE: millisecond, microsecond, nanosecond are computed to be in range
        self = .unchecked(
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second,
            millisecond: millisecond,
            microsecond: microsecond,
            nanosecond: nanosecond
        )
    }

    /// Creates time from seconds and nanoseconds without validation (internal use only).
    ///
    /// - Warning: Only use when nanoseconds is known to be valid (0-999,999,999)
    internal static func unchecked(secondsSinceEpoch: Int, nanoseconds: Int) -> Time {
        let (year, month, day, hour, minute, second) = Time.Epoch.Conversion
            .componentsRaw(fromSecondsSinceEpoch: secondsSinceEpoch)

        // Extract millisecond, microsecond, nanosecond from total nanoseconds
        let millisecond = nanoseconds / 1_000_000
        let microsecond = (nanoseconds % 1_000_000) / 1_000
        let nanosecond = nanoseconds % 1_000

        // SAFE: componentsRaw guarantees valid values by construction
        // SAFE: millisecond, microsecond, nanosecond are computed to be in range
        return .unchecked(
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second,
            millisecond: millisecond,
            microsecond: microsecond,
            nanosecond: nanosecond
        )
    }
}

// MARK: - Error

extension Time {
    /// Validation errors for time components.
    public enum Error: Swift.Error, Sendable, Equatable {
        /// Month value is not in valid range (1-12)
        case monthOutOfRange(Int)

        /// Day value is not valid for the given month and year
        case dayOutOfRange(Int, month: Int, year: Int)

        /// Hour value is not in valid range (0-23)
        case hourOutOfRange(Int)

        /// Minute value is not in valid range (0-59)
        case minuteOutOfRange(Int)

        /// Second value is not in valid range (0-60, allowing leap second)
        case secondOutOfRange(Int)

        /// Millisecond value is not in valid range (0-999)
        case millisecondOutOfRange(Int)

        /// Microsecond value is not in valid range (0-999)
        case microsecondOutOfRange(Int)

        /// Nanosecond value is not in valid range (0-999)
        case nanosecondOutOfRange(Int)
    }
}

// MARK: - Computed Properties

extension Time {
    /// Total nanoseconds within the current second (0-999,999,999).
    ///
    /// Combines millisecond, microsecond, and nanosecond fields into a single value.
    @inlinable
    public var totalNanoseconds: Int {
        Self.totalNanoseconds(
            millisecond: millisecond,
            microsecond: microsecond,
            nanosecond: nanosecond
        )
    }

    /// Calculates total nanoseconds within the current second (0-999,999,999).
    ///
    /// Static function that combines millisecond, microsecond, and nanosecond fields into a single value.
    @inlinable
    public static func totalNanoseconds(
        millisecond: Time.Millisecond,
        microsecond: Time.Microsecond,
        nanosecond: Time.Nanosecond
    ) -> Int {
        millisecond.value * 1_000_000 + microsecond.value * 1000 + nanosecond.value
    }

    /// Day of the week for this date.
    ///
    /// Calculated using Zeller's congruence algorithm.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let time = try Time(year: 2024, month: 1, day: 15, hour: 10, minute: 30, second: 0)
    /// print(time.weekday) // .monday
    /// ```
    @inlinable
    public var weekday: Time.Weekday {
        Self.weekday(year: year, month: month, day: day)
    }

    /// Calculates the day of the week for a given date.
    ///
    /// Uses Zeller's congruence algorithm to determine the weekday.
    @inlinable
    public static func weekday(year: Time.Year, month: Time.Month, day: Time.Month.Day) -> Time.Weekday {
        Time.Weekday(year: year, month: month, day: day)
    }

    /// Seconds since Unix epoch (1970-01-01 00:00:00 UTC).
    ///
    /// Calculates using O(1) algorithm based on Gregorian calendar cycle structure.
    /// Use `totalNanoseconds` for the sub-second component.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let time = try Time(year: 1970, month: 1, day: 1, hour: 0, minute: 0, second: 0)
    /// print(time.secondsSinceEpoch) // 0
    ///
    /// let time2 = try Time(year: 2024, month: 1, day: 1, hour: 0, minute: 0, second: 0)
    /// print(time2.secondsSinceEpoch) // 1704067200
    /// ```
    @inlinable
    public var secondsSinceEpoch: Int {
        Self.secondsSinceEpoch(from: self)
    }

    /// Calculates seconds since Unix epoch (1970-01-01 00:00:00 UTC).
    ///
    /// O(1) algorithm based on Gregorian calendar cycle structure.
    @inlinable
    public static func secondsSinceEpoch(from time: Time) -> Int {
        Time.Epoch.Conversion.secondsSinceEpoch(from: time)
    }
}

// MARK: - Instant Conversion

@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
extension Time {
    /// Creates time from instant.
    ///
    /// Converts timeline representation to calendar representation with full nanosecond precision.
    public init(_ instant: Instant) {
        // SAFE: Instant guarantees nanosecondFraction is in valid range [0, 1_000_000_000)
        self = .unchecked(
            secondsSinceEpoch: Int(instant.secondsSinceUnixEpoch),
            nanoseconds: Int(instant.nanosecondFraction)
        )
    }
}

// MARK: - Codable

#if Codable
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    extension Time: Codable {
        public init(from decoder: any Decoder) throws {
            let instant = try Instant(from: decoder)
            self.init(instant)
        }

        public func encode(to encoder: any Encoder) throws {
            try Instant(self).encode(to: encoder)
        }
    }
#endif
