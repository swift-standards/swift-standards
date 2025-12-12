// Sextant Tests.swift

import StandardsTestSupport
import Testing

@testable import Region

@Suite("Sextant - Rotation")
struct SextantRotationTests {
    @Test(arguments: Region.Sextant.allCases)
    func `next is cyclic`(sextant: Region.Sextant) {
        var current = sextant
        for _ in 0..<6 {
            current = Region.Sextant.next(of: current)
        }
        #expect(current == sextant)
    }

    @Test(arguments: Region.Sextant.allCases)
    func `previous is cyclic`(sextant: Region.Sextant) {
        var current = sextant
        for _ in 0..<6 {
            current = Region.Sextant.previous(of: current)
        }
        #expect(current == sextant)
    }

    @Test(arguments: Region.Sextant.allCases)
    func `opposite is involution`(sextant: Region.Sextant) {
        let opposite = Region.Sextant.opposite(of: sextant)
        let oppositeOpposite = Region.Sextant.opposite(of: opposite)
        #expect(oppositeOpposite == sextant)
    }

    @Test(arguments: Region.Sextant.allCases)
    func `opposite and prefix operator are equivalent`(sextant: Region.Sextant) {
        let staticOpposite = Region.Sextant.opposite(of: sextant)
        let prefixOpposite = !sextant
        #expect(staticOpposite == prefixOpposite)
    }

    @Test
    func nextSequence() {
        #expect(Region.Sextant.I.next == .II)
        #expect(Region.Sextant.II.next == .III)
        #expect(Region.Sextant.III.next == .IV)
        #expect(Region.Sextant.IV.next == .V)
        #expect(Region.Sextant.V.next == .VI)
        #expect(Region.Sextant.VI.next == .I)
    }

    @Test
    func previousSequence() {
        #expect(Region.Sextant.I.previous == .VI)
        #expect(Region.Sextant.II.previous == .I)
        #expect(Region.Sextant.III.previous == .II)
        #expect(Region.Sextant.IV.previous == .III)
        #expect(Region.Sextant.V.previous == .IV)
        #expect(Region.Sextant.VI.previous == .V)
    }

    @Test
    func oppositeMapping() {
        #expect(Region.Sextant.I.opposite == .IV)
        #expect(Region.Sextant.II.opposite == .V)
        #expect(Region.Sextant.III.opposite == .VI)
        #expect(Region.Sextant.IV.opposite == .I)
        #expect(Region.Sextant.V.opposite == .II)
        #expect(Region.Sextant.VI.opposite == .III)
    }
}

@Suite("Sextant - Quadrant")
struct SextantQuadrantTests {
    @Test(arguments: Region.Sextant.allCases)
    func `quadrant property matches static function`(sextant: Region.Sextant) {
        let property = sextant.quadrant
        let function = Region.Sextant.quadrant(of: sextant)
        #expect(property == function)
    }

    @Test
    func quadrantMapping() {
        // Quadrant I: I, II
        #expect(Region.Sextant.I.quadrant == .I)
        #expect(Region.Sextant.II.quadrant == .I)

        // Quadrant II: III
        #expect(Region.Sextant.III.quadrant == .II)

        // Quadrant III: IV
        #expect(Region.Sextant.IV.quadrant == .III)

        // Quadrant IV: V, VI
        #expect(Region.Sextant.V.quadrant == .IV)
        #expect(Region.Sextant.VI.quadrant == .IV)
    }
}

@Suite("Sextant - Half-Plane Properties")
struct SextantHalfPlaneTests {
    @Test(arguments: Region.Sextant.allCases)
    func `isUpperHalf property matches static function`(sextant: Region.Sextant) {
        let property = sextant.isUpperHalf
        let function = Region.Sextant.isUpperHalf(sextant)
        #expect(property == function)
    }

    @Test(arguments: Region.Sextant.allCases)
    func `isRightHalf property matches static function`(sextant: Region.Sextant) {
        let property = sextant.isRightHalf
        let function = Region.Sextant.isRightHalf(sextant)
        #expect(property == function)
    }

    @Test
    func upperHalfPositions() {
        #expect(Region.Sextant.I.isUpperHalf == true)
        #expect(Region.Sextant.II.isUpperHalf == true)
        #expect(Region.Sextant.III.isUpperHalf == true)
        #expect(Region.Sextant.IV.isUpperHalf == false)
        #expect(Region.Sextant.V.isUpperHalf == false)
        #expect(Region.Sextant.VI.isUpperHalf == false)
    }

    @Test
    func rightHalfPositions() {
        #expect(Region.Sextant.I.isRightHalf == true)
        #expect(Region.Sextant.II.isRightHalf == true)
        #expect(Region.Sextant.III.isRightHalf == false)
        #expect(Region.Sextant.IV.isRightHalf == false)
        #expect(Region.Sextant.V.isRightHalf == false)
        #expect(Region.Sextant.VI.isRightHalf == true)
    }
}
