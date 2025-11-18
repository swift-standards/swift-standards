import Formatting

extension Int {
    /// Formats this integer using the specified integer format.
    ///
    /// Use this method with static format properties:
    ///
    /// ```swift
    /// let result = 42.formatted(.number)
    /// ```
    ///
    /// - Parameter format: The integer format to use.
    /// - Returns: The formatted representation of this integer.
    public func formatted(_ format: Format) -> String {
        format.format(self)
    }

    /// Formats this integer using a custom format style.
    ///
    /// Use this method to format an integer with a custom format style:
    ///
    /// ```swift
    /// let result = 42.formatted(MyCustomStyle())
    /// ```
    ///
    /// - Parameter style: The format style to use for formatting.
    /// - Returns: The formatted representation of this integer.
    public func formatted<S: Formatting>(_ style: S) -> S.FormatOutput where S.FormatInput == Int {
        style.format(self)
    }

    /// Formats this integer using the default integer format.
    ///
    /// - Returns: An integer format that can be configured.
    public func formatted() -> Format {
        Format()
    }
}

// MARK: - Int Format

extension Int {
    /// A format for formatting integers.
    ///
    /// Use static properties to access predefined formats:
    ///
    /// ```swift
    /// 42.formatted(.number)  // "42"
    /// 255.formatted(.hex)    // "0xff"
    /// ```
    ///
    /// Chain methods to configure the format:
    ///
    /// ```swift
    /// 42.formatted(.number.sign(strategy: .always))  // "+42"
    /// 255.formatted(.hex.uppercase())                // "0xFF"
    /// ```
    public struct Format: Formatting {
        public let style: Style
        public let signStrategy: SignDisplayStrategy
        public let isUppercase: Bool

        public init(
            style: Style = .number,
            signStrategy: SignDisplayStrategy = .automatic,
            isUppercase: Bool = false
        ) {
            self.style = style
            self.signStrategy = signStrategy
            self.isUppercase = isUppercase
        }
    }
}

// MARK: - Int.Format.Style

extension Int.Format {
    public struct Style: Sendable {
        let apply: @Sendable (_ value: Int, _ isUppercase: Bool) -> String

        public init(apply: @escaping @Sendable (_ value: Int, _ isUppercase: Bool) -> String) {
            self.apply = apply
        }
    }
}

// MARK: - Int.Format.Style Static Properties

extension Int.Format.Style {
    /// Formats the integer as a decimal number.
    public static var number: Self {
        .init { value, _ in "\(abs(value))" }
    }

    /// Formats the integer as hexadecimal.
    public static var hex: Self {
        .init { value, isUppercase in
            let hexDigits = String(abs(value), radix: 16)
            return "0x" + (isUppercase ? hexDigits.uppercased() : hexDigits)
        }
    }

    /// Formats the integer as binary.
    public static var binary: Self {
        .init { value, _ in "0b\(String(abs(value), radix: 2))" }
    }
}

// MARK: - Int.Format.SignDisplayStrategy

extension Int.Format {
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

// MARK: - Int.Format.SignDisplayStrategy Static Properties

extension Int.Format.SignDisplayStrategy {
    /// Shows sign only for negative numbers.
    public static var automatic: Self {
        .init { false }
    }

    /// Always shows sign for positive and negative numbers.
    public static var always: Self {
        .init { true }
    }
}

// MARK: - Int.Format Methods

extension Int.Format {
    public func format(_ value: Int) -> String {
        var result = style.apply(value, isUppercase)

        // Handle sign
        if value < 0 {
            result = "-" + result
        } else if signStrategy.shouldAlwaysShowSign {
            result = "+" + result
        }

        return result
    }
}

// MARK: - Int.Format Static Properties

extension Int.Format {
    /// Formats the integer as a decimal number.
    public static var number: Self {
        .init(style: .number)
    }

    /// Formats the integer as hexadecimal.
    public static var hex: Self {
        .init(style: .hex)
    }

    /// Formats the integer as binary.
    public static var binary: Self {
        .init(style: .binary)
    }
}

// MARK: - Int.Format Chaining Methods

extension Int.Format {
    /// Configures the sign display strategy.
    ///
    /// ```swift
    /// 42.formatted(.number.sign(strategy: .always))  // "+42"
    /// (-42).formatted(.number.sign(strategy: .always))  // "-42"
    /// ```
    public func sign(strategy: SignDisplayStrategy) -> Self {
        .init(style: style, signStrategy: strategy, isUppercase: isUppercase)
    }

    /// Formats hex letters as uppercase.
    ///
    /// ```swift
    /// 255.formatted(.hex.uppercase())  // "0xFF"
    /// ```
    public func uppercase() -> Self {
        .init(style: style, signStrategy: signStrategy, isUppercase: true)
    }
}
