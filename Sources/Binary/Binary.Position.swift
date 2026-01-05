// Binary.Position.swift
// Type-safe byte positions and offsets parameterized by scalar type and space.

extension Binary {
    /// Absolute byte position in a binary space.
    ///
    /// A position represents an absolute location in a byte stream or buffer.
    /// Positions support affine arithmetic: you can compute the displacement
    /// between two positions, or translate a position by an offset.
    ///
    /// ## Affine Arithmetic
    ///
    /// - `Position - Position = Offset` (displacement between positions)
    /// - `Position + Offset = Position` (translate position forward)
    /// - `Position - Offset = Position` (translate position backward)
    ///
    /// ## Example
    ///
    /// ```swift
    /// typealias BufferPos = Binary.Position<Int, Binary.Space>
    /// let start: BufferPos = 0
    /// let end: BufferPos = 100
    /// let displacement = end - start  // Binary.Offset<Int, Space> = 100
    /// ```
    ///
    /// - Parameters:
    ///   - Scalar: The integer type used to represent the position (e.g., `Int`, `UInt64`).
    ///   - Space: A phantom type distinguishing different address spaces.
    public typealias Position<Scalar: BinaryInteger, Space> = Coordinate.X<Space>.Value<Scalar>

    /// Relative byte offset (displacement) in a binary space.
    ///
    /// An offset represents a directed distance between two positions.
    /// Offsets form a vector space and can be added together.
    ///
    /// ## Offset Arithmetic
    ///
    /// - `Offset + Offset = Offset`
    /// - `Offset - Offset = Offset`
    /// - `Position + Offset = Position`
    ///
    /// ## Example
    ///
    /// ```swift
    /// typealias BufferOffset = Binary.Offset<Int, Binary.Space>
    /// let headerSize: BufferOffset = 64
    /// let payloadOffset: BufferOffset = 128
    /// let totalOffset = headerSize + payloadOffset  // 192
    /// ```
    ///
    /// - Parameters:
    ///   - Scalar: The integer type used to represent the offset (e.g., `Int`, `Int64`).
    ///   - Space: A phantom type distinguishing different address spaces.
    public typealias Offset<Scalar: BinaryInteger, Space> = Displacement.X<Space>.Value<Scalar>
}

// MARK: - Convenience Aliases

extension Binary.Space {
    /// Position in this space.
    public typealias Position<Scalar: BinaryInteger> = Binary.Position<Scalar, Binary.Space>

    /// Offset in this space.
    public typealias Offset<Scalar: BinaryInteger> = Binary.Offset<Scalar, Binary.Space>
}
