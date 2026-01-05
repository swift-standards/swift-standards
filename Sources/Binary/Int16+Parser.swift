//
//  Int16+Parser.swift
//  swift-standards
//
//  ParserPrinter for Int16 binary serialization.
//

extension Int16 {
    /// A parser that reads two bytes as an `Int16`.
    ///
    /// Zero-allocation implementation using manual byte assembly.
    /// Assembles unsigned value first, then converts via `bitPattern`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// var input: ArraySlice<UInt8> = [0xFF, 0xFE, 0x00][...]
    /// let parser = Int16.Parser(endianness: .big)
    /// let value = try parser.parse(&input)
    /// // value == -2, input == [0x00]
    /// ```
    public struct Parser: Parsing.ParserPrinter, Sendable {
        public typealias Input = ArraySlice<UInt8>
        public typealias Output = Int16
        public typealias Failure = Parsing.EndOfInput.Error

        public let endianness: Binary.Endianness

        public init(endianness: Binary.Endianness) {
            self.endianness = endianness
        }

        @inlinable
        public func parse(_ input: inout Input) throws(Failure) -> Int16 {
            let size = 2
            guard input.count >= size else {
                throw .unexpected(expected: "\(size) bytes for Int16")
            }

            let base = input.startIndex
            let b0 = input[base]
            let b1 = input[base + 1]
            input.removeFirst(size)

            let unsigned: UInt16
            switch endianness {
            case .little:
                unsigned = UInt16(b0) | (UInt16(b1) << 8)
            case .big:
                unsigned = (UInt16(b0) << 8) | UInt16(b1)
            }
            return Int16(bitPattern: unsigned)
        }

        @inlinable
        public func print(_ output: Int16, into input: inout Input) {
            let bytes = output.bytes(endianness: endianness)
            input.insert(contentsOf: bytes, at: input.startIndex)
        }
    }
}
