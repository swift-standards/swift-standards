/// Namespace containing formatting types and protocols.
///
/// Use this namespace to access format styles for converting values to strings. Provides built-in support for integers (decimal, binary, octal) and floating-point numbers (decimal, percentage). Additional format styles can be created by conforming to `FormatStyle`.
///
/// ## Example
///
/// ```swift
/// 42.formatted(.binary)            // "0b101010"
/// 0.75.formatted(.percent)         // "75%"
/// 3.14159.formatted(.number)       // "3.14159"
/// ```
public enum Format {}

// MARK: - FormatStyle Protocol

/// Protocol for types that convert values to formatted output.
///
/// Conform to this protocol to create custom format styles that work with the `.formatted(_:)` API. Define the input and output types, then implement the `format(_:)` method with your formatting logic.
///
/// ## Example
///
/// ```swift
/// struct CurrencyStyle: FormatStyle {
///     typealias FormatInput = Double
///     typealias FormatOutput = String
///
///     func format(_ value: Double) -> String {
///         "$\(String(format: "%.2f", value))"
///     }
/// }
///
/// 42.5.formatted(CurrencyStyle())  // "$42.50"
/// ```
public protocol FormatStyle<FormatInput, FormatOutput>: Sendable {
    /// Input value type accepted by this format style
    associatedtype FormatInput

    /// Output type produced by formatting
    associatedtype FormatOutput

    /// Converts a value to the formatted output type.
    ///
    /// - Parameter value: Value to format
    /// - Returns: Formatted output
    func format(_ value: FormatInput) -> FormatOutput
}

// MARK: - BinaryFloatingPoint + formatted()

extension BinaryFloatingPoint {
    /// Converts this value to formatted output using the specified format style.
    ///
    /// - Parameter format: Format style to apply
    /// - Returns: Formatted output
    @inlinable
    public func formatted<S>(_ format: S) -> S.FormatOutput
    where Self == S.FormatInput, S: FormatStyle {
        format.format(self)
    }

    /// Converts this value to formatted output, converting to the format's input type first.
    ///
    /// - Parameter format: Format style to apply
    /// - Returns: Formatted output
    @inlinable
    public func formatted<S>(_ format: S) -> S.FormatOutput
    where S: FormatStyle, S.FormatInput: BinaryFloatingPoint {
        format.format(S.FormatInput(self))
    }
}

// MARK: - BinaryInteger + formatted()

extension BinaryInteger {
    /// Converts this value to formatted output using the specified format style.
    ///
    /// - Parameter format: Format style to apply
    /// - Returns: Formatted output
    @inlinable
    public func formatted<S>(_ format: S) -> S.FormatOutput
    where Self == S.FormatInput, S: FormatStyle {
        format.format(self)
    }

    /// Converts this value to formatted output, converting to the format's input type first.
    ///
    /// - Parameter format: Format style to apply
    /// - Returns: Formatted output
    @inlinable
    public func formatted<S>(_ format: S) -> S.FormatOutput
    where S: FormatStyle, S.FormatInput: BinaryInteger {
        format.format(S.FormatInput(self))
    }
}
