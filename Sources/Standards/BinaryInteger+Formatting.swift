import Formatting

// MARK: - BinaryIntegerFormat

/// A format for formatting any BinaryInteger value.
///
/// This categorical format works for all BinaryInteger types (Int, UInt, Int8, etc.).
/// It provides operations specific to the BinaryInteger category:
/// - Radix representations (hex, binary, octal)
/// - Sign display strategies
///
/// Note: This is a generic categorical formatter that operates across the BinaryInteger category.
/// It does not conform to `Formatting` as it works with multiple input types, not a single FormatInput.
///
/// Use static properties to access predefined formats:
///
/// ```swift
/// 42.formatted(.number)  // "42"
/// 255.formatted(.hex)    // "0xff"
/// 42.formatted(.binary)  // "0b101010"
/// UInt8(255).formatted(.octal)  // "0o377"
/// ```
///
/// Chain methods to configure the format:
///
/// ```swift
/// 42.formatted(.number.sign(strategy: .always))  // "+42"
/// 255.formatted(.hex.uppercase())                // "0xFF"
/// ```
public struct BinaryIntegerFormat {
    let radix: Int
    let prefix: String
    public let signStrategy: SignDisplayStrategy
    public let isUppercase: Bool

    private init(radix: Int, prefix: String, signStrategy: SignDisplayStrategy, isUppercase: Bool) {
        self.radix = radix
        self.prefix = prefix
        self.signStrategy = signStrategy
        self.isUppercase = isUppercase
    }

    public init(signStrategy: SignDisplayStrategy = .automatic, isUppercase: Bool = false) {
        self.radix = 10
        self.prefix = ""
        self.signStrategy = signStrategy
        self.isUppercase = isUppercase
    }
}

// MARK: - BinaryIntegerFormat.SignDisplayStrategy

extension BinaryIntegerFormat {
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

// MARK: - BinaryIntegerFormat.SignDisplayStrategy Static Properties

extension BinaryIntegerFormat.SignDisplayStrategy {
    /// Shows sign only for negative numbers.
    public static var automatic: Self {
        .init { false }
    }

    /// Always shows sign for positive and negative numbers.
    public static var always: Self {
        .init { true }
    }
}

// MARK: - BinaryIntegerFormat Format Method

extension BinaryIntegerFormat {
    /// Formats a binary integer value.
    ///
    /// This is a generic method that works across all BinaryInteger types.
    public func format<T: BinaryInteger>(_ value: T) -> String {
        let absValue = value.magnitude
        var digits = String(absValue, radix: radix)

        if isUppercase {
            digits = digits.uppercased()
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

// MARK: - BinaryIntegerFormat Static Properties

extension BinaryIntegerFormat {
    /// Formats the binary integer as a decimal number.
    public static var number: Self {
        .init(radix: 10, prefix: "", signStrategy: .automatic, isUppercase: false)
    }

    /// Formats the binary integer as hexadecimal.
    public static var hex: Self {
        .init(radix: 16, prefix: "0x", signStrategy: .automatic, isUppercase: false)
    }

    /// Formats the binary integer as binary.
    public static var binary: Self {
        .init(radix: 2, prefix: "0b", signStrategy: .automatic, isUppercase: false)
    }

    /// Formats the binary integer as octal.
    public static var octal: Self {
        .init(radix: 8, prefix: "0o", signStrategy: .automatic, isUppercase: false)
    }
}

// MARK: - BinaryIntegerFormat Chaining Methods

extension BinaryIntegerFormat {
    /// Configures the sign display strategy.
    ///
    /// ```swift
    /// 42.formatted(BinaryIntegerFormat.number.sign(strategy: .always))  // "+42"
    /// (-42).formatted(BinaryIntegerFormat.number.sign(strategy: .always))  // "-42"
    /// ```
    public func sign(strategy: SignDisplayStrategy) -> Self {
        .init(radix: radix, prefix: prefix, signStrategy: strategy, isUppercase: isUppercase)
    }

    /// Formats hex letters as uppercase.
    ///
    /// ```swift
    /// 255.formatted(BinaryIntegerFormat.hex.uppercase())  // "0xFF"
    /// ```
    public func uppercase() -> Self {
        .init(radix: radix, prefix: prefix, signStrategy: signStrategy, isUppercase: true)
    }
}

// MARK: - BinaryInteger Extension

extension BinaryInteger {
    /// Formats this binary integer using the specified binary integer format.
    ///
    /// Use this method with static format properties:
    ///
    /// ```swift
    /// let result = 42.formatted(.number)
    /// let result = UInt8(255).formatted(.hex)
    /// let result = 255.formatted(.hex.uppercase())
    /// ```
    ///
    /// - Parameter format: The binary integer format to use.
    /// - Returns: The formatted representation of this binary integer.
    public func formatted(_ format: BinaryIntegerFormat) -> String {
        format.format(self)
    }
}
