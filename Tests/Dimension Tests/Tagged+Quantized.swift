//
//  Tagged+Quantized Tests.swift
//  swift-standards
//
//  Tests for Tagged quantized arithmetic and tick-based equality.
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
    struct `Tick Representation` {

        @Test
        func `ticks property returns correct grid index`() {
            let x: QX = .init(1.234)
            #expect(x.ticks == 123)
        }

        @Test
        func `init from ticks creates correct value`() {
            let x = QX(ticks: 14940)
            #expect(x.ticks == 14940)
        }

        @Test
        func `same tick produces identical bits`() {
            let x1 = QX(ticks: 14940)
            let x2 = QX(ticks: 14940)
            #expect(x1.rawValue == x2.rawValue)
            #expect(x1.rawValue.bitPattern == x2.rawValue.bitPattern)
        }
    }

    @Suite
    struct `Tick Equality` {

        @Test
        func `equal ticks are equal`() {
            let x1: QX = .init(149.4)
            let x2: QX = .init(149.4000000001)  // Same tick after quantization
            #expect(x1 == x2)
            #expect(x1.ticks == x2.ticks)
        }

        @Test
        func `different ticks are not equal`() {
            let x1: QX = .init(149.4)
            let x2: QX = .init(149.5)
            #expect(x1 != x2)
        }
    }

    @Suite
    struct `X Axis` {

        @Test
        func `coordinate + displacement`() {
            let x: QX = .init(100.0)
            let dx: QDx = .init(21.8)
            let result = x + dx
            #expect(result.ticks == 12180)
        }

        @Test
        func `coordinate + displacement accumulation`() {
            let x: QX = .init(84.0)
            let dx: QDx = .init(21.8)
            let row1 = x + dx
            let row2 = row1 + dx
            let row3 = row2 + dx

            #expect(row1.ticks == 10580)
            #expect(row2.ticks == 12760)
            #expect(row3.ticks == 14940)
        }

        @Test
        func `coordinate - coordinate`() {
            let x1: QX = .init(149.4)
            let x2: QX = .init(84.0)
            let dx: QDx = x1 - x2
            #expect(dx.ticks == 6540)
        }

        @Test
        func `coordinate - displacement`() {
            let x: QX = .init(149.4)
            let dx: QDx = .init(21.8)
            let result = x - dx
            #expect(result.ticks == 12760)
        }

        @Test
        func `displacement + displacement`() {
            let dx1: QDx = .init(21.8)
            let dx2: QDx = .init(21.8)
            let dx3: QDx = .init(21.8)
            let sum = dx1 + dx2 + dx3
            #expect(sum.ticks == 6540)
        }

        @Test
        func `displacement - displacement`() {
            let dx1: QDx = .init(65.4)
            let dx2: QDx = .init(21.8)
            let result = dx1 - dx2
            #expect(result.ticks == 4360)
        }
    }

    @Suite
    struct `Y Axis` {

        @Test
        func `coordinate + displacement`() {
            let y: QY = .init(100.0)
            let dy: QDy = .init(21.8)
            let result = y + dy
            #expect(result.ticks == 12180)
        }

        @Test
        func `coordinate - coordinate`() {
            let y1: QY = .init(149.4)
            let y2: QY = .init(84.0)
            let dy: QDy = y1 - y2
            #expect(dy.ticks == 6540)
        }

        @Test
        func `displacement + displacement`() {
            let dy1: QDy = .init(21.8)
            let dy2: QDy = .init(21.8)
            let dy3: QDy = .init(21.8)
            let sum = dy1 + dy2 + dy3
            #expect(sum.ticks == 6540)
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

            // Both should be tick 14940
            #expect(row3End == spanEnd)
            #expect(row3End.ticks == spanEnd.ticks)
            #expect(row3End.ticks == 14940)
        }

        @Test
        func `different computation paths produce same bits`() {
            let start: QY = .init(84.0)
            let step: QDy = .init(21.8)
            let total: QDy = .init(65.4)

            let accumulated = start + step + step + step
            let direct = start + total

            // Same tick means identical IEEE 754 bits
            #expect(accumulated.rawValue.bitPattern == direct.rawValue.bitPattern)
        }
    }
}
