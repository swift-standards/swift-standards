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

// MARK: - InstantProtocol Conformance

extension Tagged: InstantProtocol where RawValue == Int64 {
    /// Returns the duration from this instant to another.
    ///
    /// Positive if `other` is after `self`, negative otherwise.
    @inlinable
    public func duration(to other: Self) -> Duration {
        .nanoseconds(other._rawValue - self._rawValue)
    }

    /// Returns a new instant advanced by the specified duration.
    ///
    /// Sub-nanosecond precision is truncated toward zero.
    /// Saturates to min/max on overflow.
    @inlinable
    public func advanced(by duration: Duration) -> Self {
        (try? advancedThrowing(by: duration))
            ?? (duration.components.seconds > 0 ? Self(Int64.max) : Self(Int64.min))
    }

    /// Returns a new instant advanced by the specified duration.
    ///
    /// Sub-nanosecond precision is truncated toward zero.
    ///
    /// - Throws: `Time.Clock.InstantError.overflow` if the operation overflows.
    /// - Note: Named `advancedThrowing` because Swift doesn't allow overloading on throws alone.
    ///   Rename to `advanced(by:)` when the language supports this.
    @inlinable
    public func advancedThrowing(by duration: Duration) throws(Time.Clock.InstantError) -> Self {
        let c = duration.components

        let (secToNs, ov1) = c.seconds.multipliedReportingOverflow(by: 1_000_000_000)
        if ov1 { throw .overflow }

        let subNs = Int64(c.attoseconds / 1_000_000_000)

        let (deltaNs, ov2) = secToNs.addingReportingOverflow(subNs)
        if ov2 { throw .overflow }

        let (result, ov3) = self._rawValue.addingReportingOverflow(deltaNs)
        if ov3 { throw .overflow }

        return Self(result)
    }
}

// MARK: - Duration Initializers

extension Tagged where RawValue == Int64 {
    /// Creates a tagged value from a duration.
    ///
    /// Sub-nanosecond precision is truncated toward zero.
    /// Traps on overflow.
    ///
    /// - Parameter duration: The duration to convert.
    @inlinable
    public init(_ duration: Duration) {
        do {
            try self.init(throwing: duration)
        } catch {
            preconditionFailure("Duration overflow when converting to nanoseconds")
        }
    }

    /// Creates a tagged value from a duration.
    ///
    /// Sub-nanosecond precision is truncated toward zero.
    ///
    /// - Parameter duration: The duration to convert.
    /// - Throws: `Time.Clock.InstantError.overflow` if the operation overflows.
    /// - Note: Named `init(throwing:)` because Swift doesn't allow overloading on throws alone.
    ///   Rename to `init(_:)` when the language supports this.
    @inlinable
    public init(throwing duration: Duration) throws(Time.Clock.InstantError) {
        let c = duration.components

        let (secToNs, ov1) = c.seconds.multipliedReportingOverflow(by: 1_000_000_000)
        if ov1 { throw .overflow }

        let subNs = Int64(c.attoseconds / 1_000_000_000)

        let (total, ov2) = secToNs.addingReportingOverflow(subNs)
        if ov2 { throw .overflow }

        self = .init(total)
    }
}
