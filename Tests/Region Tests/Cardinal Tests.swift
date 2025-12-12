// Cardinal Tests.swift

import StandardsTestSupport
import Testing

@testable import Region

@Suite
struct `Cardinal - Rotation` {
    @Test(arguments: Region.Cardinal.allCases)
    func `clockwise is cyclic`(direction: Region.Cardinal) {
        let cw = Region.Cardinal.clockwise(of: direction)
        let cwcw = Region.Cardinal.clockwise(of: cw)
        let cwcwcw = Region.Cardinal.clockwise(of: cwcw)
        let cwcwcwcw = Region.Cardinal.clockwise(of: cwcwcw)
        #expect(cwcwcwcw == direction)
    }

    @Test(arguments: Region.Cardinal.allCases)
    func `counterclockwise is cyclic`(direction: Region.Cardinal) {
        let ccw = Region.Cardinal.counterclockwise(of: direction)
        let ccwccw = Region.Cardinal.counterclockwise(of: ccw)
        let ccwccwccw = Region.Cardinal.counterclockwise(of: ccwccw)
        let ccwccwccwccw = Region.Cardinal.counterclockwise(of: ccwccwccw)
        #expect(ccwccwccwccw == direction)
    }

    @Test(arguments: Region.Cardinal.allCases)
    func `opposite is involution`(direction: Region.Cardinal) {
        let opposite = Region.Cardinal.opposite(of: direction)
        let oppositeOpposite = Region.Cardinal.opposite(of: opposite)
        #expect(oppositeOpposite == direction)
    }

    @Test(arguments: Region.Cardinal.allCases)
    func `opposite and prefix operator are equivalent`(direction: Region.Cardinal) {
        let staticOpposite = Region.Cardinal.opposite(of: direction)
        let prefixOpposite = !direction
        #expect(staticOpposite == prefixOpposite)
    }

    @Test
    func clockwiseSequence() {
        #expect(Region.Cardinal.north.clockwise == .east)
        #expect(Region.Cardinal.east.clockwise == .south)
        #expect(Region.Cardinal.south.clockwise == .west)
        #expect(Region.Cardinal.west.clockwise == .north)
    }

    @Test
    func counterclockwiseSequence() {
        #expect(Region.Cardinal.north.counterclockwise == .west)
        #expect(Region.Cardinal.east.counterclockwise == .north)
        #expect(Region.Cardinal.south.counterclockwise == .east)
        #expect(Region.Cardinal.west.counterclockwise == .south)
    }

    @Test
    func oppositeMapping() {
        #expect(Region.Cardinal.north.opposite == .south)
        #expect(Region.Cardinal.east.opposite == .west)
        #expect(Region.Cardinal.south.opposite == .north)
        #expect(Region.Cardinal.west.opposite == .east)
    }
}

@Suite
struct `Cardinal - Axis Properties` {
    @Test(arguments: Region.Cardinal.allCases)
    func `isHorizontal property matches static function`(direction: Region.Cardinal) {
        let property = direction.isHorizontal
        let function = Region.Cardinal.isHorizontal(direction)
        #expect(property == function)
    }

    @Test(arguments: Region.Cardinal.allCases)
    func `isVertical property matches static function`(direction: Region.Cardinal) {
        let property = direction.isVertical
        let function = Region.Cardinal.isVertical(direction)
        #expect(property == function)
    }

    @Test
    func horizontalDirections() {
        #expect(Region.Cardinal.north.isHorizontal == false)
        #expect(Region.Cardinal.east.isHorizontal == true)
        #expect(Region.Cardinal.south.isHorizontal == false)
        #expect(Region.Cardinal.west.isHorizontal == true)
    }

    @Test
    func verticalDirections() {
        #expect(Region.Cardinal.north.isVertical == true)
        #expect(Region.Cardinal.east.isVertical == false)
        #expect(Region.Cardinal.south.isVertical == true)
        #expect(Region.Cardinal.west.isVertical == false)
    }

    @Test(arguments: Region.Cardinal.allCases)
    func `horizontal and vertical are mutually exclusive`(direction: Region.Cardinal) {
        let isHorizontal = direction.isHorizontal
        let isVertical = direction.isVertical
        #expect(isHorizontal != isVertical)
    }
}
