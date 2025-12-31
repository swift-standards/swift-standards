// Time.Julian.Offset+Constants.swift
// StandardTime
//
// Standard Julian Day offset constants

public import Dimension

extension Tagged where Tag == Displacement.X<Time.Julian.Space>, RawValue == Double {
    /// Modified Julian Day offset.
    ///
    /// MJD = JD - 2400000.5
    ///
    /// The Modified Julian Day epoch is November 17, 1858 00:00:00 UTC.
    /// MJD starts at midnight (not noon like JD), making it more convenient
    /// for civil timekeeping.
    public static let modified: Self = 2_400_000.5
}
