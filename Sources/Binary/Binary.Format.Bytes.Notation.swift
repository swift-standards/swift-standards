// Binary.Format.Bytes.Notation.swift
// Notation styles for byte formatting.

extension Binary.Format.Bytes {
    /// Notation style for byte formatting.
    ///
    /// Controls spacing between the numeric value and unit symbol.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 1024.formatted(Binary.Format.bytes.notation(.spaced))       // "1.02 KB"
    /// 1024.formatted(Binary.Format.bytes.notation(.compactName))  // "1.02KB"
    /// ```
    public enum Notation: Sendable, Equatable {
        /// Standard notation with space between value and unit.
        ///
        /// Example: "1.5 MB", "512 B"
        case spaced

        /// Compact notation without space between value and unit.
        ///
        /// Example: "1.5MB", "512B"
        case compactName

        /// The separator string between value and unit.
        @inlinable
        public var separator: String {
            switch self {
            case .spaced: return " "
            case .compactName: return ""
            }
        }
    }
}
