// Octant Tests.swift

import StandardsTestSupport
import Testing

@testable import Region

@Suite("Octant - Opposite")
struct OctantOppositeTests {
    @Test(arguments: Region.Octant.allCases)
    func `opposite is involution`(octant: Region.Octant) {
        let opposite = Region.Octant.opposite(of: octant)
        let oppositeOpposite = Region.Octant.opposite(of: opposite)
        #expect(oppositeOpposite == octant)
    }

    @Test(arguments: Region.Octant.allCases)
    func `opposite and prefix operator are equivalent`(octant: Region.Octant) {
        let staticOpposite = Region.Octant.opposite(of: octant)
        let prefixOpposite = !octant
        #expect(staticOpposite == prefixOpposite)
    }

    @Test
    func oppositeMapping() {
        #expect(Region.Octant.ppp.opposite == .nnn)
        #expect(Region.Octant.ppn.opposite == .nnp)
        #expect(Region.Octant.pnp.opposite == .npn)
        #expect(Region.Octant.pnn.opposite == .npp)
        #expect(Region.Octant.npp.opposite == .pnn)
        #expect(Region.Octant.npn.opposite == .pnp)
        #expect(Region.Octant.nnp.opposite == .ppn)
        #expect(Region.Octant.nnn.opposite == .ppp)
    }
}

@Suite("Octant - X Sign Property")
struct OctantXSignTests {
    @Test(arguments: Region.Octant.allCases)
    func `hasPositiveX property matches static function`(octant: Region.Octant) {
        let property = octant.hasPositiveX
        let function = Region.Octant.hasPositiveX(octant)
        #expect(property == function)
    }

    @Test
    func positiveXOctants() {
        #expect(Region.Octant.ppp.hasPositiveX == true)
        #expect(Region.Octant.ppn.hasPositiveX == true)
        #expect(Region.Octant.pnp.hasPositiveX == true)
        #expect(Region.Octant.pnn.hasPositiveX == true)
        #expect(Region.Octant.npp.hasPositiveX == false)
        #expect(Region.Octant.npn.hasPositiveX == false)
        #expect(Region.Octant.nnp.hasPositiveX == false)
        #expect(Region.Octant.nnn.hasPositiveX == false)
    }
}

@Suite("Octant - Y Sign Property")
struct OctantYSignTests {
    @Test(arguments: Region.Octant.allCases)
    func `hasPositiveY property matches static function`(octant: Region.Octant) {
        let property = octant.hasPositiveY
        let function = Region.Octant.hasPositiveY(octant)
        #expect(property == function)
    }

    @Test
    func positiveYOctants() {
        #expect(Region.Octant.ppp.hasPositiveY == true)
        #expect(Region.Octant.ppn.hasPositiveY == true)
        #expect(Region.Octant.pnp.hasPositiveY == false)
        #expect(Region.Octant.pnn.hasPositiveY == false)
        #expect(Region.Octant.npp.hasPositiveY == true)
        #expect(Region.Octant.npn.hasPositiveY == true)
        #expect(Region.Octant.nnp.hasPositiveY == false)
        #expect(Region.Octant.nnn.hasPositiveY == false)
    }
}

@Suite("Octant - Z Sign Property")
struct OctantZSignTests {
    @Test(arguments: Region.Octant.allCases)
    func `hasPositiveZ property matches static function`(octant: Region.Octant) {
        let property = octant.hasPositiveZ
        let function = Region.Octant.hasPositiveZ(octant)
        #expect(property == function)
    }

    @Test
    func positiveZOctants() {
        #expect(Region.Octant.ppp.hasPositiveZ == true)
        #expect(Region.Octant.ppn.hasPositiveZ == false)
        #expect(Region.Octant.pnp.hasPositiveZ == true)
        #expect(Region.Octant.pnn.hasPositiveZ == false)
        #expect(Region.Octant.npp.hasPositiveZ == true)
        #expect(Region.Octant.npn.hasPositiveZ == false)
        #expect(Region.Octant.nnp.hasPositiveZ == true)
        #expect(Region.Octant.nnn.hasPositiveZ == false)
    }
}
