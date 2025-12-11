// Collection.swift
// swift-standards
//
// Pure Swift collection utilities

extension Collection {
    /// Safely accesses the element at the specified index, returning `nil` for invalid indices.
    ///
    /// Returns the element if the index is valid, or `nil` if the index is out of bounds.
    /// Use this to avoid crashes when accessing potentially invalid indices.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let array = [1, 2, 3]
    /// array[safe: 1]   // 2
    /// array[safe: 10]  // nil
    /// ```
    public subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }

    /// Safely accesses the subsequence at the specified range, returning `nil` for invalid ranges.
    ///
    /// Returns the subsequence if the range is valid, or `nil` if the range is out of bounds or invalid.
    /// Use this to avoid crashes when accessing potentially invalid ranges.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// array[safe: 1..<3]   // [2, 3]
    /// array[safe: 3..<10]  // nil
    /// ```
    public subscript(safe range: Range<Index>) -> SubSequence? {
        guard range.lowerBound >= startIndex,
            range.upperBound <= endIndex,
            range.lowerBound <= range.upperBound
        else { return nil }
        return self[range]
    }

    /// Splits the collection into arrays of the specified size.
    ///
    /// Returns an array of arrays, where each sub-array contains up to `size` elements. The last chunk may contain fewer elements.
    /// Use this to process large collections in manageable batches.
    ///
    /// ## Example
    ///
    /// ```swift
    /// [1, 2, 3, 4, 5].chunked(into: 2)  // [[1, 2], [3, 4], [5]]
    /// [1, 2, 3].chunked(into: 5)        // [[1, 2, 3]]
    /// ```
    public func chunked(into size: Int) -> [[Element]] {
        guard size > 0 else { return [] }
        var chunks: [[Element]] = []
        var currentChunk: [Element] = []
        currentChunk.reserveCapacity(size)

        for element in self {
            currentChunk.append(element)
            if currentChunk.count == size {
                chunks.append(currentChunk)
                currentChunk = []
                currentChunk.reserveCapacity(size)
            }
        }

        if !currentChunk.isEmpty {
            chunks.append(currentChunk)
        }

        return chunks
    }

    /// Splits the collection into two subsequences at the specified index.
    ///
    /// Returns a tuple containing the prefix (elements before the index) and suffix (elements from the index onward).
    /// Use this to divide a collection at a specific point.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let (prefix, suffix) = [1, 2, 3, 4, 5].split(at: 2)
    /// // prefix: [1, 2], suffix: [3, 4, 5]
    /// ```
    public func split(at index: Index) -> (SubSequence, SubSequence) {
        (self[startIndex..<index], self[index..<endIndex])
    }
}
