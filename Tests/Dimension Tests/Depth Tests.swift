// Depth Tests.swift

import StandardsTestSupport
import Testing
@testable import Dimension

// MARK: - Depth - Static Functions

@Suite("Depth - Static Functions")
struct Depth_StaticTests {
    @Test(arguments: [Depth.forward, Depth.backward])
    func `opposite is involution`(depth: Depth) {
        #expect(Depth.opposite(of: Depth.opposite(of: depth)) == depth)
    }

    @Test
    func `opposite maps forward to backward`() {
        #expect(Depth.opposite(of: .forward) == .backward)
    }

    @Test
    func `opposite maps backward to forward`() {
        #expect(Depth.opposite(of: .backward) == .forward)
    }
}

// MARK: - Depth - Properties

@Suite("Depth - Properties")
struct Depth_PropertyTests {
    @Test(arguments: [Depth.forward, Depth.backward])
    func `opposite property delegates to static function`(depth: Depth) {
        #expect(depth.opposite == Depth.opposite(of: depth))
    }

    @Test
    func `direction maps forward to positive`() {
        #expect(Depth.forward.direction == .positive)
    }

    @Test
    func `direction maps backward to negative`() {
        #expect(Depth.backward.direction == .negative)
    }

    @Test
    func `isForward property`() {
        #expect(Depth.forward.isForward)
        #expect(!Depth.backward.isForward)
    }

    @Test
    func `isBackward property`() {
        #expect(Depth.backward.isBackward)
        #expect(!Depth.forward.isBackward)
    }

    @Test(arguments: [Depth.forward, Depth.backward])
    func `isPositive property`(depth: Depth) {
        if depth == .forward {
            #expect(depth.isPositive)
        } else {
            #expect(!depth.isPositive)
        }
    }

    @Test(arguments: [Depth.forward, Depth.backward])
    func `isNegative property`(depth: Depth) {
        if depth == .backward {
            #expect(depth.isNegative)
        } else {
            #expect(!depth.isNegative)
        }
    }
}

// MARK: - Depth - Initializers

@Suite("Depth - Initializers")
struct Depth_InitializerTests {
    @Test
    func `init from positive direction creates forward`() {
        #expect(Depth(direction: .positive) == .forward)
    }

    @Test
    func `init from negative direction creates backward`() {
        #expect(Depth(direction: .negative) == .backward)
    }

    @Test(arguments: [Depth.forward, Depth.backward])
    func `direction roundtrip`(depth: Depth) {
        #expect(Depth(direction: depth.direction) == depth)
    }

    @Test
    func `init from true creates forward`() {
        #expect(Depth(true) == .forward)
    }

    @Test
    func `init from false creates backward`() {
        #expect(Depth(false) == .backward)
    }
}

// MARK: - Depth - Protocol Conformances

@Suite("Depth - Protocol Conformances")
struct Depth_ProtocolTests {
    @Test
    func `allCases contains exactly two cases`() {
        #expect(Depth.allCases.count == 2)
    }

    @Test
    func `allCases contains forward`() {
        #expect(Depth.allCases.contains(.forward))
    }

    @Test
    func `allCases contains backward`() {
        #expect(Depth.allCases.contains(.backward))
    }

    @Test(arguments: [Depth.forward, Depth.backward])
    func `Equatable reflexivity`(depth: Depth) {
        #expect(depth == depth)
    }

    @Test
    func `Equatable symmetry`() {
        #expect(Depth.forward != Depth.backward)
        #expect(Depth.backward != Depth.forward)
    }

    @Test
    func `Hashable produces unique hashes`() {
        let set: Set<Depth> = [.forward, .backward, .forward]
        #expect(set.count == 2)
    }

    @Test(arguments: [Depth.forward, Depth.backward])
    func `description property`(depth: Depth) {
        let desc = depth.description
        #expect(desc == "forward" || desc == "backward")
    }
}

// MARK: - Depth - Operators

@Suite("Depth - Operators")
struct Depth_OperatorTests {
    @Test(arguments: [Depth.forward, Depth.backward])
    func `negation operator is involution`(depth: Depth) {
        #expect(!(!depth) == depth)
    }

    @Test
    func `negation maps forward to backward`() {
        #expect(!Depth.forward == .backward)
    }

    @Test
    func `negation maps backward to forward`() {
        #expect(!Depth.backward == .forward)
    }
}
