//
//  Parsing.EndOfInput.Error.swift
//  swift-standards
//
//  Errors from unexpected end of input.
//

extension Parsing.EndOfInput {
    /// Errors from unexpected end of input conditions.
    ///
    /// Used by parsers that require more input to continue:
    /// - `First.Element` requiring at least one element
    /// - `Literal` requiring enough bytes to match
    /// - Sequence parsers needing continuation
    public enum Error: Swift.Error, Sendable, Equatable {
        /// Input ended when more was expected.
        ///
        /// - Parameter expected: Description of what was expected
        case unexpected(expected: String)
    }
}
