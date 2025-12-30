import Testing

@testable import Binary

@Suite
struct `Binary.Mutable Tests` {

    // MARK: - Array<UInt8> Conformance

    @Test
    func `Array conforms to Binary.Mutable`() {
        var array: [UInt8] = [0, 0, 0]

        array.withUnsafeMutableBytes { ptr in
            ptr[0] = 0xAA
            ptr[1] = 0xBB
            ptr[2] = 0xCC
        }

        #expect(array == [0xAA, 0xBB, 0xCC])
    }

    @Test
    func `Array mutable count matches buffer count`() {
        var array: [UInt8] = [1, 2, 3, 4]
        let expectedCount = array.count

        array.withUnsafeMutableBytes { ptr in
            #expect(ptr.count == expectedCount)
        }
    }

    // MARK: - ContiguousArray<UInt8> Conformance

    @Test
    func `ContiguousArray conforms to Binary.Mutable`() {
        var array: ContiguousArray<UInt8> = [0, 0]

        array.withUnsafeMutableBytes { ptr in
            ptr[0] = 0x12
            ptr[1] = 0x34
        }

        #expect(array == [0x12, 0x34])
    }

    // MARK: - Mutable Refines Contiguous

    @Test
    func `Binary.Mutable type can be read via Binary.Contiguous`() {
        func readFirst<T: Binary.Mutable>(_ data: T) -> UInt8? {
            data.withUnsafeBytes { ptr in
                ptr.first
            }
        }

        let array: [UInt8] = [0x99]
        #expect(readFirst(array) == 0x99)
    }

    // MARK: - Generic Usage

    @Test
    func `generic function accepts Binary.Mutable`() {
        func writeFirstByte(_ data: inout some Binary.Mutable, value: UInt8) {
            data.withUnsafeMutableBytes { ptr in
                if !ptr.isEmpty {
                    ptr[0] = value
                }
            }
        }

        var array: [UInt8] = [0]
        var contiguousArray: ContiguousArray<UInt8> = [0]

        writeFirstByte(&array, value: 0xAA)
        writeFirstByte(&contiguousArray, value: 0xBB)

        #expect(array[0] == 0xAA)
        #expect(contiguousArray[0] == 0xBB)
    }

    @Test
    func `generic function zeros buffer`() {
        func zero(_ data: inout some Binary.Mutable) {
            data.withUnsafeMutableBytes { ptr in
                for i in 0..<ptr.count {
                    ptr[i] = 0
                }
            }
        }

        var array: [UInt8] = [1, 2, 3, 4, 5]
        zero(&array)

        #expect(array == [0, 0, 0, 0, 0])
    }

    // MARK: - Typed Throws

    @Test
    func `mutable typed throwing closure propagates error`() {
        enum TestError: Error { case expected }

        var array: [UInt8] = [1, 2, 3]

        #expect(throws: TestError.expected) {
            try array.withUnsafeMutableBytes {
                (_: UnsafeMutableRawBufferPointer) throws(TestError) in
                throw TestError.expected
            }
        }
    }

    // MARK: - Rethrows Overload

    @Test
    func `mutable rethrows overload works with non-throwing closure`() {
        var array: [UInt8] = [1, 2, 3]

        let result = array.withUnsafeMutableBytes { ptr -> Int in
            ptr[0] = 0xFF
            return ptr.count
        }

        #expect(result == 3)
        #expect(array[0] == 0xFF)
    }
}
