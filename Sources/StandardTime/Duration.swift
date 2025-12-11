// Duration.swift
// StandardTime
//
// Duration type alias for timeline arithmetic

/// Duration for timeline arithmetic.
///
/// Type alias for `Swift.Duration`. Use with `Instant` for timeline operations
/// (adding/subtracting time intervals).
///
/// ## Example
///
/// ```swift
/// let duration = Duration.seconds(3600)
/// let later = instant + duration
/// ```
@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
public typealias Duration = Swift.Duration
