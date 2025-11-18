import Formatting

extension Float {
    /// Formats this float using the specified float format.
    ///
    /// Use this method with static format properties:
    ///
    /// ```swift
    /// let result = Float(0.75).formatted(.percent)
    /// ```
    ///
    /// - Parameter format: The float format to use.
    /// - Returns: The formatted representation of this float.
    public func formatted(_ format: Format) -> String {
        format.format(self)
    }

    /// Formats this float using a custom format style.
    ///
    /// Use this method to format a float with a custom format style:
    ///
    /// ```swift
    /// let result = Float(0.75).formatted(MyCustomStyle())
    /// ```
    ///
    /// - Parameter style: The format style to use for formatting.
    /// - Returns: The formatted representation of this float.
    public func formatted<S: Formatting>(_ style: S) -> S.FormatOutput where S.FormatInput == Float {
        style.format(self)
    }

    /// Formats this float using the default float format.
    ///
    /// - Returns: A float format that can be configured.
    public func formatted() -> Format {
        Format()
    }
}

// MARK: - Float Format

extension Float {
    /// A format for formatting floats.
    ///
    /// Use static properties to access predefined formats:
    ///
    /// ```swift
    /// Float(0.75).formatted(.percent)  // "75%"
    /// Float(3.14159).formatted(.number)  // "3.14159"
    /// ```
    ///
    /// Chain methods to configure the format:
    ///
    /// ```swift
    /// Float(0.75).formatted(.percent.rounded())        // "75%"
    /// Float(0.755).formatted(.percent.precision(2))    // "75.50%"
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

// MARK: - Float.Format.Style

extension Float.Format {
    public struct Style: Sendable {
        let apply: @Sendable (_ value: Float, _ shouldRound: Bool, _ precisionDigits: Int?) -> String

        public init(apply: @escaping @Sendable (_ value: Float, _ shouldRound: Bool, _ precisionDigits: Int?) -> String) {
            self.apply = apply
        }
    }
}

// MARK: - Float.Format.Style Static Properties

extension Float.Format.Style {
    /// Formats the float as a decimal number.
    public static var number: Self {
        .init { value, shouldRound, precisionDigits in
            var numericValue = value
            if shouldRound {
                numericValue = numericValue.rounded()
            }
            if let precision = precisionDigits {
                let multiplier = Float(10.0).power(precision)
                numericValue = (numericValue * multiplier).rounded() / multiplier
            }
            return "\(numericValue)"
        }
    }

    /// Formats the float as a percentage.
    public static var percent: Self {
        .init { value, shouldRound, precisionDigits in
            let percentValue = value * 100
            if shouldRound {
                return "\(Int(percentValue.rounded()))%"
            }
            if let precision = precisionDigits {
                let multiplier = Float(10.0).power(precision)
                let rounded = (percentValue * multiplier).rounded() / multiplier
                return "\(rounded)%"
            }
            return "\(Int(percentValue))%"
        }
    }
}

// MARK: - Float.Format Methods

extension Float.Format {
    public func format(_ value: Float) -> String {
        style.apply(value, shouldRound, precisionDigits)
    }
}

// MARK: - Float.Format Static Properties

extension Float.Format {
    /// Formats the float as a decimal number.
    public static var number: Self {
        .init(style: .number)
    }

    /// Formats the float as a percentage.
    public static var percent: Self {
        .init(style: .percent)
    }
}

// MARK: - Float.Format Chaining Methods

extension Float.Format {
    /// Rounds the value when formatting.
    ///
    /// ```swift
    /// Float(3.7).formatted(.number.rounded())  // "4.0"
    /// Float(0.755).formatted(.percent.rounded())  // "76%"
    /// ```
    public func rounded() -> Self {
        .init(style: style, shouldRound: true, precisionDigits: precisionDigits)
    }

    /// Sets the precision (decimal places) for the formatted value.
    ///
    /// ```swift
    /// Float(3.14159).formatted(.number.precision(2))  // "3.14"
    /// Float(0.12345).formatted(.percent.precision(2))  // "12.35%"
    /// ```
    public func precision(_ digits: Int) -> Self {
        .init(style: style, shouldRound: shouldRound, precisionDigits: digits)
    }
}
