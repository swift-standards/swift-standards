// TestSpacing.swift
// Shared test spacing type for Layout tests

/// A custom spacing type for testing
struct TestSpacing: AdditiveArithmetic, Comparable, Codable, Hashable, Sendable,
    ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral
{
    let value: Double

    init(_ value: Double) {
        self.value = value
    }

    init(integerLiteral value: Int) {
        self.value = Double(value)
    }

    init(floatLiteral value: Double) {
        self.value = value
    }

    static var zero: TestSpacing { TestSpacing(0) }

    static func + (lhs: TestSpacing, rhs: TestSpacing) -> TestSpacing {
        TestSpacing(lhs.value + rhs.value)
    }

    static func - (lhs: TestSpacing, rhs: TestSpacing) -> TestSpacing {
        TestSpacing(lhs.value - rhs.value)
    }

    static func < (lhs: TestSpacing, rhs: TestSpacing) -> Bool {
        lhs.value < rhs.value
    }
}
