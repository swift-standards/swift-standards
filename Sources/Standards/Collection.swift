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
    @inlinable
    public subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
