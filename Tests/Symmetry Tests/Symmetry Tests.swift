// Symmetry Tests.swift

import Algebra_Linear
import Geometry
import Testing

@testable import Symmetry

@Suite
struct SymmetryTests {
    @Test
    func rotationIdentity() {
        let identity = Rotation<2, Double>.identity
        #expect(identity.matrix[0][0] == 1)
        #expect(identity.matrix[1][1] == 1)
        #expect(identity.matrix[0][1] == 0)
        #expect(identity.matrix[1][0] == 0)
    }

    @Test
    func scaleIdentity() {
        let identity = Scale<2, Double>.identity
        #expect(identity.x == 1)
        #expect(identity.y == 1)
    }

    @Test
    func shearIdentity() {
        let identity = Shear<2, Double>.identity
        #expect(identity.x == 0)
        #expect(identity.y == 0)
    }
}
