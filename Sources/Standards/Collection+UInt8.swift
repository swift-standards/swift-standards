//
//  Collection+UInt8.swift
//  swift-standards
//
//  Created by Coen ten Thije Boonkkamp on 25/11/2025.
//

// MARK: - Byte Collection Trimming

extension Collection where Element == UInt8 {
    /// Trims bytes from both ends of a collection (authoritative implementation)
    ///
    /// - Parameters:
    ///   - bytes: The byte collection to trim
    ///   - predicate: A closure that returns `true` for bytes to trim
    /// - Returns: A subsequence with matching bytes trimmed from both ends
    ///
    /// This method returns a zero-copy view (SubSequence) of the original collection.
    ///
    /// Example:
    /// ```swift
    /// [UInt8].trimming([0x20, 0x48, 0x69, 0x20], where: { $0 == 0x20 })  // [0x48, 0x69]
    /// ```
    public static func trimming<C: Collection>(
        _ bytes: C,
        where predicate: (UInt8) -> Bool
    ) -> C.SubSequence where C.Element == UInt8 {
        var start = bytes.startIndex

        // Trim from start
        while start != bytes.endIndex, predicate(bytes[start]) {
            start = bytes.index(after: start)
        }

        // All bytes were trimmed
        if start == bytes.endIndex {
            return bytes[start..<start]
        }

        // Scan forward, remembering the last index that should NOT be trimmed
        var lastNonTrimIndex = start
        var i = start

        while i != bytes.endIndex {
            if !predicate(bytes[i]) {
                lastNonTrimIndex = i
            }
            i = bytes.index(after: i)
        }

        let end = bytes.index(after: lastNonTrimIndex)
        return bytes[start..<end]
    }

    /// Trims bytes from both ends of a collection
    ///
    /// Convenience overload that delegates to `trimming(_:where:)`.
    ///
    /// - Parameters:
    ///   - bytes: The byte collection to trim
    ///   - byteSet: The set of bytes to trim
    /// - Returns: A subsequence with the specified bytes trimmed from both ends
    ///
    /// Example:
    /// ```swift
    /// [UInt8].trimming([0x20, 0x48, 0x69, 0x20], of: [0x20])  // [0x48, 0x69]
    /// ```
    public static func trimming<C: Collection>(
        _ bytes: C,
        of byteSet: Set<UInt8>
    ) -> C.SubSequence where C.Element == UInt8 {
        trimming(bytes, where: byteSet.contains)
    }

    /// Trims bytes matching a predicate from both ends of the collection
    ///
    /// Delegates to the authoritative `Self.trimming(_:where:)` implementation.
    ///
    /// - Parameter predicate: A closure that returns `true` for bytes to trim
    /// - Returns: A subsequence with matching bytes trimmed from both ends
    ///
    /// Example:
    /// ```swift
    /// [0x20, 0x48, 0x69, 0x20].trimming(where: { $0 == 0x20 })  // [0x48, 0x69]
    /// bytes.trimming(where: { $0 < 0x21 })  // trim control chars and space
    /// ```
    public func trimming(where predicate: (UInt8) -> Bool) -> SubSequence {
        Self.trimming(self, where: predicate)
    }

    /// Trims bytes from both ends of the collection
    ///
    /// Delegates to the authoritative `Self.trimming(_:where:)` implementation.
    ///
    /// - Parameter byteSet: The set of bytes to trim
    /// - Returns: A subsequence with the specified bytes trimmed from both ends
    ///
    /// Example:
    /// ```swift
    /// [0x20, 0x48, 0x69, 0x20].trimming([0x20])  // [0x48, 0x69]
    /// bytes.trimming([0x20, 0x09, 0x0A, 0x0D])   // trim whitespace
    /// ```
    public func trimming(_ byteSet: Set<UInt8>) -> SubSequence {
        Self.trimming(self, of: byteSet)
    }
}

// MARK: - Byte Subsequence Search

extension Collection where Element == UInt8 {
    /// Finds the first occurrence of a byte subsequence
    ///
    /// Searches for the first position where `needle` appears in this collection.
    /// Returns the index of the first byte of the match, or nil if not found.
    ///
    /// - Parameter needle: The byte sequence to search for
    /// - Returns: Index of the first occurrence, or nil if not found
    ///
    /// Example:
    /// ```swift
    /// let data: [UInt8] = [0x48, 0x65, 0x6C, 0x6C, 0x6F]  // "Hello"
    /// data.firstIndex(of: [0x6C, 0x6C])  // 2 (index of "ll")
    /// data.firstIndex(of: [0x58])        // nil
    /// ```
    public func firstIndex<C: Collection>(of needle: C) -> Index?
    where C.Element == UInt8 {
        guard !needle.isEmpty else { return startIndex }
        guard needle.count <= count else { return nil }

        var i = startIndex
        let searchEnd = index(endIndex, offsetBy: -needle.count + 1)

        while i < searchEnd {
            var matches = true
            var selfIndex = i
            var needleIndex = needle.startIndex

            while needleIndex != needle.endIndex {
                if self[selfIndex] != needle[needleIndex] {
                    matches = false
                    break
                }
                selfIndex = index(after: selfIndex)
                needleIndex = needle.index(after: needleIndex)
            }

            if matches {
                return i
            }
            i = index(after: i)
        }

        return nil
    }

    /// Finds the last occurrence of a byte subsequence
    ///
    /// Searches for the last position where `needle` appears in this collection.
    /// Returns the index of the first byte of the match, or nil if not found.
    ///
    /// - Parameter needle: The byte sequence to search for
    /// - Returns: Index of the last occurrence, or nil if not found
    ///
    /// Example:
    /// ```swift
    /// let data: [UInt8] = [0x61, 0x62, 0x61, 0x62]  // "abab"
    /// data.lastIndex(of: [0x61, 0x62])  // 2 (last "ab")
    /// ```
    public func lastIndex<C: Collection>(of needle: C) -> Index?
    where C.Element == UInt8 {
        guard !needle.isEmpty else { return endIndex }
        guard needle.count <= count else { return nil }

        // Convert to array for reverse iteration (Collection doesn't guarantee bidirectional)
        let selfArray = Array(self)
        let needleArray = Array(needle)

        for i in stride(from: selfArray.count - needleArray.count, through: 0, by: -1) {
            if selfArray[i..<i + needleArray.count].elementsEqual(needleArray) {
                return index(startIndex, offsetBy: i)
            }
        }

        return nil
    }

    /// Checks if the collection contains a byte subsequence
    ///
    /// - Parameter needle: The byte sequence to search for
    /// - Returns: True if the subsequence is found, false otherwise
    ///
    /// Example:
    /// ```swift
    /// let data: [UInt8] = [0x48, 0x65, 0x6C, 0x6C, 0x6F]  // "Hello"
    /// data.contains([0x65, 0x6C])  // true ("el")
    /// data.contains([0x58, 0x59])  // false
    /// ```
    public func contains<C: Collection>(_ needle: C) -> Bool
    where C.Element == UInt8 {
        firstIndex(of: needle) != nil
    }
}
