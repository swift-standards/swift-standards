// Horizontal Tests.swift

import Testing

@testable import Dimension
@testable import Layout

@Suite("Horizontal.Alignment")
struct HorizontalAlignmentTests {
    @Test("Horizontal.Alignment cases", arguments: Horizontal.Alignment.allCases)
    func cases(alignment: Horizontal.Alignment) {
        // Verify each case is distinct
        #expect(Horizontal.Alignment.allCases.contains(alignment))
    }

    @Test("Horizontal.Alignment CaseIterable")
    func caseIterable() {
        #expect(Horizontal.Alignment.allCases.count == 3)
        #expect(Horizontal.Alignment.allCases.contains(.leading))
        #expect(Horizontal.Alignment.allCases.contains(.center))
        #expect(Horizontal.Alignment.allCases.contains(.trailing))
    }

    @Test("Horizontal.Alignment Hashable")
    func hashable() {
        let set: Set<Horizontal.Alignment> = [.leading, .center, .trailing, .leading]
        #expect(set.count == 3)
    }
}
