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
    /// ## Example
    ///
    /// ```swift
    /// struct IntPrinter: Parsing.Printer {
    ///     typealias Input = [UInt8]
    ///     typealias Output = Int
    ///
    ///     func print(_ output: Int, into input: inout [UInt8]) throws(Parsing.Error) {
    ///         input.insert(contentsOf: "\(output)".utf8, at: input.startIndex)
    ///     }
    /// }
    /// ```
    public protocol Printer<Input, Output> {
        /// The input type this printer produces.
        associatedtype Input

        /// The output type this printer consumes.
        associatedtype Output

        /// Prints a value into the input.
        ///
        /// On success, prepends the printed representation to input.
        /// On failure, throws an error. The input state after failure is undefined.
        ///
        /// - Parameters:
        ///   - output: The value to print.
        ///   - input: The input buffer to prepend to.
        /// - Throws: `Parsing.Error` if printing fails.
        func print(_ output: Output, into input: inout Input) throws(Parsing.Error)
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
    /// - Throws: If printing fails.
    @inlinable
    public func print(_ output: Output) throws(Parsing.Error) -> Input {
        var input = Input()
        try print(output, into: &input)
        return input
    }
}
