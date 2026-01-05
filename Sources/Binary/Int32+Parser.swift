//
//  Int32+Parser.swift
//  swift-standards
//
//  ParserPrinter for Int32 binary serialization.
//

extension Int32 {
    /// A parser that reads four bytes as an `Int32`.
    ///
    /// Zero-allocation implementation using manual byte assembly.
    /// Assembles unsigned value first, then converts via `bitPattern`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// var input: ArraySlice<UInt8> = [0xFF, 0xFF, 0xFF, 0xFE, 0x00][...]
    /// let parser = Int32.Parser(endianness: .big)
    /// let value = try parser.parse(&input)
    /// // value == -2, input == [0x00]
    /// ```
    public struct Parser: Parsing.ParserPrinter, Sendable {
        public typealias Input = ArraySlice<UInt8>
        public typealias Output = Int32
        public typealias Failure = Parsing.EndOfInput.Error

        public let endianness: Binary.Endianness

        public init(endianness: Binary.Endianness) {
            self.endianness = endianness
        }

        @inlinable
        public func parse(_ input: inout Input) throws(Failure) -> Int32 {
            let size = 4
            guard input.count >= size else {
                throw .unexpected(expected: "\(size) bytes for Int32")
            }

            let base = input.startIndex
            let b0 = input[base]
            let b1 = input[base + 1]
            let b2 = input[base + 2]
            let b3 = input[base + 3]
            input.removeFirst(size)

            let unsigned: UInt32
            switch endianness {
            case .little:
                unsigned = UInt32(b0) | (UInt32(b1) << 8) | (UInt32(b2) << 16) | (UInt32(b3) << 24)
            case .big:
                unsigned = (UInt32(b0) << 24) | (UInt32(b1) << 16) | (UInt32(b2) << 8) | UInt32(b3)
            }
            return Int32(bitPattern: unsigned)
        }

        @inlinable
        public func print(_ output: Int32, into input: inout Input) {
            let bytes = output.bytes(endianness: endianness)
            input.insert(contentsOf: bytes, at: input.startIndex)
        }
    }
}
