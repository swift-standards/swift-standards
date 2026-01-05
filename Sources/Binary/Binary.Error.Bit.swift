// Binary.Error.Bit.swift
// Bit operation error.

extension Binary.Error {
    /// A bit operation parameter was invalid.
    ///
    /// Thrown when a bit operation (shift, position, count) exceeds
    /// the bit width of the type.
    public struct Bit: Swift.Error, Sendable, Equatable {
        /// The kind of bit error.
        public let kind: Kind

        /// The invalid value.
        public let value: Int

        /// The bit width limit.
        public let width: Int

        public init(kind: Kind, value: Int, width: Int) {
            self.kind = kind
            self.value = value
            self.width = width
        }
    }
}

// MARK: - Kind

extension Binary.Error.Bit {
    /// The kind of bit operation that failed.
    public enum Kind: Sendable, Equatable {
        /// Shift amount exceeded bit width.
        case shift

        /// Bit position exceeded bit width.
        case position

        /// Bit count exceeded bit width.
        case count
    }
}

// MARK: - CustomStringConvertible

extension Binary.Error.Bit: CustomStringConvertible {
    public var description: String {
        switch kind {
        case .shift:
            return "shift out of bounds (was \(value), valid: 0..<\(width))"
        case .position:
            return "bit position out of bounds (was \(value), valid: 0..<\(width))"
        case .count:
            return "bit count out of bounds (was \(value), valid: 0...\(width))"
        }
    }
}
