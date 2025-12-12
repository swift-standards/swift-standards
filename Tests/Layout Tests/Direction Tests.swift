// Direction Tests.swift

import Testing

@testable import Layout

@Suite
struct `Direction Tests` {
    @Test(arguments: Direction.allCases)
    func cases(direction: Direction) {
        // Verify each case is distinct
        #expect(Direction.allCases.contains(direction))
    }

    @Test
    func `Direction CaseIterable`() {
        #expect(Direction.allCases.count == 2)
        #expect(Direction.allCases.contains(.leftToRight))
        #expect(Direction.allCases.contains(.rightToLeft))
    }

    @Test
    func `Direction aliases`() {
        #expect(Direction.ltr == .leftToRight)
        #expect(Direction.rtl == .rightToLeft)
    }

    @Test(arguments: Direction.allCases)
    func opposite(direction: Direction) {
        let result = Direction.opposite(direction)
        #expect(result == direction.opposite)
        #expect(result.opposite == direction)
    }
}
