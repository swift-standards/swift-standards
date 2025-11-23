//
//  Format.Numeric.Precision+Extensions.swift
//  swift-standards
//
//  Additional precision options: significant digits and integer length
//

// MARK: - Precision Type Definition

extension Format.Numeric.Style {
    /// Precision configuration for fraction digits
    public struct Precision {
        internal let min: Int?
        internal let max: Int?
        internal let significantDigits: (min: Int?, max: Int?)?
        internal let integerLength: (min: Int?, max: Int?)?

        internal init(
            min: Int? = nil,
            max: Int? = nil,
            significantDigits: (min: Int?, max: Int?)? = nil,
            integerLength: (min: Int?, max: Int?)? = nil
        ) {
            self.min = min
            self.max = max
            self.significantDigits = significantDigits
            self.integerLength = integerLength
        }
    }
}

// MARK: - Fraction Length

extension Format.Numeric.Style.Precision {
    /// Exact number of fraction digits
    public static func fractionLength(_ exact: Int) -> Format.Numeric.Style.Precision {
        Format.Numeric.Style.Precision(min: exact, max: exact)
    }

    /// Minimum to maximum fraction digits
    public static func fractionLength(_ range: ClosedRange<Int>) -> Format.Numeric.Style.Precision {
        Format.Numeric.Style.Precision(min: range.lowerBound, max: range.upperBound)
    }

    /// Maximum fraction digits
    public static func fractionLength(_ range: PartialRangeThrough<Int>) -> Format.Numeric.Style.Precision {
        Format.Numeric.Style.Precision(min: nil, max: range.upperBound)
    }

    /// Minimum fraction digits
    public static func fractionLength(_ range: PartialRangeFrom<Int>) -> Format.Numeric.Style.Precision {
        Format.Numeric.Style.Precision(min: range.lowerBound, max: nil)
    }
}

// MARK: - Significant Digits

extension Format.Numeric.Style.Precision {
    /// Fixed number of significant digits
    public static func significantDigits(_ exact: Int) -> Format.Numeric.Style.Precision {
        Format.Numeric.Style.Precision(
            min: nil,
            max: nil,
            significantDigits: (exact, exact)
        )
    }

    /// Minimum to maximum significant digits
    public static func significantDigits(_ range: ClosedRange<Int>) -> Format.Numeric.Style.Precision {
        Format.Numeric.Style.Precision(
            min: nil,
            max: nil,
            significantDigits: (range.lowerBound, range.upperBound)
        )
    }

    /// Maximum significant digits
    public static func significantDigits(_ range: PartialRangeThrough<Int>) -> Format.Numeric.Style.Precision {
        Format.Numeric.Style.Precision(
            min: nil,
            max: nil,
            significantDigits: (nil, range.upperBound)
        )
    }

    /// Minimum significant digits
    public static func significantDigits(_ range: PartialRangeFrom<Int>) -> Format.Numeric.Style.Precision {
        Format.Numeric.Style.Precision(
            min: nil,
            max: nil,
            significantDigits: (range.lowerBound, nil)
        )
    }
}

// MARK: - Integer Length

extension Format.Numeric.Style.Precision {
    /// Fixed integer length (zero-padded)
    public static func integerLength(_ exact: Int) -> Format.Numeric.Style.Precision {
        Format.Numeric.Style.Precision(
            min: nil,
            max: nil,
            integerLength: (exact, exact)
        )
    }

    /// Minimum to maximum integer length
    public static func integerLength(_ range: ClosedRange<Int>) -> Format.Numeric.Style.Precision {
        Format.Numeric.Style.Precision(
            min: nil,
            max: nil,
            integerLength: (range.lowerBound, range.upperBound)
        )
    }

    /// Maximum integer length
    public static func integerLength(_ range: PartialRangeThrough<Int>) -> Format.Numeric.Style.Precision {
        Format.Numeric.Style.Precision(
            min: nil,
            max: nil,
            integerLength: (nil, range.upperBound)
        )
    }

    /// Minimum integer length
    public static func integerLength(_ range: PartialRangeFrom<Int>) -> Format.Numeric.Style.Precision {
        Format.Numeric.Style.Precision(
            min: nil,
            max: nil,
            integerLength: (range.lowerBound, nil)
        )
    }
}

// MARK: - Integer and Fraction Combined

extension Format.Numeric.Style.Precision {
    /// Fixed integer and fraction lengths
    public static func integerAndFractionLength(
        integer: Int,
        fraction: Int
    ) -> Format.Numeric.Style.Precision {
        Format.Numeric.Style.Precision(
            min: fraction,
            max: fraction,
            integerLength: (integer, integer)
        )
    }

    /// Integer and fraction length ranges
    public static func integerAndFractionLength(
        integerLimits: ClosedRange<Int>,
        fractionLimits: ClosedRange<Int>
    ) -> Format.Numeric.Style.Precision {
        Format.Numeric.Style.Precision(
            min: fractionLimits.lowerBound,
            max: fractionLimits.upperBound,
            integerLength: (integerLimits.lowerBound, integerLimits.upperBound)
        )
    }
}
