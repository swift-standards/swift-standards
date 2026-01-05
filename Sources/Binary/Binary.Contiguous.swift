extension Binary {
    /// A type that provides read-only access to its contiguous bytes.
    ///
    /// Conforming types guarantee that bytes are laid out contiguously in memory
    /// and provide safe, scoped access.
    ///
    /// ## Type Parameters
    ///
    /// - `Space`: A phantom type distinguishing different address spaces.
    /// - `Scalar`: The integer type for index arithmetic (default: `Int`).
    ///
    /// ## Normative vs Derived APIs
    ///
    /// - **Normative:** `withUnsafeBytes` is the normative access primitive.
    ///   It provides structurally lifetime-bounded access that is correct across
    ///   all generic and witness contexts.
    /// - **Derived:** `bytes` is a derived convenience view. Prefer it for most
    ///   algorithms, but fall back to closure APIs when span composition is not
    ///   expressible or when typed throws must propagate through witness boundaries.
    ///
    /// ## Invariants
    ///
    /// - `count >= 0`
    /// - `withUnsafeBytes` passes a buffer whose `.count == self.count`
    /// - `bytes.count == self.count`
    ///
    /// The pointer passed to the closure is only valid for the duration of the call.
    /// Do not store or return the pointer.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Preferred: use Span for most algorithms
    /// func checksum<T: Binary.Contiguous>(_ data: borrowing T) -> UInt32 {
    ///     data.bytes.reduce(0) { $0 &+ UInt32($1) }
    /// }
    ///
    /// // Escape hatch: use closure for interop or witness boundary cases
    /// func checksumViaPointer<T: Binary.Contiguous>(_ data: T) -> UInt32 {
    ///     data.withUnsafeBytes { ptr in
    ///         ptr.reduce(0) { $0 &+ UInt32($1) }
    ///     }
    /// }
    /// ```
    public protocol Contiguous: ~Copyable {
        /// The address space for typed positions and offsets.
        ///
        /// Downstream packages can define custom spaces to distinguish
        /// file offsets from buffer positions at compile time.
        associatedtype Space

        /// The scalar type for index arithmetic.
        ///
        /// Must be `FixedWidthInteger & Sendable` to support bitwise alignment
        /// operations and type-safe counts.
        /// Default is `Int` for ergonomics with Swift standard library.
        /// Use `UInt64` for file offsets or `Int64` for signed file positions.
        ///
        /// - Note: Negative values are programmer error; enforce non-negativity
        ///   at the boundaries (e.g., via `Binary.Count`).
        associatedtype Scalar: FixedWidthInteger & Sendable = Int

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

        /// Read-only span of the buffer as bytes (derived convenience view).
        ///
        /// Prefer this property for most algorithms. Fall back to `withUnsafeBytes`
        /// when span composition is not expressible or when typed throws must
        /// propagate through witness boundaries.
        ///
        /// The span is lifetime-dependent on `self`. Conformers must use
        /// `@_lifetime(borrow self)` on the getter implementation.
        ///
        /// ## Lifetime Contract
        ///
        /// - The span is valid ONLY for the duration of the borrow of `self`.
        /// - The span MUST NOT be stored, returned, or allowed to escape.
        var bytes: Span<UInt8> { get }
    }
}

// MARK: - Typed Count

extension Binary.Contiguous {
    /// The byte count as a typed value in this storage's space.
    @inlinable
    public var typedCount: Binary.Count<Scalar, Space> {
        Binary.Count(unchecked: Scalar(count))
    }
}
