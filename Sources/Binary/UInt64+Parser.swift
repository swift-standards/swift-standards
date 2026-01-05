//
//  UInt64+Parser.swift
//  swift-standards
//
//  ParserPrinter for UInt64 binary serialization.
//

extension UInt64 {
    /// A parser that reads eight bytes as a `UInt64`.
    ///
    /// Zero-allocation implementation using manual byte assembly.
    ///
    /// ## Example
    ///
    /// ```swift
    /// var input: ArraySlice<UInt8> = [0x12, 0x34, 0x56, 0x78, 0x9A, 0xBC, 0xDE, 0xF0, 0x00][...]
    /// let parser = UInt64.Parser(endianness: .big)
    /// let value = try parser.parse(&input)
    /// // value == 0x123456789ABCDEF0, input == [0x00]
    /// ```
    public struct Parser: Parsing.ParserPrinter, Sendable {
        public typealias Input = ArraySlice<UInt8>
        public typealias Output = UInt64
        public typealias Failure = Parsing.EndOfInput.Error

        public let endianness: Binary.Endianness

        public init(endianness: Binary.Endianness) {
            self.endianness = endianness
        }

        @inlinable
        public func parse(_ input: inout Input) throws(Failure) -> UInt64 {
            let size = 8
            guard input.count >= size else {
                throw .unexpected(expected: "\(size) bytes for UInt64")
            }

            let base = input.startIndex
            let b0 = input[base]
            let b1 = input[base + 1]
            let b2 = input[base + 2]
            let b3 = input[base + 3]
            let b4 = input[base + 4]
            let b5 = input[base + 5]
            let b6 = input[base + 6]
            let b7 = input[base + 7]
            input.removeFirst(size)

            switch endianness {
            case .little:
                return UInt64(b0) | (UInt64(b1) << 8) | (UInt64(b2) << 16) | (UInt64(b3) << 24)
                    | (UInt64(b4) << 32) | (UInt64(b5) << 40) | (UInt64(b6) << 48) | (UInt64(b7) << 56)
            case .big:
                return (UInt64(b0) << 56) | (UInt64(b1) << 48) | (UInt64(b2) << 40) | (UInt64(b3) << 32)
                    | (UInt64(b4) << 24) | (UInt64(b5) << 16) | (UInt64(b6) << 8) | UInt64(b7)
            }
        }

        @inlinable
        public func print(_ output: UInt64, into input: inout Input) {
            let bytes = output.bytes(endianness: endianness)
            input.insert(contentsOf: bytes, at: input.startIndex)
        }
    }
}
