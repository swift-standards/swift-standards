// Layout Tests.swift

import Testing

@testable import Layout

@Suite
struct `Layout Tests` {
    @Test
    func `Layout is a namespace`() {
        // Layout is a namespace type, this test just verifies it exists
        let _: Layout<Double>.Type = Layout<Double>.self
    }
}
