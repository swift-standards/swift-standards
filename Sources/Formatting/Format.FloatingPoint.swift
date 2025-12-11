// Format.FloatingPoint.swift
// Formatting for FloatingPoint types.

import StandardLibraryExtensions

extension Format {
    /// Format style for converting floating-point values to strings with optional percentage and precision control.
    ///
    /// Use this format to display decimal numbers or percentages. Works with all `FloatingPoint` types including `Double`, `Float`, and others. Chain methods to configure rounding and decimal precision.
    ///
    /// Does not conform to `FormatStyle` because it works across multiple input types within the FloatingPoint category, not a single FormatInput type.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 0.75.formatted(.percent)                   // "75%"
    /// 0.755.formatted(.percent.precision(2))     // "75.50%"
    /// 3.14159.formatted(.number.precision(2))    // "3.14"
    /// ```
    public struct FloatingPoint: Sendable {
        let isPercent: Bool
        public let shouldRound: Bool
        public let precisionDigits: Int?

        private init(isPercent: Bool, shouldRound: Bool, precisionDigits: Int?) {
            self.isPercent = isPercent
            self.shouldRound = shouldRound
            self.precisionDigits = precisionDigits
        }

        public init(shouldRound: Bool = false, precisionDigits: Int? = nil) {
            self.isPercent = false
            self.shouldRound = shouldRound
            self.precisionDigits = precisionDigits
        }
    }
}

// MARK: - Format.FloatingPoint Format Method

extension Format.FloatingPoint {
    /// Converts the floating-point value to a string using this format's configuration.
    ///
    /// - Parameter value: Floating-point value to format
    /// - Returns: Formatted string representation
    public func format<T: Swift.FloatingPoint>(_ value: T) -> String {
        var workingValue = value

        if isPercent {
            workingValue *= T(100)
        }

        if shouldRound {
            workingValue = workingValue.rounded()
        }

        if let precision = precisionDigits {
            let multiplier = T(10).power(precision)
            workingValue = (workingValue * multiplier).rounded() / multiplier
        }

        var result = "\(workingValue)"

        // Strip trailing ".0" for whole numbers (e.g., "10.0" -> "10")
        if result.hasSuffix(".0") {
            result.removeLast(2)
        }

        return isPercent ? result + "%" : result
    }
}

// MARK: - Format.FloatingPoint Static Properties

extension Format.FloatingPoint {
    /// Standard decimal format for floating-point values
    ///
    /// ## Example
    ///
    /// ```swift
    /// 3.14159.formatted(.number)  // "3.14159"
    /// ```
    public static var number: Self {
        .init(isPercent: false, shouldRound: false, precisionDigits: nil)
    }

    /// Percentage format that multiplies by 100 and appends "%" symbol
    public static var percent: Self {
        .init(isPercent: true, shouldRound: false, precisionDigits: nil)
    }
}

// MARK: - Format.FloatingPoint Chaining Methods

extension Format.FloatingPoint {
    /// Returns a format that rounds to the nearest whole number.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 0.755.formatted(.percent.rounded())  // "76%"
    /// ```
    public func rounded() -> Self {
        .init(isPercent: isPercent, shouldRound: true, precisionDigits: precisionDigits)
    }

    /// Returns a format that displays the specified number of decimal places.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 0.12345.formatted(.percent.precision(2))  // "12.35%"
    /// ```
    public func precision(_ digits: Int) -> Self {
        .init(isPercent: isPercent, shouldRound: shouldRound, precisionDigits: digits)
    }
}

// MARK: - FloatingPoint Extension

extension Swift.FloatingPoint {
    /// Converts this floating-point value to a string using the specified format.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 0.75.formatted(.percent)                 // "75%"
    /// Float(0.5).formatted(.percent)           // "50%"
    /// 0.755.formatted(.percent.precision(2))   // "75.50%"
    /// ```
    ///
    /// - Parameter format: Format style to apply
    /// - Returns: Formatted string representation
    public func formatted(_ format: Format.FloatingPoint) -> String {
        format.format(self)
    }
}
