extension Format {
    /// A type that can both format values and parse formatted representations.
    ///
    /// Conform to this protocol to create bidirectional formatting that can convert
    /// values to formatted representations and parse those representations back.
    ///
    /// ## Example
    ///
    /// ```swift
    /// struct ReversibleUppercaseFormat: Format.Reversible {
    ///     func format(_ value: String) -> String {
    ///         value.uppercased()
    ///     }
    ///
    ///     func parse(_ value: String) throws -> String {
    ///         value.lowercased()
    ///     }
    /// }
    ///
    /// let formatter = ReversibleUppercaseFormat()
    /// let formatted = formatter.format("hello")  // "HELLO"
    /// let parsed = try formatter.parse("HELLO")  // "hello"
    /// ```
    ///
    /// - Note: This protocol is a convenience that combines `Formatting` and `Parsing`.
    ///   The format input type must match the parse output type, and vice versa.
    public protocol Reversible: Formatting, Parsing
        where FormatInput == ParseOutput, FormatOutput == ParseInput {}
}
