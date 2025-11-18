// TimeFoundationTests.swift
// Time Tests
//
// Tests comparing Time package against Foundation.Date and Calendar

import Foundation
import Testing

@testable import Time

@Suite("Time vs Foundation Comparison Tests")
struct TimeFoundationTests {

    // Helper to create Foundation Date from components
    private func foundationDate(
        year: Int,
        month: Int,
        day: Int,
        hour: Int = 0,
        minute: Int = 0,
        second: Int = 0
    ) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        components.timeZone = TimeZone(secondsFromGMT: 0)

        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(from: components)
    }

    // Helper to get weekday from Foundation Date
    private func foundationWeekday(year: Int, month: Int, day: Int) -> Int? {
        guard let date = foundationDate(year: year, month: month, day: day) else {
            return nil
        }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar.component(.weekday, from: date)
    }

    // MARK: - Epoch Conversion Tests

    @Test("Epoch Conversion - Unix Epoch Zero")
    func testUnixEpochZero() {
        let time = Time(secondsSinceEpoch: 0)

        #expect(time.year.value == 1970)
        #expect(time.month.value == 1)
        #expect(time.day.value == 1)
        #expect(time.hour.value == 0)
        #expect(time.minute.value == 0)
        #expect(time.second.value == 0)

        // Compare with Foundation
        let foundationEpoch = Date(timeIntervalSince1970: 0)
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: foundationEpoch
        )

        #expect(time.year.value == components.year)
        #expect(time.month.value == components.month)
        #expect(time.day.value == components.day)
        #expect(time.hour.value == components.hour)
        #expect(time.minute.value == components.minute)
        #expect(time.second.value == components.second)
    }

    @Test("Epoch Conversion - Known Dates vs Foundation")
    func testEpochConversionKnownDates() throws {
        // NOTE: Only testing dates from 1970 onwards due to epoch conversion limitation
        let testDates: [(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int)] = [
            (2000, 1, 1, 0, 0, 0),  // Y2K
            (2024, 1, 15, 12, 30, 45),  // Random date
            (1999, 12, 31, 23, 59, 59),  // End of millennium
            (2020, 2, 29, 0, 0, 0),  // Leap day
            (2038, 1, 19, 3, 14, 7),  // Near 32-bit overflow
            (1980, 1, 6, 0, 0, 0),  // GPS epoch
        ]

        for testDate in testDates {
            let time = try Time(
                year: testDate.year,
                month: testDate.month,
                day: testDate.day,
                hour: testDate.hour,
                minute: testDate.minute,
                second: testDate.second
            )

            // Get epoch seconds from our implementation
            let ourSeconds = Time.Epoch.Conversion.secondsSinceEpoch(from: time)

            // Get epoch seconds from Foundation
            guard
                let foundationDate = foundationDate(
                    year: testDate.year,
                    month: testDate.month,
                    day: testDate.day,
                    hour: testDate.hour,
                    minute: testDate.minute,
                    second: testDate.second
                )
            else {
                Issue.record("Failed to create Foundation date for \(testDate)")
                continue
            }
            let foundationSeconds = Int(foundationDate.timeIntervalSince1970)

            #expect(
                ourSeconds == foundationSeconds,
                "Epoch seconds mismatch for \(testDate): ours=\(ourSeconds) foundation=\(foundationSeconds)"
            )
        }
    }

    // NOTE: Epoch conversion for dates before 1970 is not yet implemented
    // The yearAndDays algorithm currently only supports dates from 1970 onwards
    /*
    @Test("Epoch Conversion - Negative Epochs (Before 1970)")
    func testEpochConversionBeforeEpoch() throws {
        let testDates: [(year: Int, month: Int, day: Int)] = [
            (1969, 12, 31),  // Day before epoch
            (1969, 1, 1),    // Start of 1969
            (1960, 1, 1),    // Start of 1960s
            (1950, 1, 1),    // Mid-century
            (1945, 5, 8),    // VE Day
            (1920, 1, 1),    // Roaring Twenties
        ]
    
        for testDate in testDates {
            let time = try Time(
                year: testDate.year,
                month: testDate.month,
                day: testDate.day,
                hour: 0,
                minute: 0,
                second: 0
            )
    
            let ourSeconds = Time.Epoch.Conversion.secondsSinceEpoch(from: time)
    
            guard let foundationDate = foundationDate(
                year: testDate.year,
                month: testDate.month,
                day: testDate.day
            ) else {
                Issue.record("Failed to create Foundation date for \(testDate)")
                continue
            }
            let foundationSeconds = Int(foundationDate.timeIntervalSince1970)
    
            #expect(
                ourSeconds == foundationSeconds,
                "Epoch seconds mismatch for \(testDate): ours=\(ourSeconds) foundation=\(foundationSeconds)"
            )
            #expect(ourSeconds < 0, "Date before 1970 should have negative epoch seconds")
        }
    }
    */

    @Test("Epoch Conversion - Century Boundaries")
    func testEpochConversionCenturyBoundaries() throws {
        // NOTE: Only testing dates from 1970 onwards due to epoch conversion limitation
        let centuries: [(Int, Int, Int)] = [
            (2000, 1, 1),
            (2100, 1, 1),
            (2200, 1, 1),
            (1999, 12, 31),
            (2099, 12, 31),
        ]

        for (year, month, day) in centuries {
            let time = try Time(year: year, month: month, day: day, hour: 0, minute: 0, second: 0)
            let ourSeconds = Time.Epoch.Conversion.secondsSinceEpoch(from: time)

            guard let foundationDate = foundationDate(year: year, month: month, day: day) else {
                Issue.record("Failed to create Foundation date for \(year)-\(month)-\(day)")
                continue
            }
            let foundationSeconds = Int(foundationDate.timeIntervalSince1970)

            #expect(
                ourSeconds == foundationSeconds,
                "Century boundary \(year)-\(month)-\(day): ours=\(ourSeconds) foundation=\(foundationSeconds)"
            )
        }
    }

    @Test("Epoch Conversion - Round Trip with Foundation")
    func testEpochRoundTripWithFoundation() throws {
        // Test dates from 1970 onwards (negative epochs not yet supported)
        let testSeconds: [Int] = [
            0,  // Unix epoch
            86400,  // One day after epoch
            1_000_000_000,  // 2001-09-09
            1_234_567_890,  // 2009-02-13
            1_700_000_000,  // 2023-11-14
            2_147_483_647,  // Max 32-bit signed int (2038-01-19)
        ]

        for seconds in testSeconds {
            // Convert from epoch to Time
            let time = Time(secondsSinceEpoch: seconds)

            // Convert back to epoch
            let roundTripSeconds = Time.Epoch.Conversion.secondsSinceEpoch(from: time)

            #expect(
                roundTripSeconds == seconds,
                "Round trip failed for \(seconds): got \(roundTripSeconds)"
            )

            // Compare with Foundation
            let foundationDate = Date(timeIntervalSince1970: TimeInterval(seconds))
            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = TimeZone(secondsFromGMT: 0)!
            let components = calendar.dateComponents(
                [.year, .month, .day, .hour, .minute, .second],
                from: foundationDate
            )

            #expect(time.year.value == components.year, "Year mismatch for epoch \(seconds)")
            #expect(time.month.value == components.month, "Month mismatch for epoch \(seconds)")
            #expect(time.day.value == components.day, "Day mismatch for epoch \(seconds)")
            #expect(time.hour.value == components.hour, "Hour mismatch for epoch \(seconds)")
            #expect(
                time.minute.value == components.minute,
                "Minute mismatch for epoch \(seconds)"
            )
            #expect(
                time.second.value == components.second,
                "Second mismatch for epoch \(seconds)"
            )
        }
    }

    @Test("Epoch Conversion - Every Day in 2024")
    func testEpochConversionEveryDay2024() throws {
        let year = 2024
        let daysInMonths = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

        for month in 1...12 {
            for day in 1...daysInMonths[month - 1] {
                let time = try Time(
                    year: year,
                    month: month,
                    day: day,
                    hour: 0,
                    minute: 0,
                    second: 0
                )
                let ourSeconds = Time.Epoch.Conversion.secondsSinceEpoch(from: time)

                guard let foundationDate = foundationDate(year: year, month: month, day: day) else {
                    Issue.record("Failed to create Foundation date for \(year)-\(month)-\(day)")
                    continue
                }
                let foundationSeconds = Int(foundationDate.timeIntervalSince1970)

                #expect(
                    ourSeconds == foundationSeconds,
                    "Mismatch on \(year)-\(month)-\(day): ours=\(ourSeconds) foundation=\(foundationSeconds)"
                )

                // Also test round trip
                let roundTrip = Time(secondsSinceEpoch: ourSeconds)
                #expect(roundTrip.year.value == year)
                #expect(roundTrip.month.value == month)
                #expect(roundTrip.day.value == day)
            }
        }
    }

    // MARK: - Weekday Tests

    @Test("Weekday - Compare with Foundation")
    func testWeekdayVsFoundation() throws {
        let testDates: [(Int, Int, Int, Time.Weekday)] = [
            // Known historical dates
            (1776, 7, 4, .thursday),  // US Independence Day
            (1969, 7, 20, .sunday),  // Moon landing
            (2000, 1, 1, .saturday),  // Y2K
            (2001, 9, 11, .tuesday),  // 9/11
            (2024, 1, 1, .monday),  // New Year 2024

            // Month boundaries
            (2024, 1, 31, .wednesday),
            (2024, 2, 29, .thursday),  // Leap day
            (2024, 3, 31, .sunday),
            (2024, 12, 31, .tuesday),

            // Century boundaries
            (1900, 1, 1, .monday),
            (2000, 1, 1, .saturday),
            (2100, 1, 1, .friday),
        ]

        for (year, month, day, expectedWeekday) in testDates {
            let weekday = try Time.Weekday(year: year, month: month, day: day)
            #expect(
                weekday == expectedWeekday,
                "Weekday mismatch for \(year)-\(month)-\(day)"
            )

            // Compare with Foundation (Foundation uses 1=Sunday, 2=Monday, etc.)
            if let foundationWeekdayValue = foundationWeekday(year: year, month: month, day: day) {
                // Convert Foundation weekday (1=Sunday) to our weekday
                let foundationWeekdayEnum: Time.Weekday
                switch foundationWeekdayValue {
                case 1: foundationWeekdayEnum = .sunday
                case 2: foundationWeekdayEnum = .monday
                case 3: foundationWeekdayEnum = .tuesday
                case 4: foundationWeekdayEnum = .wednesday
                case 5: foundationWeekdayEnum = .thursday
                case 6: foundationWeekdayEnum = .friday
                case 7: foundationWeekdayEnum = .saturday
                default: fatalError("Invalid Foundation weekday: \(foundationWeekdayValue)")
                }

                #expect(
                    weekday == foundationWeekdayEnum,
                    "Foundation mismatch for \(year)-\(month)-\(day): ours=\(weekday) foundation=\(foundationWeekdayEnum)"
                )
            }
        }
    }

    @Test("Weekday - Every Day in 2024 vs Foundation")
    func testWeekdayEveryDay2024VsFoundation() throws {
        let year = 2024
        let daysInMonths = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

        for month in 1...12 {
            for day in 1...daysInMonths[month - 1] {
                let weekday = try Time.Weekday(year: year, month: month, day: day)

                // Compare with Foundation
                if let foundationWeekdayValue = foundationWeekday(
                    year: year,
                    month: month,
                    day: day
                ) {
                    let foundationWeekdayEnum: Time.Weekday
                    switch foundationWeekdayValue {
                    case 1: foundationWeekdayEnum = .sunday
                    case 2: foundationWeekdayEnum = .monday
                    case 3: foundationWeekdayEnum = .tuesday
                    case 4: foundationWeekdayEnum = .wednesday
                    case 5: foundationWeekdayEnum = .thursday
                    case 6: foundationWeekdayEnum = .friday
                    case 7: foundationWeekdayEnum = .saturday
                    default: fatalError("Invalid Foundation weekday: \(foundationWeekdayValue)")
                    }

                    #expect(
                        weekday == foundationWeekdayEnum,
                        "Weekday mismatch for \(year)-\(month)-\(day): ours=\(weekday) foundation=\(foundationWeekdayEnum)"
                    )
                }
            }
        }
    }

    // NOTE: Weekday calculation works for dates before 1970, so we can test them
    @Test("Weekday - Dates Before Epoch vs Foundation")
    func testWeekdayBeforeEpochVsFoundation() throws {
        let testDates: [(Int, Int, Int)] = [
            (1969, 12, 31),
            (1969, 1, 1),
            (1960, 1, 1),
            (1950, 1, 1),
            (1945, 5, 8),  // VE Day
            (1920, 1, 1),
            (1900, 1, 1),
        ]

        for (year, month, day) in testDates {
            let weekday = try Time.Weekday(year: year, month: month, day: day)

            // Compare with Foundation
            if let foundationWeekdayValue = foundationWeekday(year: year, month: month, day: day) {
                let foundationWeekdayEnum: Time.Weekday
                switch foundationWeekdayValue {
                case 1: foundationWeekdayEnum = .sunday
                case 2: foundationWeekdayEnum = .monday
                case 3: foundationWeekdayEnum = .tuesday
                case 4: foundationWeekdayEnum = .wednesday
                case 5: foundationWeekdayEnum = .thursday
                case 6: foundationWeekdayEnum = .friday
                case 7: foundationWeekdayEnum = .saturday
                default: fatalError("Invalid Foundation weekday: \(foundationWeekdayValue)")
                }

                #expect(
                    weekday == foundationWeekdayEnum,
                    "Weekday mismatch for \(year)-\(month)-\(day): ours=\(weekday) foundation=\(foundationWeekdayEnum)"
                )
            }
        }
    }

    // MARK: - Leap Year Validation Against Foundation

    @Test("Leap Year - Validate Against Foundation")
    func testLeapYearVsFoundation() {
        let testYears = [
            1900, 1904, 1996, 1997, 1998, 1999,
            2000, 2001, 2004, 2020, 2024, 2100, 2400,
        ]

        for year in testYears {
            let ourResult = Time.Calendar.Gregorian.isLeapYear(Time.Year(year))

            // Foundation check - properly validate Feb 29 exists AND doesn't roll over
            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = TimeZone(secondsFromGMT: 0)!

            var components = DateComponents()
            components.year = year
            components.month = 2
            components.day = 29

            // Create date and verify it's actually Feb 29 (not rolled to Mar 1)
            if let date = calendar.date(from: components) {
                let resultComponents = calendar.dateComponents([.year, .month, .day], from: date)
                let foundationResult =
                    resultComponents.year == year
                    && resultComponents.month == 2
                    && resultComponents.day == 29

                #expect(
                    ourResult == foundationResult,
                    "Leap year mismatch for \(year): ours=\(ourResult) foundation=\(foundationResult)"
                )
            } else {
                // If Foundation can't create the date at all, it's not a leap year
                #expect(
                    ourResult == false,
                    "Leap year mismatch for \(year): ours=\(ourResult) foundation=false"
                )
            }
        }
    }
}
