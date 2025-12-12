import Testing

@testable import Binary

@Suite
struct `Array+Bytes Tests` {

    // MARK: - Single Integer Serialization

    @Test
    func `Array from integer little endian`() {
        let bytes = [UInt8](UInt16(0x1234), endianness: .little)
        #expect(bytes == [0x34, 0x12])
    }

    @Test
    func `Array from integer big endian`() {
        let bytes = [UInt8](UInt16(0x1234), endianness: .big)
        #expect(bytes == [0x12, 0x34])
    }

    @Test
    func `Array from integer default endianness is little`() {
        let bytes = [UInt8](UInt16(0x1234))
        #expect(bytes == [0x34, 0x12])
    }

    @Test(arguments: [
        (UInt32(0x12345678), Binary.Endianness.little, [0x78, 0x56, 0x34, 0x12] as [UInt8]),
        (UInt32(0x12345678), Binary.Endianness.big, [0x12, 0x34, 0x56, 0x78] as [UInt8]),
    ])
    func `Array from UInt32 with different endianness`(testCase: (UInt32, Binary.Endianness, [UInt8])) {
        let (value, endianness, expected) = testCase
        let bytes = [UInt8](value, endianness: endianness)
        #expect(bytes == expected)
    }

    // MARK: - Collection Serialization

    @Test
    func `Array from collection of integers`() {
        let values: [UInt16] = [1, 2, 3]
        let bytes = [UInt8](serializing: values, endianness: .little)
        #expect(bytes.count == 6)
        #expect(bytes == [1, 0, 2, 0, 3, 0])
    }

    @Test
    func `Array from empty collection`() {
        let values: [UInt16] = []
        let bytes = [UInt8](serializing: values, endianness: .little)
        #expect(bytes.isEmpty)
    }

    @Test
    func `Array from collection big endian`() {
        let values: [UInt16] = [0x1234, 0x5678]
        let bytes = [UInt8](serializing: values, endianness: .big)
        #expect(bytes == [0x12, 0x34, 0x56, 0x78])
    }

    // MARK: - String Conversions

    @Test
    func `Array from UTF8 string`() {
        let bytes = [UInt8](utf8: "Hi")
        #expect(bytes == [72, 105])
    }

    @Test
    func `Array from UTF8 empty string`() {
        let bytes = [UInt8](utf8: "")
        #expect(bytes.isEmpty)
    }

    @Test
    func `Array from UTF8 unicode string`() {
        let bytes = [UInt8](utf8: "Hello 👋")
        #expect(bytes.count > 5)
        #expect(String(decoding: bytes, as: UTF8.self) == "Hello 👋")
    }

    // MARK: - Splitting

    @Test
    func `Split by separator`() {
        let data: [UInt8] = [1, 2, 0, 0, 3, 4, 0, 0, 5]
        let parts = data.split(separator: [0, 0])
        #expect(parts.count == 3)
        #expect(parts[0] == [1, 2])
        #expect(parts[1] == [3, 4])
        #expect(parts[2] == [5])
    }

    @Test
    func `Split static method`() {
        let data: [UInt8] = [1, 2, 0, 3, 4]
        let parts = [UInt8].split(data, separator: [0])
        #expect(parts.count == 2)
        #expect(parts[0] == [1, 2])
        #expect(parts[1] == [3, 4])
    }

    @Test
    func `Split with empty separator returns original array`() {
        let data: [UInt8] = [1, 2, 3]
        let parts = data.split(separator: [])
        #expect(parts.count == 1)
        #expect(parts[0] == data)
    }

    @Test
    func `Split when separator not found`() {
        let data: [UInt8] = [1, 2, 3, 4]
        let parts = data.split(separator: [99])
        #expect(parts.count == 1)
        #expect(parts[0] == data)
    }

    // MARK: - Mutation Helpers

    @Test
    func `Append UInt16`() {
        var buffer: [UInt8] = []
        buffer.append(UInt16(0x1234), endianness: .big)
        #expect(buffer == [0x12, 0x34])
    }

    @Test
    func `Append UInt32`() {
        var buffer: [UInt8] = []
        buffer.append(UInt32(0x12345678), endianness: .big)
        #expect(buffer == [0x12, 0x34, 0x56, 0x78])
    }

    @Test
    func `Append UInt64`() {
        var buffer: [UInt8] = []
        buffer.append(UInt64(0x0102030405060708), endianness: .big)
        #expect(buffer == [0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08])
    }

    @Test
    func `Append Int16`() {
        var buffer: [UInt8] = []
        buffer.append(Int16(0x1234), endianness: .big)
        #expect(buffer == [0x12, 0x34])
    }

    @Test
    func `Append Int32`() {
        var buffer: [UInt8] = []
        buffer.append(Int32(0x12345678), endianness: .big)
        #expect(buffer == [0x12, 0x34, 0x56, 0x78])
    }

    @Test
    func `Append Int64`() {
        var buffer: [UInt8] = []
        buffer.append(Int64(0x0102030405060708), endianness: .big)
        #expect(buffer == [0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08])
    }

    @Test
    func `Append Int`() {
        var buffer: [UInt8] = []
        buffer.append(Int(42), endianness: .little)
        #expect(buffer.count == MemoryLayout<Int>.size)
        #expect(buffer[0] == 42)
    }

    @Test
    func `Append UInt`() {
        var buffer: [UInt8] = []
        buffer.append(UInt(42), endianness: .little)
        #expect(buffer.count == MemoryLayout<UInt>.size)
        #expect(buffer[0] == 42)
    }

    @Test
    func `Append multiple values`() {
        var buffer: [UInt8] = []
        buffer.append(UInt16(1), endianness: .little)
        buffer.append(UInt16(2), endianness: .little)
        #expect(buffer == [1, 0, 2, 0])
    }
}

// MARK: - Joining Byte Arrays

@Suite
struct `[[UInt8]] - Joining Tests` {

    @Test
    func `Join with separator`() {
        let parts: [[UInt8]] = [[1, 2], [3, 4], [5]]
        let joined = parts.joined(separator: [0, 0])
        #expect(joined == [1, 2, 0, 0, 3, 4, 0, 0, 5])
    }

    @Test
    func `Join without separator`() {
        let parts: [[UInt8]] = [[1, 2], [3, 4], [5]]
        let joined = parts.joined()
        #expect(joined == [1, 2, 3, 4, 5])
    }

    @Test
    func `Join empty array`() {
        let parts: [[UInt8]] = []
        let joined = parts.joined(separator: [0])
        #expect(joined.isEmpty)
    }

    @Test
    func `Join single element`() {
        let parts: [[UInt8]] = [[1, 2, 3]]
        let joined = parts.joined(separator: [0])
        #expect(joined == [1, 2, 3])
    }

    @Test
    func `Join with empty separator`() {
        let parts: [[UInt8]] = [[1], [2], [3]]
        let joined = parts.joined(separator: [])
        #expect(joined == [1, 2, 3])
    }

    @Test
    func `Join preserves capacity efficiency`() {
        let parts: [[UInt8]] = [[1, 2], [3, 4], [5, 6]]
        let joined = parts.joined(separator: [0])
        // Should be [1, 2, 0, 3, 4, 0, 5, 6] = 8 bytes
        #expect(joined.count == 8)
    }
}
