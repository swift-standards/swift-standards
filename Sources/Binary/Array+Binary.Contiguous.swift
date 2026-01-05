// MARK: - Array Conformances

extension Array: Binary.Contiguous where Element == UInt8 {
    /// The address space for this storage type.
    public typealias Space = Binary.Space

    /// The scalar type for index arithmetic.
    public typealias Scalar = Int

    @inlinable
    public func withUnsafeBytes<R, E: Swift.Error>(
        _ body: (UnsafeRawBufferPointer) throws(E) -> R
    ) throws(E) -> R {
        try self.withUnsafeBufferPointer { (buffer: UnsafeBufferPointer<UInt8>) throws(E) -> R in
            try body(UnsafeRawBufferPointer(buffer))
        }
    }

    @inlinable
    public var bytes: Span<UInt8> {
        @_lifetime(borrow self)
        borrowing get {
            self.span
        }
    }
}

extension Array: Binary.Mutable where Element == UInt8 {
    @inlinable
    public mutating func withUnsafeMutableBytes<R, E: Swift.Error>(
        _ body: (UnsafeMutableRawBufferPointer) throws(E) -> R
    ) throws(E) -> R {
        try self.withUnsafeMutableBufferPointer {
            (buffer: inout UnsafeMutableBufferPointer<UInt8>) throws(E) -> R in
            try body(UnsafeMutableRawBufferPointer(buffer))
        }
    }

    @inlinable
    public var mutableBytes: MutableSpan<UInt8> {
        @_lifetime(&self)
        mutating get {
            self.mutableSpan
        }
    }
}

// MARK: - ContiguousArray Conformances

extension ContiguousArray: Binary.Contiguous where Element == UInt8 {
    /// The address space for this storage type.
    public typealias Space = Binary.Space

    /// The scalar type for index arithmetic.
    public typealias Scalar = Int

    @inlinable
    public func withUnsafeBytes<R, E: Swift.Error>(
        _ body: (UnsafeRawBufferPointer) throws(E) -> R
    ) throws(E) -> R {
        try self.withUnsafeBufferPointer { (buffer: UnsafeBufferPointer<UInt8>) throws(E) -> R in
            try body(UnsafeRawBufferPointer(buffer))
        }
    }

    @inlinable
    public var bytes: Span<UInt8> {
        @_lifetime(borrow self)
        borrowing get {
            self.span
        }
    }
}

extension ContiguousArray: Binary.Mutable where Element == UInt8 {
    @inlinable
    public mutating func withUnsafeMutableBytes<R, E: Swift.Error>(
        _ body: (UnsafeMutableRawBufferPointer) throws(E) -> R
    ) throws(E) -> R {
        try self.withUnsafeMutableBufferPointer {
            (buffer: inout UnsafeMutableBufferPointer<UInt8>) throws(E) -> R in
            try body(UnsafeMutableRawBufferPointer(buffer))
        }
    }

    @inlinable
    public var mutableBytes: MutableSpan<UInt8> {
        @_lifetime(&self)
        mutating get {
            self.mutableSpan
        }
    }
}
