// RangeReplaceableCollection.swift
// swift-standards
//
// Extensions for Swift standard library RangeReplaceableCollection

extension RangeReplaceableCollection {
    /// Returns a new collection with the element inserted at the beginning.
    ///
    /// Creates a copy of the collection with the given element prepended, leaving the original unchanged.
    /// Use this for immutable operations that add to the start of a collection.
    ///
    /// ## Example
    ///
    /// ```swift
    /// [2, 3, 4].prepending(1)  // [1, 2, 3, 4]
    /// "ello".prepending("h")   // "hello"
    /// ```
    public func prepending(_ element: Element) -> Self {
        var result = self
        result.insert(element, at: startIndex)
        return result
    }
}

extension RangeReplaceableCollection where Element: Hashable {
    /// Returns a new collection with duplicate elements removed, preserving first occurrence order.
    ///
    /// Keeps only the first occurrence of each element. Use this to remove duplicates while maintaining order.
    /// More efficient than converting to Set and back when order matters.
    ///
    /// ## Example
    ///
    /// ```swift
    /// [1, 2, 2, 3, 1, 4].removingDuplicates()  // [1, 2, 3, 4]
    /// "hello".removingDuplicates()             // "helo"
    /// ```
    public func removingDuplicates() -> Self {
        var seen: Set<Element> = []
        return filter { seen.insert($0).inserted }
    }
}
