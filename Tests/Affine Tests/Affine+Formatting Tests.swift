// Affine+Formatting Tests.swift
// Tests for Affine+Formatting.swift

import Testing

@testable import Affine

@Suite("Affine+Formatting Tests")
struct AffineFormattingTests {
    typealias X = Affine<Double, Void>.X
    typealias Y = Affine<Double, Void>.Y
    typealias Z = Affine<Double, Void>.Z

    // MARK: - Coordinate Formatting Tests

    @Suite("Coordinate Formatting")
    struct CoordinateFormattingTests {
        @Test("X coordinate has value")
        func xValue() {
            let x = X(3.14159)
            #expect(x.value == 3.14159)
        }

        @Test("Y coordinate has value")
        func yValue() {
            let y = Y(2.71828)
            #expect(y.value == 2.71828)
        }

        @Test("Z coordinate has value")
        func zValue() {
            let z = Z(1.41421)
            #expect(z.value == 1.41421)
        }

        @Test("Integer coordinate has value")
        func integerValue() {
            let x = Affine<Int, Void>.X(42)
            #expect(x.value == 42)
        }

        @Test("Zero coordinate")
        func zeroValue() {
            let x = X.zero
            #expect(x.value == 0)
        }

        @Test("Negative coordinate")
        func negativeValue() {
            let x = X(-5.5)
            #expect(x.value == -5.5)
        }
    }
}
