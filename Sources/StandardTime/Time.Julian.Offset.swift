// Time.Julian.Offset.swift
// StandardTime
//
// Julian Day offset as a displacement in Julian time space

public import Dimension

extension Time.Julian {
    /// Displacement in Julian days.
    ///
    /// Represents a directed offset between two Julian Day coordinates.
    /// Used for time intervals and epoch conversions.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let oneDay: Offset = 1.0
    /// let jd: Day = 2_451_545.0
    /// let tomorrow = jd + oneDay  // Day + Offset = Day
    /// ```
    public typealias Offset = Displacement.X<Space>.Value<Double>
}
