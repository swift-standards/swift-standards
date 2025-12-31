// Instant+Julian.swift
// StandardTime
//
// Conversions between Instant and Julian Day

public import Dimension

// MARK: - Instant → Julian Day

@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
extension Tagged where Tag == Coordinate.X<Time.Julian.Space>, RawValue == Double {
    /// Creates a Julian Day from an Instant.
    ///
    /// - Parameter instant: The instant to convert
    public init(_ instant: Instant) {
        self = Self.from(instant)
    }

    /// Converts an Instant to Julian Day.
    ///
    /// Uses the Unix epoch Julian Day (2440587.5) as reference.
    public static func from(_ instant: Instant) -> Self {
        let secondsPerDay: Double = 86400.0
        let days = Double(instant.secondsSinceUnixEpoch) / secondsPerDay
            + Double(instant.nanosecondFraction) / (secondsPerDay * 1_000_000_000)
        return Self.unixEpoch + Time.Julian.Offset(days)
    }
}

// MARK: - Julian Day → Instant

@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
extension Instant {
    /// Creates an Instant from a Julian Day.
    ///
    /// - Parameter julianDay: The Julian Day to convert
    public init(_ julianDay: Time.Julian.Day) {
        self = Self.from(julianDay)
    }

    /// Converts a Julian Day to Instant.
    ///
    /// Uses the Unix epoch Julian Day (2440587.5) as reference.
    public static func from(_ julianDay: Time.Julian.Day) -> Self {
        let offset = julianDay - .unixEpoch
        let days = offset._rawValue

        let secondsPerDay: Double = 86400.0
        let totalSeconds = days * secondsPerDay

        let wholeSeconds = Int64(totalSeconds)
        let fractionalSeconds = totalSeconds - Double(wholeSeconds)
        let nanoseconds = Int32(fractionalSeconds * 1_000_000_000)

        return Instant(
            __unchecked: (),
            secondsSinceUnixEpoch: wholeSeconds,
            nanosecondFraction: nanoseconds
        )
    }

    /// The Julian Day representation of this instant.
    public var julianDay: Time.Julian.Day {
        Time.Julian.Day(self)
    }
}
