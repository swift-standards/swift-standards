// Corner Tests.swift

import Testing

@testable import Dimension
@testable import Layout

@Suite
struct `Corner Tests` {
    @Test(arguments: Corner.allCases)
    func presets(corner: Corner) {
        // Test that each corner has the correct components
        if corner == .topLeading {
            #expect(corner.horizontal == .leading)
            #expect(corner.vertical == .top)
        } else if corner == .topTrailing {
            #expect(corner.horizontal == .trailing)
            #expect(corner.vertical == .top)
        } else if corner == .bottomLeading {
            #expect(corner.horizontal == .leading)
            #expect(corner.vertical == .bottom)
        } else if corner == .bottomTrailing {
            #expect(corner.horizontal == .trailing)
            #expect(corner.vertical == .bottom)
        }
    }

    @Test(arguments: Corner.allCases)
    func opposite(corner: Corner) {
        let result = Corner.opposite(corner)
        #expect(result == corner.opposite)
        #expect(result == !corner)
        #expect(result.opposite == corner)
    }

    @Test(arguments: Corner.allCases)
    func isTop(corner: Corner) {
        let result = Corner.isTop(corner)
        #expect(result == corner.isTop)
        #expect(result == (corner.vertical == .top))
    }

    @Test(arguments: Corner.allCases)
    func isBottom(corner: Corner) {
        let result = Corner.isBottom(corner)
        #expect(result == corner.isBottom)
        #expect(result == (corner.vertical == .bottom))
    }

    @Test(arguments: Corner.allCases)
    func isLeading(corner: Corner) {
        let result = Corner.isLeading(corner)
        #expect(result == corner.isLeading)
        #expect(result == (corner.horizontal == .leading))
    }

    @Test(arguments: Corner.allCases)
    func isTrailing(corner: Corner) {
        let result = Corner.isTrailing(corner)
        #expect(result == corner.isTrailing)
        #expect(result == (corner.horizontal == .trailing))
    }

    @Test(arguments: Corner.allCases)
    func horizontalAdjacent(corner: Corner) {
        let result = Corner.horizontalAdjacent(corner)
        #expect(result == corner.horizontalAdjacent)
        #expect(result.vertical == corner.vertical)
        #expect(result.horizontal != corner.horizontal)
    }

    @Test(arguments: Corner.allCases)
    func verticalAdjacent(corner: Corner) {
        let result = Corner.verticalAdjacent(corner)
        #expect(result == corner.verticalAdjacent)
        #expect(result.horizontal == corner.horizontal)
        #expect(result.vertical != corner.vertical)
    }
}

@Suite
struct `Horizontal.Alignment.Side` {
    @Test(arguments: Horizontal.Alignment.Side.allCases)
    func opposite(side: Horizontal.Alignment.Side) {
        let result = Horizontal.Alignment.Side.opposite(side)
        #expect(result == side.opposite)
        #expect(result.opposite == side)
    }
}

@Suite
struct `Vertical.Alignment.Side` {
    @Test(arguments: Vertical.Alignment.Side.allCases)
    func opposite(side: Vertical.Alignment.Side) {
        let result = Vertical.Alignment.Side.opposite(side)
        #expect(result == side.opposite)
        #expect(result.opposite == side)
    }
}
