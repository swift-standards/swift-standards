// Time.Julian.Day.swift
// StandardTime
//
// Julian Day as a coordinate in Julian time space

public import Dimension

extension Time.Julian {
    /// Julian Day number (absolute coordinate in Julian time).
    ///
    /// Continuous count of days since the beginning of the Julian Period
    /// (noon on November 24, 4714 BC in the proleptic Gregorian calendar).
    ///
    /// ## Important
    ///
    /// Julian Day starts at **noon**, not midnight:
    /// - `.0` fraction = noon
    /// - `.5` fraction = midnight
    /// - `.75` fraction = 6:00 AM
    ///
    /// ## Affine Arithmetic
    ///
    /// ```swift
    /// let jd1: Day = 2_451_545.0
    /// let jd2: Day = 2_451_546.0
    /// let diff: Offset = jd2 - jd1     // Day - Day = Offset
    /// let jd3 = jd1 + diff             // Day + Offset = Day
    /// ```
    public typealias Day = Coordinate.X<Space>.Value<Double>
}
