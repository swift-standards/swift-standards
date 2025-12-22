// Time.Clock.Instant.swift
// StandardTime
//
// Generic clock instant using Tagged for compile-time clock separation.

public import Dimension

extension Time.Clock {
    /// A point in time relative to a specific clock's epoch.
    ///
    /// Uses `Tagged` to ensure compile-time separation between instants
    /// from different clocks. You cannot compare or subtract instants
    /// from `Continuous` and `Suspending` clocks directly.
    ///
    /// The raw value is nanoseconds since the clock's epoch as `Int64`.
    public typealias Instant<Clock> = Tagged<Clock, Int64>
}

// MARK: - Instant Arithmetic

extension Tagged where RawValue == Int64 {
    /// Returns the duration between two instants.
    ///
    /// Positive if `self` is after `other`, negative otherwise.
    /// This operation is lossless.
    @inlinable
    public func duration(to other: Self) -> Duration {
        .nanoseconds(other._rawValue - self._rawValue)
    }

    /// Advances this instant by a duration (strict).
    ///
    /// Throws if the duration has sub-nanosecond precision or would overflow.
    ///
    /// - Parameter duration: The duration to advance by.
    /// - Returns: The advanced instant.
    /// - Throws: `Error.resolutionLossBeyondPolicy` if sub-nanosecond precision exists,
    ///           `Error.rangeOverflow` if the result would overflow Int64.
    @inlinable
    public func advancing(by duration: Duration) throws(Error) -> Self {
        let c = duration.components

        let (secToNs, ov1) = c.seconds.multipliedReportingOverflow(by: 1_000_000_000)
        if ov1 { throw .rangeOverflow }

        let remainder = c.attoseconds % 1_000_000_000
        if remainder != 0 { throw .resolutionLossBeyondPolicy }

        let subNs = Int64(c.attoseconds / 1_000_000_000)

        let (deltaNs, ov2) = secToNs.addingReportingOverflow(subNs)
        if ov2 { throw .rangeOverflow }

        let (result, ov3) = self._rawValue.addingReportingOverflow(deltaNs)
        if ov3 { throw .rangeOverflow }

        return Self(result)
    }

    /// Retreats this instant by a duration (strict).
    ///
    /// Throws if the duration has sub-nanosecond precision or would overflow.
    ///
    /// - Parameter duration: The duration to retreat by.
    /// - Returns: The retreated instant.
    /// - Throws: `Error.resolutionLossBeyondPolicy` if sub-nanosecond precision exists,
    ///           `Error.rangeOverflow` if the result would overflow Int64.
    @inlinable
    public func retreating(by duration: Duration) throws(Error) -> Self {
        let c = duration.components

        let (secToNs, ov1) = c.seconds.multipliedReportingOverflow(by: 1_000_000_000)
        if ov1 { throw .rangeOverflow }

        let remainder = c.attoseconds % 1_000_000_000
        if remainder != 0 { throw .resolutionLossBeyondPolicy }

        let subNs = Int64(c.attoseconds / 1_000_000_000)

        let (deltaNs, ov2) = secToNs.addingReportingOverflow(subNs)
        if ov2 { throw .rangeOverflow }

        let (result, ov3) = self._rawValue.subtractingReportingOverflow(deltaNs)
        if ov3 { throw .rangeOverflow }

        return Self(result)
    }

    /// Advances this instant by a duration, truncating sub-nanosecond precision.
    ///
    /// Sub-nanosecond precision is discarded (truncated toward zero).
    /// Still throws on overflow.
    ///
    /// - Parameter duration: The duration to advance by.
    /// - Returns: The advanced instant.
    /// - Throws: `Error.rangeOverflow` if the result would overflow Int64.
    @inlinable
    public func advancing(truncating duration: Duration) throws(Error) -> Self {
        let c = duration.components

        let (secToNs, ov1) = c.seconds.multipliedReportingOverflow(by: 1_000_000_000)
        if ov1 { throw .rangeOverflow }

        let subNs = Int64(c.attoseconds / 1_000_000_000)  // truncates

        let (deltaNs, ov2) = secToNs.addingReportingOverflow(subNs)
        if ov2 { throw .rangeOverflow }

        let (result, ov3) = self._rawValue.addingReportingOverflow(deltaNs)
        if ov3 { throw .rangeOverflow }

        return Self(result)
    }

    /// Retreats this instant by a duration, truncating sub-nanosecond precision.
    ///
    /// Sub-nanosecond precision is discarded (truncated toward zero).
    /// Still throws on overflow.
    ///
    /// - Parameter duration: The duration to retreat by.
    /// - Returns: The retreated instant.
    /// - Throws: `Error.rangeOverflow` if the result would overflow Int64.
    @inlinable
    public func retreating(truncating duration: Duration) throws(Error) -> Self {
        let c = duration.components

        let (secToNs, ov1) = c.seconds.multipliedReportingOverflow(by: 1_000_000_000)
        if ov1 { throw .rangeOverflow }

        let subNs = Int64(c.attoseconds / 1_000_000_000)  // truncates

        let (deltaNs, ov2) = secToNs.addingReportingOverflow(subNs)
        if ov2 { throw .rangeOverflow }

        let (result, ov3) = self._rawValue.subtractingReportingOverflow(deltaNs)
        if ov3 { throw .rangeOverflow }

        return Self(result)
    }
}

// MARK: - Duration Initializers

extension Tagged where RawValue == Int64 {
    /// Creates a tagged value from a duration (strict).
    ///
    /// Throws if the duration has sub-nanosecond precision or would overflow Int64.
    ///
    /// - Parameter duration: The duration to convert.
    /// - Throws: `Error.resolutionLossBeyondPolicy` if sub-nanosecond precision exists,
    ///           `Error.rangeOverflow` if the result would overflow Int64.
    @inlinable
    public init(
        _ duration: Duration
    ) throws(Self.Error) {
        let c = duration.components

        let (secToNs, ov1) = c.seconds.multipliedReportingOverflow(by: 1_000_000_000)
        if ov1 { throw .rangeOverflow }

        let remainder = c.attoseconds % 1_000_000_000
        if remainder != 0 { throw .resolutionLossBeyondPolicy }

        let subNs = Int64(c.attoseconds / 1_000_000_000)

        let (total, ov2) = secToNs.addingReportingOverflow(subNs)
        if ov2 { throw .rangeOverflow }

        self = .init(total)
    }

    /// Creates a tagged value from a duration, truncating sub-nanosecond precision.
    ///
    /// Sub-nanosecond precision is discarded (truncated toward zero).
    /// Still throws on overflow.
    ///
    /// - Parameter duration: The duration to convert.
    /// - Throws: `Error.rangeOverflow` if the result would overflow Int64.
    @inlinable
    public init(
        truncating duration: Duration
    ) throws(Self.Error) {
        let c = duration.components

        let (secToNs, ov1) = c.seconds.multipliedReportingOverflow(by: 1_000_000_000)
        if ov1 { throw .rangeOverflow }

        let subNs = Int64(c.attoseconds / 1_000_000_000)  // truncates toward zero

        let (total, ov2) = secToNs.addingReportingOverflow(subNs)
        if ov2 { throw .rangeOverflow }

        self = .init(total)
    }
}
