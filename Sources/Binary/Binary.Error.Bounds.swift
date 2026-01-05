// Binary.Error.Bounds.swift
// Bounds error.

extension Binary.Error {
    /// An index or position was out of valid range.
    ///
    /// Thrown when an index, position, or offset would result in
    /// accessing memory outside valid bounds.
    public struct Bounds: Swift.Error, Sendable, Equatable {
        /// The field that was out of bounds.
        public let field: Field

        /// The invalid value.
        public let value: Int64

        /// The lower bound (inclusive).
        public let lower: Int64

        /// The upper bound (inclusive).
        public let upper: Int64

        public init(field: Field, value: Int64, lower: Int64, upper: Int64) {
            self.field = field
            self.value = value
            self.lower = lower
            self.upper = upper
        }
    }
}

// MARK: - Field

extension Binary.Error.Bounds {
    /// The field that was out of bounds.
    public enum Field: Sendable, Equatable {
        /// An index value.
        case index

        /// A position value.
        case position

        /// A reader index.
        case reader

        /// A writer index.
        case writer
    }
}

// MARK: - Convenience Initializers

extension Binary.Error.Bounds {
    /// Creates a bounds error from any BinaryInteger values.
    @inlinable
    public init<T: BinaryInteger>(field: Field, value: T, lower: T, upper: T) {
        self.field = field
        self.value = Int64(clamping: value)
        self.lower = Int64(clamping: lower)
        self.upper = Int64(clamping: upper)
    }
}

// MARK: - CustomStringConvertible

extension Binary.Error.Bounds: CustomStringConvertible {
    public var description: String {
        "\(field) out of bounds (was \(value), valid: \(lower)...\(upper))"
    }
}

extension Binary.Error.Bounds.Field: CustomStringConvertible {
    public var description: String {
        switch self {
        case .index: return "index"
        case .position: return "position"
        case .reader: return "readerIndex"
        case .writer: return "writerIndex"
        }
    }
}
