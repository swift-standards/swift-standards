// MARK: - Array Conformances

extension Array: Binary.Contiguous where Element == UInt8 {
    @inlinable
    public func withUnsafeBytes<R, E: Swift.Error>(
        _ body: (UnsafeRawBufferPointer) throws(E) -> R
    ) throws(E) -> R {
        try self.withUnsafeBufferPointer { (buffer: UnsafeBufferPointer<UInt8>) throws(E) -> R in
            try body(UnsafeRawBufferPointer(buffer))
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
}

// MARK: - ContiguousArray Conformances

extension ContiguousArray: Binary.Contiguous where Element == UInt8 {
    @inlinable
    public func withUnsafeBytes<R, E: Swift.Error>(
        _ body: (UnsafeRawBufferPointer) throws(E) -> R
    ) throws(E) -> R {
        try self.withUnsafeBufferPointer { (buffer: UnsafeBufferPointer<UInt8>) throws(E) -> R in
            try body(UnsafeRawBufferPointer(buffer))
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
}
