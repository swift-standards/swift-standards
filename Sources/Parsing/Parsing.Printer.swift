//
//  Parsing.Printer.swift
//  swift-standards
//
//  Core Printer protocol definition.
//

extension Parsing {
    /// A type that can print a value into an input.
    ///
    /// Printing is the inverse of parsing: it takes a structured value
    /// and produces an input representation.
    ///
    /// ## Input Construction
    ///
    /// The `print` method prepends to an existing input buffer (passed as `inout`).
    /// This allows printers to be composed in sequence, each prepending their output.
    ///
    /// ## Performance
    ///
    /// Like parsers, printers are designed for zero-copy, non-allocating operation
    /// where possible. The `inout` pattern enables efficient buffer construction.
    ///
    /// ## Error Handling
    ///
    /// Printers use typed throws with a `Failure` associated type, matching
    /// the pattern used by parsers. Printer/parser pairs typically share
    /// the same failure type for consistency.
    ///
    /// ## Example
    ///
    /// ```swift
    /// struct IntPrinter: Parsing.Printer {
    ///     typealias Input = [UInt8]
    ///     typealias Output = Int
    ///     typealias Failure = Parsing.Constraint.Error
    ///
    ///     func print(_ output: Int, into input: inout [UInt8]) throws(Failure) {
    ///         guard output >= 0 else {
    ///             throw .validationFailed(value: "\(output)", reason: "negative")
    ///         }
    ///         input.insert(contentsOf: "\(output)".utf8, at: input.startIndex)
    ///     }
    /// }
    /// ```
    public protocol Printer<Input, Output, Failure> {
        /// The input type this printer produces.
        associatedtype Input

        /// The output type this printer consumes.
        associatedtype Output

        /// The error type this printer can throw.
        ///
        /// Use `Never` for infallible printers.
        associatedtype Failure: Swift.Error & Sendable

        /// Prints a value into the input.
        ///
        /// On success, prepends the printed representation to input.
        /// On failure, throws an error. The input state after failure is undefined.
        ///
        /// - Parameters:
        ///   - output: The value to print.
        ///   - input: The input buffer to prepend to.
        /// - Throws: `Failure` if printing fails.
        func print(_ output: Output, into input: inout Input) throws(Failure)
    }
}

// MARK: - Convenience Extensions

extension Parsing.Printer where Input: RangeReplaceableCollection {
    /// Prints a value, returning the constructed input.
    ///
    /// Use this for top-level printing where you want to create a new input.
    ///
    /// - Parameter output: The value to print.
    /// - Returns: The constructed input.
    /// - Throws: `Failure` if printing fails.
    @inlinable
    public func print(_ output: Output) throws(Failure) -> Input {
        var input = Input()
        try print(output, into: &input)
        return input
    }
}
