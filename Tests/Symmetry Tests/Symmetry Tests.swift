// Symmetry Tests.swift

import Testing

@testable import Symmetry

@Suite
struct `Symmetry Tests` {

    // MARK: - Namespace validation

    @Test
    func `Symmetry is an enum namespace`() {
        // This test validates that the Symmetry type exists as a namespace
        // The enum cannot be instantiated, which is the intended design
        let typeName = String(describing: Symmetry.self)
        #expect(typeName == "Symmetry")
    }
}
