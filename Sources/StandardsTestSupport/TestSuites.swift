//
//  TestSuites.swift
//  swift-standards
//
//  Macro that generates standardized test suite structure.
//
//  Usage:
//    extension MyType {
//        #TestSuites
//    }
//
//  Expands to:
//    extension MyType {
//        @Suite enum Test {
//            @Suite struct Unit {}
//            @Suite struct EdgeCase {}
//            @Suite(.serialized) struct Performance {}
//        }
//    }
//
//  This allows tests to be written as:
//    extension MyType.Test.Unit {
//        @Test func myTest() { ... }
//    }
//

public import Testing

@freestanding(declaration, names: named(Test))
public macro TestSuites() =
    #externalMacro(
        module: "StandardsTestSupportMacros",
        type: "TestSuitesMacro"
    )
