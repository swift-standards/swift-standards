// Collection+Bytes.swift
// Byte collection utilities.

// MARK: - Byte Collection Trimming

extension Collection<UInt8> {
    /// Trims bytes from both ends of a collection matching a predicate.
    ///
    /// Returns a zero-copy view of the original collection with matching bytes
    /// removed from the start and end. Use this for efficient prefix/suffix removal
    /// without allocating new memory.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let bytes: [UInt8] = [0x20, 0x48, 0x69, 0x20]
    /// let trimmed = [UInt8].trimming(bytes, where: { $0 == 0x20 })
    /// // [0x48, 0x69]
    /// ```
    ///
    /// - Parameters:
    ///   - bytes: The byte collection to trim
    ///   - predicate: Returns `true` for bytes to remove
    /// - Returns: A subsequence with matching bytes trimmed from both ends
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

    /// Trims specific bytes from both ends of a collection.
    ///
    /// - Parameters:
    ///   - bytes: The byte collection to trim
    ///   - byteSet: The set of bytes to remove
    /// - Returns: A subsequence with the specified bytes trimmed from both ends
    public static func trimming<C: Collection>(
        _ bytes: C,
        of byteSet: Set<UInt8>
    ) -> C.SubSequence where C.Element == UInt8 {
        trimming(bytes, where: byteSet.contains)
    }

    /// Trims bytes matching a predicate from both ends.
    ///
    /// - Parameter predicate: Returns `true` for bytes to remove
    /// - Returns: A subsequence with matching bytes trimmed from both ends
    public func trimming(where predicate: (UInt8) -> Bool) -> SubSequence {
        Self.trimming(self, where: predicate)
    }

    /// Trims specific bytes from both ends.
    ///
    /// - Parameter byteSet: The set of bytes to remove
    /// - Returns: A subsequence with the specified bytes trimmed from both ends
    public func trimming(_ byteSet: Set<UInt8>) -> SubSequence {
        Self.trimming(self, of: byteSet)
    }
}

// MARK: - Byte Subsequence Search

extension Collection<UInt8> {
    /// Finds the first occurrence of a byte subsequence.
    ///
    /// - Parameter needle: The byte sequence to search for
    /// - Returns: Index of the first occurrence, or `nil` if not found
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

    /// Finds the last occurrence of a byte subsequence.
    ///
    /// - Parameter needle: The byte sequence to search for
    /// - Returns: Index of the last occurrence, or `nil` if not found
    public func lastIndex<C: Collection>(of needle: C) -> Index?
    where C.Element == UInt8 {
        guard !needle.isEmpty else { return endIndex }
        guard needle.count <= count else { return nil }

        let selfArray = Array(self)
        let needleArray = Array(needle)

        for i in stride(from: selfArray.count - needleArray.count, through: 0, by: -1) {
            if selfArray[i..<i + needleArray.count].elementsEqual(needleArray) {
                return index(startIndex, offsetBy: i)
            }
        }

        return nil
    }

    /// Checks if the collection contains a byte subsequence.
    ///
    /// - Parameter needle: The byte sequence to search for
    /// - Returns: `true` if the subsequence is found, `false` otherwise
    public func contains<C: Collection>(_ needle: C) -> Bool
    where C.Element == UInt8 {
        firstIndex(of: needle) != nil
    }
}
