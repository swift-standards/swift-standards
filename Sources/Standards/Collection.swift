// Collection.swift
// swift-standards
//
// Pure Swift collection utilities

extension Collection {
    /// Safe element access via functorial projection into Maybe monad
    ///
    /// Lifts partial indexing into total function space by projecting into Optional.
    /// This natural transformation from Collection to Maybe encodes indexing failure
    /// as None rather than trapping.
    ///
    /// Category theory: Natural transformation η: Collection → Maybe where
    /// η(collection)[index] = Some(element) if index ∈ indices, None otherwise
    ///
    /// Example:
    /// ```swift
    /// let array = [1, 2, 3]
    /// array[safe: 1]   // Optional(2)
    /// array[safe: 10]  // nil
    /// ```
    public subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }

    /// Safe range access with totalization via Maybe monad
    ///
    /// Extends safe indexing to range projections, lifting partial range operations
    /// into total functions via the Maybe natural transformation.
    ///
    /// Category theory: η: Collection × Range → Maybe(SubSequence)
    ///
    /// Example:
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// array[safe: 1..<3]   // Optional([2, 3])
    /// array[safe: 3..<10]  // nil
    /// ```
    public subscript(safe range: Range<Index>) -> SubSequence? {
        guard range.lowerBound >= startIndex,
            range.upperBound <= endIndex,
            range.lowerBound <= range.upperBound
        else { return nil }
        return self[range]
    }

    /// Partitions collection into fixed-size chunks
    ///
    /// List homomorphism preserving structure through equipartition.
    /// Maps collection into product space [SubSequence]^n where each component
    /// has cardinality ≤ size.
    ///
    /// Category theory: Morphism in category of collections that preserves
    /// concatenation structure: chunks(size) ∘ concat ≡ concat ∘ chunks(size)
    ///
    /// Example:
    /// ```swift
    /// [1, 2, 3, 4, 5].chunked(into: 2)  // [[1, 2], [3, 4], [5]]
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

    /// Partitions collection at specified index
    ///
    /// Canonical decomposition into coproduct (prefix, suffix).
    /// Exhibits collection as sum of two subcollections.
    ///
    /// Category theory: Coproduct injection establishing isomorphism
    /// Collection ≅ Prefix ⊕ Suffix in category of sequences
    ///
    /// Example:
    /// ```swift
    /// let (prefix, suffix) = [1, 2, 3, 4, 5].split(at: 2)
    /// // prefix: [1, 2], suffix: [3, 4, 5]
    /// ```
    public func split(at index: Index) -> (SubSequence, SubSequence) {
        (self[startIndex..<index], self[index..<endIndex])
    }
}

// MARK: - RangeReplaceableCollection Extensions

extension RangeReplaceableCollection {
    /// Non-mutating element prepending
    ///
    /// Adds element to beginning, preserving existing structure.
    /// Left unit operation for list construction.
    ///
    /// Category theory: Cons operation in list algebra,
    /// prepend(x, xs) ≡ [x] ⊕ xs
    ///
    /// Example:
    /// ```swift
    /// let result = [2, 3, 4].prepending(1)  // [1, 2, 3, 4]
    /// ```
    public func prepending(_ element: Element) -> Self {
        var result = self
        result.insert(element, at: startIndex)
        return result
    }
}

extension RangeReplaceableCollection where Element: Hashable {
    /// Removes duplicate elements preserving first occurrence order
    ///
    /// Implements idempotent operation: f ∘ f = f
    /// Projects collection onto its image under inclusion, removing redundancy.
    ///
    /// Category theory: Retraction morphism r: Collection → Set → Collection
    /// satisfying r ∘ r = r (idempotent endomorphism)
    ///
    /// Example:
    /// ```swift
    /// [1, 2, 2, 3, 1, 4].removingDuplicates()  // [1, 2, 3, 4]
    /// ```
    public func removingDuplicates() -> Self {
        var seen: Set<Element> = []
        return filter { seen.insert($0).inserted }
    }
}
