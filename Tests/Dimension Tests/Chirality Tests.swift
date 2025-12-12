// Chirality Tests.swift

import Foundation
import StandardsTestSupport
import Testing
@testable import Dimension

// MARK: - Chirality - Static Functions

@Suite("Chirality - Static Functions")
struct Chirality_StaticTests {
    @Test(arguments: [Chirality.left, Chirality.right])
    func `opposite is involution`(chirality: Chirality) {
        #expect(Chirality.opposite(of: Chirality.opposite(of: chirality)) == chirality)
    }

    @Test
    func `opposite maps left to right`() {
        #expect(Chirality.opposite(of: .left) == .right)
    }

    @Test
    func `opposite maps right to left`() {
        #expect(Chirality.opposite(of: .right) == .left)
    }
}

// MARK: - Chirality - Properties

@Suite("Chirality - Properties")
struct Chirality_PropertyTests {
    @Test(arguments: [Chirality.left, Chirality.right])
    func `opposite property delegates to static function`(chirality: Chirality) {
        #expect(chirality.opposite == Chirality.opposite(of: chirality))
    }

    @Test(arguments: [Chirality.left, Chirality.right])
    func `mirrored is alias for opposite`(chirality: Chirality) {
        #expect(chirality.mirrored == chirality.opposite)
    }

    @Test
    func `standard coordinate system`() {
        #expect(Chirality.standard == .right)
    }

    @Test
    func `DirectX coordinate system`() {
        #expect(Chirality.directX == .left)
    }
}

// MARK: - Chirality - Operators

@Suite("Chirality - Operators")
struct Chirality_OperatorTests {
    @Test(arguments: [Chirality.left, Chirality.right])
    func `negation operator is involution`(chirality: Chirality) {
        #expect(!(!chirality) == chirality)
    }

    @Test
    func `negation maps left to right`() {
        #expect(!Chirality.left == .right)
    }

    @Test
    func `negation maps right to left`() {
        #expect(!Chirality.right == .left)
    }
}

// MARK: - Chirality - Protocol Conformances

@Suite("Chirality - Protocol Conformances")
struct Chirality_ProtocolTests {
    @Test
    func `allCases contains exactly two cases`() {
        #expect(Chirality.allCases.count == 2)
    }

    @Test
    func `allCases contains left`() {
        #expect(Chirality.allCases.contains(.left))
    }

    @Test
    func `allCases contains right`() {
        #expect(Chirality.allCases.contains(.right))
    }

    @Test(arguments: [Chirality.left, Chirality.right])
    func `Equatable reflexivity`(chirality: Chirality) {
        #expect(chirality == chirality)
    }

    @Test
    func `Equatable symmetry`() {
        #expect(Chirality.left != Chirality.right)
        #expect(Chirality.right != Chirality.left)
    }

    @Test
    func `Hashable produces unique hashes`() {
        let set: Set<Chirality> = [.left, .right, .left]
        #expect(set.count == 2)
    }

    @Test
    func `Codable roundtrip`() throws {
        let original = Chirality.right
        let encoded = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Chirality.self, from: encoded)
        #expect(decoded == original)
    }
}

// MARK: - Chirality - Value Typealias

@Suite("Chirality - Value Typealias")
struct Chirality_ValueTests {
    @Test
    func `Value typealias for Pair`() {
        let paired: Chirality.Value<String> = Pair(.left, "hand")
        #expect(paired.first == .left)
        #expect(paired.second == "hand")
    }

    @Test
    func `Value is Pair type`() {
        let value: Chirality.Value<Int> = Pair(.right, 42)
        #expect(value.first == .right)
        #expect(value.second == 42)
    }
}
