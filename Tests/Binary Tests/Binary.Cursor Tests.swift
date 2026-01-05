import Testing

@testable import Binary

@Suite
struct `Binary.Cursor Tests` {

    // MARK: - Initialization

    @Test
    func `cursor initializes with default indices`() {
        let storage: [UInt8] = [1, 2, 3, 4, 5]
        let cursor = Binary.Cursor(storage: storage)

        #expect(cursor.readerIndex._rawValue == 0)
        #expect(cursor.writerIndex._rawValue == 0)
        #expect(cursor.readableCount._rawValue == 0)
        #expect(cursor.writableCount._rawValue == 5)
    }

    @Test
    func `cursor initializes with custom indices`() throws {
        let storage: [UInt8] = [1, 2, 3, 4, 5]
        let cursor = try Binary.Cursor(storage: storage, readerIndex: 1, writerIndex: 4)

        #expect(cursor.readerIndex._rawValue == 1)
        #expect(cursor.writerIndex._rawValue == 4)
        #expect(cursor.readableCount._rawValue == 3)
        #expect(cursor.writableCount._rawValue == 1)
    }

    @Test
    func `cursor initializes with unchecked indices`() {
        let storage: [UInt8] = [1, 2, 3, 4, 5]
        let cursor = Binary.Cursor(__unchecked: (), storage: storage, readerIndex: 1, writerIndex: 4)

        #expect(cursor.readerIndex._rawValue == 1)
        #expect(cursor.writerIndex._rawValue == 4)
    }

    // MARK: - Index Mutation

    @Test
    func `moveReaderIndex advances reader`() throws {
        let storage: [UInt8] = [1, 2, 3, 4, 5]
        var cursor = try Binary.Cursor(storage: storage, readerIndex: 0, writerIndex: 5)

        try cursor.moveReaderIndex(by: 2)
        #expect(cursor.readerIndex._rawValue == 2)
        #expect(cursor.readableCount._rawValue == 3)
    }

    @Test
    func `moveReaderIndex unchecked advances reader`() throws {
        let storage: [UInt8] = [1, 2, 3, 4, 5]
        var cursor = try Binary.Cursor(storage: storage, readerIndex: 0, writerIndex: 5)

        cursor.moveReaderIndex(__unchecked: (), by: 2)
        #expect(cursor.readerIndex._rawValue == 2)
    }

    @Test
    func `moveWriterIndex advances writer`() throws {
        let storage: [UInt8] = [1, 2, 3, 4, 5]
        var cursor = try Binary.Cursor(storage: storage, readerIndex: 0, writerIndex: 2)

        try cursor.moveWriterIndex(by: 2)
        #expect(cursor.writerIndex._rawValue == 4)
        #expect(cursor.writableCount._rawValue == 1)
    }

    @Test
    func `moveWriterIndex unchecked advances writer`() throws {
        let storage: [UInt8] = [1, 2, 3, 4, 5]
        var cursor = try Binary.Cursor(storage: storage, readerIndex: 0, writerIndex: 2)

        cursor.moveWriterIndex(__unchecked: (), by: 2)
        #expect(cursor.writerIndex._rawValue == 4)
    }

    @Test
    func `setReaderIndex sets absolute position`() throws {
        let storage: [UInt8] = [1, 2, 3, 4, 5]
        var cursor = try Binary.Cursor(storage: storage, readerIndex: 0, writerIndex: 5)

        try cursor.setReaderIndex(to: 3)
        #expect(cursor.readerIndex._rawValue == 3)
    }

    @Test
    func `setReaderIndex unchecked sets absolute position`() throws {
        let storage: [UInt8] = [1, 2, 3, 4, 5]
        var cursor = try Binary.Cursor(storage: storage, readerIndex: 0, writerIndex: 5)

        cursor.setReaderIndex(__unchecked: (), to: 3)
        #expect(cursor.readerIndex._rawValue == 3)
    }

    @Test
    func `setWriterIndex sets absolute position`() throws {
        let storage: [UInt8] = [1, 2, 3, 4, 5]
        var cursor = try Binary.Cursor(storage: storage, readerIndex: 0, writerIndex: 2)

        try cursor.setWriterIndex(to: 4)
        #expect(cursor.writerIndex._rawValue == 4)
    }

    @Test
    func `setWriterIndex unchecked sets absolute position`() throws {
        let storage: [UInt8] = [1, 2, 3, 4, 5]
        var cursor = try Binary.Cursor(storage: storage, readerIndex: 0, writerIndex: 2)

        cursor.setWriterIndex(__unchecked: (), to: 4)
        #expect(cursor.writerIndex._rawValue == 4)
    }

    @Test
    func `reset clears both indices`() throws {
        let storage: [UInt8] = [1, 2, 3, 4, 5]
        var cursor = try Binary.Cursor(storage: storage, readerIndex: 2, writerIndex: 4)

        cursor.reset()
        #expect(cursor.readerIndex._rawValue == 0)
        #expect(cursor.writerIndex._rawValue == 0)
    }

    // MARK: - Readable/Writable Checks

    @Test
    func `isReadable returns true when bytes available`() throws {
        let storage: [UInt8] = [1, 2, 3]
        let cursor = try Binary.Cursor(storage: storage, readerIndex: 0, writerIndex: 3)
        let isReadable = cursor.isReadable

        #expect(isReadable == true)
    }

    @Test
    func `isReadable returns false when no bytes available`() throws {
        let storage: [UInt8] = [1, 2, 3]
        let cursor = try Binary.Cursor(storage: storage, readerIndex: 3, writerIndex: 3)
        let isReadable = cursor.isReadable

        #expect(isReadable == false)
    }

    @Test
    func `isWritable returns true when space available`() throws {
        let storage: [UInt8] = [1, 2, 3]
        let cursor = try Binary.Cursor(storage: storage, readerIndex: 0, writerIndex: 1)
        let isWritable = cursor.isWritable

        #expect(isWritable == true)
    }

    @Test
    func `isWritable returns false when no space available`() throws {
        let storage: [UInt8] = [1, 2, 3]
        let cursor = try Binary.Cursor(storage: storage, readerIndex: 0, writerIndex: 3)
        let isWritable = cursor.isWritable

        #expect(isWritable == false)
    }

    // MARK: - Closure-Based Access

    @Test
    func `withReadableBytes provides correct slice`() throws {
        let storage: [UInt8] = [1, 2, 3, 4, 5]
        let cursor = try Binary.Cursor(storage: storage, readerIndex: 1, writerIndex: 4)

        cursor.withReadableBytes { ptr in
            #expect(ptr.count == 3)
            #expect(ptr[0] == 2)
            #expect(ptr[1] == 3)
            #expect(ptr[2] == 4)
        }
    }

    @Test
    func `withWritableBytes provides correct slice`() throws {
        let storage: [UInt8] = [0, 0, 0, 0, 0]
        var cursor = try Binary.Cursor(storage: storage, readerIndex: 0, writerIndex: 2)

        cursor.withWritableBytes { ptr in
            #expect(ptr.count == 3)
            ptr[0] = 42
            ptr[1] = 43
            ptr[2] = 44
        }

        #expect(cursor.storage[2] == 42)
        #expect(cursor.storage[3] == 43)
        #expect(cursor.storage[4] == 44)
    }

    // MARK: - Typed Throws

    @Test
    func `withReadableBytes propagates typed error`() throws {
        enum TestError: Error { case expected }

        let storage: [UInt8] = [1, 2, 3]
        let cursor = try Binary.Cursor(storage: storage, readerIndex: 0, writerIndex: 3)

        #expect(throws: TestError.expected) {
            try cursor.withReadableBytes { (_: UnsafeRawBufferPointer) throws(TestError) in
                throw TestError.expected
            }
        }
    }

    @Test
    func `withWritableBytes propagates typed error`() {
        enum TestError: Error { case expected }

        let storage: [UInt8] = [1, 2, 3]
        var cursor = Binary.Cursor(storage: storage)

        #expect(throws: TestError.expected) {
            try cursor.withWritableBytes { (_: UnsafeMutableRawBufferPointer) throws(TestError) in
                throw TestError.expected
            }
        }
    }

    // MARK: - Error Cases

    @Test
    func `validated init throws on invalid reader index`() {
        let storage: [UInt8] = [1, 2, 3]

        #expect(throws: Binary.Error.self) {
            try Binary.Cursor(storage: storage, readerIndex: -1, writerIndex: 3)
        }
    }

    @Test
    func `validated init throws on reader exceeding writer`() {
        let storage: [UInt8] = [1, 2, 3]

        #expect(throws: Binary.Error.self) {
            try Binary.Cursor(storage: storage, readerIndex: 2, writerIndex: 1)
        }
    }

    @Test
    func `validated init throws on writer exceeding storage`() {
        let storage: [UInt8] = [1, 2, 3]

        #expect(throws: Binary.Error.self) {
            try Binary.Cursor(storage: storage, readerIndex: 0, writerIndex: 10)
        }
    }

    @Test
    func `moveReaderIndex throws on exceeding writer`() throws {
        let storage: [UInt8] = [1, 2, 3, 4, 5]
        var cursor = try Binary.Cursor(storage: storage, readerIndex: 0, writerIndex: 3)

        #expect(throws: Binary.Error.self) {
            try cursor.moveReaderIndex(by: 5)
        }
    }

    @Test
    func `moveWriterIndex throws on exceeding storage`() throws {
        let storage: [UInt8] = [1, 2, 3, 4, 5]
        var cursor = try Binary.Cursor(storage: storage, readerIndex: 0, writerIndex: 3)

        #expect(throws: Binary.Error.self) {
            try cursor.moveWriterIndex(by: 10)
        }
    }
}
