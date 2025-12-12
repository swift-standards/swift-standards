// Dimension Tests.swift

import StandardsTestSupport
import Testing
@testable import Dimension

// MARK: - Index Phantom Types

@Suite
struct `Dimension - Index Phantom Types` {
    enum TestSpace {}

    @Test
    func `Index X Coordinate type exists`() {
        // Compile-time verification that phantom types are defined
        let _: Index.X.Coordinate<TestSpace>? = nil
        #expect(true)
    }

    @Test
    func `Index X Displacement type exists`() {
        let _: Index.X.Displacement<TestSpace>? = nil
        #expect(true)
    }

    @Test
    func `Index Y types exist`() {
        let _: Index.Y.Coordinate<TestSpace>? = nil
        let _: Index.Y.Displacement<TestSpace>? = nil
        #expect(true)
    }

    @Test
    func `Index Z types exist`() {
        let _: Index.Z.Coordinate<TestSpace>? = nil
        let _: Index.Z.Displacement<TestSpace>? = nil
        #expect(true)
    }

    @Test
    func `Index W types exist`() {
        let _: Index.W.Coordinate<TestSpace>? = nil
        let _: Index.W.Displacement<TestSpace>? = nil
        #expect(true)
    }

    @Test
    func `Index Magnitude type exists`() {
        let _: Index.Magnitude<TestSpace>? = nil
        #expect(true)
    }
}

// MARK: - Tagged Values with Index

@Suite
struct `Dimension - Tagged with Index` {
    enum TestSpace {}

    @Test
    func `Tagged with X Coordinate`() {
        let x: Tagged<Index.X.Coordinate<TestSpace>, Double> = Tagged(10.0)
        #expect(x.rawValue == 10.0)
    }

    @Test
    func `Tagged with Y Displacement`() {
        let dy: Tagged<Index.Y.Displacement<TestSpace>, Double> = Tagged(5.0)
        #expect(dy.rawValue == 5.0)
    }

    @Test
    func `Tagged with Magnitude`() {
        let mag: Tagged<Index.Magnitude<TestSpace>, Double> = Tagged(3.14)
        #expect(mag.rawValue == 3.14)
    }

    @Test
    func `Different spaces are different types`() {
        enum Space1 {}
        enum Space2 {}

        let x1: Tagged<Index.X.Coordinate<Space1>, Double> = Tagged(10.0)
        let x2: Tagged<Index.X.Coordinate<Space2>, Double> = Tagged(10.0)

        // These are different types - cannot compare directly
        // This is a compile-time safety feature
        #expect(x1.rawValue == x2.rawValue)
    }

    @Test
    func `Void space for generic geometry`() {
        let x: Tagged<Index.X.Coordinate<Void>, Double> = Tagged(10.0)
        let y: Tagged<Index.Y.Coordinate<Void>, Double> = Tagged(20.0)

        #expect(x.rawValue == 10.0)
        #expect(y.rawValue == 20.0)
    }
}
