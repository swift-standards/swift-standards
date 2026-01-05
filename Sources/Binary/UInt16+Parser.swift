//
//  UInt16+Parser.swift
//  swift-standards
//
//  ParserPrinter for UInt16 binary serialization.
//

extension UInt16 {
    /// A parser that reads two bytes as a `UInt16`.
    ///
    /// Zero-allocation implementation using manual byte assembly.
    ///
    /// ## Example
    ///
    /// ```swift
    /// var input: ArraySlice<UInt8> = [0x12, 0x34, 0x00][...]
    /// let parser = UInt16.Parser(endianness: .big)
    /// let value = try parser.parse(&input)
    /// // value == 0x1234, input == [0x00]
    /// ```
    public struct Parser: Parsing.ParserPrinter, Sendable {
        public typealias Input = ArraySlice<UInt8>
        public typealias Output = UInt16
        public typealias Failure = Parsing.EndOfInput.Error

        public let endianness: Binary.Endianness

        public init(endianness: Binary.Endianness) {
            self.endianness = endianness
        }

        @inlinable
        public func parse(_ input: inout Input) throws(Failure) -> UInt16 {
            let size = 2
            guard input.count >= size else {
                throw .unexpected(expected: "\(size) bytes for UInt16")
            }

            let base = input.startIndex
            let b0 = input[base]
            let b1 = input[base + 1]
            input.removeFirst(size)

            switch endianness {
            case .little:
                return UInt16(b0) | (UInt16(b1) << 8)
            case .big:
                return (UInt16(b0) << 8) | UInt16(b1)
            }
        }

        @inlinable
        public func print(_ output: UInt16, into input: inout Input) {
            let bytes = output.bytes(endianness: endianness)
            input.insert(contentsOf: bytes, at: input.startIndex)
        }
    }
}
