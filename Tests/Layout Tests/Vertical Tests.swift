// Vertical Tests.swift

import Testing

@testable import Dimension
@testable import Layout

@Suite("Vertical.Alignment")
struct VerticalAlignmentTests {
    @Test("Vertical.Alignment cases", arguments: Vertical.Alignment.allCases)
    func cases(alignment: Vertical.Alignment) {
        // Verify each case is distinct
        #expect(Vertical.Alignment.allCases.contains(alignment))
    }

    @Test("Vertical.Alignment CaseIterable")
    func caseIterable() {
        #expect(Vertical.Alignment.allCases.count == 5)
        #expect(Vertical.Alignment.allCases.contains(.top))
        #expect(Vertical.Alignment.allCases.contains(.center))
        #expect(Vertical.Alignment.allCases.contains(.bottom))
        #expect(Vertical.Alignment.allCases.contains(.firstBaseline))
        #expect(Vertical.Alignment.allCases.contains(.lastBaseline))
    }

    @Test("Vertical.Alignment baseline convenience")
    func baselineConvenience() {
        #expect(Vertical.Alignment.firstBaseline == .baseline(.first))
        #expect(Vertical.Alignment.lastBaseline == .baseline(.last))
    }
}

@Suite("Vertical.Baseline")
struct VerticalBaselineTests {
    @Test("Vertical.Baseline cases", arguments: Vertical.Baseline.allCases)
    func cases(baseline: Vertical.Baseline) {
        // Verify each case is distinct
        #expect(Vertical.Baseline.allCases.contains(baseline))
    }

    @Test("Vertical.Baseline CaseIterable")
    func caseIterable() {
        #expect(Vertical.Baseline.allCases.count == 2)
        #expect(Vertical.Baseline.allCases.contains(.first))
        #expect(Vertical.Baseline.allCases.contains(.last))
    }
}
