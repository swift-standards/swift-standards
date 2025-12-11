// String.swift
// swift-standards
//
// Pure Swift string manipulation utilities

// String trimming has been moved to swift-incits-4-1986

extension String {
    /// A case-insensitive string wrapper for use as dictionary keys and in comparisons.
    ///
    /// Provides case-insensitive hashing and equality checking, enabling case-insensitive lookups in dictionaries and sets.
    /// Use this when you need to treat strings like "Content-Type" and "content-type" as equal.
    ///
    /// ## Example
    ///
    /// ```swift
    /// var headers: [String.CaseInsensitive: String] = [:]
    /// headers["Content-Type".caseInsensitive] = "text/html"
    /// headers["content-type".caseInsensitive]  // "text/html"
    /// ```
    public struct CaseInsensitive: Hashable, Comparable, Sendable {
        public let value: String

        public init(_ value: some StringProtocol) {
            self.value = String(value)
        }

        public func hash(into hasher: inout Hasher) {
            value.lowercased().hash(into: &hasher)
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.value.lowercased() == rhs.value.lowercased()
        }

        public static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.value.lowercased() < rhs.value.lowercased()
        }
    }

    /// A case-insensitive wrapper for the string.
    public var caseInsensitive: CaseInsensitive {
        CaseInsensitive(self)
    }
}

// ASCII validation methods have been moved to swift-incits-4-1986

extension String {
    /// A case transformation style for string formatting.
    ///
    /// Represents different ways to transform string casing (upper, lower, title, sentence).
    /// Extensible design allows custom case transformations by providing a closure.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let customCase = String.Case { string in
    ///     string.map { $0.isLetter ? $0.uppercased() : $0.lowercased() }.joined()
    /// }
    /// let result = customCase.transform("hello world")
    /// ```
    public struct Case: Sendable {
        let transform: @Sendable (String) -> String

        public init(transform: @escaping @Sendable (String) -> String) {
            self.transform = transform
        }

        /// Uppercase transformation (HELLO WORLD).
        public static let upper = Case { $0.uppercased() }

        /// Lowercase transformation (hello world).
        public static let lower = Case { $0.lowercased() }

        /// Title case transformation (Hello World).
        public static let title = Case { string in
            string.split(separator: " ")
                .map { word in
                    guard let first = word.first else { return "" }
                    return first.uppercased() + word.dropFirst().lowercased()
                }
                .joined(separator: " ")
        }

        /// Sentence case transformation (Hello world).
        public static let sentence = Case { string in
            guard let first = string.first else { return string }
            return first.uppercased() + string.dropFirst().lowercased()
        }
    }

}

// StringProtocol extensions have been moved to StringProtocol.swift

extension String {
    /// The string split into separate lines.
    ///
    /// ## Example
    ///
    /// ```swift
    /// "hello\nworld\ntest".lines  // ["hello", "world", "test"]
    /// "single line".lines         // ["single line"]
    /// ```
    public var lines: [String] {
        split(whereSeparator: \.isNewline).map(String.init)
    }

    /// The string split into separate words.
    ///
    /// ## Example
    ///
    /// ```swift
    /// "hello world test".words  // ["hello", "world", "test"]
    /// "single".words            // ["single"]
    /// ```
    public var words: [String] {
        split(whereSeparator: \.isWhitespace).map(String.init)
    }
}
