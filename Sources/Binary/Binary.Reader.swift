// Binary.Reader.swift
// Read-only position-tracked view with typed throws.

extension Binary {
    /// A read-only position-tracked view over contiguous storage.
    ///
    /// Uses typed throws for all validation.
    ///
    /// ## API Pattern
    ///
    /// - **Primary**: `init(storage:) throws(Binary.Error)` — validates at runtime
    /// - **Performance**: `init(unchecked:)` — debug assertion only
    ///
    /// ## Nested Accessor Pattern
    ///
    /// ```swift
    /// // Move operations
    /// try reader.move.index(by: offset)
    /// reader.move.index.unchecked(by: offset)
    ///
    /// // Set operations
    /// try reader.set.index(to: position)
    /// ```
    ///
    /// ## Invariants
    ///
    /// `0 <= readerIndex <= storage.count`
    public struct Reader<Storage: Binary.Contiguous>: ~Copyable {
        /// The underlying storage.
        public let storage: Storage

        /// The current read position.
        @usableFromInline
        internal var _readerIndex: Binary.Position<Storage.Scalar, Storage.Space>

        /// The current read position.
        @inlinable
        public var readerIndex: Binary.Position<Storage.Scalar, Storage.Space> {
            _readerIndex
        }
    }
}

// MARK: - Throwing Initializer

extension Binary.Reader {
    /// Creates a reader over the given storage.
    ///
    /// - Throws: `Binary.Error` if readerIndex is invalid.
    public init(
        storage: consuming Storage,
        readerIndex: Binary.Position<Storage.Scalar, Storage.Space> = 0
    ) throws(Binary.Error) {
        guard readerIndex._rawValue >= 0 else {
            throw .negative(.init(field: .reader, value: readerIndex._rawValue))
        }

        let count = Storage.Scalar(storage.count)
        guard readerIndex._rawValue <= count else {
            throw .bounds(.init(
                field: .reader,
                value: readerIndex._rawValue,
                lower: Storage.Scalar(0),
                upper: count
            ))
        }

        self.storage = storage
        self._readerIndex = readerIndex
    }
}

// MARK: - Unchecked Initializer

extension Binary.Reader {
    /// Creates a reader without validation.
    ///
    /// - Precondition: `0 <= readerIndex <= storage.count`
    public init(
        unchecked storage: consuming Storage,
        readerIndex: Binary.Position<Storage.Scalar, Storage.Space> = 0
    ) {
        assert(readerIndex._rawValue >= 0)
        assert(readerIndex._rawValue <= Storage.Scalar(storage.count))
        self.storage = storage
        self._readerIndex = readerIndex
    }
}

// MARK: - Computed Properties

extension Binary.Reader {
    /// Bytes remaining to read.
    @inlinable
    public var remaining: Binary.Count<Storage.Scalar, Storage.Space> {
        Binary.Count(unchecked: Storage.Scalar(storage.count) - _readerIndex._rawValue)
    }

    /// Whether there are bytes remaining to read.
    @inlinable
    public var hasRemaining: Bool {
        remaining._rawValue > 0
    }

    /// Whether the reader has consumed all bytes.
    @inlinable
    public var isAtEnd: Bool {
        _readerIndex._rawValue >= Storage.Scalar(storage.count)
    }
}

// MARK: - Move Namespace

extension Binary.Reader {
    /// Accessor for move operations.
    public struct Move: ~Copyable {
        @usableFromInline
        var parent: UnsafeMutablePointer<Binary.Reader<Storage>>

        @usableFromInline
        init(_ parent: UnsafeMutablePointer<Binary.Reader<Storage>>) {
            self.parent = parent
        }
    }

    /// Move operations on this reader.
    public var move: Move {
        mutating get {
            Move(&self)
        }
    }
}

// MARK: - Move.Index

extension Binary.Reader.Move {
    /// Accessor for reader index movement.
    public struct Index: ~Copyable {
        @usableFromInline
        var parent: UnsafeMutablePointer<Binary.Reader<Storage>>

        @usableFromInline
        init(_ parent: UnsafeMutablePointer<Binary.Reader<Storage>>) {
            self.parent = parent
        }
    }

    /// Reader index movement.
    public var index: Index {
        Index(parent)
    }
}

extension Binary.Reader.Move.Index {
    /// Move reader index by offset.
    ///
    /// - Throws: `Binary.Error` if resulting index would be invalid.
    @inlinable
    public func callAsFunction(
        by offset: Binary.Offset<Storage.Scalar, Storage.Space>
    ) throws(Binary.Error) {
        let newIndex = parent.pointee._readerIndex._rawValue + offset._rawValue
        let count = Storage.Scalar(parent.pointee.storage.count)

        guard newIndex >= 0 else {
            throw .bounds(.init(
                field: .reader,
                value: newIndex,
                lower: Storage.Scalar(0),
                upper: count
            ))
        }

        guard newIndex <= count else {
            throw .bounds(.init(
                field: .reader,
                value: newIndex,
                lower: Storage.Scalar(0),
                upper: count
            ))
        }

        parent.pointee._readerIndex = Binary.Position(newIndex)
    }

    /// Move reader index by offset (unchecked).
    @inlinable
    public func unchecked(
        by offset: Binary.Offset<Storage.Scalar, Storage.Space>
    ) {
        let newIndex = parent.pointee._readerIndex._rawValue + offset._rawValue
        assert(newIndex >= 0 && newIndex <= Storage.Scalar(parent.pointee.storage.count))
        parent.pointee._readerIndex = Binary.Position(newIndex)
    }
}

// MARK: - Set Namespace

extension Binary.Reader {
    /// Accessor for set operations.
    public struct Set: ~Copyable {
        @usableFromInline
        var parent: UnsafeMutablePointer<Binary.Reader<Storage>>

        @usableFromInline
        init(_ parent: UnsafeMutablePointer<Binary.Reader<Storage>>) {
            self.parent = parent
        }
    }

    /// Set operations on this reader.
    public var set: Set {
        mutating get {
            Set(&self)
        }
    }
}

// MARK: - Set.Index

extension Binary.Reader.Set {
    /// Accessor for reader index setting.
    public struct Index: ~Copyable {
        @usableFromInline
        var parent: UnsafeMutablePointer<Binary.Reader<Storage>>

        @usableFromInline
        init(_ parent: UnsafeMutablePointer<Binary.Reader<Storage>>) {
            self.parent = parent
        }
    }

    /// Reader index setting.
    public var index: Index {
        Index(parent)
    }
}

extension Binary.Reader.Set.Index {
    /// Set reader index to position.
    ///
    /// - Throws: `Binary.Error` if position is invalid.
    @inlinable
    public func callAsFunction(
        to position: Binary.Position<Storage.Scalar, Storage.Space>
    ) throws(Binary.Error) {
        let count = Storage.Scalar(parent.pointee.storage.count)

        guard position._rawValue >= 0 else {
            throw .negative(.init(field: .reader, value: position._rawValue))
        }

        guard position._rawValue <= count else {
            throw .bounds(.init(
                field: .reader,
                value: position._rawValue,
                lower: Storage.Scalar(0),
                upper: count
            ))
        }

        parent.pointee._readerIndex = position
    }

    /// Set reader index to position (unchecked).
    @inlinable
    public func unchecked(
        to position: Binary.Position<Storage.Scalar, Storage.Space>
    ) {
        assert(position._rawValue >= 0)
        assert(position._rawValue <= Storage.Scalar(parent.pointee.storage.count))
        parent.pointee._readerIndex = position
    }
}

// MARK: - Reset

extension Binary.Reader {
    /// Reset reader index to zero.
    public mutating func reset() {
        _readerIndex = 0
    }
}

// MARK: - Region Access

extension Binary.Reader {
    /// Provides read-only access to the remaining bytes region.
    ///
    /// The remaining region is `storage[readerIndex..<storage.count]`.
    /// The buffer pointer is valid only within the closure scope.
    @inlinable
    public func withRemainingBytes<R, E: Swift.Error>(
        _ body: (UnsafeRawBufferPointer) throws(E) -> R
    ) throws(E) -> R {
        let readerIdx = Int(_readerIndex._rawValue)
        return try storage.withUnsafeBytes { (ptr: UnsafeRawBufferPointer) throws(E) -> R in
            let slice = UnsafeRawBufferPointer(rebasing: ptr[readerIdx..<storage.count])
            return try body(slice)
        }
    }
}
