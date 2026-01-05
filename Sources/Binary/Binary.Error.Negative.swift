// Binary.Error.Negative.swift
// Negative value error.

extension Binary.Error {
    /// A value that must be non-negative was negative.
    ///
    /// Thrown when attempting to construct a type that requires
    /// non-negative values (like `Binary.Count`) with a negative value.
    public struct Negative: Swift.Error, Sendable, Equatable {
        /// The field that was negative.
        public let field: Field

        /// The negative value that was provided.
        public let value: Int64

        public init(field: Field, value: Int64) {
            self.field = field
            self.value = value
        }
    }
}

// MARK: - Field

extension Binary.Error.Negative {
    /// The field that had a negative value.
    public enum Field: Sendable, Equatable {
        /// A count value.
        case count

        /// An offset value.
        case offset

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

extension Binary.Error.Negative {
    /// Creates a negative error from any BinaryInteger value.
    @inlinable
    public init<T: BinaryInteger>(field: Field, value: T) {
        self.field = field
        self.value = Int64(clamping: value)
    }
}

// MARK: - CustomStringConvertible

extension Binary.Error.Negative: CustomStringConvertible {
    public var description: String {
        "\(field) cannot be negative (was \(value))"
    }
}

extension Binary.Error.Negative.Field: CustomStringConvertible {
    public var description: String {
        switch self {
        case .count: return "count"
        case .offset: return "offset"
        case .index: return "index"
        case .position: return "position"
        case .reader: return "readerIndex"
        case .writer: return "writerIndex"
        }
    }
}
