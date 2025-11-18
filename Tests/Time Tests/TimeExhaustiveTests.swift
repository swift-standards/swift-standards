// TimeExhaustiveTests.swift
// Time Tests
//
// Comprehensive tests for Time target with Foundation comparison

import Foundation
import Testing

@testable import Time

@Suite("Time Exhaustive Tests")
struct TimeExhaustiveTests {

    // MARK: - Leap Year Tests

    @Test("Leap Year - Comprehensive Edge Cases")
    func testLeapYearComprehensive() {
        // Years divisible by 400 (always leap years)
        let divisibleBy400 = [400, 800, 1200, 1600, 2000, 2400]
        for year in divisibleBy400 {
            #expect(
                Time.Calendar.Gregorian.isLeapYear(Time.Year(year)) == true,
                "\(year) should be a leap year"
            )
        }

        // Years divisible by 100 but not 400 (NOT leap years)
        let divisibleBy100Not400 = [
            100, 200, 300, 500, 600, 700, 900, 1000, 1100, 1300, 1400, 1500, 1700, 1800, 1900, 2100,
            2200, 2300,
        ]
        for year in divisibleBy100Not400 {
            #expect(
                Time.Calendar.Gregorian.isLeapYear(Time.Year(year)) == false,
                "\(year) should NOT be a leap year"
            )
        }

        // Years divisible by 4 but not 100 (leap years)
        let divisibleBy4Not100 = [
            4, 8, 12, 16, 96, 104, 196, 204, 296, 304, 396, 404, 496, 504, 596, 604, 696, 704, 796,
            804, 896, 904, 996, 1004, 1996, 2004, 2008, 2012, 2016, 2020, 2024, 2028,
        ]
        for year in divisibleBy4Not100 {
            #expect(
                Time.Calendar.Gregorian.isLeapYear(Time.Year(year)) == true,
                "\(year) should be a leap year"
            )
        }

        // Years not divisible by 4 (NOT leap years)
        let notDivisibleBy4 = [
            1, 2, 3, 5, 7, 11, 97, 101, 199, 201, 1001, 1997, 1998, 1999, 2001, 2002, 2003, 2005,
            2006, 2007, 2009, 2010, 2011, 2013, 2014, 2015, 2017, 2018, 2019, 2021, 2022, 2023,
            2025, 2026, 2027,
        ]
        for year in notDivisibleBy4 {
            #expect(
                Time.Calendar.Gregorian.isLeapYear(Time.Year(year)) == false,
                "\(year) should NOT be a leap year"
            )
        }

        // Edge case: Year 0 in proleptic Gregorian calendar (leap year)
        #expect(Time.Calendar.Gregorian.isLeapYear(Time.Year(0)) == true)

        // Negative years (proleptic Gregorian)
        #expect(Time.Calendar.Gregorian.isLeapYear(Time.Year(-4)) == true)
        #expect(Time.Calendar.Gregorian.isLeapYear(Time.Year(-1)) == false)
        #expect(Time.Calendar.Gregorian.isLeapYear(Time.Year(-100)) == false)
        #expect(Time.Calendar.Gregorian.isLeapYear(Time.Year(-400)) == true)
    }

    // MARK: - Days in Month Tests

    @Test("Days in Month - All Months in Leap Year")
    func testDaysInMonthLeapYear() {
        let year = Time.Year(2024)  // Leap year
        let expected = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

        for month in 1...12 {
            let days = Time.Calendar.Gregorian.daysInMonth(year, Time.Month(unchecked: month))
            #expect(
                days == expected[month - 1],
                "Month \(month) in leap year 2024 should have \(expected[month - 1]) days"
            )
        }
    }

    @Test("Days in Month - All Months in Non-Leap Year")
    func testDaysInMonthNonLeapYear() {
        let year = Time.Year(2023)  // Non-leap year
        let expected = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

        for month in 1...12 {
            let days = Time.Calendar.Gregorian.daysInMonth(year, Time.Month(unchecked: month))
            #expect(
                days == expected[month - 1],
                "Month \(month) in non-leap year 2023 should have \(expected[month - 1]) days"
            )
        }
    }

    @Test("Days in Month - February Across Multiple Years")
    func testFebruaryDaysAcrossYears() {
        // Test February in various year types
        let testCases: [(Int, Int)] = [
            (2000, 29),  // Divisible by 400
            (2100, 28),  // Divisible by 100, not 400
            (2020, 29),  // Divisible by 4, not 100
            (2021, 28),  // Not divisible by 4
            (2024, 29),  // Divisible by 4, not 100
            (2023, 28),  // Not divisible by 4
            (1900, 28),  // Divisible by 100, not 400
            (2004, 29),  // Divisible by 4, not 100
        ]

        for (year, expectedDays) in testCases {
            let days = Time.Calendar.Gregorian.daysInMonth(
                Time.Year(year),
                Time.Month(unchecked: 2)
            )
            #expect(days == expectedDays, "February \(year) should have \(expectedDays) days")
        }
    }

    // MARK: - Component Validation Tests

    @Test("Month Validation - Boundary Cases")
    func testMonthValidation() throws {
        // Valid months
        for month in 1...12 {
            _ = try Time.Month(month)
        }

        // Invalid months
        #expect(throws: Time.Month.Error.self) {
            try Time.Month(0)
        }
        #expect(throws: Time.Month.Error.self) {
            try Time.Month(13)
        }
        #expect(throws: Time.Month.Error.self) {
            try Time.Month(-1)
        }
        #expect(throws: Time.Month.Error.self) {
            try Time.Month(100)
        }
    }

    @Test("Day Validation - All Valid Days in Each Month")
    func testDayValidationAllMonths() throws {
        let year = Time.Year(2024)  // Leap year

        // January (31 days)
        let jan = try Time.Month(1)
        for day in 1...31 {
            _ = try Time.Month.Day(day, in: jan, year: year)
        }
        #expect(throws: Time.Month.Day.Error.self) {
            try Time.Month.Day(32, in: jan, year: year)
        }

        // February in leap year (29 days)
        let feb = try Time.Month(2)
        for day in 1...29 {
            _ = try Time.Month.Day(day, in: feb, year: year)
        }
        #expect(throws: Time.Month.Day.Error.self) {
            try Time.Month.Day(30, in: feb, year: year)
        }

        // February in non-leap year (28 days)
        let nonLeapYear = Time.Year(2023)
        for day in 1...28 {
            _ = try Time.Month.Day(day, in: feb, year: nonLeapYear)
        }
        #expect(throws: Time.Month.Day.Error.self) {
            try Time.Month.Day(29, in: feb, year: nonLeapYear)
        }

        // April (30 days)
        let apr = try Time.Month(4)
        for day in 1...30 {
            _ = try Time.Month.Day(day, in: apr, year: year)
        }
        #expect(throws: Time.Month.Day.Error.self) {
            try Time.Month.Day(31, in: apr, year: year)
        }

        // December (31 days)
        let dec = try Time.Month(12)
        for day in 1...31 {
            _ = try Time.Month.Day(day, in: dec, year: year)
        }
        #expect(throws: Time.Month.Day.Error.self) {
            try Time.Month.Day(32, in: dec, year: year)
        }
    }

    @Test("Hour Validation - Boundary Cases")
    func testHourValidation() throws {
        // Valid hours
        for hour in 0...23 {
            _ = try Time.Hour(hour)
        }

        // Invalid hours
        #expect(throws: Time.Hour.Error.self) {
            try Time.Hour(-1)
        }
        #expect(throws: Time.Hour.Error.self) {
            try Time.Hour(24)
        }
        #expect(throws: Time.Hour.Error.self) {
            try Time.Hour(25)
        }
    }

    @Test("Minute Validation - Boundary Cases")
    func testMinuteValidation() throws {
        // Valid minutes
        for minute in 0...59 {
            _ = try Time.Minute(minute)
        }

        // Invalid minutes
        #expect(throws: Time.Minute.Error.self) {
            try Time.Minute(-1)
        }
        #expect(throws: Time.Minute.Error.self) {
            try Time.Minute(60)
        }
        #expect(throws: Time.Minute.Error.self) {
            try Time.Minute(61)
        }
    }

    @Test("Second Validation - Boundary Cases Including Leap Second")
    func testSecondValidation() throws {
        // Valid seconds (including leap second)
        for second in 0...60 {
            _ = try Time.Second(second)
        }

        // Invalid seconds
        #expect(throws: Time.Second.Error.self) {
            try Time.Second(-1)
        }
        #expect(throws: Time.Second.Error.self) {
            try Time.Second(61)
        }
        #expect(throws: Time.Second.Error.self) {
            try Time.Second(62)
        }
    }

    @Test("Sub-Second Validation - All Precision Levels")
    func testSubSecondValidation() throws {
        // Valid milliseconds, microseconds, nanoseconds
        for value in 0...999 {
            _ = try Time.Millisecond(value)
            _ = try Time.Microsecond(value)
            _ = try Time.Nanosecond(value)
        }

        // Invalid values
        #expect(throws: Time.Millisecond.Error.self) {
            try Time.Millisecond(-1)
        }
        #expect(throws: Time.Millisecond.Error.self) {
            try Time.Millisecond(1000)
        }

        #expect(throws: Time.Microsecond.Error.self) {
            try Time.Microsecond(-1)
        }
        #expect(throws: Time.Microsecond.Error.self) {
            try Time.Microsecond(1000)
        }

        #expect(throws: Time.Nanosecond.Error.self) {
            try Time.Nanosecond(-1)
        }
        #expect(throws: Time.Nanosecond.Error.self) {
            try Time.Nanosecond(1000)
        }
    }

    // MARK: - Sub-Second Precision Tests

    @Test("Total Nanoseconds - Calculation Accuracy")
    func testTotalNanosecondsCalculation() throws {
        // Test various combinations
        let testCases: [(ms: Int, us: Int, ns: Int, expected: Int)] = [
            (0, 0, 0, 0),
            (1, 0, 0, 1_000_000),
            (0, 1, 0, 1_000),
            (0, 0, 1, 1),
            (1, 1, 1, 1_001_001),
            (999, 999, 999, 999_999_999),
            (123, 456, 789, 123_456_789),
            (500, 500, 500, 500_500_500),
        ]

        for (ms, us, ns, expected) in testCases {
            let time = try Time(
                year: 2024,
                month: 1,
                day: 1,
                hour: 0,
                minute: 0,
                second: 0,
                millisecond: ms,
                microsecond: us,
                nanosecond: ns
            )
            #expect(
                time.totalNanoseconds == expected,
                "ms:\(ms) us:\(us) ns:\(ns) should total \(expected) nanoseconds"
            )
        }
    }

    @Test("Total Nanoseconds - Boundary Cases")
    func testTotalNanosecondsBoundaries() throws {
        // Zero
        let zero = try Time(
            year: 2024,
            month: 1,
            day: 1,
            hour: 0,
            minute: 0,
            second: 0,
            millisecond: 0,
            microsecond: 0,
            nanosecond: 0
        )
        #expect(zero.totalNanoseconds == 0)

        // Maximum
        let max = try Time(
            year: 2024,
            month: 1,
            day: 1,
            hour: 0,
            minute: 0,
            second: 0,
            millisecond: 999,
            microsecond: 999,
            nanosecond: 999
        )
        #expect(max.totalNanoseconds == 999_999_999)
    }

    // MARK: - Time Construction Tests

    @Test("Time Construction - Invalid Date Combinations")
    func testTimeConstructionInvalidDates() {
        // February 30 (never valid)
        #expect(throws: Time.Error.self) {
            try Time(year: 2024, month: 2, day: 30, hour: 0, minute: 0, second: 0)
        }

        // February 29 in non-leap year
        #expect(throws: Time.Error.self) {
            try Time(year: 2023, month: 2, day: 29, hour: 0, minute: 0, second: 0)
        }

        // April 31 (30-day month)
        #expect(throws: Time.Error.self) {
            try Time(year: 2024, month: 4, day: 31, hour: 0, minute: 0, second: 0)
        }

        // June 31 (30-day month)
        #expect(throws: Time.Error.self) {
            try Time(year: 2024, month: 6, day: 31, hour: 0, minute: 0, second: 0)
        }

        // September 31 (30-day month)
        #expect(throws: Time.Error.self) {
            try Time(year: 2024, month: 9, day: 31, hour: 0, minute: 0, second: 0)
        }

        // November 31 (30-day month)
        #expect(throws: Time.Error.self) {
            try Time(year: 2024, month: 11, day: 31, hour: 0, minute: 0, second: 0)
        }
    }

    @Test("Time Construction - Valid Boundary Dates")
    func testTimeConstructionValidBoundaries() throws {
        // February 29 in leap year
        _ = try Time(year: 2024, month: 2, day: 29, hour: 0, minute: 0, second: 0)

        // Last day of each 31-day month
        for month in [1, 3, 5, 7, 8, 10, 12] {
            _ = try Time(year: 2024, month: month, day: 31, hour: 0, minute: 0, second: 0)
        }

        // Last day of each 30-day month
        for month in [4, 6, 9, 11] {
            _ = try Time(year: 2024, month: month, day: 30, hour: 0, minute: 0, second: 0)
        }

        // Last second of day (including leap second)
        _ = try Time(year: 2024, month: 1, day: 1, hour: 23, minute: 59, second: 59)
        _ = try Time(year: 2024, month: 1, day: 1, hour: 23, minute: 59, second: 60)
    }
}
