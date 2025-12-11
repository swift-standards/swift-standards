// Time.Epoch.swift
// Time
//
// Epoch as a first-class reference point in time

extension Time {
    /// A reference point in time for measuring time intervals.
    ///
    /// Different systems use different epochs as their zero point (Unix: 1970, NTP: 1900, GPS: 1980).
    /// Use predefined epoch constants or create custom reference points.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let unix = Time.Epoch.unix
    /// print(unix.referenceDate.year) // 1970
    ///
    /// let ntp = Time.Epoch.ntp
    /// print(ntp.referenceDate.year) // 1900
    /// ```
    public struct Epoch: Sendable, Equatable, Hashable {
        /// Reference date for this epoch
        public let referenceDate: Time

        /// Creates an epoch with a reference date.
        public init(referenceDate: Time) {
            self.referenceDate = referenceDate
        }
    }
}

// MARK: - Standard Epochs

extension Time.Epoch {
    /// Unix epoch (1970-01-01 00:00:00 UTC).
    ///
    /// Reference point for POSIX time, used by most modern computing platforms.
    public static let unix = Time.Epoch(
        referenceDate: .unchecked(
            year: 1970,
            month: 1,
            day: 1,
            hour: 0,
            minute: 0,
            second: 0
        )
    )

    /// NTP epoch (1900-01-01 00:00:00 UTC).
    ///
    /// Reference point for Network Time Protocol, predating Unix by 70 years.
    public static let ntp = Time.Epoch(
        referenceDate: .unchecked(
            year: 1900,
            month: 1,
            day: 1,
            hour: 0,
            minute: 0,
            second: 0
        )
    )

    /// GPS epoch (1980-01-06 00:00:00 UTC).
    ///
    /// Reference point for Global Positioning System time. GPS time does not observe leap seconds,
    /// so it gradually diverges from UTC (18 seconds ahead as of 2024).
    public static let gps = Time.Epoch(
        referenceDate: .unchecked(
            year: 1980,
            month: 1,
            day: 6,
            hour: 0,
            minute: 0,
            second: 0
        )
    )

    /// TAI epoch (1958-01-01 00:00:00).
    ///
    /// Reference point for International Atomic Time, a continuous timescale without leap seconds.
    public static let tai = Time.Epoch(
        referenceDate: .unchecked(
            year: 1958,
            month: 1,
            day: 1,
            hour: 0,
            minute: 0,
            second: 0,
            millisecond: 0,
            microsecond: 0,
            nanosecond: 0
        )
    )

    /// Windows FILETIME / NTFS epoch (1601-01-01 00:00:00 UTC).
    ///
    /// Reference point for Win32 `FILETIME`, NTFS, and Active Directory timestamps.
    public static let windowsFileTime = Time.Epoch(
        referenceDate: .unchecked(
            year: 1601,
            month: 1,
            day: 1,
            hour: 0,
            minute: 0,
            second: 0,
            millisecond: 0,
            microsecond: 0,
            nanosecond: 0
        )
    )

    /// Apple / Core Foundation absolute time epoch (2001-01-01 00:00:00 UTC).
    ///
    /// Reference point for `CFAbsoluteTime` and `CFDate` on Apple platforms.
    public static let appleAbsolute = Time.Epoch(
        referenceDate: .unchecked(
            year: 2001,
            month: 1,
            day: 1,
            hour: 0,
            minute: 0,
            second: 0,
            millisecond: 0,
            microsecond: 0,
            nanosecond: 0
        )
    )
}
