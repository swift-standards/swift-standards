// Binary.Error.Invariant.swift
// Invariant violation error.

extension Binary.Error {
    /// A required invariant was violated.
    ///
    /// Thrown when an operation would violate a structural invariant,
    /// such as `readerIndex <= writerIndex`.
    public struct Invariant: Swift.Error, Sendable, Equatable {
        /// The invariant that was violated.
        public let kind: Kind

        /// The left-hand side value of the invariant.
        public let left: Int64

        /// The right-hand side value of the invariant.
        public let right: Int64

        public init(kind: Kind, left: Int64, right: Int64) {
            self.kind = kind
            self.left = left
            self.right = right
        }
    }
}

// MARK: - Kind

extension Binary.Error.Invariant {
    /// The kind of invariant that was violated.
    public enum Kind: Sendable, Equatable {
        /// `readerIndex <= writerIndex` was violated.
        case reader

        /// `writerIndex <= count` was violated.
        case writer

        /// `start <= end` was violated.
        case range
    }
}

// MARK: - Convenience Initializers

extension Binary.Error.Invariant {
    /// Creates an invariant error from any BinaryInteger values.
    @inlinable
    public init<T: BinaryInteger>(kind: Kind, left: T, right: T) {
        self.kind = kind
        self.left = Int64(clamping: left)
        self.right = Int64(clamping: right)
    }
}

// MARK: - CustomStringConvertible

extension Binary.Error.Invariant: CustomStringConvertible {
    public var description: String {
        switch kind {
        case .reader:
            return "readerIndex must be <= writerIndex (reader=\(left), writer=\(right))"
        case .writer:
            return "writerIndex must be <= count (writer=\(left), count=\(right))"
        case .range:
            return "start must be <= end (start=\(left), end=\(right))"
        }
    }
}
