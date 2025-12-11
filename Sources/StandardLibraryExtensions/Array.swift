// Array.swift
// swift-standards
//
// Extensions for Swift standard library Array

extension Array {
    /// Returns a new array with the element at the specified index removed.
    ///
    /// Creates a copy of the array without the element at the given index, leaving the original array unchanged.
    /// Use this when you need an immutable operation that preserves the original array.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let numbers = [1, 2, 3, 4, 5]
    /// let result = numbers.removing(at: 2)
    /// // result == [1, 2, 4, 5]
    /// // numbers == [1, 2, 3, 4, 5]
    /// ```
    public func removing(at index: Int) -> [Element] {
        var result = self
        result.remove(at: index)
        return result
    }

    /// Returns a new array with the element inserted at the specified index.
    ///
    /// Creates a copy of the array with the given element inserted at the specified position, leaving the original array unchanged.
    /// Use this when you need an immutable insertion that preserves the original array.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let numbers = [1, 2, 4, 5]
    /// let result = numbers.inserting(3, at: 2)
    /// // result == [1, 2, 3, 4, 5]
    /// // numbers == [1, 2, 4, 5]
    /// ```
    public func inserting(_ element: Element, at index: Int) -> [Element] {
        var result = self
        result.insert(element, at: index)
        return result
    }

    /// Safely accesses the array slice at the specified range, returning `nil` for invalid ranges.
    ///
    /// Returns the array slice for valid ranges, or `nil` if the range is out of bounds or invalid.
    /// Use this to avoid crashes when accessing potentially invalid array ranges.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let numbers = [1, 2, 3, 4, 5]
    /// numbers[safe: 1..<3]   // [2, 3]
    /// numbers[safe: 3..<10]  // nil
    /// numbers[safe: -1..<2]  // nil
    /// ```
    public subscript(safe range: Range<Int>) -> ArraySlice<Element>? {
        guard range.lowerBound >= 0,
            range.upperBound <= count,
            range.lowerBound <= range.upperBound
        else { return nil }
        return self[range]
    }

    /// Safely accesses the array slice at the specified closed range, returning `nil` for invalid ranges.
    ///
    /// Returns the array slice for valid closed ranges (including upper bound), or `nil` if the range is out of bounds or invalid.
    /// Use this to avoid crashes when accessing potentially invalid array ranges.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let numbers = [1, 2, 3, 4, 5]
    /// numbers[safe: 1...3]   // [2, 3, 4]
    /// numbers[safe: 3...10]  // nil
    /// numbers[safe: -1...2]  // nil
    /// ```
    public subscript(safe range: ClosedRange<Int>) -> ArraySlice<Element>? {
        guard range.lowerBound >= 0,
            range.upperBound < count,
            range.lowerBound <= range.upperBound
        else { return nil }
        return self[range]
    }
}
