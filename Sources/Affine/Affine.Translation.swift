// Affine.Translation.swift
// A 2D translation (displacement) in an affine space.

public import Algebra
public import Algebra_Linear
public import Dimension

extension Affine {
    /// Two-dimensional displacement in coordinate space.
    ///
    /// Represents directional offset rather than absolute position, distinguishing it from `Point`.
    /// Translation carries coordinate system units, unlike dimensionless transformations like rotation or scale.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let offset = Affine<Double>.Translation(dx: 72, dy: 144)
    /// let point = Affine<Double>.Point(x: 10, y: 20)
    /// let translated = point.translated(by: offset.vector)  // (82, 164)
    /// ```
    public struct Translation {
        /// Horizontal displacement component.
        public var dx: Linear<Scalar>.Dx

        /// Vertical displacement component.
        public var dy: Linear<Scalar>.Dy

        /// Creates translation from type-safe displacement components.
        @inlinable
        public init(dx: Linear<Scalar>.Dx, dy: Linear<Scalar>.Dy) {
            self.dx = dx
            self.dy = dy
        }
    }
}

extension Affine.Translation: Sendable where Scalar: Sendable {}
extension Affine.Translation: Equatable where Scalar: Equatable {}
extension Affine.Translation: Hashable where Scalar: Hashable {}

#if Codable
    extension Affine.Translation: Codable where Scalar: Codable {}
#endif

// MARK: - Convenience Initializers

extension Affine.Translation {
    /// Creates translation from raw scalar displacement values.
    @inlinable
    public init(dx: Scalar, dy: Scalar) {
        self.dx = Linear<Scalar>.Dx(dx)
        self.dy = Linear<Scalar>.Dy(dy)
    }

    /// Creates translation from 2D displacement vector.
    @inlinable
    public init(_ vector: Linear<Scalar>.Vector<2>) {
        self.dx = vector.dx
        self.dy = vector.dy
    }
}

// MARK: - Zero

extension Affine.Translation where Scalar: AdditiveArithmetic {
    /// Identity translation with no displacement.
    @inlinable
    public static var zero: Self {
        Self(dx: .zero, dy: .zero)
    }
}

// MARK: - AdditiveArithmetic

extension Affine.Translation: AdditiveArithmetic where Scalar: AdditiveArithmetic {
    @inlinable
    @_disfavoredOverload
    public static func + (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        Self(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }

    @inlinable
    @_disfavoredOverload
    public static func - (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        Self(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }
}

// MARK: - Negation

extension Affine.Translation where Scalar: SignedNumeric {
    /// Negates translation direction.
    @inlinable
    public static prefix func - (value: borrowing Self) -> Self {
        Self(dx: -value.dx, dy: -value.dy)
    }
}

// MARK: - Conversion to Vector

extension Affine.Translation {
    /// Converts translation to 2D displacement vector.
    @inlinable
    public var vector: Linear<Scalar>.Vector<2> {
        Linear<Scalar>.Vector(dx: dx, dy: dy)
    }
}
