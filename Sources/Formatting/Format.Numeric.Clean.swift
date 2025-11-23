//
//  Format.Numeric.Clean.swift
//  swift-standards
//
//  Created by Coen ten Thije Boonkkamp on 23/11/2025.
//

extension Format.Numeric {
    /// A format style that removes unnecessary trailing zeros and decimal points.
    ///
    /// This formatter produces clean, human-readable numeric strings by removing
    /// unnecessary decimal points and trailing zeros while preserving precision
    /// when needed. **Foundation-free implementation.**
    ///
    /// ## Examples
    ///
    /// ```swift
    /// // Basic usage - removes .0 from whole numbers
    /// 100.0.formatted(Format.Numeric.Clean())  // "100"
    /// 3.14.formatted(Format.Numeric.Clean())   // "3.14"
    ///
    /// // With maximum precision
    /// let formatter = Format.Numeric.Clean(maximumFractionDigits: 2)
    /// 3.14159.formatted(formatter)  // "3.14"
    ///
    /// // With grouping separator for large numbers
    /// let grouped = Format.Numeric.Clean(groupingSeparator: ",")
    /// 1234567.0.formatted(grouped)  // "1,234,567"
    /// ```
    public struct Clean: Formatting, Sendable {
        public typealias FormatInput = Double
        public typealias FormatOutput = String

        /// Maximum number of fraction digits (nil = no limit)
        public var maximumFractionDigits: Int?

        /// Minimum number of fraction digits (nil = remove all trailing zeros)
        public var minimumFractionDigits: Int?

        /// Grouping separator for thousands (nil = no grouping)
        public var groupingSeparator: String?

        /// Decimal separator (default: ".")
        public var decimalSeparator: String

        /// Creates a clean numeric format style.
        ///
        /// - Parameters:
        ///   - maximumFractionDigits: Maximum decimal places (default: nil, no limit)
        ///   - minimumFractionDigits: Minimum decimal places (default: nil, remove trailing zeros)
        ///   - groupingSeparator: Thousands separator (default: nil, no grouping)
        ///   - decimalSeparator: Decimal point character (default: ".")
        public init(
            maximumFractionDigits: Int? = nil,
            minimumFractionDigits: Int? = nil,
            groupingSeparator: String? = nil,
            decimalSeparator: String = "."
        ) {
            self.maximumFractionDigits = maximumFractionDigits
            self.minimumFractionDigits = minimumFractionDigits
            self.groupingSeparator = groupingSeparator
            self.decimalSeparator = decimalSeparator
        }

        public func format(_ value: Double) -> String {
            // Handle special cases
            if value.isNaN { return "NaN" }
            if value.isInfinite { return value > 0 ? "Infinity" : "-Infinity" }

            let isNegative = value < 0
            let absoluteValue = abs(value)

            // Split into integer and fractional parts
            let integerPart = Int64(absoluteValue)
            var fractionalPart = absoluteValue - Double(integerPart)

            // Format integer part with grouping if needed
            var integerString = String(integerPart)
            if let separator = groupingSeparator, integerString.count > 3 {
                integerString = addGroupingSeparator(to: integerString, separator: separator)
            }

            // Handle fractional part
            if fractionalPart == 0 && minimumFractionDigits == nil {
                // Whole number with no minimum fraction digits
                return isNegative ? "-\(integerString)" : integerString
            }

            // Determine fraction digits to use
            var fractionDigits: Int
            if let max = maximumFractionDigits {
                fractionDigits = max
            } else {
                // Calculate significant digits (up to 15 for Double precision)
                fractionDigits = 15
            }

            // Apply minimum if specified
            if let min = minimumFractionDigits {
                fractionDigits = max(fractionDigits, min)
            }

            // Format fractional part
            var fractionalString = ""
            if fractionDigits > 0 {
                // Calculate multiplier (10^digits) without using pow
                var multiplier: Double = 1.0
                for _ in 0..<fractionDigits {
                    multiplier *= 10.0
                }

                // Round the fractional part
                fractionalPart = (fractionalPart * multiplier).rounded() / multiplier

                // Convert to string
                var fracValue = Int64(fractionalPart * multiplier)
                var digits: [Character] = []

                for _ in 0..<fractionDigits {
                    digits.append(Character(String(fracValue % 10)))
                    fracValue /= 10
                }

                fractionalString = String(digits.reversed())

                // Remove trailing zeros unless minimumFractionDigits is set
                if minimumFractionDigits == nil {
                    while fractionalString.last == "0" {
                        fractionalString.removeLast()
                    }
                } else if let min = minimumFractionDigits {
                    // Ensure minimum digits
                    while fractionalString.count > min && fractionalString.last == "0" {
                        fractionalString.removeLast()
                    }
                }
            }

            // Combine parts
            var result = integerString
            if !fractionalString.isEmpty {
                result += decimalSeparator + fractionalString
            }

            return isNegative ? "-\(result)" : result
        }

        /// Add grouping separator to integer string
        private func addGroupingSeparator(to string: String, separator: String) -> String {
            var result = ""
            let chars = Array(string)
            for (index, char) in chars.enumerated() {
                if index > 0 && (chars.count - index) % 3 == 0 {
                    result.append(separator)
                }
                result.append(char)
            }
            return result
        }
    }
}

// MARK: - Convenience Extensions

extension Format.Numeric.Clean {
    /// Default clean format (removes trailing zeros, no grouping)
    public static var `default`: Self {
        Self()
    }
}

// MARK: - Value Extensions

extension Double {
    /// Formats this value using the clean numeric format style.
    ///
    /// - Parameter style: The format style to use
    /// - Returns: A formatted string representation
    public func formatted(_ style: Format.Numeric.Clean) -> String {
        style.format(self)
    }
}

extension Float {
    /// Formats this value using the clean numeric format style.
    ///
    /// - Parameter style: The format style to use
    /// - Returns: A formatted string representation
    public func formatted(_ style: Format.Numeric.Clean) -> String {
        style.format(Double(self))
    }
}

extension Int {
    /// Formats this value using the clean numeric format style.
    ///
    /// - Parameter style: The format style to use
    /// - Returns: A formatted string representation
    public func formatted(_ style: Format.Numeric.Clean) -> String {
        style.format(Double(self))
    }
}
