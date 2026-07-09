//
//  Geometry+Quantized Tests.swift
//  swift-standards
//
//  Geometry integration tests for quantized spaces.
//  Verifies that Rectangle and other shapes work correctly with tick-based quantization.
//

import Dimension
import Geometry
import Testing

// MARK: - Test Space

private enum TestSpace: Quantized {
}

extension TestSpace {
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

            #expect(rect.llx.ticks == 8400)
            #expect(rect.urx.ticks == 14940)
            #expect(rect.lly.ticks == 10000)
            #expect(rect.ury.ticks == 14360)
        }

        @Test
        func `adjacent rectangles align exactly`() {
            let startY: QGeometry.Y = .init(84.0)
            let rowHeight: QGeometry.Height = .init(21.8)

            let row1 = QGeometry.Rectangle(
                x: .init(0),
                y: startY,
                width: .init(100),
                height: rowHeight
            )
            let row2 = QGeometry.Rectangle(
                x: .init(0),
                y: row1.ury,
                width: .init(100),
                height: rowHeight
            )
            let row3 = QGeometry.Rectangle(
                x: .init(0),
                y: row2.ury,
                width: .init(100),
                height: rowHeight
            )

            let spanHeight: QGeometry.Height = .init(65.4)
            let span = QGeometry.Rectangle(
                x: .init(0),
                y: startY,
                width: .init(100),
                height: spanHeight
            )

            // Tick-based equality: accumulated and direct computation match
            #expect(row3.ury == span.ury)
            #expect(row3.ury.ticks == span.ury.ticks)
        }

        @Test
        func `accumulated row heights match span`() {
            let startY: QGeometry.Y = .init(84.0)
            let rowHeight: QGeometry.Height = .init(21.8)

            // Build three rows
            let row1 = QGeometry.Rectangle(
                x: .init(0),
                y: startY,
                width: .init(100),
                height: rowHeight
            )
            let row2 = QGeometry.Rectangle(
                x: .init(0),
                y: row1.ury,
                width: .init(100),
                height: rowHeight
            )
            let row3 = QGeometry.Rectangle(
                x: .init(0),
                y: row2.ury,
                width: .init(100),
                height: rowHeight
            )

            // Check each row's upper y coordinate
            #expect(row1.ury.ticks == 10580)  // 84.0 + 21.8 = 105.8
            #expect(row2.ury.ticks == 12760)  // 105.8 + 21.8 = 127.6
            #expect(row3.ury.ticks == 14940)  // 127.6 + 21.8 = 149.4

            // Span should match
            let spanHeight: QGeometry.Height = .init(65.4)
            let span = QGeometry.Rectangle(
                x: .init(0),
                y: startY,
                width: .init(100),
                height: spanHeight
            )
            #expect(span.ury.ticks == 14940)  // 84.0 + 65.4 = 149.4
        }
    }
}
