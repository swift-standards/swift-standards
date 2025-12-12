// Affine+Formatting Tests.swift
// Tests for Affine+Formatting.swift

import Testing

@testable import Affine

@Suite
struct `Affine+Formatting Tests` {
    typealias X = Affine<Double, Void>.X
    typealias Y = Affine<Double, Void>.Y
    typealias Z = Affine<Double, Void>.Z

    // MARK: - Coordinate Formatting Tests

    @Suite
    struct `Coordinate Formatting` {
        @Test
        func `X coordinate has value`() {
            let x = X(3.14159)
            #expect(x.value == 3.14159)
        }

        @Test
        func `Y coordinate has value`() {
            let y = Y(2.71828)
            #expect(y.value == 2.71828)
        }

        @Test
        func `Z coordinate has value`() {
            let z = Z(1.41421)
            #expect(z.value == 1.41421)
        }

        @Test
        func `Integer coordinate has value`() {
            let x = Affine<Int, Void>.X(42)
            #expect(x.value == 42)
        }

        @Test
        func `Zero coordinate`() {
            let x = X.zero
            #expect(x.value == 0)
        }

        @Test
        func `Negative coordinate`() {
            let x = X(-5.5)
            #expect(x.value == -5.5)
        }
    }
}
