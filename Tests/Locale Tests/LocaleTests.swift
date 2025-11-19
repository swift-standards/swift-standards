// LocaleTests.swift
// Locale Tests

import Testing
@testable import Locale
import Standards

@Suite
struct `Locale Foundation Tests` {

    @Test
    func `Placeholder test`() {
        let locale = Locale()
        #expect(locale == locale)
    }
}
