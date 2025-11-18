import Formatting

// MARK: - NumericFormat

/// A format for formatting any Numeric value.
///
/// This is the base category format that works for all Numeric types.
/// It provides only basic decimal string interpolation - the universal morphism.
///
/// Note: This is a generic categorical formatter that operates across the Numeric category.
/// It does not conform to `Formatting` as it works with multiple input types, not a single FormatInput.
///
/// Use static properties to access predefined formats:
///
/// ```swift
/// 42.formatted(.decimal)    // "42"
/// 3.14.formatted(.decimal)  // "3.14"
/// UInt8(255).formatted(.decimal)  // "255"
/// ```
///
/// For more advanced formatting, use category-specific formatters:
/// - `BinaryIntegerFormat` for hex, binary, etc.
/// - `FloatingPointFormat` for precision, percent, etc.
public struct NumericFormat {
    private init() {}
}

// MARK: - NumericFormat Format Method

extension NumericFormat {
    /// Formats a numeric value.
    ///
    /// This is the universal morphism - basic string interpolation.
    public func format<T: Numeric>(_ value: T) -> String {
        "\(value)"
    }
}

// MARK: - NumericFormat Static Properties

extension NumericFormat {
    /// Formats the numeric value as a decimal string.
    public static var decimal: Self {
        .init()
    }
}

// MARK: - Numeric Extension

extension Numeric {
    /// Formats this numeric value using the specified numeric format.
    ///
    /// Use this method with static format properties:
    ///
    /// ```swift
    /// let result = 42.formatted(.decimal)
    /// let result = 3.14.formatted(.decimal)
    /// ```
    ///
    /// - Parameter format: The numeric format to use.
    /// - Returns: The formatted representation of this numeric value.
    public func formatted(_ format: NumericFormat) -> String {
        format.format(self)
    }
}
