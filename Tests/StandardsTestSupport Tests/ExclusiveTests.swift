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
        func `In First Suite`() {
            #expect(Bool(true))
        }

        @Test
        func `another Test In First Suite`() {
            #expect(Bool(true))
        }
    }

    @Suite(.exclusive)
    struct SecondSuite {
        @Test
        func `In Second Suite`() {
            #expect(Bool(true))
        }

        @Test
        func `another Test In Second Suite`() {
            #expect(Bool(true))
        }
    }

    @Suite(.exclusive, .serialized)
    struct ThirdSuite {
        @Test
        func `In Third Suite`() {
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
    func `trait Is Not Recursive`() {
        let trait = Exclusive()
        #expect(trait.isRecursive == false)
    }

    @Test
    func `default Group Is Global`() {
        let trait = Exclusive()
        #expect(trait.group == Exclusive.globalGroup)
    }

    @Test
    func `group Can Be Specified`() {
        let trait = Exclusive(group: "MyGroup")
        #expect(trait.group == "MyGroup")
    }

    @Test
    func `trait Extension Without Group`() {
        let trait: Exclusive = .exclusive
        #expect(trait.group == Exclusive.globalGroup)
    }

    @Test
    func `trait Extension With Group`() {
        let trait: Exclusive = .exclusive(group: "TestGroup")
        #expect(trait.group == "TestGroup")
    }
}
