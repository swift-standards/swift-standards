//
//  Quantized Tests.swift
//  swift-standards
//
//  Tests for the Quantized protocol.
//

import Testing
import Dimension

// MARK: - Test Space

enum TestQuantizedSpace: Quantized {
    typealias Scalar = Double
    static var quantum: Double { 0.01 }
}

// MARK: - Tests

@Suite
struct `Quantized Tests` {

    @Suite
    struct `Quantize Tests` {

        @Test
        func `rounds down below midpoint`() {
            #expect(TestQuantizedSpace.quantize(1.234) == 1.23)
            #expect(TestQuantizedSpace.quantize(0.001) == 0.00)
        }

        @Test
        func `rounds up at midpoint`() {
            #expect(TestQuantizedSpace.quantize(1.235) == 1.24)
            #expect(TestQuantizedSpace.quantize(0.005) == 0.01)
        }

        @Test
        func `rounds up above midpoint`() {
            #expect(TestQuantizedSpace.quantize(1.236) == 1.24)
            #expect(TestQuantizedSpace.quantize(0.009) == 0.01)
        }
    }

    @Suite
    struct `quantum(as:)` {

        @Test
        func `converts to Double`() {
            let q: Double = TestQuantizedSpace.quantum(as: Double.self)
            #expect(q == 0.01)
        }

        @Test
        func `converts to Float`() {
            let q: Float = TestQuantizedSpace.quantum(as: Float.self)
            #expect(q == 0.01)
        }
    }
}
