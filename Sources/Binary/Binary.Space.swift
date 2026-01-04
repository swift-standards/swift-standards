// Binary.Space.swift
// Binary address space namespace.

@_exported import Dimension

extension Binary {
    /// Namespace for binary address spaces.
    ///
    /// Binary spaces parameterize Dimension types for byte-level operations.
    /// Downstream packages define their own spaces as nested types here.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // In swift-kernel:
    /// extension Kernel.File {
    ///     public enum Space {}
    /// }
    ///
    /// typealias Offset = Coordinate.X<Kernel.File.Space>.Value<Int64>
    /// ```
    public enum Space {}
}
