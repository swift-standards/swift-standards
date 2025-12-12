// Clock Tests.swift

import StandardsTestSupport
import Testing

@testable import Region

@Suite("Clock - Rotation")
struct ClockRotationTests {
    @Test(arguments: Region.Clock.allCases)
    func `clockwise is cyclic`(clock: Region.Clock) {
        var current = clock
        for _ in 0..<12 {
            current = Region.Clock.clockwise(of: current)
        }
        #expect(current == clock)
    }

    @Test(arguments: Region.Clock.allCases)
    func `counterclockwise is cyclic`(clock: Region.Clock) {
        var current = clock
        for _ in 0..<12 {
            current = Region.Clock.counterclockwise(of: current)
        }
        #expect(current == clock)
    }

    @Test(arguments: Region.Clock.allCases)
    func `opposite is involution`(clock: Region.Clock) {
        let opposite = Region.Clock.opposite(of: clock)
        let oppositeOpposite = Region.Clock.opposite(of: opposite)
        #expect(oppositeOpposite == clock)
    }

    @Test(arguments: Region.Clock.allCases)
    func `opposite and prefix operator are equivalent`(clock: Region.Clock) {
        let staticOpposite = Region.Clock.opposite(of: clock)
        let prefixOpposite = !clock
        #expect(staticOpposite == prefixOpposite)
    }

    @Test
    func clockwiseSequence() {
        #expect(Region.Clock.twelve.clockwise == .one)
        #expect(Region.Clock.one.clockwise == .two)
        #expect(Region.Clock.six.clockwise == .seven)
        #expect(Region.Clock.eleven.clockwise == .twelve)
    }

    @Test
    func counterclockwiseSequence() {
        #expect(Region.Clock.twelve.counterclockwise == .eleven)
        #expect(Region.Clock.one.counterclockwise == .twelve)
        #expect(Region.Clock.six.counterclockwise == .five)
        #expect(Region.Clock.seven.counterclockwise == .six)
    }

    @Test
    func oppositeMapping() {
        #expect(Region.Clock.twelve.opposite == .six)
        #expect(Region.Clock.one.opposite == .seven)
        #expect(Region.Clock.three.opposite == .nine)
    }

    @Test
    func advanced() {
        #expect(Region.Clock.twelve.advanced(by: 1) == .one)
        #expect(Region.Clock.twelve.advanced(by: 6) == .six)
        #expect(Region.Clock.one.advanced(by: -1) == .twelve)
        #expect(Region.Clock.one.advanced(by: 12) == .one)
    }
}

@Suite("Clock - Quadrant")
struct ClockQuadrantTests {
    @Test(arguments: Region.Clock.allCases)
    func `quadrant property matches static function`(clock: Region.Clock) {
        let property = clock.quadrant
        let function = Region.Clock.quadrant(of: clock)
        #expect(property == function)
    }

    @Test
    func quadrantMapping() {
        // Quadrant I: 12, 1, 2
        #expect(Region.Clock.twelve.quadrant == .I)
        #expect(Region.Clock.one.quadrant == .I)
        #expect(Region.Clock.two.quadrant == .I)

        // Quadrant IV: 3, 4, 5
        #expect(Region.Clock.three.quadrant == .IV)
        #expect(Region.Clock.four.quadrant == .IV)
        #expect(Region.Clock.five.quadrant == .IV)

        // Quadrant III: 6, 7, 8
        #expect(Region.Clock.six.quadrant == .III)
        #expect(Region.Clock.seven.quadrant == .III)
        #expect(Region.Clock.eight.quadrant == .III)

        // Quadrant II: 9, 10, 11
        #expect(Region.Clock.nine.quadrant == .II)
        #expect(Region.Clock.ten.quadrant == .II)
        #expect(Region.Clock.eleven.quadrant == .II)
    }
}

@Suite("Clock - Cardinal Direction")
struct ClockCardinalTests {
    @Test(arguments: Region.Clock.allCases)
    func `nearestCardinal property matches static function`(clock: Region.Clock) {
        let property = clock.nearestCardinal
        let function = Region.Clock.nearestCardinal(of: clock)
        #expect(property == function)
    }

    @Test
    func nearestCardinalMapping() {
        // North: 12, 1, 11
        #expect(Region.Clock.twelve.nearestCardinal == .north)
        #expect(Region.Clock.one.nearestCardinal == .north)
        #expect(Region.Clock.eleven.nearestCardinal == .north)

        // East: 2, 3, 4
        #expect(Region.Clock.two.nearestCardinal == .east)
        #expect(Region.Clock.three.nearestCardinal == .east)
        #expect(Region.Clock.four.nearestCardinal == .east)

        // South: 5, 6, 7
        #expect(Region.Clock.five.nearestCardinal == .south)
        #expect(Region.Clock.six.nearestCardinal == .south)
        #expect(Region.Clock.seven.nearestCardinal == .south)

        // West: 8, 9, 10
        #expect(Region.Clock.eight.nearestCardinal == .west)
        #expect(Region.Clock.nine.nearestCardinal == .west)
        #expect(Region.Clock.ten.nearestCardinal == .west)
    }
}

@Suite("Clock - Position Properties")
struct ClockPositionTests {
    @Test(arguments: Region.Clock.allCases)
    func `isCardinal property matches static function`(clock: Region.Clock) {
        let property = clock.isCardinal
        let function = Region.Clock.isCardinal(clock)
        #expect(property == function)
    }

    @Test(arguments: Region.Clock.allCases)
    func `isOrdinal property matches static function`(clock: Region.Clock) {
        let property = clock.isOrdinal
        let function = Region.Clock.isOrdinal(clock)
        #expect(property == function)
    }

    @Test(arguments: Region.Clock.allCases)
    func `isUpperHalf property matches static function`(clock: Region.Clock) {
        let property = clock.isUpperHalf
        let function = Region.Clock.isUpperHalf(clock)
        #expect(property == function)
    }

    @Test(arguments: Region.Clock.allCases)
    func `isRightHalf property matches static function`(clock: Region.Clock) {
        let property = clock.isRightHalf
        let function = Region.Clock.isRightHalf(clock)
        #expect(property == function)
    }

    @Test
    func cardinalPositions() {
        #expect(Region.Clock.twelve.isCardinal == true)
        #expect(Region.Clock.three.isCardinal == true)
        #expect(Region.Clock.six.isCardinal == true)
        #expect(Region.Clock.nine.isCardinal == true)
        #expect(Region.Clock.one.isCardinal == false)
        #expect(Region.Clock.two.isCardinal == false)
    }

    @Test
    func ordinalPositions() {
        #expect(Region.Clock.one.isOrdinal == true)
        #expect(Region.Clock.two.isOrdinal == true)
        #expect(Region.Clock.four.isOrdinal == true)
        #expect(Region.Clock.twelve.isOrdinal == false)
        #expect(Region.Clock.three.isOrdinal == false)
    }

    @Test
    func cardinalAndOrdinalAreMutuallyExclusive() {
        for clock in Region.Clock.allCases {
            let isCardinal = clock.isCardinal
            let isOrdinal = clock.isOrdinal
            #expect(isCardinal != isOrdinal)
        }
    }

    @Test
    func upperHalfPositions() {
        #expect(Region.Clock.ten.isUpperHalf == true)
        #expect(Region.Clock.eleven.isUpperHalf == true)
        #expect(Region.Clock.twelve.isUpperHalf == true)
        #expect(Region.Clock.one.isUpperHalf == true)
        #expect(Region.Clock.two.isUpperHalf == true)

        #expect(Region.Clock.three.isUpperHalf == false)
        #expect(Region.Clock.six.isUpperHalf == false)
        #expect(Region.Clock.nine.isUpperHalf == false)
    }

    @Test
    func rightHalfPositions() {
        #expect(Region.Clock.one.isRightHalf == true)
        #expect(Region.Clock.two.isRightHalf == true)
        #expect(Region.Clock.three.isRightHalf == true)
        #expect(Region.Clock.four.isRightHalf == true)
        #expect(Region.Clock.five.isRightHalf == true)

        #expect(Region.Clock.six.isRightHalf == false)
        #expect(Region.Clock.nine.isRightHalf == false)
        #expect(Region.Clock.twelve.isRightHalf == false)
    }
}
