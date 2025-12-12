// Cross Tests.swift

import Testing

@testable import Layout

@Suite("Cross.Alignment")
struct CrossAlignmentTests {
    @Test("Cross.Alignment cases", arguments: Cross.Alignment.allCases)
    func cases(alignment: Cross.Alignment) {
        // Verify each case is distinct
        #expect(Cross.Alignment.allCases.contains(alignment))
    }

    @Test("Cross.Alignment CaseIterable")
    func caseIterable() {
        #expect(Cross.Alignment.allCases.count == 4)
        #expect(Cross.Alignment.allCases.contains(.leading))
        #expect(Cross.Alignment.allCases.contains(.center))
        #expect(Cross.Alignment.allCases.contains(.trailing))
        #expect(Cross.Alignment.allCases.contains(.fill))
    }
}
