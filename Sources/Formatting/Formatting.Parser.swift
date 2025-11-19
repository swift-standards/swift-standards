extension Format {
    /// A type that can parse a representation into a value.
    ///
    /// Conform to this protocol to create custom parsing strategies that can convert
    /// formatted representations back into their original values.
    ///
    /// ## Example
    ///
    /// ```swift
    /// struct UppercaseParser: Format.Parsing {
    ///     func parse(_ value: String) throws -> String {
    ///         guard value == value.uppercased() else {
    ///             throw ParseError.notUppercase
    ///         }
    ///         return value.lowercased()
    ///     }
    /// }
    /// ```
    ///
    /// - Note: Parsing strategies are the inverse of formatting, converting formatted
    ///   output back into the original input type.
    public protocol Parsing: Sendable {
        /// The type of the formatted representation to parse.
        associatedtype ParseInput

        /// The type of value produced by parsing.
        associatedtype ParseOutput

        /// Parses the given representation into a value.
        ///
        /// - Parameter value: The formatted representation to parse.
        /// - Returns: The parsed value.
        /// - Throws: An error if parsing fails.
        func parse(_ value: ParseInput) throws -> ParseOutput
    }
}

// MARK: - Convenience Methods

extension Format.Parsing {
    /// Parses the given representation into a value.
    ///
    /// This method provides function call syntax for parsing:
    ///
    /// ```swift
    /// let parser = UppercaseParser()
    /// let result = try parser("HELLO")  // "hello"
    /// ```
    ///
    /// - Parameter value: The formatted representation to parse.
    /// - Returns: The parsed value.
    /// - Throws: An error if parsing fails.
    public func callAsFunction(_ value: ParseInput) throws -> ParseOutput {
        try parse(value)
    }
}
