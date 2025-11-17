// String.swift
// swift-standards
//
// Pure Swift string manipulation utilities

// String trimming has been moved to swift-incits-4-1986

extension String {
    /// Creates a hexadecimal encoded string from bytes
    /// - Parameter hexEncoding: The bytes to encode
    public init(hexEncoding bytes: [UInt8]) {
        guard !bytes.isEmpty else {
            self = ""
            return
        }

        var result = [UInt8]()
        result.reserveCapacity(bytes.count * 2)

        for byte in bytes {
            let high = (byte >> 4) & 0x0F
            let low = byte & 0x0F
            result.append([UInt8].hexEncodeTable[Int(high)])
            result.append([UInt8].hexEncodeTable[Int(low)])
        }

        self = String(decoding: result, as: UTF8.self)
    }
}

extension String {
    /// Percent-encodes a string, preserving specified characters
    /// - Parameters:
    ///   - string: The string to encode
    ///   - allowed: Set of characters that should not be encoded
    ///   - uppercaseHex: Whether to use uppercase hex digits (A-F) instead of lowercase (a-f)
    /// - Returns: Percent-encoded string
    public static func percentEncoded(
        string: String,
        allowing allowed: Set<Character>,
        uppercaseHex: Bool = false
    ) -> String {
        var result = ""
        result.reserveCapacity(string.count)

        let hexTable = uppercaseHex ? [UInt8].hexEncodeTableUppercase : [UInt8].hexEncodeTable

        for char in string {
            if allowed.contains(char) {
                result.append(char)
            } else {
                // Encode as UTF-8 bytes
                for byte in String(char).utf8 {
                    result.append("%")
                    let high = (byte >> 4) & 0x0F
                    let low = byte & 0x0F
                    result.append(Character(UnicodeScalar(hexTable[Int(high)])))
                    result.append(Character(UnicodeScalar(hexTable[Int(low)])))
                }
            }
        }

        return result
    }

    /// Percent-encodes a string, preserving specified characters
    /// - Parameters:
    ///   - allowed: Set of characters that should not be encoded
    ///   - uppercaseHex: Whether to use uppercase hex digits (A-F) instead of lowercase (a-f)
    /// - Returns: Percent-encoded string
    public func percentEncoded(allowing allowed: Set<Character>, uppercaseHex: Bool = false) -> String {
        Self.percentEncoded(string: self, allowing: allowed, uppercaseHex: uppercaseHex)
    }

    /// Decodes a percent-encoded string
    /// - Parameter string: The percent-encoded string to decode
    /// - Returns: Decoded string, or original string if decoding fails
    public static func percentDecoded(string: String) -> String {
        var bytes = [UInt8]()
        bytes.reserveCapacity(string.count)

        var iterator = string.utf8.makeIterator()

        while let byte = iterator.next() {
            if byte == 0x25 {  // '%'
                // Read next two hex digits
                guard let high = iterator.next(),
                      let low = iterator.next() else {
                    return string
                }

                let decodeTable = [UInt8].hexDecodeTable
                let highValue = decodeTable[Int(high)]
                let lowValue = decodeTable[Int(low)]

                guard highValue != 255 && lowValue != 255 else {
                    return string
                }

                bytes.append((highValue << 4) | lowValue)
            } else {
                bytes.append(byte)
            }
        }

        return String(decoding: bytes, as: UTF8.self)
    }

    /// Decodes a percent-encoded string
    /// - Returns: Decoded string, or original string if decoding fails
    public func percentDecoded() -> String {
        Self.percentDecoded(string: self)
    }
}

extension String {
    /// Case-insensitive string wrapper for use as dictionary keys and comparisons
    ///
    /// Provides case-insensitive hashing and equality checking, enabling
    /// case-insensitive lookups in dictionaries and sets.
    ///
    /// Example:
    /// ```swift
    /// var headers: [String.CaseInsensitive: String] = [:]
    /// headers["Content-Type".caseInsensitive] = "text/html"
    /// headers["content-type".caseInsensitive]  // "text/html"
    /// ```
    public struct CaseInsensitive: Hashable, Comparable, Sendable {
        public let value: String

        public init(_ value: String) {
            self.value = value
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

    /// Returns a case-insensitive wrapper for this string
    public var caseInsensitive: CaseInsensitive {
        CaseInsensitive(self)
    }
}

// ASCII validation methods have been moved to swift-incits-4-1986

extension String {
    /// String case style for formatting
    ///
    /// This struct allows for extensible case transformations. Third parties can
    /// create custom case formats by providing a closure that transforms strings.
    ///
    /// Example:
    /// ```swift
    /// let customCase = String.Case { string in
    ///     // Custom transformation logic
    ///     return string.map { $0.isLetter ? $0.uppercased() : $0.lowercased() }.joined()
    /// }
    /// let result = "hello world".formatted(as: customCase)
    /// ```
    public struct Case: Sendable {
        let transform: @Sendable (String) -> String

        public init(transform: @escaping @Sendable (String) -> String) {
            self.transform = transform
        }

        /// Convert to uppercase (HELLO WORLD)
        public static let upper = Case { $0.uppercased() }

        /// Convert to lowercase (hello world)
        public static let lower = Case { $0.lowercased() }

        /// Convert to title case (Hello World)
        public static let title = Case { string in
            string.split(separator: " ")
                .map { word in
                    guard let first = word.first else { return "" }
                    return first.uppercased() + word.dropFirst().lowercased()
                }
                .joined(separator: " ")
        }

        /// Convert to sentence case (Hello world)
        public static let sentence = Case { string in
            guard let first = string.first else { return string }
            return first.uppercased() + string.dropFirst().lowercased()
        }
    }

}

extension StringProtocol {
    /// Formats the string using the specified case transformation
    /// - Parameter case: The case format to apply
    /// - Returns: Formatted string
    ///
    /// Example:
    /// ```swift
    /// "hello world".formatted(as: .upper)  // "HELLO WORLD"
    /// "hello world".formatted(as: .title)  // "Hello World"
    /// let sub = "hello world"[...]; sub.formatted(as: .upper)  // Works on Substring too
    /// ```
    public func formatted(as case: String.Case) -> String {
        `case`.transform(String(self))
    }
}

extension String {
    /// Line ending style for text normalization
    public enum LineEnding: String, Sendable {
        /// Unix style: \n
        case lf = "\n"
        /// Old Mac style: \r
        case cr = "\r"
        /// Windows/Network protocol style: \r\n (required by HTTP, Email)
        case crlf = "\r\n"
    }
}

extension String.LineEnding {
    public static let lineFeed: Self = .lf
    public static let carriageReturn: Self = .cr
    public static let carriageReturnLineFeed: Self = .crlf
}

extension String {

    /// Normalizes line endings to the specified style
    ///
    /// Converts all line endings (\n, \r, \r\n) to the target format.
    /// Useful for protocols like HTTP and Email that require CRLF.
    ///
    /// Example:
    /// ```swift
    /// let text = "line1\nline2\r\nline3"
    /// text.normalized(to: .crlf)  // "line1\r\nline2\r\nline3"
    /// ```
    public func normalized(to lineEnding: LineEnding) -> String {
        // Check if normalization is needed by examining bytes
        let hasLF = utf8.contains(0x0A)  // \n
        let hasCR = utf8.contains(0x0D)  // \r

        // Fast path: if already normalized, return self
        if lineEnding == .crlf && !hasLF && !hasCR { return self }
        if lineEnding == .lf && !hasCR { return self }
        if lineEnding == .cr && !hasLF { return self }

        let targetBytes = Array(lineEnding.rawValue.utf8)
        var resultBytes = [UInt8]()
        resultBytes.reserveCapacity(self.utf8.count)

        var index = self.utf8.startIndex
        while index < self.utf8.endIndex {
            let byte = self.utf8[index]

            if byte == 0x0D {  // \r
                let next = self.utf8.index(after: index)
                if next < self.utf8.endIndex && self.utf8[next] == 0x0A {  // \n
                    // \r\n -> normalize
                    resultBytes.append(contentsOf: targetBytes)
                    index = self.utf8.index(after: next)
                    continue
                } else {
                    // \r alone -> normalize
                    resultBytes.append(contentsOf: targetBytes)
                    index = next
                    continue
                }
            } else if byte == 0x0A {  // \n
                // \n alone -> normalize
                resultBytes.append(contentsOf: targetBytes)
                index = self.utf8.index(after: index)
                continue
            }

            resultBytes.append(byte)
            index = self.utf8.index(after: index)
        }

        return String(decoding: resultBytes, as: UTF8.self)
    }
}
