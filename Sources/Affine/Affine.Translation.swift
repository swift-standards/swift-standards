// Affine.Translation.swift
// A 2D translation (displacement) in an affine space.

public import Algebra_Linear

extension Affine {
    /// A 2D translation (displacement) in an affine space.
    ///
    /// Translation is parameterized by the scalar type because it represents
    /// an actual displacement in the coordinate system - unlike rotation or
    /// scale which are dimensionless.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let offset: Affine<Double>.Translation = .init(x: 72, y: 144)
    /// ```
    public struct Translation {
        /// Horizontal displacement
        public var x: Affine.X

        /// Vertical displacement
        public var y: Affine.Y

        /// Create a translation with typed X and Y components
        @inlinable
        public init(x: Affine.X, y: Affine.Y) {
            self.x = x
            self.y = y
        }
    }
}

extension Affine.Translation: Sendable where Scalar: Sendable {}
extension Affine.Translation: Equatable where Scalar: Equatable {}
extension Affine.Translation: Hashable where Scalar: Hashable {}
extension Affine.Translation: Codable where Scalar: Codable {}

// MARK: - Convenience Initializers

extension Affine.Translation {
    /// Create a translation from raw scalar values
    @inlinable
    public init(x: Scalar, y: Scalar) {
        self.x = Affine.X(x)
        self.y = Affine.Y(y)
    }

    /// Create a translation from a vector
    @inlinable
    public init(_ vector: Linear<Scalar>.Vector<2>) {
        self.x = Affine.X(vector.dx)
        self.y = Affine.Y(vector.dy)
    }
}

// MARK: - Zero

extension Affine.Translation where Scalar: AdditiveArithmetic {
    /// Zero translation (no displacement)
    @inlinable
    public static var zero: Self {
        Self(x: .zero, y: .zero)
    }
}

// MARK: - AdditiveArithmetic

extension Affine.Translation: AdditiveArithmetic where Scalar: AdditiveArithmetic {
    @inlinable
    @_disfavoredOverload
    public static func + (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        Self(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    @inlinable
    @_disfavoredOverload
    public static func - (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        Self(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}

// MARK: - Negation

extension Affine.Translation where Scalar: SignedNumeric {
    /// Negate the translation
    @inlinable
    public static prefix func - (value: borrowing Self) -> Self {
        Self(x: -value.x, y: -value.y)
    }
}

// MARK: - Conversion to Vector

extension Affine.Translation {
    /// Convert to a 2D vector
    @inlinable
    public var vector: Linear<Scalar>.Vector<2> {
        Linear<Scalar>.Vector(dx: x.value, dy: y.value)
    }
}
