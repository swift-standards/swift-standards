//
//  ExclusiveTests.swift
//  swift-standards
//
//  Tests for the Exclusive trait.
//

import StandardsTestSupport
import Testing

/// Verify that the trait properties are correct.
extension Exclusive {
    @Suite
    struct Test {

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
}

/// Tests that Exclusive trait can be applied to sibling suites.
extension Exclusive.Test {

    @Suite(.exclusive)
    struct `First Suite` {
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
    struct `Second Suite` {
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
    struct `Third Suite` {
        @Test
        func `In Third Suite`() {
            #expect(Bool(true))
        }
    }
}

/// Tests for grouped exclusion.
extension Exclusive.Test {

    @Suite
    struct Grouped {
        @Suite(.exclusive(group: "GroupA"))
        struct `A First` {
            @Test
            func test() {
                #expect(Bool(true))
            }
        }

        @Suite(.exclusive(group: "GroupA"))
        struct `A Second` {
            @Test
            func test() {
                #expect(Bool(true))
            }
        }

        @Suite(.exclusive(group: "GroupB"))
        struct `B First` {
            @Test
            func test() {
                #expect(Bool(true))
            }
        }
    }
}
