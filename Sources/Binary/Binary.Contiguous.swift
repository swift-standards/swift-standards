extension Binary {
    /// A type that provides read-only access to its contiguous bytes.
    ///
    /// Conforming types guarantee that bytes are laid out contiguously in memory
    /// and provide safe, scoped access via closure.
    ///
    /// ## Invariants
    ///
    /// - `count >= 0`
    /// - `withUnsafeBytes` passes a buffer whose `.count == self.count`
    ///
    /// The pointer passed to the closure is only valid for the duration of the call.
    /// Do not store or return the pointer.
    ///
    /// ## Example
    ///
    /// ```swift
    /// func checksum<T: Binary.Contiguous>(_ data: T) -> UInt32 {
    ///     data.withUnsafeBytes { ptr in
    ///         ptr.reduce(0) { $0 &+ UInt32($1) }
    ///     }
    /// }
    /// ```
    public protocol Contiguous: ~Copyable {
        /// The number of bytes in the buffer.
        ///
        /// This value is always non-negative and matches the count of the
        /// buffer pointer passed to `withUnsafeBytes`.
        var count: Int { get }

        /// Calls the given closure with a pointer to the contiguous bytes.
        ///
        /// - Parameter body: A closure that receives the buffer pointer.
        /// - Returns: The value returned by the closure.
        /// - Throws: The error thrown by the closure.
        func withUnsafeBytes<R, E: Swift.Error>(
            _ body: (UnsafeRawBufferPointer) throws(E) -> R
        ) throws(E) -> R
    }
}

// MARK: - Stdlib-Compatible Overload

extension Binary.Contiguous {
    /// Calls the given closure with a pointer to the contiguous bytes.
    ///
    /// This overload provides compatibility with stdlib-style APIs that use `rethrows`.
    ///
    /// - Parameter body: A closure that receives the buffer pointer.
    /// - Returns: The value returned by the closure.
    @inlinable
    public func withUnsafeBytes<R>(
        _ body: (UnsafeRawBufferPointer) throws -> R
    ) rethrows -> R {
        try withUnsafeBytes { ptr in
            try body(ptr)
        }
    }
}
