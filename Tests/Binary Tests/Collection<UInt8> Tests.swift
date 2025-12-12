import Testing

@testable import Binary

@Suite
struct `Collection<UInt8> Tests` {

    // MARK: - Trimming

    @Test
    func `Trimming with predicate`() {
        let bytes: [UInt8] = [0x20, 0x48, 0x69, 0x20]
        let trimmed = bytes.trimming(where: { $0 == 0x20 })
        #expect(Array(trimmed) == [0x48, 0x69])
    }

    @Test
    func `Trimming static method with predicate`() {
        let bytes: [UInt8] = [0x00, 0x01, 0x02, 0x00]
        let trimmed = [UInt8].trimming(bytes, where: { $0 == 0x00 })
        #expect(Array(trimmed) == [0x01, 0x02])
    }

    @Test
    func `Trimming with byte set`() {
        let bytes: [UInt8] = [0x20, 0x09, 0x48, 0x69, 0x20, 0x09]
        let trimmed = bytes.trimming([0x20, 0x09])
        #expect(Array(trimmed) == [0x48, 0x69])
    }

    @Test
    func `Trimming static method with byte set`() {
        let bytes: [UInt8] = [0x00, 0xFF, 0x01, 0x02, 0x00, 0xFF]
        let trimmed = [UInt8].trimming(bytes, of: [0x00, 0xFF])
        #expect(Array(trimmed) == [0x01, 0x02])
    }

    @Test
    func `Trimming all bytes returns empty`() {
        let bytes: [UInt8] = [0x20, 0x20, 0x20]
        let trimmed = bytes.trimming(where: { $0 == 0x20 })
        #expect(Array(trimmed).isEmpty)
    }

    @Test
    func `Trimming empty collection`() {
        let bytes: [UInt8] = []
        let trimmed = bytes.trimming(where: { $0 == 0x20 })
        #expect(Array(trimmed).isEmpty)
    }

    @Test
    func `Trimming no matching bytes`() {
        let bytes: [UInt8] = [0x48, 0x69]
        let trimmed = bytes.trimming(where: { $0 == 0x20 })
        #expect(Array(trimmed) == [0x48, 0x69])
    }

    // MARK: - Subsequence Search

    @Test
    func `First index of subsequence`() {
        let data: [UInt8] = [0x48, 0x65, 0x6C, 0x6C, 0x6F]  // "Hello"
        let index = data.firstIndex(of: [0x6C, 0x6C])  // "ll"
        #expect(index == 2)
    }

    @Test
    func `First index static method`() {
        let data: [UInt8] = [1, 2, 3, 4, 5]
        let index = [UInt8].firstIndex(of: [3, 4], in: data)
        #expect(index == 2)
    }

    @Test
    func `First index not found`() {
        let data: [UInt8] = [1, 2, 3, 4]
        let index = data.firstIndex(of: [5, 6])
        #expect(index == nil)
    }

    @Test
    func `First index empty needle`() {
        let data: [UInt8] = [1, 2, 3]
        let index = data.firstIndex(of: [UInt8]())
        #expect(index == 0)
    }

    @Test
    func `First index at start`() {
        let data: [UInt8] = [1, 2, 3, 4]
        let index = data.firstIndex(of: [1, 2])
        #expect(index == 0)
    }

    @Test
    func `First index at end`() {
        let data: [UInt8] = [1, 2, 3, 4]
        let index = data.firstIndex(of: [3, 4])
        #expect(index == 2)
    }

    @Test
    func `Last index of subsequence`() {
        let data: [UInt8] = [1, 2, 3, 1, 2, 3]
        let index = data.lastIndex(of: [1, 2])
        #expect(index == 3)
    }

    @Test
    func `Last index static method`() {
        let data: [UInt8] = [1, 2, 3, 1, 2, 3]
        let index = [UInt8].lastIndex(of: [2, 3], in: data)
        #expect(index == 4)
    }

    @Test
    func `Last index not found`() {
        let data: [UInt8] = [1, 2, 3, 4]
        let index = data.lastIndex(of: [5, 6])
        #expect(index == nil)
    }

    @Test
    func `Last index empty needle returns endIndex`() {
        let data: [UInt8] = [1, 2, 3]
        let index = data.lastIndex(of: [UInt8]())
        #expect(index == data.endIndex)
    }

    @Test
    func `Contains subsequence`() {
        let data: [UInt8] = [0x48, 0x65, 0x6C, 0x6C, 0x6F]
        #expect(data.contains([0x65, 0x6C]))  // "el"
        #expect(!data.contains([0x58, 0x59]))  // "XY"
    }

    @Test
    func `Contains static method`() {
        let data: [UInt8] = [1, 2, 3, 4, 5]
        #expect([UInt8].contains([2, 3], in: data))
        #expect(![UInt8].contains([6, 7], in: data))
    }

    @Test
    func `Contains empty subsequence`() {
        let data: [UInt8] = [1, 2, 3]
        #expect(data.contains([UInt8]()))
    }

    @Test
    func `Contains single byte`() {
        let data: [UInt8] = [1, 2, 3]
        #expect(data.contains([2]))
        #expect(!data.contains([4]))
    }

    @Test
    func `Contains full sequence`() {
        let data: [UInt8] = [1, 2, 3]
        #expect(data.contains([1, 2, 3]))
    }
}
