// Horizontal Tests.swift

import StandardsTestSupport
import Testing
@testable import Dimension

// MARK: - Horizontal - Static Functions

@Suite("Horizontal - Static Functions")
struct Horizontal_StaticTests {
    @Test(arguments: [Horizontal.rightward, Horizontal.leftward])
    func `opposite is involution`(horizontal: Horizontal) {
        #expect(Horizontal.opposite(of: Horizontal.opposite(of: horizontal)) == horizontal)
    }

    @Test
    func `opposite maps rightward to leftward`() {
        #expect(Horizontal.opposite(of: .rightward) == .leftward)
    }

    @Test
    func `opposite maps leftward to rightward`() {
        #expect(Horizontal.opposite(of: .leftward) == .rightward)
    }
}

// MARK: - Horizontal - Properties

@Suite("Horizontal - Properties")
struct Horizontal_PropertyTests {
    @Test(arguments: [Horizontal.rightward, Horizontal.leftward])
    func `opposite property delegates to static function`(horizontal: Horizontal) {
        #expect(horizontal.opposite == Horizontal.opposite(of: horizontal))
    }

    @Test
    func `direction maps rightward to positive`() {
        #expect(Horizontal.rightward.direction == .positive)
    }

    @Test
    func `direction maps leftward to negative`() {
        #expect(Horizontal.leftward.direction == .negative)
    }

    @Test
    func `isRightward property`() {
        #expect(Horizontal.rightward.isRightward)
        #expect(!Horizontal.leftward.isRightward)
    }

    @Test
    func `isLeftward property`() {
        #expect(Horizontal.leftward.isLeftward)
        #expect(!Horizontal.rightward.isLeftward)
    }

    @Test(arguments: [Horizontal.rightward, Horizontal.leftward])
    func `isPositive property`(horizontal: Horizontal) {
        if horizontal == .rightward {
            #expect(horizontal.isPositive)
        } else {
            #expect(!horizontal.isPositive)
        }
    }

    @Test(arguments: [Horizontal.rightward, Horizontal.leftward])
    func `isNegative property`(horizontal: Horizontal) {
        if horizontal == .leftward {
            #expect(horizontal.isNegative)
        } else {
            #expect(!horizontal.isNegative)
        }
    }
}

// MARK: - Horizontal - Initializers

@Suite("Horizontal - Initializers")
struct Horizontal_InitializerTests {
    @Test
    func `init from positive direction creates rightward`() {
        #expect(Horizontal(direction: .positive) == .rightward)
    }

    @Test
    func `init from negative direction creates leftward`() {
        #expect(Horizontal(direction: .negative) == .leftward)
    }

    @Test(arguments: [Horizontal.rightward, Horizontal.leftward])
    func `direction roundtrip`(horizontal: Horizontal) {
        #expect(Horizontal(direction: horizontal.direction) == horizontal)
    }

    @Test
    func `init from true creates rightward`() {
        #expect(Horizontal(true) == .rightward)
    }

    @Test
    func `init from false creates leftward`() {
        #expect(Horizontal(false) == .leftward)
    }
}

// MARK: - Horizontal - Protocol Conformances

@Suite("Horizontal - Protocol Conformances")
struct Horizontal_ProtocolTests {
    @Test
    func `allCases contains exactly two cases`() {
        #expect(Horizontal.allCases.count == 2)
    }

    @Test
    func `allCases contains rightward`() {
        #expect(Horizontal.allCases.contains(.rightward))
    }

    @Test
    func `allCases contains leftward`() {
        #expect(Horizontal.allCases.contains(.leftward))
    }

    @Test(arguments: [Horizontal.rightward, Horizontal.leftward])
    func `Equatable reflexivity`(horizontal: Horizontal) {
        #expect(horizontal == horizontal)
    }

    @Test
    func `Equatable symmetry`() {
        #expect(Horizontal.rightward != Horizontal.leftward)
        #expect(Horizontal.leftward != Horizontal.rightward)
    }

    @Test
    func `Hashable produces unique hashes`() {
        let set: Set<Horizontal> = [.rightward, .leftward, .rightward]
        #expect(set.count == 2)
    }

    @Test(arguments: [Horizontal.rightward, Horizontal.leftward])
    func `description property`(horizontal: Horizontal) {
        let desc = horizontal.description
        #expect(desc == "rightward" || desc == "leftward")
    }
}

// MARK: - Horizontal - Operators

@Suite("Horizontal - Operators")
struct Horizontal_OperatorTests {
    @Test(arguments: [Horizontal.rightward, Horizontal.leftward])
    func `negation operator is involution`(horizontal: Horizontal) {
        #expect(!(!horizontal) == horizontal)
    }

    @Test
    func `negation maps rightward to leftward`() {
        #expect(!Horizontal.rightward == .leftward)
    }

    @Test
    func `negation maps leftward to rightward`() {
        #expect(!Horizontal.leftward == .rightward)
    }
}
