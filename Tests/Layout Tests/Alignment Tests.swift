// Alignment Tests.swift

import Testing

@testable import Layout

@Suite("Alignment")
struct AlignmentTests {
    @Test("Alignment presets")
    func presets() {
        let topLeading: Alignment = .topLeading
        #expect(topLeading.horizontal == .leading)
        #expect(topLeading.vertical == .top)

        let center: Alignment = .center
        #expect(center.horizontal == .center)
        #expect(center.vertical == .center)

        let bottomTrailing: Alignment = .bottomTrailing
        #expect(bottomTrailing.horizontal == .trailing)
        #expect(bottomTrailing.vertical == .bottom)
    }

    @Test("Alignment custom")
    func custom() {
        let custom: Alignment = .init(horizontal: .trailing, vertical: .top)
        #expect(custom.horizontal == .trailing)
        #expect(custom.vertical == .top)
    }

    @Test("Alignment Equatable")
    func equatable() {
        let a: Alignment = .center
        let b: Alignment = .init(horizontal: .center, vertical: .center)
        #expect(a == b)
    }
}
