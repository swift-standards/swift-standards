// JulianTests.swift
// StandardTime Tests
//
// Tests for Julian Day conversions

import Dimension
import Testing

@testable import StandardTime

@Suite
struct JulianTests {

    // MARK: - Constants

    @Test
    func unixEpochConstant() {
        let jd = Time.Julian.Day.unixEpoch
        #expect(jd._rawValue == 2_440_587.5)
    }

    @Test
    func j2000Constant() {
        let jd = Time.Julian.Day.j2000
        #expect(jd._rawValue == 2_451_545.0)
    }

    @Test
    func modifiedOffsetConstant() {
        let offset = Time.Julian.Offset.modified
        #expect(offset._rawValue == 2_400_000.5)
    }

    // MARK: - Time → Julian Day

    @Test
    func timeToJulianDayJ2000() throws {
        // J2000.0 is 2000-01-01 12:00:00 TT
        let time = try Time(year: 2000, month: 1, day: 1, hour: 12, minute: 0, second: 0)
        let jd = Time.Julian.Day(time)
        #expect(abs(jd._rawValue - 2_451_545.0) < 0.0001)
    }

    @Test
    func timeToJulianDayUnixEpoch() throws {
        // Unix epoch is 1970-01-01 00:00:00
        let time = try Time(year: 1970, month: 1, day: 1, hour: 0, minute: 0, second: 0)
        let jd = Time.Julian.Day(time)
        #expect(abs(jd._rawValue - 2_440_587.5) < 0.0001)
    }

    @Test
    func timeToJulianDayMidnight() throws {
        // Midnight should be .5 fraction
        let time = try Time(year: 2024, month: 6, day: 15, hour: 0, minute: 0, second: 0)
        let jd = Time.Julian.Day(time)
        let fractionalPart = jd._rawValue - Double(Int(jd._rawValue))
        #expect(abs(fractionalPart - 0.5) < 0.0001)
    }

    @Test
    func timeToJulianDayNoon() throws {
        // Noon should be .0 fraction
        let time = try Time(year: 2024, month: 6, day: 15, hour: 12, minute: 0, second: 0)
        let jd = Time.Julian.Day(time)
        let fractionalPart = jd._rawValue - Double(Int(jd._rawValue))
        #expect(fractionalPart < 0.0001 || fractionalPart > 0.9999)
    }

    // MARK: - Julian Day → Time

    @Test
    func julianDayToTimeJ2000() throws {
        let jd: Time.Julian.Day = 2_451_545.0
        let time = Time(jd)
        #expect(time.year.rawValue == 2000)
        #expect(time.month.rawValue == 1)
        #expect(time.day.rawValue == 1)
        #expect(time.hour.value == 12)
    }

    @Test
    func julianDayToTimeUnixEpoch() throws {
        let jd: Time.Julian.Day = 2_440_587.5
        let time = Time(jd)
        #expect(time.year.rawValue == 1970)
        #expect(time.month.rawValue == 1)
        #expect(time.day.rawValue == 1)
        #expect(time.hour.value == 0)
    }

    // MARK: - Round Trip

    @Test
    func roundTripTimeToJulianDay() throws {
        let original = try Time(
            year: 2024,
            month: 7,
            day: 20,
            hour: 15,
            minute: 30,
            second: 45
        )
        let jd = Time.Julian.Day(original)
        let restored = Time(jd)

        #expect(restored.year.rawValue == original.year.rawValue)
        #expect(restored.month.rawValue == original.month.rawValue)
        #expect(restored.day.rawValue == original.day.rawValue)
        #expect(restored.hour.value == original.hour.value)
        #expect(restored.minute.value == original.minute.value)
        #expect(restored.second.value == original.second.value)
    }

    // MARK: - Affine Arithmetic

    @Test
    func dayMinusDayEqualsOffset() {
        let jd1: Time.Julian.Day = 2_451_545.0
        let jd2: Time.Julian.Day = 2_451_546.0
        let offset = jd2 - jd1
        #expect(abs(offset._rawValue - 1.0) < 0.0001)
    }

    @Test
    func dayPlusOffsetEqualsDay() {
        let jd: Time.Julian.Day = 2_451_545.0
        let offset: Time.Julian.Offset = 10.0
        let result = jd + offset
        #expect(abs(result._rawValue - 2_451_555.0) < 0.0001)
    }

    @Test
    func dayMinusOffsetEqualsDay() {
        let jd: Time.Julian.Day = 2_451_545.0
        let offset: Time.Julian.Offset = 10.0
        let result = jd - offset
        #expect(abs(result._rawValue - 2_451_535.0) < 0.0001)
    }

    // MARK: - Modified Julian Day

    @Test
    func modifiedJulianDayJ2000() {
        let jd: Time.Julian.Day = 2_451_545.0
        let mjd = jd.modified
        #expect(abs(mjd - 51544.5) < 0.0001)
    }

    @Test
    func modifiedJulianDayFromOffset() {
        let jd: Time.Julian.Day = 2_451_545.0
        let mjd = jd - .modified
        #expect(abs(mjd._rawValue - 51544.5) < 0.0001)
    }

    // MARK: - Instant Conversions

    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @Test
    func instantToJulianDay() throws {
        let instant = try Instant(secondsSinceUnixEpoch: 0)
        let jd = Time.Julian.Day(instant)
        #expect(abs(jd._rawValue - 2_440_587.5) < 0.0001)
    }

    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @Test
    func julianDayToInstant() throws {
        let jd: Time.Julian.Day = 2_440_587.5
        let instant = Instant(jd)
        #expect(instant.secondsSinceUnixEpoch == 0)
    }

    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @Test
    func instantRoundTrip() throws {
        let original = try Instant(secondsSinceUnixEpoch: 1_000_000_000, nanosecondFraction: 500_000_000)
        let jd = Time.Julian.Day(original)
        let restored = Instant(jd)

        #expect(restored.secondsSinceUnixEpoch == original.secondsSinceUnixEpoch)
        // Note: precision loss expected due to Double's ~15 significant digits
        // For large JD values, nanosecond precision is limited
        #expect(abs(restored.nanosecondFraction - original.nanosecondFraction) < 100_000)
    }
}
