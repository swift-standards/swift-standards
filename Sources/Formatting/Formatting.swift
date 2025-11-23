//
//  File.swift
//  swift-standards
//
//  Created by Coen ten Thije Boonkkamp on 23/11/2025.
//

/// A type that can format a given value into a representation.
///
/// Conform to this protocol to create custom formatting types that can be used with
/// the `.formatted(_:)` method on types.
///
/// ## Example
///
/// ```swift
/// struct UppercaseFormat: Formatting {
///     func format(_ value: String) -> String {
///         value.uppercased()
///     }
/// }
///
/// let result = "hello".formatted(UppercaseFormat())
/// // result == "HELLO"
/// ```
///
/// - Note: The most common output type is `String`, but you can format to any type,
///   including `AttributedString` or custom types.
public protocol Formatting: Sendable {
    /// The type of value to be formatted.
    associatedtype FormatInput

    /// The type of the formatted representation.
    associatedtype FormatOutput

    /// Formats the given value into the output representation.
    ///
    /// - Parameter value: The value to format.
    /// - Returns: The formatted representation of the value.
    func format(_ value: FormatInput) -> FormatOutput
}

// MARK: - Convenience Methods

extension Formatting {
    /// Formats the given value into the output representation.
    ///
    /// This method provides function call syntax for formatting:
    ///
    /// ```swift
    /// let formatter = UppercaseFormat()
    /// let result = formatter("hello")  // "HELLO"
    /// ```
    ///
    /// - Parameter value: The value to format.
    /// - Returns: The formatted representation of the value.
    public func callAsFunction(_ value: FormatInput) -> FormatOutput {
        format(value)
    }
}
