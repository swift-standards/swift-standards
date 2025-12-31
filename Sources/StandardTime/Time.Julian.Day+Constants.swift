// Time.Julian.Day+Constants.swift
// StandardTime
//
// Standard Julian Day constants

public import Dimension

extension Tagged where Tag == Coordinate.X<Time.Julian.Space>, RawValue == Double {
    /// Unix epoch (1970-01-01 00:00:00 UTC) as Julian Day.
    ///
    /// Value: 2440587.5
    public static let unixEpoch: Self = 2_440_587.5

    /// J2000.0 epoch (2000-01-01 12:00:00 TT) as Julian Day.
    ///
    /// Standard astronomical epoch for celestial coordinates.
    /// Value: 2451545.0
    public static let j2000: Self = 2_451_545.0

    /// Julian Day zero (noon on November 24, 4714 BC proleptic Gregorian).
    public static let zero: Self = 0.0
}
