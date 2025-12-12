// Ordinal Tests.swift

import StandardsTestSupport
import Testing
@testable import Dimension

// MARK: - Ordinal - Static Functions

@Suite
struct `Ordinal - Static Functions` {
    @Test
    func `injected safely converts to larger domain`() {
        let ord2: Ordinal<2> = Ordinal(0)!
        let ord5: Ordinal<5> = Ordinal.injected(ord2)
        #expect(ord5.rawValue == 0)
    }

    @Test(arguments: [0, 1])
    func `injected preserves raw value`(value: Int) {
        let ord2: Ordinal<2> = Ordinal(value)!
        let ord10: Ordinal<10> = Ordinal.injected(ord2)
        #expect(ord10.rawValue == value)
    }

    @Test
    func `projected converts to smaller domain when valid`() {
        let ord10: Ordinal<10> = Ordinal(2)!
        let ord5: Ordinal<5>? = Ordinal.projected(ord10)
        #expect(ord5?.rawValue == 2)
    }

    @Test
    func `projected returns nil when value too large`() {
        let ord10: Ordinal<10> = Ordinal(7)!
        let ord5: Ordinal<5>? = Ordinal.projected(ord10)
        #expect(ord5 == nil)
    }
}

// MARK: - Ordinal - Properties

@Suite
struct `Ordinal - Properties` {
    @Test(arguments: [0, 1, 2])
    func `rawValue accessor`(value: Int) {
        let ordinal: Ordinal<5> = Ordinal(value)!
        #expect(ordinal.rawValue == value)
    }

    @Test
    func `zero property`() {
        let zero: Ordinal<10> = .zero
        #expect(zero.rawValue == 0)
    }

    @Test
    func `max property`() {
        let max: Ordinal<5> = .max
        #expect(max.rawValue == 4)
    }

    @Test
    func `count property`() {
        #expect(Ordinal<3>.count == 3)
        #expect(Ordinal<10>.count == 10)
        #expect(Ordinal<1>.count == 1)
    }

    @Test
    func `injected property delegates to static function`() {
        let ord2: Ordinal<2> = Ordinal(1)!
        let result1: Ordinal<5> = ord2.injected()
        let result2: Ordinal<5> = Ordinal.injected(ord2)
        #expect(result1.rawValue == result2.rawValue)
    }

    @Test
    func `projected property delegates to static function`() {
        let ord10: Ordinal<10> = Ordinal(2)!
        let result1: Ordinal<5>? = ord10.projected()
        let result2: Ordinal<5>? = Ordinal.projected(ord10)
        #expect(result1?.rawValue == result2?.rawValue)
    }
}

// MARK: - Ordinal - Initializers

@Suite
struct `Ordinal - Initializers` {
    @Test(arguments: [0, 1, 2, 3, 4])
    func `init with valid value`(value: Int) {
        let ordinal: Ordinal<5>? = Ordinal(value)
        #expect(ordinal != nil)
        #expect(ordinal?.rawValue == value)
    }

    @Test(arguments: [-1, 5, 10, 100])
    func `init with invalid value returns nil`(value: Int) {
        let ordinal: Ordinal<5>? = Ordinal(value)
        #expect(ordinal == nil)
    }

    @Test(arguments: [0, 1, 2])
    func `init unchecked creates ordinal without validation`(value: Int) {
        let ordinal: Ordinal<5> = Ordinal(unchecked: value)
        #expect(ordinal.rawValue == value)
    }
}

// MARK: - Ordinal - Protocol Conformances

@Suite
struct `Ordinal - Protocol Conformances` {
    @Test
    func `Equatable reflexivity`() {
        let ord1: Ordinal<5> = Ordinal(2)!
        let ord2: Ordinal<5> = Ordinal(2)!
        let ord3: Ordinal<5> = Ordinal(3)!
        #expect(ord1 == ord2)
        #expect(ord1 != ord3)
    }

    @Test
    func `Hashable produces unique hashes`() {
        let set: Set<Ordinal<5>> = [Ordinal(0)!, Ordinal(1)!, Ordinal(0)!]
        #expect(set.count == 2)
    }

    @Test
    func `Comparable ordering`() {
        let ord1: Ordinal<5> = Ordinal(1)!
        let ord2: Ordinal<5> = Ordinal(3)!
        #expect(ord1 < ord2)
        #expect(ord2 > ord1)
    }

    @Test
    func `Enumerable caseCount`() {
        #expect(Ordinal<5>.caseCount == 5)
        #expect(Ordinal<10>.caseCount == 10)
    }

    @Test(arguments: [0, 1, 2, 3])
    func `Enumerable caseIndex`(index: Int) {
        let ordinal: Ordinal<5> = Ordinal(index)!
        #expect(ordinal.caseIndex == index)
    }

    @Test(arguments: [0, 1, 2, 3])
    func `Enumerable init from caseIndex`(index: Int) {
        let ordinal: Ordinal<5> = Ordinal(caseIndex: index)
        #expect(ordinal.rawValue == index)
    }

    @Test
    func `CaseIterable allCases`() {
        let allCases = Array(Ordinal<3>.allCases)
        #expect(allCases.count == 3)
        #expect(allCases[0].rawValue == 0)
        #expect(allCases[1].rawValue == 1)
        #expect(allCases[2].rawValue == 2)
    }
}

// MARK: - Ordinal - Array Subscripting

@Suite
struct `Ordinal - Array Subscripting` {
    @Test
    func `array subscript with ordinal`() {
        let array = ["a", "b", "c", "d", "e"]
        let index: Ordinal<5> = Ordinal(2)!
        #expect(array[index] == "c")
    }

    @Test(arguments: [0, 1, 2, 3])
    func `array subscript type safety`(value: Int) {
        let array = [10, 20, 30, 40]
        let index: Ordinal<4> = Ordinal(value)!
        let expected = array[value]
        #expect(array[index] == expected)
    }
}

// MARK: - Ordinal - Type Alias

@Suite
struct `Ordinal - Type Alias` {
    @Test
    func `Fin is alias for Ordinal`() {
        let ord: Ordinal<5> = Ordinal(2)!
        let fin: Fin<5> = Fin(2)!
        #expect(ord.rawValue == fin.rawValue)
    }
}
