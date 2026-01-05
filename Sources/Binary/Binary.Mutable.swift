extension Binary {
    /// A type that provides mutable access to its contiguous bytes.
    ///
    /// `Mutable` refines `Contiguous`, so any mutable buffer is also readable.
    /// Conforming types guarantee that bytes are laid out contiguously in memory
    /// and provide safe, scoped mutable access.
    ///
    /// ## Type Parameters
    ///
    /// Inherits `Space` and `Scalar` from `Binary.Contiguous`:
    /// - `Space`: A phantom type distinguishing different address spaces (default: `Buffer`).
    /// - `Scalar`: The integer type for index arithmetic (default: `Int`).
    ///
    /// ## Normative vs Derived APIs
    ///
    /// - **Normative:** `withUnsafeMutableBytes` is the normative access primitive.
    ///   It provides structurally lifetime-bounded access that is correct across
    ///   all generic and witness contexts.
    /// - **Derived:** `mutableBytes` is a derived convenience view. Prefer it for
    ///   most algorithms, but fall back to closure APIs when span composition is
    ///   not expressible or when typed throws must propagate through witness boundaries.
    ///
    /// ## Invariants
    ///
    /// - `count >= 0`
    /// - `withUnsafeMutableBytes` passes a buffer whose `.count == self.count`
    /// - `mutableBytes.count == self.count`
    ///
    /// The pointer passed to the closure is only valid for the duration of the call.
    /// Do not store or return the pointer.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Preferred: use MutableSpan for most algorithms
    /// func zero<T: Binary.Mutable>(_ buffer: inout T) {
    ///     buffer.mutableBytes.update(repeating: 0)
    /// }
    ///
    /// // Escape hatch: use closure for interop or witness boundary cases
    /// func zeroViaPointer<T: Binary.Mutable>(_ buffer: inout T) {
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

        /// Mutable span of the buffer as bytes (derived convenience view).
        ///
        /// Prefer this property for most algorithms. Fall back to `withUnsafeMutableBytes`
        /// when span composition is not expressible or when typed throws must
        /// propagate through witness boundaries.
        ///
        /// The span is lifetime-dependent on `self`. Conformers must use
        /// `@_lifetime(&self)` on the getter implementation.
        ///
        /// ## Lifetime Contract
        ///
        /// - The span is valid ONLY for the duration of the exclusive mutable borrow.
        /// - The span MUST NOT be stored, returned, or allowed to escape.
        /// - No concurrent mutable borrows are permitted.
        var mutableBytes: MutableSpan<UInt8> { mutating get }
    }
}
