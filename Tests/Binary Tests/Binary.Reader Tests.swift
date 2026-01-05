import Testing

@testable import Binary

@Suite
struct `Binary.Reader Tests` {

    // MARK: - Initialization

    @Test
    func `reader initializes with default index`() throws {
        let storage: [UInt8] = [1, 2, 3, 4, 5]
        let reader = try Binary.Reader(storage: storage)

        #expect(reader.readerIndex._rawValue == 0)
        #expect(reader.remaining._rawValue == 5)
    }

    @Test
    func `reader initializes with custom index`() throws {
        let storage: [UInt8] = [1, 2, 3, 4, 5]
        let reader = try Binary.Reader(storage: storage, readerIndex: 2)

        #expect(reader.readerIndex._rawValue == 2)
        #expect(reader.remaining._rawValue == 3)
    }

    @Test
    func `reader initializes with unchecked`() {
        let storage: [UInt8] = [1, 2, 3, 4, 5]
        let reader = Binary.Reader(unchecked: storage, readerIndex: 2)

        #expect(reader.readerIndex._rawValue == 2)
        #expect(reader.remaining._rawValue == 3)
    }

    // MARK: - Index Mutation

    @Test
    func `move index advances reader`() throws {
        let storage: [UInt8] = [1, 2, 3, 4, 5]
        var reader = try Binary.Reader(storage: storage)

        try reader.move.index(by: 3)
        #expect(reader.readerIndex._rawValue == 3)
        #expect(reader.remaining._rawValue == 2)
    }

    @Test
    func `move index allows negative offset (rewind)`() throws {
        let storage: [UInt8] = [1, 2, 3, 4, 5]
        var reader = try Binary.Reader(storage: storage, readerIndex: 3)

        try reader.move.index(by: -2)
        #expect(reader.readerIndex._rawValue == 1)
        #expect(reader.remaining._rawValue == 4)
    }

    @Test
    func `set index sets absolute position`() throws {
        let storage: [UInt8] = [1, 2, 3, 4, 5]
        var reader = try Binary.Reader(storage: storage)

        try reader.set.index(to: 4)
        #expect(reader.readerIndex._rawValue == 4)
        #expect(reader.remaining._rawValue == 1)
    }

    @Test
    func `reset clears reader index`() throws {
        let storage: [UInt8] = [1, 2, 3, 4, 5]
        var reader = try Binary.Reader(storage: storage, readerIndex: 3)

        reader.reset()
        #expect(reader.readerIndex._rawValue == 0)
        #expect(reader.remaining._rawValue == 5)
    }

    // MARK: - Convenience Properties

    @Test
    func `hasRemaining returns true when bytes available`() throws {
        let storage: [UInt8] = [1, 2, 3]
        let reader = try Binary.Reader(storage: storage)
        let hasRemaining = reader.hasRemaining

        #expect(hasRemaining == true)
    }

    @Test
    func `hasRemaining returns false at end`() throws {
        let storage: [UInt8] = [1, 2, 3]
        let reader = try Binary.Reader(storage: storage, readerIndex: 3)
        let hasRemaining = reader.hasRemaining

        #expect(hasRemaining == false)
    }

    @Test
    func `isAtEnd returns true at end`() throws {
        let storage: [UInt8] = [1, 2, 3]
        let reader = try Binary.Reader(storage: storage, readerIndex: 3)
        let isAtEnd = reader.isAtEnd

        #expect(isAtEnd == true)
    }

    @Test
    func `isAtEnd returns false when bytes remain`() throws {
        let storage: [UInt8] = [1, 2, 3]
        let reader = try Binary.Reader(storage: storage)
        let isAtEnd = reader.isAtEnd

        #expect(isAtEnd == false)
    }

    // MARK: - Closure-Based Access

    @Test
    func `withRemainingBytes provides correct slice`() throws {
        let storage: [UInt8] = [1, 2, 3, 4, 5]
        let reader = try Binary.Reader(storage: storage, readerIndex: 2)

        reader.withRemainingBytes { ptr in
            #expect(ptr.count == 3)
            #expect(ptr[0] == 3)
            #expect(ptr[1] == 4)
            #expect(ptr[2] == 5)
        }
    }

    @Test
    func `withRemainingBytes returns empty for exhausted reader`() throws {
        let storage: [UInt8] = [1, 2, 3]
        let reader = try Binary.Reader(storage: storage, readerIndex: 3)

        reader.withRemainingBytes { ptr in
            #expect(ptr.isEmpty)
        }
    }

    // MARK: - Typed Throws

    @Test
    func `withRemainingBytes propagates typed error`() throws {
        enum TestError: Error { case expected }

        let storage: [UInt8] = [1, 2, 3]
        let reader = try Binary.Reader(storage: storage)

        #expect(throws: TestError.expected) {
            try reader.withRemainingBytes { (_: UnsafeRawBufferPointer) throws(TestError) in
                throw TestError.expected
            }
        }
    }

    // MARK: - Storage Access

    @Test
    func `storage property provides access to underlying data`() throws {
        let storage: [UInt8] = [10, 20, 30]
        let reader = try Binary.Reader(storage: storage)

        #expect(reader.storage.count == 3)
        #expect(reader.storage[0] == 10)
    }
}
