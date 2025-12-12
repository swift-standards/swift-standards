// Direction Tests.swift

import Testing

@testable import Layout

@Suite("Direction")
struct DirectionTests {
    @Test("Direction cases", arguments: Direction.allCases)
    func cases(direction: Direction) {
        // Verify each case is distinct
        #expect(Direction.allCases.contains(direction))
    }

    @Test("Direction CaseIterable")
    func caseIterable() {
        #expect(Direction.allCases.count == 2)
        #expect(Direction.allCases.contains(.leftToRight))
        #expect(Direction.allCases.contains(.rightToLeft))
    }

    @Test("Direction aliases")
    func aliases() {
        #expect(Direction.ltr == .leftToRight)
        #expect(Direction.rtl == .rightToLeft)
    }

    @Test("Direction opposite", arguments: Direction.allCases)
    func opposite(direction: Direction) {
        let result = Direction.opposite(direction)
        #expect(result == direction.opposite)
        #expect(result.opposite == direction)
    }
}
