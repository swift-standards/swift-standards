// Binary.Cursor.swift
// Position-tracked view with typed throws.

extension Binary {
    /// A position-tracked view over mutable contiguous storage.
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
    /// try cursor.move.reader(by: offset)
    /// try cursor.move.writer(by: offset)
    /// cursor.move.reader.unchecked(by: offset)
    ///
    /// // Set operations
    /// try cursor.set.reader(to: position)
    /// try cursor.set.writer(to: position)
    /// ```
    ///
    /// ## Invariants
    ///
    /// `0 <= readerIndex <= writerIndex <= storage.count`
    public struct Cursor<Storage: Binary.Mutable>: ~Copyable {
        /// The underlying storage.
        public var storage: Storage

        /// The current read position (internal storage).
        @usableFromInline
        internal var _readerIndex: Binary.Position<Storage.Scalar, Storage.Space>

        /// The current write position (internal storage).
        @usableFromInline
        internal var _writerIndex: Binary.Position<Storage.Scalar, Storage.Space>

        /// The current read position.
        @inlinable
        public var readerIndex: Binary.Position<Storage.Scalar, Storage.Space> {
            _readerIndex
        }

        /// The current write position.
        @inlinable
        public var writerIndex: Binary.Position<Storage.Scalar, Storage.Space> {
            _writerIndex
        }
    }
}

// MARK: - Throwing Initializer

extension Binary.Cursor {
    /// Creates a cursor over the given storage.
    ///
    /// - Throws: `Binary.Error` if indices are invalid.
    public init(
        storage: consuming Storage,
        readerIndex: Binary.Position<Storage.Scalar, Storage.Space> = 0,
        writerIndex: Binary.Position<Storage.Scalar, Storage.Space> = 0
    ) throws(Binary.Error) {
        guard readerIndex._rawValue >= 0 else {
            throw .negative(.init(field: .reader, value: readerIndex._rawValue))
        }

        guard writerIndex._rawValue >= readerIndex._rawValue else {
            throw .invariant(.init(
                kind: .reader,
                left: readerIndex._rawValue,
                right: writerIndex._rawValue
            ))
        }

        let count = Storage.Scalar(storage.count)
        guard writerIndex._rawValue <= count else {
            throw .bounds(.init(
                field: .writer,
                value: writerIndex._rawValue,
                lower: Storage.Scalar(0),
                upper: count
            ))
        }

        self.storage = storage
        self._readerIndex = readerIndex
        self._writerIndex = writerIndex
    }
}

// MARK: - Unchecked Initializer

extension Binary.Cursor {
    /// Creates a cursor without validation.
    ///
    /// - Precondition: `0 <= readerIndex <= writerIndex <= storage.count`
    public init(
        unchecked storage: consuming Storage,
        readerIndex: Binary.Position<Storage.Scalar, Storage.Space> = 0,
        writerIndex: Binary.Position<Storage.Scalar, Storage.Space> = 0
    ) {
        assert(readerIndex._rawValue >= 0)
        assert(writerIndex._rawValue >= readerIndex._rawValue)
        assert(writerIndex._rawValue <= Storage.Scalar(storage.count))
        self.storage = storage
        self._readerIndex = readerIndex
        self._writerIndex = writerIndex
    }
}

// MARK: - Computed Properties

extension Binary.Cursor {
    /// Bytes available for reading.
    @inlinable
    public var readable: Binary.Count<Storage.Scalar, Storage.Space> {
        Binary.Count(unchecked: _writerIndex._rawValue - _readerIndex._rawValue)
    }

    /// Bytes available for writing.
    @inlinable
    public var writable: Binary.Count<Storage.Scalar, Storage.Space> {
        Binary.Count(unchecked: Storage.Scalar(storage.count) - _writerIndex._rawValue)
    }

    /// Whether there are bytes available to read.
    @inlinable
    public var isReadable: Bool {
        readable._rawValue > 0
    }

    /// Whether there is space available to write.
    @inlinable
    public var isWritable: Bool {
        writable._rawValue > 0
    }
}

// MARK: - Move Namespace

extension Binary.Cursor {
    /// Accessor for move operations.
    public struct Move: ~Copyable {
        @usableFromInline
        var cursor: UnsafeMutablePointer<Binary.Cursor<Storage>>

        @usableFromInline
        init(_ cursor: UnsafeMutablePointer<Binary.Cursor<Storage>>) {
            self.cursor = cursor
        }
    }

    /// Move operations on this cursor.
    public var move: Move {
        mutating get {
            Move(&self)
        }
    }
}

// MARK: - Move.Reader

extension Binary.Cursor.Move {
    /// Accessor for reader index movement.
    public struct Reader: ~Copyable {
        @usableFromInline
        var cursor: UnsafeMutablePointer<Binary.Cursor<Storage>>

        @usableFromInline
        init(_ cursor: UnsafeMutablePointer<Binary.Cursor<Storage>>) {
            self.cursor = cursor
        }
    }

    /// Reader index movement.
    public var reader: Reader {
        Reader(cursor)
    }
}

extension Binary.Cursor.Move.Reader {
    /// Move reader index by offset.
    ///
    /// - Throws: `Binary.Error` if resulting index would be invalid.
    @inlinable
    public func callAsFunction(
        by offset: Binary.Offset<Storage.Scalar, Storage.Space>
    ) throws(Binary.Error) {
        let newIndex = cursor.pointee._readerIndex._rawValue + offset._rawValue

        guard newIndex >= 0 else {
            throw .bounds(.init(
                field: .reader,
                value: newIndex,
                lower: Storage.Scalar(0),
                upper: cursor.pointee._writerIndex._rawValue
            ))
        }

        guard newIndex <= cursor.pointee._writerIndex._rawValue else {
            throw .invariant(.init(
                kind: .reader,
                left: newIndex,
                right: cursor.pointee._writerIndex._rawValue
            ))
        }

        cursor.pointee._readerIndex = Binary.Position(newIndex)
    }

    /// Move reader index by offset (unchecked).
    @inlinable
    public func unchecked(
        by offset: Binary.Offset<Storage.Scalar, Storage.Space>
    ) {
        let newIndex = cursor.pointee._readerIndex._rawValue + offset._rawValue
        assert(newIndex >= 0 && newIndex <= cursor.pointee._writerIndex._rawValue)
        cursor.pointee._readerIndex = Binary.Position(newIndex)
    }
}

// MARK: - Move.Writer

extension Binary.Cursor.Move {
    /// Accessor for writer index movement.
    public struct Writer: ~Copyable {
        @usableFromInline
        var cursor: UnsafeMutablePointer<Binary.Cursor<Storage>>

        @usableFromInline
        init(_ cursor: UnsafeMutablePointer<Binary.Cursor<Storage>>) {
            self.cursor = cursor
        }
    }

    /// Writer index movement.
    public var writer: Writer {
        Writer(cursor)
    }
}

extension Binary.Cursor.Move.Writer {
    /// Move writer index by offset.
    ///
    /// - Throws: `Binary.Error` if resulting index would be invalid.
    @inlinable
    public func callAsFunction(
        by offset: Binary.Offset<Storage.Scalar, Storage.Space>
    ) throws(Binary.Error) {
        let newIndex = cursor.pointee._writerIndex._rawValue + offset._rawValue
        let count = Storage.Scalar(cursor.pointee.storage.count)

        guard newIndex >= cursor.pointee._readerIndex._rawValue else {
            throw .invariant(.init(
                kind: .reader,
                left: cursor.pointee._readerIndex._rawValue,
                right: newIndex
            ))
        }

        guard newIndex <= count else {
            throw .bounds(.init(
                field: .writer,
                value: newIndex,
                lower: cursor.pointee._readerIndex._rawValue,
                upper: count
            ))
        }

        cursor.pointee._writerIndex = Binary.Position(newIndex)
    }

    /// Move writer index by offset (unchecked).
    @inlinable
    public func unchecked(
        by offset: Binary.Offset<Storage.Scalar, Storage.Space>
    ) {
        let newIndex = cursor.pointee._writerIndex._rawValue + offset._rawValue
        assert(newIndex >= cursor.pointee._readerIndex._rawValue)
        assert(newIndex <= Storage.Scalar(cursor.pointee.storage.count))
        cursor.pointee._writerIndex = Binary.Position(newIndex)
    }
}

// MARK: - Set Namespace

extension Binary.Cursor {
    /// Accessor for set operations.
    public struct Set: ~Copyable {
        @usableFromInline
        var cursor: UnsafeMutablePointer<Binary.Cursor<Storage>>

        @usableFromInline
        init(_ cursor: UnsafeMutablePointer<Binary.Cursor<Storage>>) {
            self.cursor = cursor
        }
    }

    /// Set operations on this cursor.
    public var set: Set {
        mutating get {
            Set(&self)
        }
    }
}

// MARK: - Set.Reader

extension Binary.Cursor.Set {
    /// Accessor for reader index setting.
    public struct Reader: ~Copyable {
        @usableFromInline
        var cursor: UnsafeMutablePointer<Binary.Cursor<Storage>>

        @usableFromInline
        init(_ cursor: UnsafeMutablePointer<Binary.Cursor<Storage>>) {
            self.cursor = cursor
        }
        
        /// Set reader index to position.
        ///
        /// - Throws: `Binary.Error` if position is invalid.
        @inlinable
        public func callAsFunction(
            to position: Binary.Position<Storage.Scalar, Storage.Space>
        ) throws(Binary.Error) {
            guard position._rawValue >= 0 else {
                throw .negative(.init(field: .reader, value: position._rawValue))
            }

            guard position._rawValue <= cursor.pointee._writerIndex._rawValue else {
                throw .invariant(.init(
                    kind: .reader,
                    left: position._rawValue,
                    right: cursor.pointee._writerIndex._rawValue
                ))
            }

            cursor.pointee._readerIndex = position
        }

        /// Set reader index to position (unchecked).
        @inlinable
        public func unchecked(
            to position: Binary.Position<Storage.Scalar, Storage.Space>
        ) {
            assert(position._rawValue >= 0)
            assert(position._rawValue <= cursor.pointee._writerIndex._rawValue)
            cursor.pointee._readerIndex = position
        }
    }

    /// Reader index setting.
    public var reader: Reader {
        Reader(cursor)
    }
}

//extension Binary.Cursor.Set.Reader {}

// MARK: - Set.Writer

extension Binary.Cursor.Set {
    /// Accessor for writer index setting.
    public struct Writer: ~Copyable {
        @usableFromInline
        var cursor: UnsafeMutablePointer<Binary.Cursor<Storage>>

        @usableFromInline
        init(_ cursor: UnsafeMutablePointer<Binary.Cursor<Storage>>) {
            self.cursor = cursor
        }
        
        /// Set writer index to position.
        ///
        /// - Throws: `Binary.Error` if position is invalid.
        @inlinable
        public func callAsFunction(
            to position: Binary.Position<Storage.Scalar, Storage.Space>
        ) throws(Binary.Error) {
            let count = Storage.Scalar(cursor.pointee.storage.count)

            guard position._rawValue >= cursor.pointee._readerIndex._rawValue else {
                throw .invariant(.init(
                    kind: .reader,
                    left: cursor.pointee._readerIndex._rawValue,
                    right: position._rawValue
                ))
            }

            guard position._rawValue <= count else {
                throw .bounds(.init(
                    field: .writer,
                    value: position._rawValue,
                    lower: cursor.pointee._readerIndex._rawValue,
                    upper: count
                ))
            }

            cursor.pointee._writerIndex = position
        }

        /// Set writer index to position (unchecked).
        @inlinable
        public func unchecked(
            to position: Binary.Position<Storage.Scalar, Storage.Space>
        ) {
            assert(position._rawValue >= cursor.pointee._readerIndex._rawValue)
            assert(position._rawValue <= Storage.Scalar(cursor.pointee.storage.count))
            cursor.pointee._writerIndex = position
        }
    }

    /// Writer index setting.
    public var writer: Writer {
        Writer(cursor)
    }
}


// MARK: - Reset

extension Binary.Cursor {
    /// Reset both indices to zero.
    public mutating func reset() {
        _readerIndex = 0
        _writerIndex = 0
    }
}

// MARK: - Region Access

extension Binary.Cursor {
    /// Provides read-only access to the readable bytes region.
    ///
    /// The readable region is `storage[readerIndex..<writerIndex]`.
    /// The buffer pointer is valid only within the closure scope.
    @inlinable
    public func withReadableBytes<R, E: Swift.Error>(
        _ body: (UnsafeRawBufferPointer) throws(E) -> R
    ) throws(E) -> R {
        let readerIdx = Int(_readerIndex._rawValue)
        let writerIdx = Int(_writerIndex._rawValue)
        return try storage.withUnsafeBytes { (ptr: UnsafeRawBufferPointer) throws(E) -> R in
            let slice = UnsafeRawBufferPointer(rebasing: ptr[readerIdx..<writerIdx])
            return try body(slice)
        }
    }

    /// Provides mutable access to the writable bytes region.
    ///
    /// The writable region is `storage[writerIndex..<storage.count]`.
    /// The buffer pointer is valid only within the closure scope.
    @inlinable
    public mutating func withWritableBytes<R, E: Swift.Error>(
        _ body: (UnsafeMutableRawBufferPointer) throws(E) -> R
    ) throws(E) -> R {
        let writerIdx = Int(_writerIndex._rawValue)
        let storageCount = storage.count
        return try storage.withUnsafeMutableBytes {
            (ptr: UnsafeMutableRawBufferPointer) throws(E) -> R in
            let slice = UnsafeMutableRawBufferPointer(rebasing: ptr[writerIdx..<storageCount])
            return try body(slice)
        }
    }
}
