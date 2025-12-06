// EnumTests.swift
// Tests for Geometry enum types: Quadrant, Octant, Cardinal, Corner, Edge, Curvature

import Testing
import Algebra
@testable import Geometry

// MARK: - Quadrant Tests

@Suite
struct QuadrantTests {
    @Test
    func `Quadrant cases`() {
        #expect(Quadrant.allCases.count == 4)
        #expect(Quadrant.allCases.contains(.I))
        #expect(Quadrant.allCases.contains(.II))
        #expect(Quadrant.allCases.contains(.III))
        #expect(Quadrant.allCases.contains(.IV))
    }

    @Test
    func `Quadrant opposite is 180 degree rotation`() {
        #expect(Quadrant.I.opposite == .III)
        #expect(Quadrant.II.opposite == .IV)
        #expect(Quadrant.III.opposite == .I)
        #expect(Quadrant.IV.opposite == .II)
    }

    @Test
    func `Quadrant opposite is involution`() {
        for q in Quadrant.allCases {
            #expect(q.opposite.opposite == q)
        }
    }

    @Test
    func `Quadrant negation operator`() {
        #expect(!Quadrant.I == .III)
        #expect(!Quadrant.II == .IV)
    }

    @Test
    func `Quadrant rotation`() {
        // Next (counterclockwise)
        #expect(Quadrant.I.next == .II)
        #expect(Quadrant.II.next == .III)
        #expect(Quadrant.III.next == .IV)
        #expect(Quadrant.IV.next == .I)

        // Previous (clockwise)
        #expect(Quadrant.I.previous == .IV)
        #expect(Quadrant.II.previous == .I)
        #expect(Quadrant.III.previous == .II)
        #expect(Quadrant.IV.previous == .III)

        // Four rotations return to start
        var q = Quadrant.I
        q = q.next.next.next.next
        #expect(q == .I)
    }

    @Test
    func `Quadrant sign properties`() {
        #expect(Quadrant.I.hasPositiveX == true)
        #expect(Quadrant.I.hasPositiveY == true)
        #expect(Quadrant.II.hasPositiveX == false)
        #expect(Quadrant.II.hasPositiveY == true)
        #expect(Quadrant.III.hasPositiveX == false)
        #expect(Quadrant.III.hasPositiveY == false)
        #expect(Quadrant.IV.hasPositiveX == true)
        #expect(Quadrant.IV.hasPositiveY == false)
    }

    @Test
    func `Quadrant Value typealias`() {
        let tagged: Quadrant.Value<String> = .init(tag: .I, value: "first")
        #expect(tagged.tag == .I)
        #expect(tagged.value == "first")
    }
}

// MARK: - Octant Tests

@Suite
struct OctantTests {
    @Test
    func `Octant cases`() {
        #expect(Octant.allCases.count == 8)
    }

    @Test
    func `Octant opposite is reflection through origin`() {
        #expect(Octant.ppp.opposite == .nnn)
        #expect(Octant.ppn.opposite == .nnp)
        #expect(Octant.pnp.opposite == .npn)
        #expect(Octant.pnn.opposite == .npp)
        #expect(Octant.npp.opposite == .pnn)
        #expect(Octant.npn.opposite == .pnp)
        #expect(Octant.nnp.opposite == .ppn)
        #expect(Octant.nnn.opposite == .ppp)
    }

    @Test
    func `Octant opposite is involution`() {
        for o in Octant.allCases {
            #expect(o.opposite.opposite == o)
        }
    }

    @Test
    func `Octant negation operator`() {
        #expect(!Octant.ppp == .nnn)
        #expect(!(!Octant.ppp) == .ppp)
    }

    @Test
    func `Octant sign properties`() {
        // Test ppp
        #expect(Octant.ppp.hasPositiveX == true)
        #expect(Octant.ppp.hasPositiveY == true)
        #expect(Octant.ppp.hasPositiveZ == true)

        // Test nnn
        #expect(Octant.nnn.hasPositiveX == false)
        #expect(Octant.nnn.hasPositiveY == false)
        #expect(Octant.nnn.hasPositiveZ == false)

        // Test mixed
        #expect(Octant.pnp.hasPositiveX == true)
        #expect(Octant.pnp.hasPositiveY == false)
        #expect(Octant.pnp.hasPositiveZ == true)
    }

    @Test
    func `Octant Value typealias`() {
        let tagged: Octant.Value<Int> = .init(tag: .ppp, value: 1)
        #expect(tagged.tag == .ppp)
        #expect(tagged.value == 1)
    }
}

// MARK: - Cardinal Tests

@Suite
struct CardinalTests {
    @Test
    func `Cardinal cases`() {
        #expect(Cardinal.allCases.count == 4)
        #expect(Cardinal.allCases.contains(.north))
        #expect(Cardinal.allCases.contains(.east))
        #expect(Cardinal.allCases.contains(.south))
        #expect(Cardinal.allCases.contains(.west))
    }

    @Test
    func `Cardinal opposite is 180 degree rotation`() {
        #expect(Cardinal.north.opposite == .south)
        #expect(Cardinal.south.opposite == .north)
        #expect(Cardinal.east.opposite == .west)
        #expect(Cardinal.west.opposite == .east)
    }

    @Test
    func `Cardinal opposite is involution`() {
        for c in Cardinal.allCases {
            #expect(c.opposite.opposite == c)
        }
    }

    @Test
    func `Cardinal negation operator`() {
        #expect(!Cardinal.north == .south)
        #expect(!Cardinal.east == .west)
    }

    @Test
    func `Cardinal rotation forms Z4 group`() {
        // Clockwise rotation
        #expect(Cardinal.north.clockwise == .east)
        #expect(Cardinal.east.clockwise == .south)
        #expect(Cardinal.south.clockwise == .west)
        #expect(Cardinal.west.clockwise == .north)

        // Counterclockwise rotation
        #expect(Cardinal.north.counterclockwise == .west)
        #expect(Cardinal.west.counterclockwise == .south)
        #expect(Cardinal.south.counterclockwise == .east)
        #expect(Cardinal.east.counterclockwise == .north)

        // Four rotations return to start
        var c = Cardinal.north
        c = c.clockwise.clockwise.clockwise.clockwise
        #expect(c == .north)
    }

    @Test
    func `Cardinal axis properties`() {
        #expect(Cardinal.north.isVertical == true)
        #expect(Cardinal.south.isVertical == true)
        #expect(Cardinal.east.isHorizontal == true)
        #expect(Cardinal.west.isHorizontal == true)

        #expect(Cardinal.north.isHorizontal == false)
        #expect(Cardinal.east.isVertical == false)
    }

    @Test
    func `Cardinal Value typealias`() {
        let tagged: Cardinal.Value<Double> = .init(tag: .north, value: 100.0)
        #expect(tagged.tag == .north)
        #expect(tagged.value == 100.0)
    }
}

// MARK: - Corner Tests

@Suite
struct CornerTests {
    @Test
    func `Corner cases`() {
        #expect(Corner.allCases.count == 4)
        #expect(Corner.allCases.contains(.topLeading))
        #expect(Corner.allCases.contains(.topTrailing))
        #expect(Corner.allCases.contains(.bottomLeading))
        #expect(Corner.allCases.contains(.bottomTrailing))
    }

    @Test
    func `Corner opposite is diagonal`() {
        #expect(Corner.topLeading.opposite == .bottomTrailing)
        #expect(Corner.topTrailing.opposite == .bottomLeading)
        #expect(Corner.bottomLeading.opposite == .topTrailing)
        #expect(Corner.bottomTrailing.opposite == .topLeading)
    }

    @Test
    func `Corner opposite is involution`() {
        for c in Corner.allCases {
            #expect(c.opposite.opposite == c)
        }
    }

    @Test
    func `Corner negation operator`() {
        #expect(!Corner.topLeading == .bottomTrailing)
        #expect(!(!Corner.topLeading) == .topLeading)
    }

    @Test
    func `Corner position properties`() {
        #expect(Corner.topLeading.isTop == true)
        #expect(Corner.topTrailing.isTop == true)
        #expect(Corner.bottomLeading.isTop == false)
        #expect(Corner.bottomTrailing.isTop == false)

        #expect(Corner.topLeading.isBottom == false)
        #expect(Corner.bottomLeading.isBottom == true)

        #expect(Corner.topLeading.isLeading == true)
        #expect(Corner.bottomLeading.isLeading == true)
        #expect(Corner.topTrailing.isLeading == false)

        #expect(Corner.topTrailing.isTrailing == true)
        #expect(Corner.bottomTrailing.isTrailing == true)
    }

    @Test
    func `Corner adjacent corners`() {
        #expect(Corner.topLeading.horizontalAdjacent == .topTrailing)
        #expect(Corner.topLeading.verticalAdjacent == .bottomLeading)
        #expect(Corner.bottomTrailing.horizontalAdjacent == .bottomLeading)
        #expect(Corner.bottomTrailing.verticalAdjacent == .topTrailing)
    }

    @Test
    func `Corner Value typealias`() {
        let tagged: Corner.Value<Double> = .init(tag: .topLeading, value: 8.0)
        #expect(tagged.tag == .topLeading)
        #expect(tagged.value == 8.0)
    }
}

// MARK: - Edge Tests

@Suite
struct EdgeTests {
    @Test
    func `Edge cases`() {
        #expect(Edge.allCases.count == 4)
        #expect(Edge.allCases.contains(.top))
        #expect(Edge.allCases.contains(.leading))
        #expect(Edge.allCases.contains(.bottom))
        #expect(Edge.allCases.contains(.trailing))
    }

    @Test
    func `Edge opposite`() {
        #expect(Edge.top.opposite == .bottom)
        #expect(Edge.bottom.opposite == .top)
        #expect(Edge.leading.opposite == .trailing)
        #expect(Edge.trailing.opposite == .leading)
    }

    @Test
    func `Edge opposite is involution`() {
        for e in Edge.allCases {
            #expect(e.opposite.opposite == e)
        }
    }

    @Test
    func `Edge negation operator`() {
        #expect(!Edge.top == .bottom)
        #expect(!Edge.leading == .trailing)
    }

    @Test
    func `Edge orientation properties`() {
        #expect(Edge.top.isHorizontal == true)
        #expect(Edge.bottom.isHorizontal == true)
        #expect(Edge.leading.isHorizontal == false)
        #expect(Edge.trailing.isHorizontal == false)

        #expect(Edge.leading.isVertical == true)
        #expect(Edge.trailing.isVertical == true)
        #expect(Edge.top.isVertical == false)
        #expect(Edge.bottom.isVertical == false)
    }

    @Test
    func `Edge corners`() {
        let topCorners = Edge.top.corners
        #expect(topCorners.0 == .topLeading)
        #expect(topCorners.1 == .topTrailing)

        let bottomCorners = Edge.bottom.corners
        #expect(bottomCorners.0 == .bottomLeading)
        #expect(bottomCorners.1 == .bottomTrailing)

        let leadingCorners = Edge.leading.corners
        #expect(leadingCorners.0 == .topLeading)
        #expect(leadingCorners.1 == .bottomLeading)

        let trailingCorners = Edge.trailing.corners
        #expect(trailingCorners.0 == .topTrailing)
        #expect(trailingCorners.1 == .bottomTrailing)
    }

    @Test
    func `Edge Value typealias`() {
        let tagged: Edge.Value<Double> = .init(tag: .top, value: 20.0)
        #expect(tagged.tag == .top)
        #expect(tagged.value == 20.0)
    }
}

// MARK: - Curvature Tests

@Suite
struct CurvatureTests {
    @Test
    func `Curvature cases`() {
        #expect(Curvature.allCases.count == 2)
        #expect(Curvature.allCases.contains(.convex))
        #expect(Curvature.allCases.contains(.concave))
    }

    @Test
    func `Curvature opposite is involution`() {
        #expect(Curvature.convex.opposite == .concave)
        #expect(Curvature.concave.opposite == .convex)
        #expect(Curvature.convex.opposite.opposite == .convex)
    }

    @Test
    func `Curvature negation operator`() {
        #expect(!Curvature.convex == .concave)
        #expect(!Curvature.concave == .convex)
        #expect(!(!Curvature.convex) == .convex)
    }

    @Test
    func `Curvature Value typealias`() {
        let tagged: Curvature.Value<Double> = .init(tag: .convex, value: 0.5)
        #expect(tagged.tag == .convex)
        #expect(tagged.value == 0.5)
    }

    @Test
    func `Curvature Hashable`() {
        let set: Set<Curvature> = [.convex, .concave, .convex]
        #expect(set.count == 2)
    }
}
