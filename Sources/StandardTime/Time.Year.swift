// Time.Year.swift
// Time
//
// Year representation as a refinement type

extension Time {
    /// A year in the Gregorian calendar.
    ///
    /// Type-safe wrapper for year values. No range restrictions—supports any integer
    /// (negative values represent BC/BCE years).
    ///
    /// ## Example
    ///
    /// ```swift
    /// let year = Time.Year(2024)
    /// print(year.isLeapYear) // true
    ///
    /// let ancient = Time.Year(-44) // 44 BC
    /// ```
    public struct Year: RawRepresentable, Sendable, Equatable, Hashable, Comparable {
        /// Year value
        public let rawValue: Int

        /// Creates a year.
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        /// Creates a year (convenience).
        public init(_ value: Int) {
            self.rawValue = value
        }
    }
}

// MARK: - Comparable

extension Time.Year {
    public static func < (lhs: Time.Year, rhs: Time.Year) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

// MARK: - Convenience

extension Time.Year {
    /// Whether this year is a leap year in the Gregorian calendar
    public var isLeapYear: Bool {
        Time.Calendar.Gregorian.isLeapYear(self)
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Time.Year: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}
