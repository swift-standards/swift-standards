// MARK: - FloatingPointFormat

/// A format for formatting any FloatingPoint value.
///
/// This categorical format works for all FloatingPoint types (Double, Float, etc.).
/// It provides operations specific to the FloatingPoint category:
/// - Percentage formatting
/// - Precision control
/// - Rounding strategies
///
/// Note: This is a generic categorical formatter that operates across the FloatingPoint category.
/// It does not conform to `Formatting` as it works with multiple input types, not a single FormatInput.
///
/// Use static properties to access predefined formats:
///
/// ```swift
/// 0.75.formatted(.percent)  // "75%"
/// Float(0.5).formatted(.percent)  // "50%"
/// ```
///
/// Chain methods to configure the format:
///
/// ```swift
/// 0.75.formatted(.percent.rounded())        // "75%"
/// 0.755.formatted(.percent.precision(2))    // "75.50%"
/// ```
public struct FloatingPointFormat {
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

// MARK: - FloatingPointFormat Format Method

extension FloatingPointFormat {
    /// Formats a floating point value.
    ///
    /// This is a generic method that works across all FloatingPoint types.
    public func format<T: FloatingPoint>(_ value: T) -> String {
        var workingValue = value

        if isPercent {
            workingValue = workingValue * T(100)
        }

        if shouldRound {
            workingValue = workingValue.rounded()
        }

        if let precision = precisionDigits {
            let multiplier = T(10).power(precision)
            workingValue = (workingValue * multiplier).rounded() / multiplier
        }

        let result = "\(workingValue)"
        return isPercent ? result + "%" : result
    }
}

// MARK: - FloatingPointFormat Static Properties

extension FloatingPointFormat {
    /// Formats the floating point value as a percentage.
    public static var percent: Self {
        .init(isPercent: true, shouldRound: false, precisionDigits: nil)
    }
}

// MARK: - FloatingPointFormat Chaining Methods

extension FloatingPointFormat {
    /// Rounds the value when formatting.
    ///
    /// ```swift
    /// 0.755.formatted(FloatingPointFormat.percent.rounded())  // "76%"
    /// ```
    public func rounded() -> Self {
        .init(isPercent: isPercent, shouldRound: true, precisionDigits: precisionDigits)
    }

    /// Sets the precision (decimal places) for the formatted value.
    ///
    /// ```swift
    /// 0.12345.formatted(FloatingPointFormat.percent.precision(2))  // "12.35%"
    /// ```
    public func precision(_ digits: Int) -> Self {
        .init(isPercent: isPercent, shouldRound: shouldRound, precisionDigits: digits)
    }
}

// MARK: - FloatingPoint Extension

extension FloatingPoint {
    /// Formats this floating point value using the specified floating point format.
    ///
    /// Use this method with static format properties:
    ///
    /// ```swift
    /// let result = 0.75.formatted(.percent)               // "75%"
    /// let result = Float(0.5).formatted(.percent)         // "50%"
    /// let result = 0.755.formatted(.percent.precision(2)) // "75.50%"
    /// ```
    ///
    /// - Parameter format: The floating point format to use.
    /// - Returns: The formatted representation of this floating point value.
    public func formatted(_ format: FloatingPointFormat) -> String {
        format.format(self)
    }
}
