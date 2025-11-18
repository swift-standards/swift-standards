import Formatting

extension String {
    /// Formats this string using the specified string format.
    ///
    /// Use this method with static format properties:
    ///
    /// ```swift
    /// let result = "hello".formatted(.uppercased)
    /// // result == "HELLO"
    /// ```
    ///
    /// - Parameter format: The string format to use.
    /// - Returns: The formatted representation of this string.
    public func formatted(_ format: Format) -> String {
        format.format(self)
    }

    /// Formats this string using a custom format style.
    ///
    /// Use this method to format a string with a custom format style:
    ///
    /// ```swift
    /// let result = "hello".formatted(MyCustomStyle())
    /// ```
    ///
    /// - Parameter style: The format style to use for formatting.
    /// - Returns: The formatted representation of this string.
    public func formatted<S: Formatting>(_ style: S) -> S.FormatOutput where S.FormatInput == String {
        style.format(self)
    }

    /// Formats this string using the default string format.
    ///
    /// - Returns: A string format that can be configured.
    public func formatted() -> Format {
        Format()
    }
}

// MARK: - String Format

extension String {
    /// A format for formatting strings.
    ///
    /// Use static properties to access predefined formats:
    ///
    /// ```swift
    /// "hello".formatted(.uppercased)  // "HELLO"
    /// "HELLO".formatted(.lowercased)  // "hello"
    /// "hello world".formatted(.capitalized)  // "Hello World"
    /// ```
    ///
    /// Chain methods to configure the format:
    ///
    /// ```swift
    /// "hello".formatted(.uppercased.prefix(3))  // "HEL"
    /// ```
    public struct Format {
        public let style: Style
        public let prefixLength: Int?

        public init(style: Style = .uppercased, prefixLength: Int? = nil) {
            self.style = style
            self.prefixLength = prefixLength
        }
    }
}

// MARK: - String.Format.Style

extension String.Format {
    public struct Style: Sendable {
        let apply: @Sendable (_ value: String) -> String

        public init(apply: @escaping @Sendable (_ value: String) -> String) {
            self.apply = apply
        }
    }
}

// MARK: - String.Format.Style Static Properties

extension String.Format.Style {
    /// Formats the string as uppercase.
    public static var uppercased: Self {
        .init { $0.uppercased() }
    }

    /// Formats the string as lowercase.
    public static var lowercased: Self {
        .init { $0.lowercased() }
    }

    /// Formats the string as capitalized.
    public static var capitalized: Self {
        .init { value in
            value.split(separator: " ")
                .map { String($0).prefix(1).uppercased() + String($0).dropFirst() }
                .joined(separator: " ")
        }
    }
}

// MARK: - String.Format Methods

extension String.Format: Formatting {
    public func format(_ value: String) -> String {
        let result = style.apply(value)

        if let prefixLength = prefixLength {
            return String(result.prefix(prefixLength))
        }

        return result
    }
}

// MARK: - String.Format Static Properties

extension String.Format {
    /// Formats the string as uppercase.
    public static var uppercased: Self {
        .init(style: .uppercased)
    }

    /// Formats the string as lowercase.
    public static var lowercased: Self {
        .init(style: .lowercased)
    }

    /// Formats the string as capitalized.
    public static var capitalized: Self {
        .init(style: .capitalized)
    }
}

// MARK: - String.Format Chaining Methods

extension String.Format {
    /// Limits the formatted string to the specified prefix length.
    ///
    /// ```swift
    /// "hello world".formatted(.uppercased.prefix(5))  // "HELLO"
    /// ```
    public func prefix(_ length: Int) -> Self {
        .init(style: style, prefixLength: length)
    }
}
