extension Binary {
    /// A type that provides mutable access to its contiguous bytes.
    ///
    /// `Mutable` refines `Contiguous`, so any mutable buffer is also readable.
    /// Conforming types guarantee that bytes are laid out contiguously in memory
    /// and provide safe, scoped mutable access via closure.
    ///
    /// ## Invariants
    ///
    /// - `count >= 0`
    /// - `withUnsafeMutableBytes` passes a buffer whose `.count == self.count`
    ///
    /// The pointer passed to the closure is only valid for the duration of the call.
    /// Do not store or return the pointer.
    ///
    /// ## Example
    ///
    /// ```swift
    /// func zero<T: Binary.Mutable>(_ buffer: inout T) {
    ///     buffer.withUnsafeMutableBytes { ptr in
    ///         ptr.initializeMemory(as: UInt8.self, repeating: 0)
    ///     }
    /// }
    /// ```
    public protocol Mutable: Binary.Contiguous, ~Copyable {
        /// Calls the given closure with a mutable pointer to the contiguous bytes.
        ///
        /// - Parameter body: A closure that receives the mutable buffer pointer.
        /// - Returns: The value returned by the closure.
        /// - Throws: The error thrown by the closure.
        mutating func withUnsafeMutableBytes<R, E: Swift.Error>(
            _ body: (UnsafeMutableRawBufferPointer) throws(E) -> R
        ) throws(E) -> R
    }
}

// MARK: - Stdlib-Compatible Overload

extension Binary.Mutable {
    /// Calls the given closure with a mutable pointer to the contiguous bytes.
    ///
    /// This overload provides compatibility with stdlib-style APIs that use `rethrows`.
    ///
    /// - Parameter body: A closure that receives the mutable buffer pointer.
    /// - Returns: The value returned by the closure.
    @inlinable
    public mutating func withUnsafeMutableBytes<R>(
        _ body: (UnsafeMutableRawBufferPointer) throws -> R
    ) rethrows -> R {
        try withUnsafeMutableBytes { ptr in
            try body(ptr)
        }
    }
}
