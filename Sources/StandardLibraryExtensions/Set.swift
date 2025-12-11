// Set.swift
// swift-standards
//
// Extensions for Swift standard library Set

extension Set {
    /// Splits the set into two disjoint sets based on a predicate.
    ///
    /// Returns a tuple where the first set contains elements that satisfy the predicate,
    /// and the second set contains elements that don't. Use this to categorize set elements.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let numbers: Set = [1, 2, 3, 4, 5, 6]
    /// let (evens, odds) = numbers.partition(where: { $0.isMultiple(of: 2) })
    /// // evens: [2, 4, 6], odds: [1, 3, 5]
    /// ```
    public func partition(
        where predicate: (Element) -> Bool
    ) -> (satisfying: Set<Element>, failing: Set<Element>) {
        var satisfying = Set<Element>()
        var failing = Set<Element>()

        for element in self {
            if predicate(element) {
                satisfying.insert(element)
            } else {
                failing.insert(element)
            }
        }

        return (satisfying, failing)
    }

    /// Returns all possible subsets of the specified size.
    ///
    /// Generates all combinations of k elements from the set. Returns an empty set for invalid sizes (k < 0 or k > count).
    /// Use this for combinatorial operations and subset analysis.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let set: Set = [1, 2, 3]
    /// set.subsets(ofSize: 2)  // [[1, 2], [1, 3], [2, 3]]
    /// set.subsets(ofSize: 0)  // [[]]
    /// ```
    public func subsets(ofSize k: Int) -> Set<Set<Element>> {
        guard k >= 0 else { return [] }
        guard k <= count else { return [] }

        if k == 0 {
            return [[]]
        }

        if k == count {
            return [self]
        }

        var result = Set<Set<Element>>()
        let elements = Array(self)

        func combine(start: Int, current: Set<Element>) {
            if current.count == k {
                result.insert(current)
                return
            }

            for i in start..<elements.count {
                var next = current
                next.insert(elements[i])
                combine(start: i + 1, current: next)
            }
        }

        combine(start: 0, current: [])
        return result
    }

    /// Returns all ordered pairs combining elements from both sets.
    ///
    /// Generates all combinations where the first element comes from this set and the second from the other set.
    /// Use this to create all possible pairings between two sets.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let a: Set = [1, 2]
    /// let b: Set = ["x", "y"]
    /// a.cartesianProduct(b)  // [(1, "x"), (1, "y"), (2, "x"), (2, "y")]
    /// ```
    public func cartesianProduct<Other>(_ other: Set<Other>) -> [(Element, Other)] {
        var result: [(Element, Other)] = []
        result.reserveCapacity(count * other.count)

        for element in self {
            for otherElement in other {
                result.append((element, otherElement))
            }
        }

        return result
    }

    /// Returns all ordered pairs combining elements from the set with itself.
    ///
    /// Equivalent to `cartesianProduct(self)`. Generates all possible ordered pairs including pairs like (1, 1).
    /// Use this to generate all possible pairings within a single set.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let set: Set = [1, 2, 3]
    /// set.cartesianSquare()  // [(1,1), (1,2), (1,3), (2,1), (2,2), (2,3), (3,1), (3,2), (3,3)]
    /// ```
    public func cartesianSquare() -> [(Element, Element)] {
        cartesianProduct(self)
    }
}
