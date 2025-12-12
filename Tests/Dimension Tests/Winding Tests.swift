// Winding Tests.swift

import Foundation
import StandardsTestSupport
import Testing
@testable import Dimension

// MARK: - Winding - Static Functions

@Suite
struct `Winding - Static Functions` {
    @Test(arguments: [Winding.clockwise, Winding.counterclockwise])
    func `opposite is involution`(winding: Winding) {
        #expect(Winding.opposite(of: Winding.opposite(of: winding)) == winding)
    }

    @Test
    func `opposite maps clockwise to counterclockwise`() {
        #expect(Winding.opposite(of: .clockwise) == .counterclockwise)
    }

    @Test
    func `opposite maps counterclockwise to clockwise`() {
        #expect(Winding.opposite(of: .counterclockwise) == .clockwise)
    }
}

// MARK: - Winding - Properties

@Suite
struct `Winding - Properties` {
    @Test(arguments: [Winding.clockwise, Winding.counterclockwise])
    func `opposite property delegates to static function`(winding: Winding) {
        #expect(winding.opposite == Winding.opposite(of: winding))
    }

    @Test
    func `cw is alias for clockwise`() {
        #expect(Winding.cw == .clockwise)
    }

    @Test
    func `ccw is alias for counterclockwise`() {
        #expect(Winding.ccw == .counterclockwise)
    }
}

// MARK: - Winding - Operators

@Suite
struct `Winding - Operators` {
    @Test(arguments: [Winding.clockwise, Winding.counterclockwise])
    func `negation operator is involution`(winding: Winding) {
        #expect(!(!winding) == winding)
    }

    @Test
    func `negation maps clockwise to counterclockwise`() {
        #expect(!Winding.clockwise == .counterclockwise)
    }

    @Test
    func `negation maps counterclockwise to clockwise`() {
        #expect(!Winding.counterclockwise == .clockwise)
    }
}

// MARK: - Winding - Protocol Conformances

@Suite
struct `Winding - Protocol Conformances` {
    @Test
    func `allCases contains exactly two cases`() {
        #expect(Winding.allCases.count == 2)
    }

    @Test
    func `allCases contains clockwise`() {
        #expect(Winding.allCases.contains(.clockwise))
    }

    @Test
    func `allCases contains counterclockwise`() {
        #expect(Winding.allCases.contains(.counterclockwise))
    }

    @Test(arguments: [Winding.clockwise, Winding.counterclockwise])
    func `Equatable reflexivity`(winding: Winding) {
        #expect(winding == winding)
    }

    @Test
    func `Equatable symmetry`() {
        #expect(Winding.clockwise != Winding.counterclockwise)
        #expect(Winding.counterclockwise != Winding.clockwise)
    }

    @Test
    func `Hashable produces unique hashes`() {
        let set: Set<Winding> = [.clockwise, .counterclockwise, .clockwise]
        #expect(set.count == 2)
    }

    @Test
    func `Codable roundtrip`() throws {
        let original = Winding.clockwise
        let encoded = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Winding.self, from: encoded)
        #expect(decoded == original)
    }
}

// MARK: - Winding - Value Typealias

@Suite
struct `Winding - Value Typealias` {
    @Test
    func `Value typealias for Pair`() {
        let paired: Winding.Value<Double> = Pair(.clockwise, 3.14)
        #expect(paired.first == .clockwise)
        #expect(paired.second == 3.14)
    }

    @Test
    func `Value is Pair type`() {
        let value: Winding.Value<Double> = Pair(.ccw, 45.0)
        #expect(value.first == .counterclockwise)
        #expect(value.second == 45.0)
    }
}
