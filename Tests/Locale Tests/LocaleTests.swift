// LocaleTests.swift
// Locale Tests

import Standards
import Testing

@testable import Locale

@Suite
struct `Locale Foundation Tests` {

    @Test
    func `Placeholder test`() {
        let locale = Locale()
        #expect(locale == locale)
    }
}
