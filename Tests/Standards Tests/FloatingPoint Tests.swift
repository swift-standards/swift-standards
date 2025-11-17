import Testing
@testable import Standards

@Suite
struct `FloatingPoint - Extensions` {

    // MARK: - isApproximatelyEqual(to:tolerance:)

    @Test
    func `isApproximatelyEqual detects floating point equality within tolerance`() {
        let a = 0.1 + 0.2
        let b = 0.3

        #expect(a.isApproximatelyEqual(to: b, tolerance: 0.0001))
    }

    @Test(arguments: [
        (1.0, 1.001, 0.01, true),
        (1.0, 1.1, 0.01, false),
        (0.0, 0.0, 0.0, true),
        (1.5, 1.500001, 0.00001, true)
    ])
    func `isApproximatelyEqual with various tolerances`(testCase: (Double, Double, Double, Bool)) {
        let (a, b, tolerance, expected) = testCase
        #expect(a.isApproximatelyEqual(to: b, tolerance: tolerance) == expected)
    }

    @Test
    func `isApproximatelyEqual is symmetric`() {
        let a = 1.000001
        let b = 1.0
        let tolerance = 0.0001

        #expect(a.isApproximatelyEqual(to: b, tolerance: tolerance) ==
                b.isApproximatelyEqual(to: a, tolerance: tolerance))
    }

    // MARK: - lerp(to:t:)

    @Test(arguments: [
        (0.0, 10.0, 0.0, 0.0),
        (0.0, 10.0, 1.0, 10.0),
        (0.0, 10.0, 0.5, 5.0),
        (0.0, 10.0, 0.25, 2.5),
        (0.0, 10.0, 0.75, 7.5)
    ])
    func `lerp interpolates correctly`(testCase: (Double, Double, Double, Double)) {
        let (start, end, t, expected) = testCase
        #expect(start.lerp(to: end, t: t) == expected)
    }

    @Test
    func `lerp with negative values`() {
        let result = (-10.0).lerp(to: 10.0, t: 0.5)
        #expect(result == 0.0)
    }

    @Test
    func `lerp extrapolation beyond bounds`() {
        let start = 0.0
        let end = 10.0

        #expect(start.lerp(to: end, t: 1.5) == 15.0)
        #expect(start.lerp(to: end, t: -0.5) == -5.0)
    }

    @Test
    func `lerp is continuous`() {
        let start = 0.0
        let end = 100.0

        // Small changes in t produce small changes in result
        let t1 = 0.5
        let t2 = 0.50001
        let result1 = start.lerp(to: end, t: t1)
        let result2 = start.lerp(to: end, t: t2)

        #expect(abs(result2 - result1) < 0.01)
    }

    // MARK: - rounded(to:)

    @Test(arguments: [
        (3.14159, 0, 3.0),
        (3.14159, 1, 3.1),
        (3.14159, 2, 3.14),
        (3.14159, 3, 3.142),
        (3.14159, 4, 3.1416)
    ])
    func `rounded to decimal places`(testCase: (Double, Int, Double)) {
        let (value, places, expected) = testCase
        #expect(value.rounded(to: places) == expected)
    }

    @Test
    func `rounded to negative places returns original`() {
        let value = 3.14159
        #expect(value.rounded(to: -1) == value)
    }

    @Test
    func `rounded to zero places returns integer`() {
        let value = 3.7
        #expect(value.rounded(to: 0) == 4.0)
    }

    @Test
    func `rounded handles very small numbers`() {
        let value = 0.00123456
        #expect(value.rounded(to: 4) == 0.0012)
    }

    // MARK: - clamp01()

    @Test(arguments: [
        (0.5, 0.5),
        (0.0, 0.0),
        (1.0, 1.0),
        (1.5, 1.0),
        (-0.5, 0.0),
        (2.0, 1.0),
        (-10.0, 0.0)
    ])
    func `clamp01 restricts to unit interval`(testCase: (Double, Double)) {
        let (value, expected) = testCase
        #expect(value.clamp01() == expected)
    }

    @Test
    func `clamp01 is idempotent`() {
        let value = 1.5
        let clamped = value.clamp01()
        let doubleClamped = clamped.clamp01()

        #expect(clamped == doubleClamped)
    }

    @Test
    func `clamp01 preserves values in range`() {
        for value in stride(from: 0.0, through: 1.0, by: 0.1) {
            #expect(value.clamp01() == value)
        }
    }
}

@Suite
struct `FloatingPoint - Float specific` {

    @Test
    func `Float inherits isApproximatelyEqual`() {
        let a: Float = 0.1 + 0.2
        let b: Float = 0.3

        #expect(a.isApproximatelyEqual(to: b, tolerance: 0.0001))
    }

    @Test
    func `Float inherits lerp`() {
        let start: Float = 0.0
        let end: Float = 10.0
        let result = start.lerp(to: end, t: 0.5)

        #expect(result == 5.0)
    }

    @Test
    func `Float inherits rounded`() {
        let value: Float = 3.14159
        #expect(value.rounded(to: 2) == 3.14)
    }

    @Test
    func `Float inherits clamp01`() {
        let value: Float = 1.5
        #expect(value.clamp01() == 1.0)
    }
}

@Suite
struct `FloatingPoint - Double specific` {

    @Test
    func `Double inherits isApproximatelyEqual`() {
        let a: Double = 0.1 + 0.2
        let b: Double = 0.3

        #expect(a.isApproximatelyEqual(to: b, tolerance: 0.0001))
    }

    @Test
    func `Double inherits lerp`() {
        let start: Double = 0.0
        let end: Double = 10.0
        let result = start.lerp(to: end, t: 0.5)

        #expect(result == 5.0)
    }

    @Test
    func `Double inherits rounded`() {
        let value: Double = 3.14159
        #expect(value.rounded(to: 2) == 3.14)
    }

    @Test
    func `Double inherits clamp01`() {
        let value: Double = 1.5
        #expect(value.clamp01() == 1.0)
    }
}
