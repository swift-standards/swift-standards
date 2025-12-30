import Testing

@testable import Binary

@Suite
struct `Binary.Contiguous Tests` {

    // MARK: - Array<UInt8> Conformance

    @Test
    func `Array conforms to Binary.Contiguous`() {
        let array: [UInt8] = [1, 2, 3, 4, 5]

        array.withUnsafeBytes { ptr in
            #expect(ptr.count == 5)
            #expect(ptr[0] == 1)
            #expect(ptr[4] == 5)
        }
    }

    @Test
    func `Array count matches withUnsafeBytes count`() {
        let array: [UInt8] = [10, 20, 30]

        array.withUnsafeBytes { ptr in
            #expect(ptr.count == array.count)
        }
    }

    @Test
    func `Array empty buffer has zero count`() {
        let array: [UInt8] = []

        #expect(array.isEmpty)
        array.withUnsafeBytes { ptr in
            #expect(ptr.isEmpty)
        }
    }

    // MARK: - ContiguousArray<UInt8> Conformance

    @Test
    func `ContiguousArray conforms to Binary.Contiguous`() {
        let array: ContiguousArray<UInt8> = [10, 20, 30]

        array.withUnsafeBytes { ptr in
            #expect(ptr.count == 3)
            #expect(ptr[0] == 10)
            #expect(ptr[2] == 30)
        }
    }

    // MARK: - Generic Usage

    @Test
    func `generic function accepts Binary.Contiguous`() {
        func readFirstByte(_ data: some Binary.Contiguous) -> UInt8? {
            data.withUnsafeBytes { ptr in
                ptr.first
            }
        }

        let array: [UInt8] = [0x42, 0x43]
        let contiguousArray: ContiguousArray<UInt8> = [0x44, 0x45]

        #expect(readFirstByte(array) == 0x42)
        #expect(readFirstByte(contiguousArray) == 0x44)
    }

    @Test
    func `generic function uses count property`() {
        func byteCount(_ data: some Binary.Contiguous) -> Int {
            data.count
        }

        let array: [UInt8] = [1, 2, 3, 4, 5]
        #expect(byteCount(array) == 5)
    }

    // MARK: - Typed Throws

    @Test
    func `typed throwing closure propagates error`() {
        enum TestError: Error { case expected }

        let array: [UInt8] = [1, 2, 3]

        #expect(throws: TestError.expected) {
            try array.withUnsafeBytes { (_: UnsafeRawBufferPointer) throws(TestError) in
                throw TestError.expected
            }
        }
    }

    // MARK: - Rethrows Overload

    @Test
    func `rethrows overload works with throwing closure`() throws {
        let array: [UInt8] = [1, 2, 3]

        let result = try array.withUnsafeBytes { ptr -> Int in
            ptr.count
        }

        #expect(result == 3)
    }
}
