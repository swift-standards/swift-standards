// Time.Julian.swift
// StandardTime
//
// Julian date namespace

extension Time {
    /// Julian date namespace.
    ///
    /// Contains types for working with Julian Day numbers, the continuous count
    /// of days used in astronomy since November 24, 4714 BC (proleptic Gregorian).
    ///
    /// ## Types
    ///
    /// - ``Day``: Absolute Julian Day coordinate
    /// - ``Offset``: Displacement in Julian days
    ///
    /// ## Example
    ///
    /// ```swift
    /// let jd: Time.Julian.Day = 2_451_545.0  // J2000.0 epoch
    /// let mjd = jd - .modified               // Convert to MJD
    /// ```
    public enum Julian {
        /// Coordinate space for Julian time.
        public enum Space {}
    }
}
