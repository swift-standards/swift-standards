// Time.Month.swift
// Time
//
// Month representation as a refinement type

extension Time {
    /// Month in the Gregorian calendar (1-12).
    ///
    /// Refinement type constraining integers to valid month range.
    /// Use static constants (`.january`, `.february`, etc.) for convenience.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let month = try Time.Month(2) // February
    /// let feb = Time.Month.february
    /// print(feb.days(in: Time.Year(2024))) // 29
    /// ```
    public struct Month: RawRepresentable, Sendable, Equatable, Hashable, Comparable {
        /// Month value (1-12)
        public let rawValue: Int

        /// Creates a month with validation (failable).
        ///
        /// Returns `nil` if value is not 1-12.
        public init?(rawValue: Int) {
            guard (1...12).contains(rawValue) else {
                return nil
            }
            self.rawValue = rawValue
        }

        /// Creates a month with validation (throwing).
        ///
        /// - Throws: `Month.Error.invalidMonth` if value is not 1-12
        public init(_ value: Int) throws(Error) {
            guard (1...12).contains(value) else {
                throw Error.invalidMonth(value)
            }
            self.rawValue = value
        }
    }
}

// MARK: - Error

extension Time.Month {
    /// Validation errors for month values.
    public enum Error: Swift.Error, Sendable, Equatable {
        /// Month value is not in valid range (1-12)
        case invalidMonth(Int)
    }
}

// MARK: - Unchecked Initialization

extension Time.Month {
    /// Creates a month without validation (internal use only).
    ///
    /// - Warning: Only use when value is known to be valid (1-12)
    internal init(unchecked value: Int) {
        self.rawValue = value
    }
}

// MARK: - Comparable

extension Time.Month {
    public static func < (lhs: Time.Month, rhs: Time.Month) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

// MARK: - Int Comparison

extension Time.Month {
    /// Compare month with integer value
    public static func == (lhs: Time.Month, rhs: Int) -> Bool {
        lhs.rawValue == rhs
    }

    /// Compare integer value with month
    public static func == (lhs: Int, rhs: Time.Month) -> Bool {
        lhs == rhs.rawValue
    }
}

// MARK: - Convenience

extension Time.Month {
    /// Returns the number of days in this month for a given year (28-31).
    ///
    /// February varies by leap year (28 or 29 days).
    public func days(in year: Time.Year) -> Int {
        Time.Calendar.Gregorian.daysInMonth(year, self)
    }
}

// MARK: - Common Months

extension Time.Month {
    /// January (month 1)
    public static let january = Self(unchecked: 1)

    /// February (month 2)
    public static let february = Self(unchecked: 2)

    /// March (month 3)
    public static let march = Self(unchecked: 3)

    /// April (month 4)
    public static let april = Self(unchecked: 4)

    /// May (month 5)
    public static let may = Self(unchecked: 5)

    /// June (month 6)
    public static let june = Self(unchecked: 6)

    /// July (month 7)
    public static let july = Self(unchecked: 7)

    /// August (month 8)
    public static let august = Self(unchecked: 8)

    /// September (month 9)
    public static let september = Self(unchecked: 9)

    /// October (month 10)
    public static let october = Self(unchecked: 10)

    /// November (month 11)
    public static let november = Self(unchecked: 11)

    /// December (month 12)
    public static let december = Self(unchecked: 12)
}
