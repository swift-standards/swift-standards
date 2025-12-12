// Vertical Tests.swift

import StandardsTestSupport
import Testing
@testable import Dimension

// MARK: - Vertical - Static Functions

@Suite("Vertical - Static Functions")
struct Vertical_StaticTests {
    @Test(arguments: [Vertical.upward, Vertical.downward])
    func `opposite is involution`(vertical: Vertical) {
        #expect(Vertical.opposite(of: Vertical.opposite(of: vertical)) == vertical)
    }

    @Test
    func `opposite maps upward to downward`() {
        #expect(Vertical.opposite(of: .upward) == .downward)
    }

    @Test
    func `opposite maps downward to upward`() {
        #expect(Vertical.opposite(of: .downward) == .upward)
    }
}

// MARK: - Vertical - Properties

@Suite("Vertical - Properties")
struct Vertical_PropertyTests {
    @Test(arguments: [Vertical.upward, Vertical.downward])
    func `opposite property delegates to static function`(vertical: Vertical) {
        #expect(vertical.opposite == Vertical.opposite(of: vertical))
    }

    @Test
    func `direction maps upward to positive`() {
        #expect(Vertical.upward.direction == .positive)
    }

    @Test
    func `direction maps downward to negative`() {
        #expect(Vertical.downward.direction == .negative)
    }

    @Test
    func `isUpward property`() {
        #expect(Vertical.upward.isUpward)
        #expect(!Vertical.downward.isUpward)
    }

    @Test
    func `isDownward property`() {
        #expect(Vertical.downward.isDownward)
        #expect(!Vertical.upward.isDownward)
    }

    @Test(arguments: [Vertical.upward, Vertical.downward])
    func `isPositive property`(vertical: Vertical) {
        if vertical == .upward {
            #expect(vertical.isPositive)
        } else {
            #expect(!vertical.isPositive)
        }
    }

    @Test(arguments: [Vertical.upward, Vertical.downward])
    func `isNegative property`(vertical: Vertical) {
        if vertical == .downward {
            #expect(vertical.isNegative)
        } else {
            #expect(!vertical.isNegative)
        }
    }
}

// MARK: - Vertical - Initializers

@Suite("Vertical - Initializers")
struct Vertical_InitializerTests {
    @Test
    func `init from positive direction creates upward`() {
        #expect(Vertical(direction: .positive) == .upward)
    }

    @Test
    func `init from negative direction creates downward`() {
        #expect(Vertical(direction: .negative) == .downward)
    }

    @Test(arguments: [Vertical.upward, Vertical.downward])
    func `direction roundtrip`(vertical: Vertical) {
        #expect(Vertical(direction: vertical.direction) == vertical)
    }

    @Test
    func `init from true creates upward`() {
        #expect(Vertical(true) == .upward)
    }

    @Test
    func `init from false creates downward`() {
        #expect(Vertical(false) == .downward)
    }
}

// MARK: - Vertical - Protocol Conformances

@Suite("Vertical - Protocol Conformances")
struct Vertical_ProtocolTests {
    @Test
    func `allCases contains exactly two cases`() {
        #expect(Vertical.allCases.count == 2)
    }

    @Test
    func `allCases contains upward`() {
        #expect(Vertical.allCases.contains(.upward))
    }

    @Test
    func `allCases contains downward`() {
        #expect(Vertical.allCases.contains(.downward))
    }

    @Test(arguments: [Vertical.upward, Vertical.downward])
    func `Equatable reflexivity`(vertical: Vertical) {
        #expect(vertical == vertical)
    }

    @Test
    func `Equatable symmetry`() {
        #expect(Vertical.upward != Vertical.downward)
        #expect(Vertical.downward != Vertical.upward)
    }

    @Test
    func `Hashable produces unique hashes`() {
        let set: Set<Vertical> = [.upward, .downward, .upward]
        #expect(set.count == 2)
    }

    @Test(arguments: [Vertical.upward, Vertical.downward])
    func `description property`(vertical: Vertical) {
        let desc = vertical.description
        #expect(desc == "upward" || desc == "downward")
    }
}

// MARK: - Vertical - Operators

@Suite("Vertical - Operators")
struct Vertical_OperatorTests {
    @Test(arguments: [Vertical.upward, Vertical.downward])
    func `negation operator is involution`(vertical: Vertical) {
        #expect(!(!vertical) == vertical)
    }

    @Test
    func `negation maps upward to downward`() {
        #expect(!Vertical.upward == .downward)
    }

    @Test
    func `negation maps downward to upward`() {
        #expect(!Vertical.downward == .upward)
    }
}
