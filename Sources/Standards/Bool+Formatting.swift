import Formatting

extension Bool {
    /// Formats this boolean using the specified boolean format.
    ///
    /// Use this method with static format properties:
    ///
    /// ```swift
    /// let result = true.formatted(.yesNo)
    /// // result == "yes"
    /// ```
    ///
    /// - Parameter format: The boolean format to use.
    /// - Returns: The formatted representation of this boolean.
    public func formatted(_ format: Format) -> String {
        format.format(self)
    }

    /// Formats this boolean using a custom format style.
    ///
    /// Use this method to format a boolean with a custom format style:
    ///
    /// ```swift
    /// let result = true.formatted(MyCustomStyle())
    /// ```
    ///
    /// - Parameter style: The format style to use for formatting.
    /// - Returns: The formatted representation of this boolean.
    public func formatted<S: Formatting>(_ style: S) -> S.FormatOutput where S.FormatInput == Bool {
        style.format(self)
    }

    /// Formats this boolean using the default boolean format.
    ///
    /// - Returns: A boolean format that can be configured.
    public func formatted() -> Format {
        Format()
    }
}

// MARK: - Bool Format

extension Bool {
    /// A format for formatting booleans.
    ///
    /// Use static properties to access predefined formats:
    ///
    /// ```swift
    /// true.formatted(.trueFalse)  // "true"
    /// true.formatted(.yesNo)      // "yes"
    /// true.formatted(.onOff)      // "on"
    /// true.formatted(.numeric)    // "1"
    /// ```
    ///
    /// Chain methods to configure the format:
    ///
    /// ```swift
    /// true.formatted(.yesNo.uppercased())  // "YES"
    /// false.formatted(.onOff.uppercased()) // "OFF"
    /// ```
    public struct Format: Formatting {
        public let style: Style
        public let isUppercased: Bool

        public init(
            style: Style = .trueFalse,
            isUppercased: Bool = false
        ) {
            self.style = style
            self.isUppercased = isUppercased
        }
    }
}

// MARK: - Bool.Format.Style

extension Bool.Format {
    public struct Style: Sendable {
        let apply: @Sendable (_ value: Bool) -> (trueString: String, falseString: String)

        public init(apply: @escaping @Sendable (_ value: Bool) -> (trueString: String, falseString: String)) {
            self.apply = apply
        }
    }
}

// MARK: - Bool.Format.Style Static Properties

extension Bool.Format.Style {
    /// Formats the boolean as "true" or "false".
    public static var trueFalse: Self {
        .init { _ in ("true", "false") }
    }

    /// Formats the boolean as "yes" or "no".
    public static var yesNo: Self {
        .init { _ in ("yes", "no") }
    }

    /// Formats the boolean as "on" or "off".
    public static var onOff: Self {
        .init { _ in ("on", "off") }
    }

    /// Formats the boolean as "1" or "0".
    public static var numeric: Self {
        .init { _ in ("1", "0") }
    }
}

// MARK: - Bool.Format Methods

extension Bool.Format {
    public func format(_ value: Bool) -> String {
        let (trueString, falseString) = style.apply(value)
        let result = value ? trueString : falseString
        return isUppercased ? result.uppercased() : result
    }
}

// MARK: - Bool.Format Static Properties

extension Bool.Format {
    /// Formats the boolean as "true" or "false".
    public static var trueFalse: Self {
        .init(style: .trueFalse)
    }

    /// Formats the boolean as "yes" or "no".
    public static var yesNo: Self {
        .init(style: .yesNo)
    }

    /// Formats the boolean as "on" or "off".
    public static var onOff: Self {
        .init(style: .onOff)
    }

    /// Formats the boolean as "1" or "0".
    public static var numeric: Self {
        .init(style: .numeric)
    }
}

// MARK: - Bool.Format Chaining Methods

extension Bool.Format {
    /// Formats the boolean output as uppercase.
    ///
    /// ```swift
    /// true.formatted(.yesNo.uppercased())  // "YES"
    /// false.formatted(.onOff.uppercased()) // "OFF"
    /// ```
    public func uppercased() -> Self {
        .init(style: style, isUppercased: true)
    }
}
