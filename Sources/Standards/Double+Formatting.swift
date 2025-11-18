import Formatting

extension Double {
    /// Formats this double using the specified double format.
    ///
    /// Use this method with static format properties:
    ///
    /// ```swift
    /// let result = 0.75.formatted(.percent)
    /// ```
    ///
    /// - Parameter format: The double format to use.
    /// - Returns: The formatted representation of this double.
    public func formatted(_ format: Format) -> String {
        format.format(self)
    }

    /// Formats this double using a custom format style.
    ///
    /// Use this method to format a double with a custom format style:
    ///
    /// ```swift
    /// let result = 0.75.formatted(MyCustomStyle())
    /// ```
    ///
    /// - Parameter style: The format style to use for formatting.
    /// - Returns: The formatted representation of this double.
    public func formatted<S: Formatting>(_ style: S) -> S.FormatOutput where S.FormatInput == Double {
        style.format(self)
    }

    /// Formats this double using the default double format.
    ///
    /// - Returns: A double format that can be configured.
    public func formatted() -> Format {
        Format()
    }
}

// MARK: - Double Format

extension Double {
    /// A format for formatting doubles.
    ///
    /// Use static properties to access predefined formats:
    ///
    /// ```swift
    /// 0.75.formatted(.percent)  // "75%"
    /// 3.14159.formatted(.number)  // "3.14159"
    /// ```
    ///
    /// Chain methods to configure the format:
    ///
    /// ```swift
    /// 0.75.formatted(.percent.rounded())        // "75%"
    /// 0.755.formatted(.percent.precision(2))    // "75.50%"
    /// ```
    public struct Format: Formatting {
        public let style: Style
        public let shouldRound: Bool
        public let precisionDigits: Int?

        public init(
            style: Style = .number,
            shouldRound: Bool = false,
            precisionDigits: Int? = nil
        ) {
            self.style = style
            self.shouldRound = shouldRound
            self.precisionDigits = precisionDigits
        }
    }
}

// MARK: - Double.Format.Style

extension Double.Format {
    public struct Style: Sendable {
        let apply: @Sendable (_ value: Double, _ shouldRound: Bool, _ precisionDigits: Int?) -> String

        public init(apply: @escaping @Sendable (_ value: Double, _ shouldRound: Bool, _ precisionDigits: Int?) -> String) {
            self.apply = apply
        }
    }
}

// MARK: - Double.Format.Style Static Properties

extension Double.Format.Style {
    /// Formats the double as a decimal number.
    public static var number: Self {
        .init { value, shouldRound, precisionDigits in
            var numericValue = value
            if shouldRound {
                numericValue = numericValue.rounded()
            }
            if let precision = precisionDigits {
                let multiplier = power(10.0, precision)
                numericValue = (numericValue * multiplier).rounded() / multiplier
            }
            return "\(numericValue)"
        }
    }

    /// Formats the double as a percentage.
    public static var percent: Self {
        .init { value, shouldRound, precisionDigits in
            let percentValue = value * 100
            if shouldRound {
                return "\(Int(percentValue.rounded()))%"
            }
            if let precision = precisionDigits {
                let multiplier = power(10.0, precision)
                let rounded = (percentValue * multiplier).rounded() / multiplier
                return "\(rounded)%"
            }
            return "\(Int(percentValue))%"
        }
    }
}

// MARK: - Double.Format Methods

extension Double.Format {
    public func format(_ value: Double) -> String {
        style.apply(value, shouldRound, precisionDigits)
    }
}

// MARK: - Double.Format Static Properties

extension Double.Format {
    /// Formats the double as a decimal number.
    public static var number: Self {
        .init(style: .number)
    }

    /// Formats the double as a percentage.
    public static var percent: Self {
        .init(style: .percent)
    }
}

// MARK: - Double.Format Chaining Methods

extension Double.Format {
    /// Rounds the value when formatting.
    ///
    /// ```swift
    /// 3.7.formatted(.number.rounded())  // "4.0"
    /// 0.755.formatted(.percent.rounded())  // "76%"
    /// ```
    public func rounded() -> Self {
        .init(style: style, shouldRound: true, precisionDigits: precisionDigits)
    }

    /// Sets the precision (decimal places) for the formatted value.
    ///
    /// ```swift
    /// 3.14159.formatted(.number.precision(2))  // "3.14"
    /// 0.12345.formatted(.percent.precision(2))  // "12.35%"
    /// ```
    public func precision(_ digits: Int) -> Self {
        .init(style: style, shouldRound: shouldRound, precisionDigits: digits)
    }
}

// MARK: - Utilities

private func power(_ base: Double, _ exponent: Int) -> Double {
    guard exponent > 0 else { return 1.0 }
    var result = base
    for _ in 1..<exponent {
        result *= base
    }
    return result
}
