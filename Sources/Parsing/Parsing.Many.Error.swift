//
//  Parsing.Many.Error.swift
//  swift-standards
//
//  Errors from repetition parsers.
//

extension Parsing.Many {
    /// Errors from repetition parsers.
    ///
    /// Note: Element and separator parse failures are caught internally
    /// by `Many` parsers and do not propagate. Only count constraint
    /// violations produce errors.
    public enum Error: Swift.Error, Sendable, Equatable {
        /// Element count below minimum requirement.
        ///
        /// - Parameters:
        ///   - expected: The minimum required count
        ///   - got: The actual count achieved
        case countTooLow(expected: Int, got: Int)

        /// Element count above maximum limit.
        ///
        /// - Parameters:
        ///   - expected: The maximum allowed count
        ///   - got: The actual count
        case countTooHigh(expected: Int, got: Int)
    }
}
