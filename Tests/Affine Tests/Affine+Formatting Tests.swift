//// Affine+Formatting Tests.swift
//// Tests for Affine+Formatting.swift
//
// import Testing
//
// @testable import Affine
//
// @Suite
// struct `Affine+Formatting Tests` {
//    typealias X = Affine<Double, Void>.X
//    typealias Y = Affine<Double, Void>.Y
//    typealias Z = Affine<Double, Void>.Z
//
//    // MARK: - Coordinate Formatting Tests
//
//    @Suite
//    struct `Coordinate Formatting` {
//        @Test
//        func `X coordinate has value`() {
//            let x = X(3.14159)
//            #expect(x == 3.14159)
//        }
//
//        @Test
//        func `Y coordinate has value`() {
//            let y = Y(2.71828)
//            #expect(y == 2.71828)
//        }
//
//        @Test
//        func `Z coordinate has value`() {
//            let z = Z(1.41421)
//            #expect(z == 1.41421)
//        }
//
//        @Test
//        func `Integer coordinate has value`() {
//            let x = Affine<Int, Void>.X(42)
//            #expect(x == 42)
//        }
//
//        @Test
//        func `Zero coordinate`() {
//            let x = X.zero
//            #expect(x == 0)
//        }
//
//        @Test
//        func `Negative coordinate`() {
//            let x = X(-5.5)
//            #expect(x == -5.5)
//        }
//    }
// }
