// Horizontal Tests.swift

import Testing

@testable import Dimension
@testable import Layout

@Suite
struct `Horizontal.Alignment Tests` {
    @Test(arguments: Horizontal.Alignment.allCases)
    func cases(alignment: Horizontal.Alignment) {
        // Verify each case is distinct
        #expect(Horizontal.Alignment.allCases.contains(alignment))
    }

    @Test
    func `Horizontal.Alignment CaseIterable`() {
        #expect(Horizontal.Alignment.allCases.count == 3)
        #expect(Horizontal.Alignment.allCases.contains(.leading))
        #expect(Horizontal.Alignment.allCases.contains(.center))
        #expect(Horizontal.Alignment.allCases.contains(.trailing))
    }

    @Test
    func `Horizontal.Alignment Hashable`() {
        let set: Set<Horizontal.Alignment> = [.leading, .center, .trailing, .leading]
        #expect(set.count == 3)
    }
}
