// Corner Tests.swift

import StandardsTestSupport
import Testing

@testable import Region

@Suite("Corner - Opposite")
struct CornerOppositeTests {
    @Test(arguments: Region.Corner.allCases)
    func `opposite is involution`(corner: Region.Corner) {
        let opposite = Region.Corner.opposite(of: corner)
        let oppositeOpposite = Region.Corner.opposite(of: opposite)
        #expect(oppositeOpposite == corner)
    }

    @Test(arguments: Region.Corner.allCases)
    func `opposite and prefix operator are equivalent`(corner: Region.Corner) {
        let staticOpposite = Region.Corner.opposite(of: corner)
        let prefixOpposite = !corner
        #expect(staticOpposite == prefixOpposite)
    }

    @Test
    func oppositeMapping() {
        #expect(Region.Corner.topLeft.opposite == .bottomRight)
        #expect(Region.Corner.topRight.opposite == .bottomLeft)
        #expect(Region.Corner.bottomLeft.opposite == .topRight)
        #expect(Region.Corner.bottomRight.opposite == .topLeft)
    }
}

@Suite("Corner - Vertical Position")
struct CornerVerticalTests {
    @Test(arguments: Region.Corner.allCases)
    func `isTop property matches static function`(corner: Region.Corner) {
        let property = corner.isTop
        let function = Region.Corner.isTop(corner)
        #expect(property == function)
    }

    @Test(arguments: Region.Corner.allCases)
    func `isBottom property matches static function`(corner: Region.Corner) {
        let property = corner.isBottom
        let function = Region.Corner.isBottom(corner)
        #expect(property == function)
    }

    @Test
    func topCorners() {
        #expect(Region.Corner.topLeft.isTop == true)
        #expect(Region.Corner.topRight.isTop == true)
        #expect(Region.Corner.bottomLeft.isTop == false)
        #expect(Region.Corner.bottomRight.isTop == false)
    }

    @Test
    func bottomCorners() {
        #expect(Region.Corner.topLeft.isBottom == false)
        #expect(Region.Corner.topRight.isBottom == false)
        #expect(Region.Corner.bottomLeft.isBottom == true)
        #expect(Region.Corner.bottomRight.isBottom == true)
    }

    @Test(arguments: Region.Corner.allCases)
    func `isTop and isBottom are mutually exclusive`(corner: Region.Corner) {
        let isTop = corner.isTop
        let isBottom = corner.isBottom
        #expect(isTop != isBottom)
    }
}

@Suite("Corner - Horizontal Position")
struct CornerHorizontalTests {
    @Test(arguments: Region.Corner.allCases)
    func `isLeft property matches static function`(corner: Region.Corner) {
        let property = corner.isLeft
        let function = Region.Corner.isLeft(corner)
        #expect(property == function)
    }

    @Test(arguments: Region.Corner.allCases)
    func `isRight property matches static function`(corner: Region.Corner) {
        let property = corner.isRight
        let function = Region.Corner.isRight(corner)
        #expect(property == function)
    }

    @Test
    func leftCorners() {
        #expect(Region.Corner.topLeft.isLeft == true)
        #expect(Region.Corner.topRight.isLeft == false)
        #expect(Region.Corner.bottomLeft.isLeft == true)
        #expect(Region.Corner.bottomRight.isLeft == false)
    }

    @Test
    func rightCorners() {
        #expect(Region.Corner.topLeft.isRight == false)
        #expect(Region.Corner.topRight.isRight == true)
        #expect(Region.Corner.bottomLeft.isRight == false)
        #expect(Region.Corner.bottomRight.isRight == true)
    }

    @Test(arguments: Region.Corner.allCases)
    func `isLeft and isRight are mutually exclusive`(corner: Region.Corner) {
        let isLeft = corner.isLeft
        let isRight = corner.isRight
        #expect(isLeft != isRight)
    }
}

@Suite("Corner - Adjacent Corners")
struct CornerAdjacentTests {
    @Test(arguments: Region.Corner.allCases)
    func `horizontalAdjacent property matches static function`(corner: Region.Corner) {
        let property = corner.horizontalAdjacent
        let function = Region.Corner.horizontalAdjacent(of: corner)
        #expect(property == function)
    }

    @Test(arguments: Region.Corner.allCases)
    func `verticalAdjacent property matches static function`(corner: Region.Corner) {
        let property = corner.verticalAdjacent
        let function = Region.Corner.verticalAdjacent(of: corner)
        #expect(property == function)
    }

    @Test
    func horizontalAdjacentMapping() {
        #expect(Region.Corner.topLeft.horizontalAdjacent == .topRight)
        #expect(Region.Corner.topRight.horizontalAdjacent == .topLeft)
        #expect(Region.Corner.bottomLeft.horizontalAdjacent == .bottomRight)
        #expect(Region.Corner.bottomRight.horizontalAdjacent == .bottomLeft)
    }

    @Test
    func verticalAdjacentMapping() {
        #expect(Region.Corner.topLeft.verticalAdjacent == .bottomLeft)
        #expect(Region.Corner.topRight.verticalAdjacent == .bottomRight)
        #expect(Region.Corner.bottomLeft.verticalAdjacent == .topLeft)
        #expect(Region.Corner.bottomRight.verticalAdjacent == .topRight)
    }

    @Test(arguments: Region.Corner.allCases)
    func `horizontalAdjacent is involution`(corner: Region.Corner) {
        let adjacent = corner.horizontalAdjacent
        let adjacentAdjacent = adjacent.horizontalAdjacent
        #expect(adjacentAdjacent == corner)
    }

    @Test(arguments: Region.Corner.allCases)
    func `verticalAdjacent is involution`(corner: Region.Corner) {
        let adjacent = corner.verticalAdjacent
        let adjacentAdjacent = adjacent.verticalAdjacent
        #expect(adjacentAdjacent == corner)
    }
}
