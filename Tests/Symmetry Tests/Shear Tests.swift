// Shear Tests.swift

import Algebra_Linear
import Testing

@testable import Symmetry

@Suite
struct `Shear Tests` {

    // MARK: - Identity

    @Test
    func `Identity has all factors equal to 0`() {
        let identity = Shear<2, Double>.identity
        #expect(identity.x == 0)
        #expect(identity.y == 0)
    }

    // MARK: - Initialization

    @Test
    func `Initialize 2D shear with x and y`() {
        let shear = Shear<2, Double>(x: 0.5, y: 0.3)
        #expect(shear.x == 0.5)
        #expect(shear.y == 0.3)
    }

    @Test
    func `Initialize from matrix`() {
        var matrix = InlineArray<2, InlineArray<2, Double>>(
            repeating: InlineArray<2, Double>(repeating: 0)
        )
        matrix[0][1] = 0.7
        matrix[1][0] = 0.4
        let shear = Shear<2, Double>(matrix)

        #expect(shear.x == 0.7)
        #expect(shear.y == 0.4)
    }

    // MARK: - Convenience factory methods

    @Test
    func `Horizontal shear only affects x`() {
        let shear = Shear<2, Double>.horizontal(0.5)
        #expect(shear.x == 0.5)
        #expect(shear.y == 0)
    }

    @Test
    func `Vertical shear only affects y`() {
        let shear = Shear<2, Double>.vertical(0.3)
        #expect(shear.x == 0)
        #expect(shear.y == 0.3)
    }

    // MARK: - Properties

    @Test
    func `X property gets and sets correctly`() {
        var shear = Shear<2, Double>(x: 0.5, y: 0.3)
        #expect(shear.x == 0.5)

        shear.x = 0.8
        #expect(shear.x == 0.8)
        #expect(shear.y == 0.3)  // y unchanged
    }

    @Test
    func `Y property gets and sets correctly`() {
        var shear = Shear<2, Double>(x: 0.5, y: 0.3)
        #expect(shear.y == 0.3)

        shear.y = 0.9
        #expect(shear.y == 0.9)
        #expect(shear.x == 0.5)  // x unchanged
    }

    // MARK: - Equatable

    @Test
    func `Equal shears are equal`() {
        let shear1 = Shear<2, Double>(x: 0.5, y: 0.3)
        let shear2 = Shear<2, Double>(x: 0.5, y: 0.3)

        #expect(shear1 == shear2)
    }

    @Test
    func `Different shears are not equal`() {
        let shear1 = Shear<2, Double>(x: 0.5, y: 0.3)
        let shear2 = Shear<2, Double>(x: 0.5, y: 0.4)

        #expect(shear1 != shear2)
    }

    @Test
    func `Identity equals zero shear`() {
        let identity = Shear<2, Double>.identity
        let zero = Shear<2, Double>(x: 0, y: 0)

        #expect(identity == zero)
    }

    // MARK: - Linear conversion

    @Test
    func `Linear conversion produces correct matrix`() {
        let shear = Shear<2, Double>(x: 0.5, y: 0.3)
        let linear: Linear<Double, Void>.Matrix<2, 2> = shear.linear()

        #expect(linear.a == 1)      // diagonal
        #expect(linear.b == 0.5)    // x shear
        #expect(linear.c == 0.3)    // y shear
        #expect(linear.d == 1)      // diagonal
    }

    @Test
    func `Identity linear conversion produces identity matrix`() {
        let shear = Shear<2, Double>.identity
        let linear: Linear<Double, Void>.Matrix<2, 2> = shear.linear()

        #expect(linear.a == 1)
        #expect(linear.b == 0)
        #expect(linear.c == 0)
        #expect(linear.d == 1)
    }

    @Test
    func `Horizontal shear linear conversion`() {
        let shear = Shear<2, Double>.horizontal(0.7)
        let linear: Linear<Double, Void>.Matrix<2, 2> = shear.linear()

        #expect(linear.a == 1)
        #expect(linear.b == 0.7)
        #expect(linear.c == 0)
        #expect(linear.d == 1)
    }

    @Test
    func `Vertical shear linear conversion`() {
        let shear = Shear<2, Double>.vertical(0.4)
        let linear: Linear<Double, Void>.Matrix<2, 2> = shear.linear()

        #expect(linear.a == 1)
        #expect(linear.b == 0)
        #expect(linear.c == 0.4)
        #expect(linear.d == 1)
    }

    // MARK: - Matrix structure validation

    @Test
    func `Shear matrix has correct structure`() {
        let shear = Shear<2, Double>(x: 0.5, y: 0.3)

        // Off-diagonal elements
        #expect(shear.factors[0][1] == 0.5)  // x shear
        #expect(shear.factors[1][0] == 0.3)  // y shear
    }

    @Test
    func `Identity matrix has zeros in off-diagonal`() {
        let identity = Shear<2, Double>.identity

        #expect(identity.factors[0][1] == 0)
        #expect(identity.factors[1][0] == 0)
    }
}
