//
//  TestSuitesMacroTests.swift
//  swift-standards
//
//  Tests for the #TestSuites macro.
//

import StandardsTestSupport
import StandardsTestSupportMacros
import SwiftSyntaxMacros
import Testing

@Suite
struct TestSuitesMacroTests {

    let macros: [String: any Macro.Type] = [
        "TestSuites": TestSuitesMacro.self
    ]

    @Test
    func expansionGeneratesTestEnum() {
        assertMacroExpansion(
            """
            struct MyType {
                #TestSuites
            }
            """,
            expandedSource: """
                struct MyType {
                    @Suite enum Test {
                        @Suite(.exclusive(group: "MyType")) struct Unit {
                        }
                        @Suite(.exclusive(group: "MyType")) struct EdgeCase {
                        }
                        @Suite(.exclusive, .serialized) struct Performance {
                        }
                    }
                }
                """,
            macros: macros
        )
    }

    @Test
    func expansionInExtension() {
        assertMacroExpansion(
            """
            extension SomeType {
                #TestSuites
            }
            """,
            expandedSource: """
                extension SomeType {
                    @Suite enum Test {
                        @Suite(.exclusive(group: "SomeType")) struct Unit {
                        }
                        @Suite(.exclusive(group: "SomeType")) struct EdgeCase {
                        }
                        @Suite(.exclusive, .serialized) struct Performance {
                        }
                    }
                }
                """,
            macros: macros
        )
    }

    @Test
    func expansionInEnum() {
        assertMacroExpansion(
            """
            enum MyEnum {
                #TestSuites
            }
            """,
            expandedSource: """
                enum MyEnum {
                    @Suite enum Test {
                        @Suite(.exclusive(group: "MyEnum")) struct Unit {
                        }
                        @Suite(.exclusive(group: "MyEnum")) struct EdgeCase {
                        }
                        @Suite(.exclusive, .serialized) struct Performance {
                        }
                    }
                }
                """,
            macros: macros
        )
    }
}
