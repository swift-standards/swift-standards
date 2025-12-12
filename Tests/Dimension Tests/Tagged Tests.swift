// Tagged Tests.swift

import StandardsTestSupport
import Testing
@testable import Dimension

// MARK: - Tagged - Static Functions

@Suite("Tagged - Static Functions")
struct Tagged_StaticTests {
    enum Tag1 {}
    enum Tag2 {}

    @Test
    func `map transforms raw value`() {
        let tagged: Tagged<Tag1, Int> = Tagged(10)
        let result = Tagged<Tag1, Int>.map(tagged) { $0 * 2 }
        #expect(result.rawValue == 20)
    }

    @Test
    func `map preserves tag`() {
        let tagged: Tagged<Tag1, Int> = Tagged(10)
        let result: Tagged<Tag1, Double> = Tagged<Tag1, Int>.map(tagged) { Double($0) }
        #expect(result.rawValue == 10.0)
    }

    @Test
    func `retag changes tag type`() {
        let tagged: Tagged<Tag1, Int> = Tagged(42)
        let retagged: Tagged<Tag2, Int> = Tagged<Tag1, Int>.retag(tagged, to: Tag2.self)
        #expect(retagged.rawValue == 42)
    }

    @Test(arguments: [10, 20, -5, 0])
    func `retag preserves raw value`(value: Int) {
        let tagged: Tagged<Tag1, Int> = Tagged(value)
        let retagged: Tagged<Tag2, Int> = Tagged<Tag1, Int>.retag(tagged)
        #expect(retagged.rawValue == value)
    }
}

// MARK: - Tagged - Properties

@Suite("Tagged - Properties")
struct Tagged_PropertyTests {
    enum TestTag {}

    @Test
    func `rawValue accessor`() {
        let tagged: Tagged<TestTag, Int> = Tagged(42)
        #expect(tagged.rawValue == 42)
    }

    @Test
    func `value is alias for rawValue`() {
        let tagged: Tagged<TestTag, Int> = Tagged(100)
        #expect(tagged.value == tagged.rawValue)
        #expect(tagged.value == 100)
    }

    @Test
    func `map property delegates to static function`() {
        let tagged: Tagged<TestTag, Int> = Tagged(10)
        let result1 = tagged.map { $0 * 2 }
        let result2 = Tagged<TestTag, Int>.map(tagged) { $0 * 2 }
        #expect(result1.rawValue == result2.rawValue)
    }

    @Test
    func `retag property delegates to static function`() {
        enum Tag1 {}
        enum Tag2 {}
        let tagged: Tagged<Tag1, Int> = Tagged(42)
        let result1: Tagged<Tag2, Int> = tagged.retag()
        let result2: Tagged<Tag2, Int> = Tagged<Tag1, Int>.retag(tagged)
        #expect(result1.rawValue == result2.rawValue)
    }
}

// MARK: - Tagged - Initializers

@Suite("Tagged - Initializers")
struct Tagged_InitializerTests {
    enum TestTag {}

    @Test
    func `init with raw value`() {
        let tagged: Tagged<TestTag, Int> = Tagged(42)
        #expect(tagged.rawValue == 42)
    }

    @Test
    func `init with rawValue label`() {
        let tagged: Tagged<TestTag, String> = Tagged(rawValue: "hello")
        #expect(tagged.rawValue == "hello")
    }

    @Test
    func `integer literal initialization`() {
        let tagged: Tagged<TestTag, Int> = 42
        #expect(tagged.rawValue == 42)
    }

    @Test
    func `float literal initialization`() {
        let tagged: Tagged<TestTag, Double> = 3.14
        #expect(tagged.rawValue == 3.14)
    }

    @Test
    func `string literal initialization`() {
        let tagged: Tagged<TestTag, String> = "hello"
        #expect(tagged.rawValue == "hello")
    }

    @Test
    func `boolean literal initialization`() {
        let tagged: Tagged<TestTag, Bool> = true
        #expect(tagged.rawValue == true)
    }
}

// MARK: - Tagged - Protocol Conformances

@Suite("Tagged - Protocol Conformances")
struct Tagged_ProtocolTests {
    enum TestTag {}

    @Test
    func `Equatable when rawValue is Equatable`() {
        let tag1: Tagged<TestTag, Int> = Tagged(10)
        let tag2: Tagged<TestTag, Int> = Tagged(10)
        let tag3: Tagged<TestTag, Int> = Tagged(20)
        #expect(tag1 == tag2)
        #expect(tag1 != tag3)
    }

    @Test
    func `Hashable when rawValue is Hashable`() {
        let set: Set<Tagged<TestTag, Int>> = [Tagged(10), Tagged(20), Tagged(10)]
        #expect(set.count == 2)
    }

    @Test
    func `Comparable when rawValue is Comparable`() {
        let tag1: Tagged<TestTag, Int> = Tagged(10)
        let tag2: Tagged<TestTag, Int> = Tagged(20)
        #expect(tag1 < tag2)
        #expect(tag2 > tag1)
    }

    @Test
    func `max function`() {
        let tag1: Tagged<TestTag, Int> = Tagged(10)
        let tag2: Tagged<TestTag, Int> = Tagged(20)
        let result = Tagged<TestTag, Int>.max(tag1, tag2)
        #expect(result.rawValue == 20)
    }

    @Test
    func `min function`() {
        let tag1: Tagged<TestTag, Int> = Tagged(10)
        let tag2: Tagged<TestTag, Int> = Tagged(20)
        let result = Tagged<TestTag, Int>.min(tag1, tag2)
        #expect(result.rawValue == 10)
    }
}

// MARK: - Tagged - Arithmetic

@Suite("Tagged - Arithmetic")
struct Tagged_ArithmeticTests {
    enum TestTag {}

    @Test
    func `AdditiveArithmetic zero`() {
        let zero: Tagged<TestTag, Int> = .zero
        #expect(zero.rawValue == 0)
    }

    @Test
    func `addition of same-tagged values`() {
        let tag1: Tagged<TestTag, Int> = Tagged(10)
        let tag2: Tagged<TestTag, Int> = Tagged(20)
        let result = tag1 + tag2
        #expect(result.rawValue == 30)
    }

    @Test
    func `subtraction of same-tagged values`() {
        let tag1: Tagged<TestTag, Int> = Tagged(30)
        let tag2: Tagged<TestTag, Int> = Tagged(10)
        let result = tag1 - tag2
        #expect(result.rawValue == 20)
    }

    @Test
    func `scalar addition`() {
        let tagged: Tagged<TestTag, Int> = Tagged(10)
        let result1 = tagged + 5
        let result2 = 5 + tagged
        #expect(result1.rawValue == 15)
        #expect(result2.rawValue == 15)
    }

    @Test
    func `scalar subtraction`() {
        let tagged: Tagged<TestTag, Int> = Tagged(10)
        let result = tagged - 3
        #expect(result.rawValue == 7)
    }

    @Test
    func `negation`() {
        let tagged: Tagged<TestTag, Int> = Tagged(10)
        let result = -tagged
        #expect(result.rawValue == -10)
    }

    @Test
    func `scalar multiplication for FloatingPoint`() {
        let tagged: Tagged<TestTag, Double> = Tagged(10.0)
        let result1 = tagged * 2.0
        let result2 = 2.0 * tagged
        #expect(result1.rawValue == 20.0)
        #expect(result2.rawValue == 20.0)
    }

    @Test
    func `scalar division for FloatingPoint`() {
        let tagged: Tagged<TestTag, Double> = Tagged(10.0)
        let result = tagged / 2.0
        #expect(result.rawValue == 5.0)
    }

    @Test
    func `same-tag multiplication returns raw value`() {
        let tag1: Tagged<TestTag, Int> = Tagged(3)
        let tag2: Tagged<TestTag, Int> = Tagged(4)
        let result: Int = tag1 * tag2
        #expect(result == 12)
    }

    @Test
    func `same-tag division returns raw ratio`() {
        let tag1: Tagged<TestTag, Double> = Tagged(10.0)
        let tag2: Tagged<TestTag, Double> = Tagged(2.0)
        let result: Double = tag1 / tag2
        #expect(result == 5.0)
    }

    @Test
    func `compound addition assignment`() {
        var tagged: Tagged<TestTag, Int> = Tagged(10)
        tagged += Tagged(5)
        #expect(tagged.rawValue == 15)
    }

    @Test
    func `compound subtraction assignment`() {
        var tagged: Tagged<TestTag, Int> = Tagged(10)
        tagged -= Tagged(3)
        #expect(tagged.rawValue == 7)
    }

    @Test
    func `compound scalar addition assignment`() {
        var tagged: Tagged<TestTag, Int> = Tagged(10)
        tagged += 5
        #expect(tagged.rawValue == 15)
    }

    @Test
    func `compound scalar multiplication assignment`() {
        var tagged: Tagged<TestTag, Double> = Tagged(10.0)
        tagged *= 2.0
        #expect(tagged.rawValue == 20.0)
    }
}

// MARK: - Tagged - Free Functions

@Suite("Tagged - Free Functions")
struct Tagged_FreeFunctionsTests {
    enum TestTag {}

    @Test
    func `abs function`() {
        let negative: Tagged<TestTag, Int> = Tagged(-10)
        let result = abs(negative)
        #expect(result.rawValue == 10)
    }

    @Test
    func `min free function`() {
        let tag1: Tagged<TestTag, Int> = Tagged(10)
        let tag2: Tagged<TestTag, Int> = Tagged(20)
        let result = min(tag1, tag2)
        #expect(result.rawValue == 10)
    }

    @Test
    func `max free function`() {
        let tag1: Tagged<TestTag, Int> = Tagged(10)
        let tag2: Tagged<TestTag, Int> = Tagged(20)
        let result = max(tag1, tag2)
        #expect(result.rawValue == 20)
    }
}

// MARK: - Tagged - Strideable

@Suite("Tagged - Strideable")
struct Tagged_StrideableTests {
    enum TestTag {}

    @Test
    func `distance between tagged values`() {
        let tag1: Tagged<TestTag, Int> = Tagged(10)
        let tag2: Tagged<TestTag, Int> = Tagged(20)
        let distance = tag1.distance(to: tag2)
        #expect(distance == 10)
    }

    @Test
    func `advanced by stride`() {
        let tagged: Tagged<TestTag, Int> = Tagged(10)
        let result = tagged.advanced(by: 5)
        #expect(result.rawValue == 15)
    }
}
