// Symmetry Tests.swift

import Testing
@testable import Symmetry
import Geometry

@Suite
struct SymmetryTests {
    @Test
    func rotationIdentity() {
        let identity = Rotation<2>.identity
        #expect(identity.matrix.a == 1)
        #expect(identity.matrix.d == 1)
    }

    @Test
    func scaleIdentity() {
        let identity = Scale<2>.identity
        #expect(identity.x == 1)
        #expect(identity.y == 1)
    }

    @Test
    func shearIdentity() {
        let identity = Shear<2>.identity
        #expect(identity.x == 0)
        #expect(identity.y == 0)
    }
}
