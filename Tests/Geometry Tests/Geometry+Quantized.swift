//
//  Geometry+Quantized Tests.swift
//  swift-standards
//
//  Minimal Geometry integration tests for quantized spaces.
//  Core quantization tests are in Dimension Tests.
//

import Testing
import Geometry
import Dimension

// MARK: - Test Space

private enum TestSpace: Quantized {
    typealias Scalar = Double
    static var quantum: Double { 0.01 }
}

private typealias QGeometry = Geometry<Double, TestSpace>

// MARK: - Tests

@Suite
struct `Geometry+Quantized` {

    @Suite
    struct `Rectangle` {

        @Test
        func `computed corners are quantized`() {
            let rect = QGeometry.Rectangle(
                x: .init(84.0),
                y: .init(100.0),
                width: .init(65.4),
                height: .init(43.6)
            )

            #expect(rect.llx.value == 84.0)
            #expect(rect.urx.value == 149.4)
            #expect(rect.lly.value == 100.0)
            #expect(rect.ury.value == 143.6)
        }

        @Test
        func `adjacent rectangles align exactly`() {
            let startY: QGeometry.Y = .init(84.0)
            let rowHeight: QGeometry.Height = .init(21.8)

            let row1 = QGeometry.Rectangle(x: .init(0), y: startY, width: .init(100), height: rowHeight)
            let row2 = QGeometry.Rectangle(x: .init(0), y: row1.ury, width: .init(100), height: rowHeight)
            let row3 = QGeometry.Rectangle(x: .init(0), y: row2.ury, width: .init(100), height: rowHeight)

            let spanHeight: QGeometry.Height = .init(65.4)
            let span = QGeometry.Rectangle(x: .init(0), y: startY, width: .init(100), height: spanHeight)

            #expect(row3.ury.value == span.ury.value)
        }
    }
}
