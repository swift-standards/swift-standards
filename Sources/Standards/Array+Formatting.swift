import Formatting

extension Array where Element == String {
    /// Formats this array using the specified array format.
    ///
    /// Use this method with static format properties:
    ///
    /// ```swift
    /// let result = ["a", "b", "c"].formatted(.list)
    /// ```
    ///
    /// - Parameter format: The array format to use.
    /// - Returns: The formatted representation of this array.
    public func formatted(_ format: Format) -> String {
        format.format(self)
    }

    /// Formats this array using a custom format style.
    ///
    /// Use this method to format an array with a custom format style:
    ///
    /// ```swift
    /// let result = ["a", "b", "c"].formatted(MyCustomStyle())
    /// ```
    ///
    /// - Parameter style: The format style to use for formatting.
    /// - Returns: The formatted representation of this array.
    public func formatted<S: Formatting>(_ style: S) -> S.FormatOutput where S.FormatInput == [String] {
        style.format(self)
    }

    /// Formats this array using the default array format.
    ///
    /// - Returns: An array format that can be configured.
    public func formatted() -> Format {
        Format()
    }
}

// MARK: - String Array Format

extension Array where Element == String {
    /// A format for formatting string arrays.
    ///
    /// Use static properties to access predefined formats:
    ///
    /// ```swift
    /// ["a", "b", "c"].formatted(.list)  // "a, b, c"
    /// ```
    ///
    /// Chain methods to configure the format:
    ///
    /// ```swift
    /// ["a", "b", "c"].formatted(.list.separator("; "))  // "a; b; c"
    /// ["a", "b", "c"].formatted(.bullets.prefix("→ "))  // "→ a\n→ b\n→ c"
    /// ```
    public struct Format: Formatting {
        public let style: Style
        public let customSeparator: String?
        public let customPrefix: String?

        public init(
            style: Style = .list,
            customSeparator: String? = nil,
            customPrefix: String? = nil
        ) {
            self.style = style
            self.customSeparator = customSeparator
            self.customPrefix = customPrefix
        }
    }
}

// MARK: - Array<String>.Format.Style

extension Array<String>.Format {
    public struct Style: Sendable {
        let apply: @Sendable ([String], _ customSeparator: String?, _ customPrefix: String?) -> String

        public init(apply: @escaping @Sendable (_ value: [String], _ customSeparator: String?, _ customPrefix: String?) -> String) {
            self.apply = apply
        }
    }
}

// MARK: - Array<String>.Format.Style Static Properties

extension Array<String>.Format.Style {
    /// Formats the array as a comma-separated list.
    public static var list: Self {
        .init { value, customSeparator, _ in
            let separator = customSeparator ?? ", "
            return value.joined(separator: separator)
        }
    }

    /// Formats the array as a bulleted list.
    public static var bullets: Self {
        .init { value, _, customPrefix in
            let prefix = customPrefix ?? "• "
            return value
                .map { prefix + $0 }
                .joined(separator: "\n")
        }
    }
}

// MARK: - Array<String>.Format Methods

extension Array<String>.Format {
    public func format(_ value: [String]) -> String {
        style.apply(value, customSeparator, customPrefix)
    }
}

// MARK: - Array<String>.Format Static Properties

extension Array<String>.Format {
    /// Formats the array as a comma-separated list.
    public static var list: Self {
        .init(style: .list)
    }

    /// Formats the array as a bulleted list.
    public static var bullets: Self {
        .init(style: .bullets)
    }
}

// MARK: - Array<String>.Format Chaining Methods

extension Array<String>.Format {
    /// Sets a custom separator for list formatting.
    ///
    /// ```swift
    /// ["a", "b", "c"].formatted(.list.separator("; "))  // "a; b; c"
    /// ["a", "b", "c"].formatted(.list.separator(" | "))  // "a | b | c"
    /// ```
    public func separator(_ separator: String) -> Self {
        .init(style: style, customSeparator: separator, customPrefix: customPrefix)
    }

    /// Sets a custom prefix for bullet formatting.
    ///
    /// ```swift
    /// ["a", "b", "c"].formatted(.bullets.prefix("→ "))  // "→ a\n→ b\n→ c"
    /// ["a", "b", "c"].formatted(.bullets.prefix("- "))  // "- a\n- b\n- c"
    /// ```
    public func prefix(_ prefix: String) -> Self {
        .init(style: style, customSeparator: customSeparator, customPrefix: prefix)
    }
}

// MARK: - Generic Array Extension

extension Array {
    /// Formats this array using the specified format style.
    ///
    /// Use this method to format an array with a custom format style.
    ///
    /// - Parameter style: The format style to use for formatting.
    /// - Returns: The formatted representation of this array.
    public func formatted<S: Formatting>(_ style: S) -> S.FormatOutput where S.FormatInput == [Element] {
        style.format(self)
    }
}
