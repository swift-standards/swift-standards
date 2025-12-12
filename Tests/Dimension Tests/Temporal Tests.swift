// Temporal Tests.swift

import StandardsTestSupport
import Testing
@testable import Dimension

// MARK: - Temporal - Static Functions

@Suite("Temporal - Static Functions")
struct Temporal_StaticTests {
    @Test(arguments: [Temporal.future, Temporal.past])
    func `opposite is involution`(temporal: Temporal) {
        #expect(Temporal.opposite(of: Temporal.opposite(of: temporal)) == temporal)
    }

    @Test
    func `opposite maps future to past`() {
        #expect(Temporal.opposite(of: .future) == .past)
    }

    @Test
    func `opposite maps past to future`() {
        #expect(Temporal.opposite(of: .past) == .future)
    }
}

// MARK: - Temporal - Properties

@Suite("Temporal - Properties")
struct Temporal_PropertyTests {
    @Test(arguments: [Temporal.future, Temporal.past])
    func `opposite property delegates to static function`(temporal: Temporal) {
        #expect(temporal.opposite == Temporal.opposite(of: temporal))
    }

    @Test
    func `direction maps future to positive`() {
        #expect(Temporal.future.direction == .positive)
    }

    @Test
    func `direction maps past to negative`() {
        #expect(Temporal.past.direction == .negative)
    }

    @Test
    func `isFuture property`() {
        #expect(Temporal.future.isFuture)
        #expect(!Temporal.past.isFuture)
    }

    @Test
    func `isPast property`() {
        #expect(Temporal.past.isPast)
        #expect(!Temporal.future.isPast)
    }

    @Test(arguments: [Temporal.future, Temporal.past])
    func `isPositive property`(temporal: Temporal) {
        if temporal == .future {
            #expect(temporal.isPositive)
        } else {
            #expect(!temporal.isPositive)
        }
    }

    @Test(arguments: [Temporal.future, Temporal.past])
    func `isNegative property`(temporal: Temporal) {
        if temporal == .past {
            #expect(temporal.isNegative)
        } else {
            #expect(!temporal.isNegative)
        }
    }
}

// MARK: - Temporal - Initializers

@Suite("Temporal - Initializers")
struct Temporal_InitializerTests {
    @Test
    func `init from positive direction creates future`() {
        #expect(Temporal(direction: .positive) == .future)
    }

    @Test
    func `init from negative direction creates past`() {
        #expect(Temporal(direction: .negative) == .past)
    }

    @Test(arguments: [Temporal.future, Temporal.past])
    func `direction roundtrip`(temporal: Temporal) {
        #expect(Temporal(direction: temporal.direction) == temporal)
    }

    @Test
    func `init from true creates future`() {
        #expect(Temporal(true) == .future)
    }

    @Test
    func `init from false creates past`() {
        #expect(Temporal(false) == .past)
    }
}

// MARK: - Temporal - Protocol Conformances

@Suite("Temporal - Protocol Conformances")
struct Temporal_ProtocolTests {
    @Test
    func `allCases contains exactly two cases`() {
        #expect(Temporal.allCases.count == 2)
    }

    @Test
    func `allCases contains future`() {
        #expect(Temporal.allCases.contains(.future))
    }

    @Test
    func `allCases contains past`() {
        #expect(Temporal.allCases.contains(.past))
    }

    @Test(arguments: [Temporal.future, Temporal.past])
    func `Equatable reflexivity`(temporal: Temporal) {
        #expect(temporal == temporal)
    }

    @Test
    func `Equatable symmetry`() {
        #expect(Temporal.future != Temporal.past)
        #expect(Temporal.past != Temporal.future)
    }

    @Test
    func `Hashable produces unique hashes`() {
        let set: Set<Temporal> = [.future, .past, .future]
        #expect(set.count == 2)
    }

    @Test(arguments: [Temporal.future, Temporal.past])
    func `description property`(temporal: Temporal) {
        let desc = temporal.description
        #expect(desc == "future" || desc == "past")
    }
}

// MARK: - Temporal - Operators

@Suite("Temporal - Operators")
struct Temporal_OperatorTests {
    @Test(arguments: [Temporal.future, Temporal.past])
    func `negation operator is involution`(temporal: Temporal) {
        #expect(!(!temporal) == temporal)
    }

    @Test
    func `negation maps future to past`() {
        #expect(!Temporal.future == .past)
    }

    @Test
    func `negation maps past to future`() {
        #expect(!Temporal.past == .future)
    }
}
