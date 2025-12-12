// Vertical Tests.swift

import Testing

@testable import Dimension
@testable import Layout

@Suite
struct `Vertical.Alignment Tests` {
    @Test(arguments: Vertical.Alignment.allCases)
    func cases(alignment: Vertical.Alignment) {
        // Verify each case is distinct
        #expect(Vertical.Alignment.allCases.contains(alignment))
    }

    @Test
    func `Vertical.Alignment CaseIterable`() {
        #expect(Vertical.Alignment.allCases.count == 5)
        #expect(Vertical.Alignment.allCases.contains(.top))
        #expect(Vertical.Alignment.allCases.contains(.center))
        #expect(Vertical.Alignment.allCases.contains(.bottom))
        #expect(Vertical.Alignment.allCases.contains(.firstBaseline))
        #expect(Vertical.Alignment.allCases.contains(.lastBaseline))
    }

    @Test
    func `Vertical.Alignment baseline convenience`() {
        #expect(Vertical.Alignment.firstBaseline == .baseline(.first))
        #expect(Vertical.Alignment.lastBaseline == .baseline(.last))
    }
}

@Suite
struct `Vertical.Baseline Tests` {
    @Test(arguments: Vertical.Baseline.allCases)
    func cases(baseline: Vertical.Baseline) {
        // Verify each case is distinct
        #expect(Vertical.Baseline.allCases.contains(baseline))
    }

    @Test
    func `Vertical.Baseline CaseIterable`() {
        #expect(Vertical.Baseline.allCases.count == 2)
        #expect(Vertical.Baseline.allCases.contains(.first))
        #expect(Vertical.Baseline.allCases.contains(.last))
    }
}
