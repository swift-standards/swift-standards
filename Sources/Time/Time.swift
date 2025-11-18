// Time.swift
// Time
//
// Absolute UTC time value with nanosecond precision

/// Absolute UTC time with nanosecond precision
///
/// Represents a specific moment in time using Gregorian calendar components.
/// All fields are validated using refined types. Format-agnostic foundation
/// for standards like ISO-8601 and RFC 5322.
///
/// ## Design Notes
///
/// - Uses refined types for complete type safety
/// - Sub-second precision to nanosecond (10^-9) via cascading fields
/// - Format packages (RFC 5322, ISO 8601) can wrap this with additional fields
/// - Primary initializer uses refined types and cannot fail (total function)
/// - Convenience initializer accepts raw integers and validates
public struct Time: Sendable, Equatable, Hashable {
    /// Year
    public let year: Time.Year

    /// Month (1-12)
    public let month: Time.Month

    /// Day (1-31, validated for month/year)
    public let day: Time.Month.Day

    /// Hour (0-23)
    public let hour: Time.Hour

    /// Minute (0-59)
    public let minute: Time.Minute

    /// Second (0-60, allowing leap second)
    public let second: Time.Second

    /// Millisecond (0-999)
    public let millisecond: Time.Millisecond

    /// Microsecond (0-999)
    public let microsecond: Time.Microsecond

    /// Nanosecond (0-999)
    public let nanosecond: Time.Nanosecond

    /// Creates date components with refined types (total function)
    ///
    /// This initializer cannot fail because all parameters are pre-validated refined types.
    /// This is a **total function** - always succeeds.
    ///
    /// - Parameters:
    ///   - year: Year (validated Time.Year)
    ///   - month: Month (validated Time.Month, 1-12)
    ///   - day: Day (validated Time.Month.Day, 1-31 for month/year)
    ///   - hour: Hour (validated Time.Hour, 0-23)
    ///   - minute: Minute (validated Time.Minute, 0-59)
    ///   - second: Second (validated Time.Second, 0-60)
    ///   - millisecond: Millisecond (validated Time.Millisecond, 0-999)
    ///   - microsecond: Microsecond (validated Time.Microsecond, 0-999)
    ///   - nanosecond: Nanosecond (validated Time.Nanosecond, 0-999)
    public init(
        year: Time.Year,
        month: Time.Month,
        day: Time.Month.Day,
        hour: Time.Hour,
        minute: Time.Minute,
        second: Time.Second,
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
    /// Creates time value without validation (internal use only)
    ///
    /// This static method bypasses validation and should only be used when component values
    /// are known to be valid (e.g., computed from epoch seconds).
    ///
    /// - Warning: Using this with invalid values will create an invalid Time instance.
    ///   Only use when values are guaranteed valid by construction.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let components = Time.unchecked(
    ///     year: 1970,
    ///     month: 1,
    ///     day: 1,
    ///     hour: 0,
    ///     minute: 0,
    ///     second: 0,
    ///     millisecond: 0,
    ///     microsecond: 0,
    ///     nanosecond: 0
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - year: Year (unchecked)
    ///   - month: Month (unchecked)
    ///   - day: Day (unchecked)
    ///   - hour: Hour (unchecked)
    ///   - minute: Minute (unchecked)
    ///   - second: Second (unchecked)
    ///   - millisecond: Millisecond (unchecked)
    ///   - microsecond: Microsecond (unchecked)
    ///   - nanosecond: Nanosecond (unchecked)
    /// - Returns: Time with unchecked values
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
    /// Creates date components from raw integers with validation (partial function)
    ///
    /// Convenience initializer for when you have raw integer values.
    /// Validates the date components and constructs refined types.
    ///
    /// - Parameters:
    ///   - year: Year value
    ///   - month: Month value (1-12)
    ///   - day: Day value (1-31, validated for month/year)
    ///   - hour: Hour (0-23)
    ///   - minute: Minute (0-59)
    ///   - second: Second (0-60, allowing leap second)
    ///   - millisecond: Millisecond (0-999)
    ///   - microsecond: Microsecond (0-999)
    ///   - nanosecond: Nanosecond (0-999)
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
    ) throws {
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

    /// Create date components from seconds since Unix epoch
    ///
    /// Transformation: Int (epoch seconds) → DateComponents
    ///
    /// - Parameter secondsSinceEpoch: Seconds since Unix epoch (UTC)
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
}

// MARK: - Error

extension Time {
    /// Errors that can occur when creating date components from raw integers
    public enum Error: Swift.Error, Sendable, Equatable {
        /// Month must be 1-12
        case monthOutOfRange(Int)

        /// Day must be valid for the given month and year
        case dayOutOfRange(Int, month: Int, year: Int)

        /// Hour must be 0-23
        case hourOutOfRange(Int)

        /// Minute must be 0-59
        case minuteOutOfRange(Int)

        /// Second must be 0-60 (allowing leap second)
        case secondOutOfRange(Int)

        /// Millisecond must be 0-999
        case millisecondOutOfRange(Int)

        /// Microsecond must be 0-999
        case microsecondOutOfRange(Int)

        /// Nanosecond must be 0-999
        case nanosecondOutOfRange(Int)
    }
}

// MARK: - Computed Properties

extension Time {
    /// Total nanoseconds within the current second
    ///
    /// Computes the total fractional second as nanoseconds (0-999,999,999).
    /// Calculated from cascading millisecond, microsecond, and nanosecond fields.
    ///
    /// - Returns: Total nanoseconds (0-999,999,999)
    public var totalNanoseconds: Int {
        millisecond.value * 1_000_000 + microsecond.value * 1000 + nanosecond.value
    }
}
