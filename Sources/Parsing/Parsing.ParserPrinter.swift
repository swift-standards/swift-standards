//
//  Parsing.ParserPrinter.swift
//  swift-standards
//
//  ParserPrinter protocol combining Parser and Printer.
//

extension Parsing {
    /// A type that can both parse and print.
    ///
    /// ParserPrinter combines `Parser` and `Printer`, enabling bidirectional
    /// transformations between input and output representations. Both operations
    /// share the same `Failure` type for consistency.
    ///
    /// ## Round-Trip Guarantee
    ///
    /// A well-formed ParserPrinter satisfies:
    /// ```
    /// parse(print(value)) == value  // print then parse recovers original
    /// print(parse(input)) == input  // parse then print recovers original
    /// ```
    ///
    /// ## Usage
    ///
    /// ```swift
    /// struct IntParserPrinter: Parsing.ParserPrinter {
    ///     typealias Input = Substring
    ///     typealias Output = Int
    ///     typealias Failure = Parsing.Match.Error
    ///
    ///     func parse(_ input: inout Substring) throws(Failure) -> Int {
    ///         // parse integer from input
    ///     }
    ///
    ///     func print(_ output: Int, into input: inout Substring) throws(Failure) {
    ///         // prepend integer string to input
    ///     }
    /// }
    /// ```
    public protocol ParserPrinter<Input, Output, Failure>: Parser, Printer {}
}
