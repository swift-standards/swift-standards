// Time.Julian.Day+Properties.swift
// StandardTime
//
// Computed properties for Julian Day

public import Dimension

extension Tagged where Tag == Coordinate.X<Time.Julian.Space>, RawValue == Double {
    /// Modified Julian Day (MJD).
    ///
    /// MJD = JD - 2400000.5
    ///
    /// The Modified Julian Day starts at midnight (not noon) and uses smaller
    /// numbers, making it more convenient for modern applications.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let jd: Time.Julian.Day = 2_451_545.0  // J2000.0
    /// let mjd = jd.modified                   // 51544.5
    /// ```
    public var modified: Double {
        _rawValue - Time.Julian.Offset.modified._rawValue
    }
}
