// Format.BinaryInteger.swift
// Formatting for BinaryInteger types.

extension Format {
    /// Format style for converting integers to decimal, binary, or octal strings.
    ///
    /// Use this format to display integer values in different number bases. Works with all `BinaryInteger` types including `Int`, `UInt`, `Int8`, and others. Chain methods to configure sign display and zero padding.
    ///
    /// For hexadecimal formatting, use the RFC 4648 package instead.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 42.formatted(.binary)                          // "0b101010"
    /// 63.formatted(.octal)                           // "0o77"
    /// 42.formatted(.decimal.sign(strategy: .always)) // "+42"
    /// 5.formatted(.decimal.zeroPadded(width: 3))     // "005"
    /// ```
    public struct BinaryInteger: Sendable {
        let radix: Int
        let prefix: String
        public let signStrategy: SignDisplayStrategy
        public let minWidth: Int?

        private init(
            radix: Int,
            prefix: String,
            signStrategy: SignDisplayStrategy,
            minWidth: Int? = nil
        ) {
            self.radix = radix
            self.prefix = prefix
            self.signStrategy = signStrategy
            self.minWidth = minWidth
        }

        public init(signStrategy: SignDisplayStrategy = .automatic, minWidth: Int? = nil) {
            self.radix = 10
            self.prefix = ""
            self.signStrategy = signStrategy
            self.minWidth = minWidth
        }
    }
}

// MARK: - Format.BinaryInteger.SignDisplayStrategy

extension Format.BinaryInteger {
    /// Strategy controlling sign display for formatted integers.
    ///
    /// Determines whether to show plus signs for positive numbers, only minus signs for negatives, or always show both. Use the static properties `.automatic` and `.always` to configure.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 42.formatted(.decimal.sign(strategy: .always))    // "+42"
    /// (-5).formatted(.decimal.sign(strategy: .always))  // "-5"
    /// ```
    public struct SignDisplayStrategy: Sendable {
        private let _shouldAlwaysShowSign: @Sendable () -> Bool

        private init(shouldAlwaysShowSign: @escaping @Sendable () -> Bool) {
            self._shouldAlwaysShowSign = shouldAlwaysShowSign
        }

        fileprivate var shouldAlwaysShowSign: Bool {
            _shouldAlwaysShowSign()
        }
    }
}

// MARK: - Format.BinaryInteger.SignDisplayStrategy Static Properties

extension Format.BinaryInteger.SignDisplayStrategy {
    /// Displays minus sign for negatives only, no sign for positives
    public static var automatic: Self {
        .init { false }
    }

    /// Shows sign for all numbers: plus for positives, minus for negatives
    public static var always: Self {
        .init { true }
    }
}

// MARK: - Format.BinaryInteger Format Method

extension Format.BinaryInteger {
    /// Converts the integer to a string using this format's configuration.
    ///
    /// - Parameter value: Integer value to format
    /// - Returns: Formatted string representation
    public func format<T: Swift.BinaryInteger>(_ value: T) -> String {
        let absValue = value.magnitude
        var digits = String(absValue, radix: radix)

        // Apply zero-padding if minWidth is specified
        if let minWidth = minWidth {
            let padding = max(0, minWidth - digits.count)
            digits = String(repeating: "0", count: padding) + digits
        }

        var result = prefix + digits

        // Handle sign
        if value < 0 {
            result = "-" + result
        } else if signStrategy.shouldAlwaysShowSign {
            result = "+" + result
        }

        return result
    }
}

// MARK: - Format.BinaryInteger Static Properties

extension Format.BinaryInteger {
    /// Decimal format (base 10) for integers
    ///
    /// Equivalent to `.decimal`. Use this as the standard numeric format.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 42.formatted(.number)  // "42"
    /// ```
    public static var number: Self {
        .decimal
    }

    /// Standard decimal format (base 10) without prefix
    public static var decimal: Self {
        .init(radix: 10, prefix: "", signStrategy: .automatic, minWidth: nil)
    }

    /// Binary format (base 2) with "0b" prefix
    public static var binary: Self {
        .init(radix: 2, prefix: "0b", signStrategy: .automatic, minWidth: nil)
    }

    /// Octal format (base 8) with "0o" prefix
    public static var octal: Self {
        .init(radix: 8, prefix: "0o", signStrategy: .automatic, minWidth: nil)
    }
}

// MARK: - Format.BinaryInteger Chaining Methods

extension Format.BinaryInteger {
    /// Returns a format with the specified sign display strategy.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 42.formatted(.decimal.sign(strategy: .always))   // "+42"
    /// (-42).formatted(.decimal.sign(strategy: .always))  // "-42"
    /// ```
    public func sign(strategy: SignDisplayStrategy) -> Self {
        .init(radix: radix, prefix: prefix, signStrategy: strategy, minWidth: minWidth)
    }

    /// Returns a format that pads with leading zeros to the specified width.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 5.formatted(.decimal.zeroPadded(width: 2))   // "05"
    /// 42.formatted(.decimal.zeroPadded(width: 4))  // "0042"
    /// ```
    public func zeroPadded(width: Int) -> Self {
        .init(radix: radix, prefix: prefix, signStrategy: signStrategy, minWidth: width)
    }
}

// MARK: - BinaryInteger Extension

extension Swift.BinaryInteger {
    /// Converts this integer to a string using the specified format.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 42.formatted(.binary)   // "0b101010"
    /// 63.formatted(.octal)    // "0o77"
    /// 42.formatted(.decimal)  // "42"
    /// ```
    ///
    /// - Parameter format: Format style to apply
    /// - Returns: Formatted string representation
    public func formatted(_ format: Format.BinaryInteger) -> String {
        format.format(self)
    }
}
