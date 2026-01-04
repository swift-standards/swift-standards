// Binary.Format.Radix.swift
// Radix formatting for integers (binary, octal, hexadecimal).

extension Binary.Format {
    /// Format style for converting integers to different radix representations.
    ///
    /// Use this format to display integer values in different number bases.
    /// Works with all `BinaryInteger` types including `Int`, `UInt`, `Int8`, etc.
    /// Chain methods to configure prefix display, sign display, and zero padding.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 255.formatted(Binary.Format.hex)                      // "ff"
    /// 255.formatted(Binary.Format.hex.prefix)               // "0xff"
    /// 42.formatted(Binary.Format.base2)                     // "101010"
    /// 42.formatted(Binary.Format.bits)                      // "101010" (alias)
    /// 63.formatted(Binary.Format.octal)                     // "77"
    /// 42.formatted(Binary.Format.decimal.sign(.always))     // "+42"
    /// 5.formatted(Binary.Format.decimal.zeroPadded(width: 3)) // "005"
    /// ```
    public struct Radix: Sendable {
        @usableFromInline
        let radix: Int

        @usableFromInline
        let prefixString: String

        @usableFromInline
        let showPrefix: Bool

        public let signStrategy: SignDisplayStrategy
        public let minWidth: Int?

        @usableFromInline
        init(
            radix: Int,
            prefix: String,
            showPrefix: Bool = false,
            signStrategy: SignDisplayStrategy = .automatic,
            minWidth: Int? = nil
        ) {
            self.radix = radix
            self.prefixString = prefix
            self.showPrefix = showPrefix
            self.signStrategy = signStrategy
            self.minWidth = minWidth
        }

        public init(signStrategy: SignDisplayStrategy = .automatic, minWidth: Int? = nil) {
            self.radix = 10
            self.prefixString = ""
            self.showPrefix = false
            self.signStrategy = signStrategy
            self.minWidth = minWidth
        }
    }
}

// MARK: - SignDisplayStrategy

extension Binary.Format.Radix {
    /// Strategy controlling sign display for formatted integers.
    ///
    /// Determines whether to show plus signs for positive numbers,
    /// only minus signs for negatives, or always show both.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 42.formatted(Binary.Format.decimal.sign(.always))    // "+42"
    /// (-5).formatted(Binary.Format.decimal.sign(.always))  // "-5"
    /// ```
    public struct SignDisplayStrategy: Sendable {
        @usableFromInline
        let _shouldAlwaysShowSign: @Sendable () -> Bool

        @usableFromInline
        init(shouldAlwaysShowSign: @escaping @Sendable () -> Bool) {
            self._shouldAlwaysShowSign = shouldAlwaysShowSign
        }

        @usableFromInline
        var shouldAlwaysShowSign: Bool {
            _shouldAlwaysShowSign()
        }
    }
}

// MARK: - SignDisplayStrategy Static Properties

extension Binary.Format.Radix.SignDisplayStrategy {
    /// Displays minus sign for negatives only, no sign for positives.
    @inlinable
    public static var automatic: Self {
        .init { false }
    }

    /// Shows sign for all numbers: plus for positives, minus for negatives.
    @inlinable
    public static var always: Self {
        .init { true }
    }
}

// MARK: - Format Method

extension Binary.Format.Radix {
    /// Converts the integer to a string using this format's configuration.
    public func format<T: Swift.BinaryInteger>(_ value: T) -> String {
        let absValue = value.magnitude
        var digits = String(absValue, radix: radix)

        // Apply zero-padding if minWidth is specified
        if let minWidth = minWidth {
            let padding = max(0, minWidth - digits.count)
            digits = String(repeating: "0", count: padding) + digits
        }

        // Apply prefix if enabled
        var result = showPrefix ? prefixString + digits : digits

        // Handle sign
        if value < 0 {
            result = "-" + result
        } else if signStrategy.shouldAlwaysShowSign {
            result = "+" + result
        }

        return result
    }
}

// MARK: - Static Properties

extension Binary.Format.Radix {
    /// Decimal format (base 10) for integers.
    @inlinable
    public static var decimal: Self {
        .init(radix: 10, prefix: "")
    }

    /// Alias for decimal format.
    @inlinable
    public static var number: Self { .decimal }

    /// Base-2 (binary) format for integers.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 42.formatted(Binary.Format.base2)         // "101010"
    /// 42.formatted(Binary.Format.base2.prefix)  // "0b101010"
    /// ```
    @inlinable
    public static var base2: Self {
        .init(radix: 2, prefix: "0b")
    }

    /// Alias for base2 format.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 255.formatted(Binary.Format.bits)  // "11111111"
    /// ```
    @inlinable
    public static var bits: Self { .base2 }

    /// Octal format (base 8) for integers.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 63.formatted(Binary.Format.octal)         // "77"
    /// 63.formatted(Binary.Format.octal.prefix)  // "0o77"
    /// ```
    @inlinable
    public static var octal: Self {
        .init(radix: 8, prefix: "0o")
    }

    /// Hexadecimal format (base 16) for integers.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 255.formatted(Binary.Format.hex)         // "ff"
    /// 255.formatted(Binary.Format.hex.prefix)  // "0xff"
    /// ```
    @inlinable
    public static var hex: Self {
        .init(radix: 16, prefix: "0x")
    }
}

// MARK: - Chaining Methods

extension Binary.Format.Radix {
    /// Returns a format that includes the radix prefix.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 255.formatted(Binary.Format.hex.prefix)   // "0xff"
    /// 42.formatted(Binary.Format.base2.prefix)  // "0b101010"
    /// ```
    @inlinable
    public var prefix: Self {
        .init(
            radix: radix,
            prefix: prefixString,
            showPrefix: true,
            signStrategy: signStrategy,
            minWidth: minWidth
        )
    }

    /// Returns a format with the specified sign display strategy.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 42.formatted(Binary.Format.decimal.sign(.always))   // "+42"
    /// (-42).formatted(Binary.Format.decimal.sign(.always))  // "-42"
    /// ```
    @inlinable
    public func sign(_ strategy: SignDisplayStrategy) -> Self {
        .init(
            radix: radix,
            prefix: prefixString,
            showPrefix: showPrefix,
            signStrategy: strategy,
            minWidth: minWidth
        )
    }

    /// Returns a format that pads with leading zeros to the specified width.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 5.formatted(Binary.Format.decimal.zeroPadded(width: 2))   // "05"
    /// 42.formatted(Binary.Format.decimal.zeroPadded(width: 4))  // "0042"
    /// ```
    @inlinable
    public func zeroPadded(width: Int) -> Self {
        .init(
            radix: radix,
            prefix: prefixString,
            showPrefix: showPrefix,
            signStrategy: signStrategy,
            minWidth: width
        )
    }
}

// MARK: - Binary.Format Static Properties

extension Binary.Format {
    /// Decimal format (base 10) for integers.
    @inlinable
    public static var decimal: Radix { .decimal }

    /// Alias for decimal format.
    @inlinable
    public static var number: Radix { .number }

    /// Base-2 (binary) format for integers.
    @inlinable
    public static var base2: Radix { .base2 }

    /// Alias for base2 format.
    @inlinable
    public static var bits: Radix { .bits }

    /// Octal format (base 8) for integers.
    @inlinable
    public static var octal: Radix { .octal }

    /// Hexadecimal format (base 16) for integers.
    @inlinable
    public static var hex: Radix { .hex }
}

// MARK: - BinaryInteger Extension

extension BinaryInteger {
    /// Formats this integer using the specified radix format.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 255.formatted(Binary.Format.hex)    // "ff"
    /// 42.formatted(Binary.Format.base2)   // "101010"
    /// 63.formatted(Binary.Format.octal)   // "77"
    /// ```
    @inlinable
    public func formatted(_ format: Binary.Format.Radix) -> String {
        format.format(self)
    }
}
