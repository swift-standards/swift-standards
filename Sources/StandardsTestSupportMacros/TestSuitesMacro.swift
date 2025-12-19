//
//  TestSuitesMacro.swift
//  swift-standards
//
//  Macro implementation for #TestSuites - generates test suite structure.
//

public import SwiftCompilerPlugin
public import SwiftSyntax
public import SwiftSyntaxBuilder
public import SwiftSyntaxMacros

public struct TestSuitesMacro: DeclarationMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // Build group identifier from lexical context (enclosing type names)
        // Unit/EdgeCase are exclusive per-type, Performance is globally exclusive
        let typeGroup = buildGroupIdentifier(from: context)

        return [
            """
            @Suite enum Test {
                @Suite(.exclusive(group: \(literal: typeGroup))) struct Unit {}
                @Suite(.exclusive(group: \(literal: typeGroup))) struct EdgeCase {}
                @Suite(.exclusive, .serialized) struct Performance {}
            }
            """
        ]
    }

    /// Builds a group identifier from the lexical context.
    ///
    /// For `extension MyModule.MyType { #TestSuites }`, returns "MyModule.MyType".
    /// Falls back to a unique identifier if context cannot be determined.
    private static func buildGroupIdentifier(from context: some MacroExpansionContext) -> String {
        var components: [String] = []

        for lexicalContext in context.lexicalContext {
            if let name = lexicalContext.asProtocol((any DeclGroupSyntax).self)?.declGroupName {
                components.append(name)
            }
        }

        if components.isEmpty {
            // Fallback: use a unique name to avoid collisions
            let unique = context.makeUniqueName("TestSuites")
            return unique.text
        }

        // Reverse because lexicalContext is innermost-first
        return components.reversed().joined(separator: ".")
    }
}

extension DeclGroupSyntax {
    /// Extracts the name from a declaration group (struct, class, enum, extension, etc.)
    fileprivate var declGroupName: String? {
        switch self {
        case let decl as StructDeclSyntax:
            return decl.name.text
        case let decl as ClassDeclSyntax:
            return decl.name.text
        case let decl as EnumDeclSyntax:
            return decl.name.text
        case let decl as ActorDeclSyntax:
            return decl.name.text
        case let decl as ExtensionDeclSyntax:
            return decl.extendedType.trimmedDescription
        default:
            return nil
        }
    }
}

@main
struct StandardsTestSupportMacrosPlugin: CompilerPlugin {
    let providingMacros: [any Macro.Type] = [
        TestSuitesMacro.self
    ]
}
