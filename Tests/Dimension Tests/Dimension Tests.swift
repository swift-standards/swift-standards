// Dimension Tests.swift

import StandardsTestSupport
import Testing
@_spi(Internal) @testable import Dimension

// MARK: - Dimension Phantom Types

@Suite
struct `Dimension - Phantom Types` {
    enum TestSpace {}

    @Test
    func `Coordinate X type exists`() {
        // Compile-time verification that phantom types are defined
        let _: Coordinate.X<TestSpace>? = nil
        #expect(true)
    }

    @Test
    func `Displacement X type exists`() {
        let _: Displacement.X<TestSpace>? = nil
        #expect(true)
    }

    @Test
    func `Y types exist`() {
        let _: Coordinate.Y<TestSpace>? = nil
        let _: Displacement.Y<TestSpace>? = nil
        #expect(true)
    }

    @Test
    func `Z types exist`() {
        let _: Coordinate.Z<TestSpace>? = nil
        let _: Displacement.Z<TestSpace>? = nil
        #expect(true)
    }

    @Test
    func `W types exist`() {
        let _: Coordinate.W<TestSpace>? = nil
        let _: Displacement.W<TestSpace>? = nil
        #expect(true)
    }

    @Test
    func `Magnitude type exists`() {
        let _: Magnitude<TestSpace>? = nil
        #expect(true)
    }
}

// MARK: - Tagged Values with Dimension Types

@Suite
struct `Dimension - Tagged Values` {
    enum TestSpace {}

    @Test
    func `Tagged with X Coordinate`() {
        let x: Coordinate.X<TestSpace>.Value<Double> = Tagged(10.0)
        #expect(x.rawValue == 10.0)
    }

    @Test
    func `Tagged with Y Displacement`() {
        let dy: Displacement.Y<TestSpace>.Value<Double> = Tagged(5.0)
        #expect(dy.rawValue == 5.0)
    }

    @Test
    func `Tagged with Magnitude`() {
        let mag: Magnitude<TestSpace>.Value<Double> = Tagged(3.14)
        #expect(mag.rawValue == 3.14)
    }

    @Test
    func `Different spaces are different types`() {
        enum Space1 {}
        enum Space2 {}

        let x1: Coordinate.X<Space1>.Value<Double> = Tagged(10.0)
        let x2: Coordinate.X<Space2>.Value<Double> = Tagged(10.0)

        // These are different types - cannot compare directly
        // This is a compile-time safety feature
        #expect(x1.rawValue == x2.rawValue)
    }

    @Test
    func `Void space for generic geometry`() {
        let x: Coordinate.X<Void>.Value<Double> = Tagged(10.0)
        let y: Coordinate.Y<Void>.Value<Double> = Tagged(20.0)

        #expect(x.rawValue == 10.0)
        #expect(y.rawValue == 20.0)
    }
}
