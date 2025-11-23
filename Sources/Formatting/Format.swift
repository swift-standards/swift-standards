/// A namespace for formatting functionality.
///
/// The `Formatting` namespace provides protocols and extensions for type-safe formatting
/// of values to strings and parsing strings back to values.
///
/// ## Overview
///
/// This package provides the core protocols that enable the `.formatted()` API pattern:
///
/// ```swift
/// let value = 42
/// let formatted = value.formatted(MyFormatStyle())
/// ```
///
/// Extension packages can provide specific format styles:
/// - swift-percent: Percentage formatting
/// - swift-iso-8601: ISO 8601 date formatting
/// - swift-measurement: Unit and measurement formatting
public enum Format {}
