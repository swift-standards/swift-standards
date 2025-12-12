// Quadrant Tests.swift

import StandardsTestSupport
import Testing

@testable import Region

@Suite("Quadrant - Rotation")
struct QuadrantRotationTests {
    @Test(arguments: Region.Quadrant.allCases)
    func `next is cyclic`(quadrant: Region.Quadrant) {
        let next = Region.Quadrant.next(of: quadrant)
        let nextNext = Region.Quadrant.next(of: next)
        let nextNextNext = Region.Quadrant.next(of: nextNext)
        let nextNextNextNext = Region.Quadrant.next(of: nextNextNext)
        #expect(nextNextNextNext == quadrant)
    }

    @Test(arguments: Region.Quadrant.allCases)
    func `previous is cyclic`(quadrant: Region.Quadrant) {
        let prev = Region.Quadrant.previous(of: quadrant)
        let prevPrev = Region.Quadrant.previous(of: prev)
        let prevPrevPrev = Region.Quadrant.previous(of: prevPrev)
        let prevPrevPrevPrev = Region.Quadrant.previous(of: prevPrevPrev)
        #expect(prevPrevPrevPrev == quadrant)
    }

    @Test(arguments: Region.Quadrant.allCases)
    func `opposite is involution`(quadrant: Region.Quadrant) {
        let opposite = Region.Quadrant.opposite(of: quadrant)
        let oppositeOpposite = Region.Quadrant.opposite(of: opposite)
        #expect(oppositeOpposite == quadrant)
    }

    @Test(arguments: Region.Quadrant.allCases)
    func `opposite and prefix operator are equivalent`(quadrant: Region.Quadrant) {
        let staticOpposite = Region.Quadrant.opposite(of: quadrant)
        let prefixOpposite = !quadrant
        #expect(staticOpposite == prefixOpposite)
    }

    @Test
    func nextSequence() {
        #expect(Region.Quadrant.I.next == .II)
        #expect(Region.Quadrant.II.next == .III)
        #expect(Region.Quadrant.III.next == .IV)
        #expect(Region.Quadrant.IV.next == .I)
    }

    @Test
    func previousSequence() {
        #expect(Region.Quadrant.I.previous == .IV)
        #expect(Region.Quadrant.II.previous == .I)
        #expect(Region.Quadrant.III.previous == .II)
        #expect(Region.Quadrant.IV.previous == .III)
    }

    @Test
    func oppositeMapping() {
        #expect(Region.Quadrant.I.opposite == .III)
        #expect(Region.Quadrant.II.opposite == .IV)
        #expect(Region.Quadrant.III.opposite == .I)
        #expect(Region.Quadrant.IV.opposite == .II)
    }
}

@Suite("Quadrant - Sign Properties")
struct QuadrantSignTests {
    @Test(arguments: Region.Quadrant.allCases)
    func `hasPositiveX property matches static function`(quadrant: Region.Quadrant) {
        let property = quadrant.hasPositiveX
        let function = Region.Quadrant.hasPositiveX(quadrant)
        #expect(property == function)
    }

    @Test(arguments: Region.Quadrant.allCases)
    func `hasPositiveY property matches static function`(quadrant: Region.Quadrant) {
        let property = quadrant.hasPositiveY
        let function = Region.Quadrant.hasPositiveY(quadrant)
        #expect(property == function)
    }

    @Test
    func positiveXQuadrants() {
        #expect(Region.Quadrant.I.hasPositiveX == true)
        #expect(Region.Quadrant.II.hasPositiveX == false)
        #expect(Region.Quadrant.III.hasPositiveX == false)
        #expect(Region.Quadrant.IV.hasPositiveX == true)
    }

    @Test
    func positiveYQuadrants() {
        #expect(Region.Quadrant.I.hasPositiveY == true)
        #expect(Region.Quadrant.II.hasPositiveY == true)
        #expect(Region.Quadrant.III.hasPositiveY == false)
        #expect(Region.Quadrant.IV.hasPositiveY == false)
    }
}
