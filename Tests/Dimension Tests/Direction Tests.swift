// Direction Tests.swift

import StandardsTestSupport
import Testing
@testable import Dimension

// MARK: - Direction - Static Functions

@Suite("Direction - Static Functions")
struct Direction_StaticTests {
    @Test(arguments: [Direction.positive, Direction.negative])
    func `opposite is involution`(direction: Direction) {
        #expect(Direction.opposite(of: Direction.opposite(of: direction)) == direction)
    }

    @Test
    func `opposite maps positive to negative`() {
        #expect(Direction.opposite(of: .positive) == .negative)
    }

    @Test
    func `opposite maps negative to positive`() {
        #expect(Direction.opposite(of: .negative) == .positive)
    }
}

// MARK: - Direction - Properties

@Suite("Direction - Properties")
struct Direction_PropertyTests {
    @Test(arguments: [Direction.positive, Direction.negative])
    func `opposite property delegates to static function`(direction: Direction) {
        #expect(direction.opposite == Direction.opposite(of: direction))
    }

    @Test
    func `direction property returns self`() {
        #expect(Direction.positive.direction == .positive)
        #expect(Direction.negative.direction == .negative)
    }

    @Test
    func `sign returns 1 for positive`() {
        #expect(Direction.positive.sign == 1)
    }

    @Test
    func `sign returns -1 for negative`() {
        #expect(Direction.negative.sign == -1)
    }

    @Test(arguments: [Direction.positive, Direction.negative])
    func `isPositive property`(direction: Direction) {
        if direction == .positive {
            #expect(direction.isPositive)
        } else {
            #expect(!direction.isPositive)
        }
    }

    @Test(arguments: [Direction.positive, Direction.negative])
    func `isNegative property`(direction: Direction) {
        if direction == .negative {
            #expect(direction.isNegative)
        } else {
            #expect(!direction.isNegative)
        }
    }
}

// MARK: - Direction - Operators

@Suite("Direction - Operators")
struct Direction_OperatorTests {
    @Test(arguments: [Direction.positive, Direction.negative])
    func `negation operator is involution`(direction: Direction) {
        #expect(!(!direction) == direction)
    }

    @Test
    func `negation maps positive to negative`() {
        #expect(!Direction.positive == .negative)
    }

    @Test
    func `negation maps negative to positive`() {
        #expect(!Direction.negative == .positive)
    }
}

// MARK: - Direction - Initializers

@Suite("Direction - Initializers")
struct Direction_InitializerTests {
    @Test(arguments: [Direction.positive, Direction.negative])
    func `init from direction is identity`(direction: Direction) {
        #expect(Direction(direction: direction) == direction)
    }

    @Test
    func `init from non-negative sign creates positive`() {
        #expect(Direction(sign: 0) == .positive)
        #expect(Direction(sign: 1) == .positive)
        #expect(Direction(sign: 100) == .positive)
    }

    @Test
    func `init from negative sign creates negative`() {
        #expect(Direction(sign: -1) == .negative)
        #expect(Direction(sign: -100) == .negative)
    }

    @Test
    func `init from true creates positive`() {
        #expect(Direction(true) == .positive)
    }

    @Test
    func `init from false creates negative`() {
        #expect(Direction(false) == .negative)
    }
}

// MARK: - Direction - Protocol Conformances

@Suite("Direction - Protocol Conformances")
struct Direction_ProtocolTests {
    @Test
    func `allCases contains exactly two cases`() {
        #expect(Direction.allCases.count == 2)
    }

    @Test
    func `allCases contains positive`() {
        #expect(Direction.allCases.contains(.positive))
    }

    @Test
    func `allCases contains negative`() {
        #expect(Direction.allCases.contains(.negative))
    }

    @Test(arguments: [Direction.positive, Direction.negative])
    func `Equatable reflexivity`(direction: Direction) {
        #expect(direction == direction)
    }

    @Test
    func `Equatable symmetry`() {
        #expect(Direction.positive != Direction.negative)
        #expect(Direction.negative != Direction.positive)
    }

    @Test
    func `Hashable produces unique hashes`() {
        let set: Set<Direction> = [.positive, .negative, .positive]
        #expect(set.count == 2)
    }
}
