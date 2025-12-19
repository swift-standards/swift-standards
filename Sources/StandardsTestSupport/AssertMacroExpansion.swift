//
//  AssertMacroExpansion.swift
//  swift-standards
//
//  Swift Testing wrapper for macro expansion assertions.
//

public import SwiftSyntax
public import SwiftSyntaxMacroExpansion
public import SwiftSyntaxMacros
public import SwiftSyntaxMacrosGenericTestSupport
public import Testing

/// Asserts that a macro expands to the expected source code.
///
/// This wrapper bridges `SwiftSyntaxMacrosGenericTestSupport` to Swift Testing
/// by providing a failure handler that calls `Issue.record()`.
///
/// Example:
/// ```swift
/// @Test
/// func testMacroExpansion() {
///     assertMacroExpansion(
///         """
///         #myMacro
///         """,
///         expandedSource: """
///         // expanded code
///         """,
///         macros: ["myMacro": MyMacro.self]
///     )
/// }
/// ```
public func assertMacroExpansion(
    _ originalSource: String,
    expandedSource expectedExpandedSource: String,
    diagnostics: [DiagnosticSpec] = [],
    macros: [String: any Macro.Type],
    testModuleName: String = "TestModule",
    testFileName: String = "test.swift",
    indentationWidth: Trivia = .spaces(4),
    fileID: StaticString = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column
) {
    SwiftSyntaxMacrosGenericTestSupport.assertMacroExpansion(
        originalSource,
        expandedSource: expectedExpandedSource,
        diagnostics: diagnostics,
        macroSpecs: macros.mapValues { MacroSpec(type: $0) },
        testModuleName: testModuleName,
        testFileName: testFileName,
        indentationWidth: indentationWidth,
        failureHandler: { spec in
            Issue.record(
                Comment(rawValue: spec.message),
                sourceLocation: SourceLocation(
                    fileID: spec.location.fileID,
                    filePath: spec.location.filePath,
                    line: Int(spec.location.line),
                    column: Int(spec.location.column)
                )
            )
        },
        fileID: fileID,
        filePath: filePath,
        line: line,
        column: column
    )
}
