//
//  UInt32+Parser.swift
//  swift-standards
//
//  ParserPrinter for UInt32 binary serialization.
//

extension UInt32 {
    /// A parser that reads four bytes as a `UInt32`.
    ///
    /// Zero-allocation implementation using manual byte assembly.
    ///
    /// ## Example
    ///
    /// ```swift
    /// var input: ArraySlice<UInt8> = [0x12, 0x34, 0x56, 0x78, 0x00][...]
    /// let parser = UInt32.Parser(endianness: .big)
    /// let value = try parser.parse(&input)
    /// // value == 0x12345678, input == [0x00]
    /// ```
    public struct Parser: Parsing.ParserPrinter, Sendable {
        public typealias Input = ArraySlice<UInt8>
        public typealias Output = UInt32
        public typealias Failure = Parsing.EndOfInput.Error

        public let endianness: Binary.Endianness

        public init(endianness: Binary.Endianness) {
            self.endianness = endianness
        }

        @inlinable
        public func parse(_ input: inout Input) throws(Failure) -> UInt32 {
            let size = 4
            guard input.count >= size else {
                throw .unexpected(expected: "\(size) bytes for UInt32")
            }

            let base = input.startIndex
            let b0 = input[base]
            let b1 = input[base + 1]
            let b2 = input[base + 2]
            let b3 = input[base + 3]
            input.removeFirst(size)

            switch endianness {
            case .little:
                return UInt32(b0) | (UInt32(b1) << 8) | (UInt32(b2) << 16) | (UInt32(b3) << 24)
            case .big:
                return (UInt32(b0) << 24) | (UInt32(b1) << 16) | (UInt32(b2) << 8) | UInt32(b3)
            }
        }

        @inlinable
        public func print(_ output: UInt32, into input: inout Input) {
            let bytes = output.bytes(endianness: endianness)
            input.insert(contentsOf: bytes, at: input.startIndex)
        }
    }
}
