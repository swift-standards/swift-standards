// Layout Tests.swift

import Testing

@testable import Layout

@Suite("Layout")
struct LayoutTests {
    @Test("Layout is a namespace")
    func namespace() {
        // Layout is a namespace type, this test just verifies it exists
        let _: Layout<Double>.Type = Layout<Double>.self
    }
}
