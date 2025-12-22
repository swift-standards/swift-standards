// Time.Clock.Instant.Error.swift
// StandardTime
//
// Error type for clock instant conversions.

public import Dimension

extension Tagged where RawValue == Int64 {
    public enum Error: Swift.Error, Sendable {
        case rangeOverflow
        case resolutionLossBeyondPolicy
    }
}
