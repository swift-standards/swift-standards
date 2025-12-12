// Edge Tests.swift

import StandardsTestSupport
import Testing

@testable import Region

@Suite
struct `Edge - Opposite` {
    @Test(arguments: Region.Edge.allCases)
    func `opposite is involution`(edge: Region.Edge) {
        let opposite = Region.Edge.opposite(of: edge)
        let oppositeOpposite = Region.Edge.opposite(of: opposite)
        #expect(oppositeOpposite == edge)
    }

    @Test(arguments: Region.Edge.allCases)
    func `opposite and prefix operator are equivalent`(edge: Region.Edge) {
        let staticOpposite = Region.Edge.opposite(of: edge)
        let prefixOpposite = !edge
        #expect(staticOpposite == prefixOpposite)
    }

    @Test
    func oppositeMapping() {
        #expect(Region.Edge.top.opposite == .bottom)
        #expect(Region.Edge.left.opposite == .right)
        #expect(Region.Edge.bottom.opposite == .top)
        #expect(Region.Edge.right.opposite == .left)
    }
}

@Suite
struct `Edge - Orientation` {
    @Test(arguments: Region.Edge.allCases)
    func `isHorizontal property matches static function`(edge: Region.Edge) {
        let property = edge.isHorizontal
        let function = Region.Edge.isHorizontal(edge)
        #expect(property == function)
    }

    @Test(arguments: Region.Edge.allCases)
    func `isVertical property matches static function`(edge: Region.Edge) {
        let property = edge.isVertical
        let function = Region.Edge.isVertical(edge)
        #expect(property == function)
    }

    @Test
    func horizontalEdges() {
        #expect(Region.Edge.top.isHorizontal == true)
        #expect(Region.Edge.left.isHorizontal == false)
        #expect(Region.Edge.bottom.isHorizontal == true)
        #expect(Region.Edge.right.isHorizontal == false)
    }

    @Test
    func verticalEdges() {
        #expect(Region.Edge.top.isVertical == false)
        #expect(Region.Edge.left.isVertical == true)
        #expect(Region.Edge.bottom.isVertical == false)
        #expect(Region.Edge.right.isVertical == true)
    }

    @Test(arguments: Region.Edge.allCases)
    func `horizontal and vertical are mutually exclusive`(edge: Region.Edge) {
        let isHorizontal = edge.isHorizontal
        let isVertical = edge.isVertical
        #expect(isHorizontal != isVertical)
    }
}

@Suite
struct `Edge - Adjacent Corners` {
    @Test
    func topCorners() {
        let corners = Region.Edge.corners(of: .top)
        #expect(corners.0 == .topLeft)
        #expect(corners.1 == .topRight)
    }

    @Test
    func leftCorners() {
        let corners = Region.Edge.corners(of: .left)
        #expect(corners.0 == .topLeft)
        #expect(corners.1 == .bottomLeft)
    }

    @Test
    func bottomCorners() {
        let corners = Region.Edge.corners(of: .bottom)
        #expect(corners.0 == .bottomLeft)
        #expect(corners.1 == .bottomRight)
    }

    @Test
    func rightCorners() {
        let corners = Region.Edge.corners(of: .right)
        #expect(corners.0 == .topRight)
        #expect(corners.1 == .bottomRight)
    }

    @Test(arguments: Region.Edge.allCases)
    func `corners property matches static function`(edge: Region.Edge) {
        let property = edge.corners
        let function = Region.Edge.corners(of: edge)
        #expect(property.0 == function.0)
        #expect(property.1 == function.1)
    }
}
