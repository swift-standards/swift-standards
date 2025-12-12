// Cross Tests.swift

import Testing

@testable import Layout

@Suite
struct `Cross.Alignment` {
    @Test(arguments: Cross.Alignment.allCases)
    func cases(alignment: Cross.Alignment) {
        // Verify each case is distinct
        #expect(Cross.Alignment.allCases.contains(alignment))
    }

    @Test
    func `Cross.Alignment CaseIterable`() {
        #expect(Cross.Alignment.allCases.count == 4)
        #expect(Cross.Alignment.allCases.contains(.leading))
        #expect(Cross.Alignment.allCases.contains(.center))
        #expect(Cross.Alignment.allCases.contains(.trailing))
        #expect(Cross.Alignment.allCases.contains(.fill))
    }
}
