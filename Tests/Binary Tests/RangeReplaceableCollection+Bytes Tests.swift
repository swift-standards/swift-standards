import Testing

@testable import Binary

@Suite
struct `RangeReplaceableCollection+Bytes Tests` {

    // MARK: - UTF-8 Append

    @Test
    func `Append UTF-8 string to buffer`() {
        var buffer: [UInt8] = []
        buffer.append(utf8: "Hello")
        #expect(buffer == [72, 101, 108, 108, 111])
    }

    @Test
    func `Append UTF-8 string static method`() {
        var buffer: [UInt8] = []
        [UInt8].append(utf8: "World", to: &buffer)
        #expect(buffer == [87, 111, 114, 108, 100])
    }

    @Test
    func `Append UTF-8 to existing content`() {
        var buffer: [UInt8] = [72, 105]  // "Hi"
        buffer.append(utf8: " there")
        #expect(String(decoding: buffer, as: UTF8.self) == "Hi there")
    }

    @Test
    func `Append empty UTF-8 string`() {
        var buffer: [UInt8] = [1, 2, 3]
        buffer.append(utf8: "")
        #expect(buffer == [1, 2, 3])
    }

    @Test
    func `Append UTF-8 unicode characters`() {
        var buffer: [UInt8] = []
        buffer.append(utf8: "Hello 👋")
        #expect(String(decoding: buffer, as: UTF8.self) == "Hello 👋")
    }

    // MARK: - Single Byte Append

    @Test
    func `Append single byte to buffer`() {
        var buffer: [UInt8] = []
        [UInt8].append(0x41, to: &buffer)
        #expect(buffer == [0x41])
    }

    @Test
    func `Append single byte instance method`() {
        var buffer: [UInt8] = []
        buffer.append(0x42)
        #expect(buffer == [0x42])
    }

    @Test
    func `Append multiple single bytes`() {
        var buffer: [UInt8] = []
        buffer.append(0x01)
        buffer.append(0x02)
        buffer.append(0x03)
        #expect(buffer == [0x01, 0x02, 0x03])
    }

    // MARK: - ContiguousArray Support

    @Test
    func `Append UTF-8 to ContiguousArray`() {
        var buffer: ContiguousArray<UInt8> = []
        buffer.append(utf8: "Test")
        #expect(Array(buffer) == [84, 101, 115, 116])
    }

    @Test
    func `Append byte to ContiguousArray`() {
        var buffer: ContiguousArray<UInt8> = []
        buffer.append(0xFF)
        #expect(Array(buffer) == [0xFF])
    }
}
