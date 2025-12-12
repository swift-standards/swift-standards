// Scale Tests.swift

import Algebra_Linear
import Testing

@testable import Symmetry

@Suite
struct `Scale Tests` {

    // MARK: - Identity

    @Test
    func `Identity has all factors equal to 1`() {
        let identity = Scale<2, Double>.identity
        #expect(identity.x == 1)
        #expect(identity.y == 1)
    }

    @Test
    func `Identity for 3D has all factors equal to 1`() {
        let identity = Scale<3, Double>.identity
        #expect(identity.x == 1)
        #expect(identity.y == 1)
        #expect(identity.z == 1)
    }

    // MARK: - Initialization

    @Test
    func `Initialize 2D scale with x and y`() {
        let scale = Scale<2, Double>(x: 2.0, y: 3.0)
        #expect(scale.x == 2.0)
        #expect(scale.y == 3.0)
    }

    @Test
    func `Initialize 3D scale with x, y, and z`() {
        let scale = Scale<3, Double>(x: 2.0, y: 3.0, z: 4.0)
        #expect(scale.x == 2.0)
        #expect(scale.y == 3.0)
        #expect(scale.z == 4.0)
    }

    @Test
    func `Initialize 1D scale with value`() {
        let scale = Scale<1, Double>(2.5)
        #expect(scale.value == 2.5)
    }

    @Test
    func `Initialize from array`() {
        let scale = Scale<2, Double>([1.5, 2.5])
        #expect(scale.x == 1.5)
        #expect(scale.y == 2.5)
    }

    // MARK: - Uniform scale

    @Test
    func `Uniform scale creates equal factors`() {
        let scale = Scale<2, Double>.uniform(3.0)
        #expect(scale.x == 3.0)
        #expect(scale.y == 3.0)
    }

    @Test
    func `Double preset is 2x uniform scale`() {
        let scale = Scale<2, Double>.double
        #expect(scale.x == 2)
        #expect(scale.y == 2)
    }

    @Test
    func `Half preset is 0.5x uniform scale`() {
        let scale = Scale<2, Double>.half
        #expect(scale.x == 0.5)
        #expect(scale.y == 0.5)
    }

    // MARK: - Subscript access

    @Test
    func `Subscript get returns correct factor`() {
        let scale = Scale<2, Double>(x: 1.5, y: 2.5)
        #expect(scale[0] == 1.5)
        #expect(scale[1] == 2.5)
    }

    @Test
    func `Subscript set updates factor`() {
        var scale = Scale<2, Double>(x: 1.0, y: 2.0)
        scale[0] = 3.0
        scale[1] = 4.0
        #expect(scale.x == 3.0)
        #expect(scale.y == 4.0)
    }

    // MARK: - Static concatenate function

    @Test
    func `Static concatenate multiplies factors component-wise`() {
        let scale1 = Scale<2, Double>(x: 2.0, y: 3.0)
        let scale2 = Scale<2, Double>(x: 4.0, y: 5.0)
        let result = Scale.concatenate(scale1, with: scale2)

        #expect(result.x == 8.0)  // 2 * 4
        #expect(result.y == 15.0) // 3 * 5
    }

    @Test
    func `Static concatenate with identity returns original`() {
        let scale = Scale<2, Double>(x: 2.5, y: 3.5)
        let identity = Scale<2, Double>.identity
        let result = Scale.concatenate(scale, with: identity)

        #expect(result.x == 2.5)
        #expect(result.y == 3.5)
    }

    @Test
    func `Concatenating instance method works`() {
        let scale1 = Scale<2, Double>(x: 2.0, y: 3.0)
        let scale2 = Scale<2, Double>(x: 1.5, y: 2.0)
        let result = scale1.concatenating(scale2)

        #expect(result.x == 3.0)  // 2 * 1.5
        #expect(result.y == 6.0)  // 3 * 2
    }

    // MARK: - Static inverted function

    @Test
    func `Static inverted returns reciprocal factors`() {
        let scale = Scale<2, Double>(x: 2.0, y: 4.0)
        let inverted = Scale.inverted(scale)

        #expect(inverted.x == 0.5)   // 1/2
        #expect(inverted.y == 0.25)  // 1/4
    }

    @Test
    func `Static inverted of identity is identity`() {
        let identity = Scale<2, Double>.identity
        let inverted = Scale.inverted(identity)

        #expect(inverted.x == 1)
        #expect(inverted.y == 1)
    }

    @Test
    func `Inverted instance property works`() {
        let scale = Scale<2, Double>(x: 5.0, y: 10.0)
        let inverted = scale.inverted

        #expect(inverted.x == 0.2)   // 1/5
        #expect(inverted.y == 0.1)   // 1/10
    }

    @Test
    func `Composition with inverse yields identity`() {
        let scale = Scale<2, Double>(x: 3.0, y: 7.0)
        let inverted = Scale.inverted(scale)
        let result = Scale.concatenate(scale, with: inverted)

        #expect(abs(result.x - 1.0) < 1e-10)
        #expect(abs(result.y - 1.0) < 1e-10)
    }

    @Test
    func `Double inversion returns original`() {
        let original = Scale<2, Double>(x: 2.5, y: 3.5)
        let inverted = Scale.inverted(original)
        let restored = Scale.inverted(inverted)

        #expect(abs(restored.x - original.x) < 1e-10)
        #expect(abs(restored.y - original.y) < 1e-10)
    }

    // MARK: - Equatable

    @Test
    func `Equal scales are equal`() {
        let scale1 = Scale<2, Double>(x: 2.0, y: 3.0)
        let scale2 = Scale<2, Double>(x: 2.0, y: 3.0)

        #expect(scale1 == scale2)
    }

    @Test
    func `Different scales are not equal`() {
        let scale1 = Scale<2, Double>(x: 2.0, y: 3.0)
        let scale2 = Scale<2, Double>(x: 2.0, y: 4.0)

        #expect(scale1 != scale2)
    }

    // MARK: - Linear conversion

    @Test
    func `Linear conversion produces diagonal matrix`() {
        let scale = Scale<2, Double>(x: 2.0, y: 3.0)
        let linear: Linear<Double, Void>.Matrix<2, 2> = scale.linear()

        #expect(linear.a == 2.0)
        #expect(linear.b == 0)
        #expect(linear.c == 0)
        #expect(linear.d == 3.0)
    }

    @Test
    func `Identity linear conversion produces identity matrix`() {
        let scale = Scale<2, Double>.identity
        let linear: Linear<Double, Void>.Matrix<2, 2> = scale.linear()

        #expect(linear.a == 1)
        #expect(linear.b == 0)
        #expect(linear.c == 0)
        #expect(linear.d == 1)
    }

    // MARK: - 1D literal initialization

    @Test
    func `1D scale from float literal`() {
        let scale: Scale<1, Double> = 2.5
        #expect(scale.value == 2.5)
    }

    @Test
    func `1D scale from integer literal`() {
        let scale: Scale<1, Double> = 3
        #expect(scale.value == 3.0)
    }
}
