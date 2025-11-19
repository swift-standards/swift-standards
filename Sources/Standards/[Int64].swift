// [Int64].swift
// swift-standards
//
// Array extensions for Swift standard library Int64

extension [Int64] {
    /// Creates an array of integers from a flat byte collection
    /// - Parameters:
    ///   - bytes: Collection of bytes representing multiple integers
    ///   - endianness: Byte order of the input bytes (defaults to little-endian)
    /// - Returns: Array of integers, or nil if byte count is not a multiple of integer size
    public init?<C: Collection>(bytes: C, endianness: [UInt8].Endianness = .little)
    where C.Element == UInt8 {
        let elementSize = MemoryLayout<Element>.size
        guard bytes.count % elementSize == 0 else { return nil }

        var result: [Element] = []
        result.reserveCapacity(bytes.count / elementSize)

        let byteArray: [UInt8] = .init(bytes)
        for i in stride(from: 0, to: byteArray.count, by: elementSize) {
            let chunk: [UInt8] = .init(byteArray[i..<i + elementSize])
            guard let element = Element(bytes: chunk, endianness: endianness) else {
                return nil
            }
            result.append(element)
        }

        self = result
    }
}
