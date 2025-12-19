//
//  ExclusiveTests.swift
//  swift-standards
//
//  Tests for the Exclusive trait.
//

import StandardsTestSupport
import Testing

/// Tests that Exclusive trait can be applied to sibling suites.
@Suite
enum ExclusiveTests {

    @Suite(.exclusive)
    struct FirstSuite {
        @Test
        func testInFirstSuite() {
            #expect(Bool(true))
        }

        @Test
        func anotherTestInFirstSuite() {
            #expect(Bool(true))
        }
    }

    @Suite(.exclusive)
    struct SecondSuite {
        @Test
        func testInSecondSuite() {
            #expect(Bool(true))
        }

        @Test
        func anotherTestInSecondSuite() {
            #expect(Bool(true))
        }
    }

    @Suite(.exclusive, .serialized)
    struct ThirdSuite {
        @Test
        func testInThirdSuite() {
            #expect(Bool(true))
        }
    }
}

/// Tests for grouped exclusion.
@Suite
enum GroupedExclusiveTests {

    @Suite(.exclusive(group: "GroupA"))
    struct GroupAFirst {
        @Test
        func test() {
            #expect(Bool(true))
        }
    }

    @Suite(.exclusive(group: "GroupA"))
    struct GroupASecond {
        @Test
        func test() {
            #expect(Bool(true))
        }
    }

    @Suite(.exclusive(group: "GroupB"))
    struct GroupBFirst {
        @Test
        func test() {
            #expect(Bool(true))
        }
    }
}

/// Verify that the trait properties are correct.
@Suite
struct ExclusiveTraitTests {

    @Test
    func traitIsNotRecursive() {
        let trait = Exclusive()
        #expect(trait.isRecursive == false)
    }

    @Test
    func defaultGroupIsGlobal() {
        let trait = Exclusive()
        #expect(trait.group == Exclusive.globalGroup)
    }

    @Test
    func groupCanBeSpecified() {
        let trait = Exclusive(group: "MyGroup")
        #expect(trait.group == "MyGroup")
    }

    @Test
    func traitExtensionWithoutGroup() {
        let trait: Exclusive = .exclusive
        #expect(trait.group == Exclusive.globalGroup)
    }

    @Test
    func traitExtensionWithGroup() {
        let trait: Exclusive = .exclusive(group: "TestGroup")
        #expect(trait.group == "TestGroup")
    }
}
