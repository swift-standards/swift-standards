//
//  Tagged+Quantized Tests.swift
//  swift-standards
//
//  Tests for Tagged quantized arithmetic operators.
//

import Testing
import Dimension

// MARK: - Test Space

private enum TestSpace: Quantized {
    typealias Scalar = Double
    static var quantum: Double { 0.01 }
}

// MARK: - Type Aliases

private typealias QX = Tagged<Index.X.Coordinate<TestSpace>, Double>
private typealias QY = Tagged<Index.Y.Coordinate<TestSpace>, Double>
private typealias QDx = Tagged<Index.X.Displacement<TestSpace>, Double>
private typealias QDy = Tagged<Index.Y.Displacement<TestSpace>, Double>

// MARK: - Tests

@Suite
struct `Tagged+Quantized` {

    @Suite
    struct `init(quantized:quantum:)` {

        @Test
        func `quantizes value on init`() {
            let value = Tagged<TestSpace, Double>(quantized: 1.234, quantum: 0.01)
            #expect(value.rawValue == 1.23)
        }
    }

    @Suite
    struct `X Axis` {

        @Test
        func `coordinate + displacement`() {
            let x: QX = .init(100.0)
            let dx: QDx = .init(21.8)
            let result = x + dx
            #expect(result.rawValue == 121.8)
        }

        @Test
        func `coordinate + displacement accumulation`() {
            let x: QX = .init(84.0)
            let dx: QDx = .init(21.8)
            let row1 = x + dx
            let row2 = row1 + dx
            let row3 = row2 + dx

            #expect(row1.rawValue == 105.8)
            #expect(row2.rawValue == 127.6, "got \(row2.rawValue)")
            #expect(row3.rawValue == 149.4, "got \(row3.rawValue)")
        }

        @Test
        func `coordinate - coordinate`() {
            let x1: QX = .init(149.4)
            let x2: QX = .init(84.0)
            let dx: QDx = x1 - x2
            #expect(dx.rawValue == 65.4)
        }

        @Test
        func `coordinate - displacement`() {
            let x: QX = .init(149.4)
            let dx: QDx = .init(21.8)
            let result = x - dx
            #expect(result.rawValue == 127.6)
        }

        @Test
        func `displacement + displacement`() {
            let dx1: QDx = .init(21.8)
            let dx2: QDx = .init(21.8)
            let dx3: QDx = .init(21.8)
            let sum = dx1 + dx2 + dx3
            #expect(sum.rawValue == 65.4)
        }

        @Test
        func `displacement - displacement`() {
            let dx1: QDx = .init(65.4)
            let dx2: QDx = .init(21.8)
            let result = dx1 - dx2
            #expect(result.rawValue == 43.6)
        }
    }

    @Suite
    struct `Y Axis` {

        @Test
        func `coordinate + displacement`() {
            let y: QY = .init(100.0)
            let dy: QDy = .init(21.8)
            let result = y + dy
            #expect(result.rawValue == 121.8)
        }

        @Test
        func `coordinate - coordinate`() {
            let y1: QY = .init(149.4)
            let y2: QY = .init(84.0)
            let dy: QDy = y1 - y2
            #expect(dy.rawValue == 65.4)
        }

        @Test
        func `displacement + displacement`() {
            let dy1: QDy = .init(21.8)
            let dy2: QDy = .init(21.8)
            let dy3: QDy = .init(21.8)
            let sum = dy1 + dy2 + dy3
            #expect(sum.rawValue == 65.4)
        }
    }

    @Suite
    struct `Boundary Alignment` {

        @Test
        func `accumulated path equals direct path`() {
            let start: QY = .init(84.0)
            let step: QDy = .init(21.8)

            // Path 1: Add step by step
            let row1End = start + step
            let row2End = row1End + step
            let row3End = row2End + step

            // Path 2: Add total directly
            let total: QDy = .init(65.4)  // 3 * 21.8
            let spanEnd = start + total

            #expect(row3End.rawValue == spanEnd.rawValue,
                    "Accumulated: \(row3End.rawValue), Direct: \(spanEnd.rawValue)")
        }
    }
}
