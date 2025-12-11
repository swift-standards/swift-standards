// Affine.Transform.swift
// A 2D affine transformation: linear transformation + translation.

public import Algebra_Linear
public import Angle
public import RealModule

extension Affine {
    /// A 2D affine transformation.
    ///
    /// An affine transformation consists of:
    /// - A **linear** part (rotation, scale, shear) - dimensionless
    /// - A **translation** part - in coordinate system units
    ///
    /// The matrix representation is:
    /// ```
    /// | a  b  tx |     | linear    translation |
    /// | c  d  ty |  =  |                       |
    /// | 0  0  1  |     | 0  0  1               |
    /// ```
    ///
    /// ## Dimensional Analysis
    ///
    /// For a point transformation `(x', y') = (x, y) * M + (tx, ty)`:
    /// ```
    /// x' = a*x + c*y + tx
    /// y' = b*x + d*y + ty
    /// ```
    /// - Linear coefficients `(a, b, c, d)` are dimensionless ratios
    /// - Translation `(tx, ty)` has the same units as coordinates
    ///
    /// ## Example
    ///
    /// ```swift
    /// let transform = Affine<Double>.Transform(
    ///     linear: .identity,
    ///     translation: .init(x: 100, y: 50)
    /// )
    /// ```
    public struct Transform {
        /// The linear transformation (rotation, scale, shear) as a 2x2 matrix
        public var linear: Linear<Scalar>.Matrix<2, 2>

        /// The translation (displacement)
        public var translation: Translation

        /// Create an affine transform from linear and translation components
        @inlinable
        public init(linear: Linear<Scalar>.Matrix<2, 2>, translation: Translation) {
            self.linear = linear
            self.translation = translation
        }
    }
}

extension Affine.Transform: Sendable where Scalar: Sendable {}
extension Affine.Transform: Equatable where Scalar: Equatable {}
extension Affine.Transform: Hashable where Scalar: Hashable {}

// MARK: - Codable

extension Affine.Transform: Codable where Scalar: Codable {
    private enum CodingKeys: String, CodingKey {
        case a, b, c, d, tx, ty
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let a = try container.decode(Scalar.self, forKey: .a)
        let b = try container.decode(Scalar.self, forKey: .b)
        let c = try container.decode(Scalar.self, forKey: .c)
        let d = try container.decode(Scalar.self, forKey: .d)
        let tx = try container.decode(Scalar.self, forKey: .tx)
        let ty = try container.decode(Scalar.self, forKey: .ty)
        self.init(a: a, b: b, c: c, d: d, tx: tx, ty: ty)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(a, forKey: .a)
        try container.encode(b, forKey: .b)
        try container.encode(c, forKey: .c)
        try container.encode(d, forKey: .d)
        try container.encode(tx.value, forKey: .tx)
        try container.encode(ty.value, forKey: .ty)
    }
}

// MARK: - Identity

extension Affine.Transform where Scalar: AdditiveArithmetic & ExpressibleByIntegerLiteral {
    /// The identity transform (no transformation)
    @inlinable
    public static var identity: Self {
        Self(linear: .identity, translation: .zero)
    }
}

// MARK: - Convenience Initializers

extension Affine.Transform where Scalar: AdditiveArithmetic {
    /// Create from just a linear transformation (no translation)
    @inlinable
    public init(linear: Linear<Scalar>.Matrix<2, 2>) {
        self.init(linear: linear, translation: .zero)
    }
}

extension Affine.Transform where Scalar: AdditiveArithmetic & ExpressibleByIntegerLiteral {
    /// Create from just a translation (identity linear)
    @inlinable
    public init(translation: Affine.Translation) {
        self.init(linear: .identity, translation: translation)
    }
}

// MARK: - Component Access (Standard Notation)

extension Affine.Transform {
    /// Linear coefficient a (row 0, col 0)
    @inlinable
    public var a: Scalar {
        get { linear.a }
        set { linear.a = newValue }
    }

    /// Linear coefficient b (row 0, col 1)
    @inlinable
    public var b: Scalar {
        get { linear.b }
        set { linear.b = newValue }
    }

    /// Linear coefficient c (row 1, col 0)
    @inlinable
    public var c: Scalar {
        get { linear.c }
        set { linear.c = newValue }
    }

    /// Linear coefficient d (row 1, col 1)
    @inlinable
    public var d: Scalar {
        get { linear.d }
        set { linear.d = newValue }
    }

    /// Translation x component (type-safe)
    @inlinable
    public var tx: Affine.X {
        get { translation.x }
        set { translation.x = newValue }
    }

    /// Translation y component (type-safe)
    @inlinable
    public var ty: Affine.Y {
        get { translation.y }
        set { translation.y = newValue }
    }
}

// MARK: - Raw Component Initializer

extension Affine.Transform {
    /// Create an affine transform with raw matrix components
    ///
    /// - Parameters:
    ///   - a, b, c, d: Dimensionless linear transformation coefficients
    ///   - tx, ty: Translation in coordinate units (raw scalar values)
    @inlinable
    public init(a: Scalar, b: Scalar, c: Scalar, d: Scalar, tx: Scalar, ty: Scalar) {
        self.linear = Linear<Scalar>.Matrix(a: a, b: b, c: c, d: d)
        self.translation = Affine.Translation(x: tx, y: ty)
    }

    /// Create an affine transform with typed translation components
    ///
    /// - Parameters:
    ///   - a, b, c, d: Dimensionless linear transformation coefficients
    ///   - tx, ty: Translation in coordinate units (type-safe)
    @inlinable
    public init(a: Scalar, b: Scalar, c: Scalar, d: Scalar, tx: Affine.X, ty: Affine.Y) {
        self.linear = Linear<Scalar>.Matrix(a: a, b: b, c: c, d: d)
        self.translation = Affine.Translation(x: tx, y: ty)
    }
}

// MARK: - Composition

extension Affine.Transform where Scalar: FloatingPoint {
    /// Concatenate with another transform (self * other)
    ///
    /// The resulting transform applies `other` first, then `self`.
    @inlinable
    public func concatenating(_ other: Self) -> Self {
        // Linear part: matrix multiplication
        let newLinear = linear.multiplied(by: other.linear)

        // Translation part: apply self's linear to other's translation, then add self's translation
        let otherTx = other.translation.x.value
        let otherTy = other.translation.y.value
        let newTx = linear.a * otherTx + linear.b * otherTy + translation.x.value
        let newTy = linear.c * otherTx + linear.d * otherTy + translation.y.value

        return Self(
            linear: newLinear,
            translation: Affine.Translation(x: newTx, y: newTy)
        )
    }
}

// MARK: - Factory Methods

extension Affine.Transform where Scalar: FloatingPoint & ExpressibleByIntegerLiteral {
    /// Create a translation transform
    @inlinable
    public static func translation(x: Scalar, y: Scalar) -> Self {
        Self(linear: .identity, translation: Affine.Translation(x: x, y: y))
    }

    /// Create a translation transform from a vector
    @inlinable
    public static func translation(_ vector: Linear<Scalar>.Vector<2>) -> Self {
        Self(translation: Affine.Translation(vector))
    }

    /// Create a uniform scaling transform
    @inlinable
    public static func scale(_ factor: Scalar) -> Self {
        Self(linear: Linear<Scalar>.Matrix(a: factor, b: 0, c: 0, d: factor))
    }

    /// Create a non-uniform scaling transform
    @inlinable
    public static func scale(x: Scalar, y: Scalar) -> Self {
        Self(linear: Linear<Scalar>.Matrix(a: x, b: 0, c: 0, d: y))
    }

    /// Create a shear transform
    @inlinable
    public static func shear(x: Scalar, y: Scalar) -> Self {
        Self(linear: Linear<Scalar>.Matrix(a: 1, b: x, c: y, d: 1))
    }
}

// MARK: - Rotation Factory (Real & BinaryFloatingPoint)

extension Affine.Transform where Scalar: Real & BinaryFloatingPoint {
    /// Create a rotation transform
    @inlinable
    public static func rotation(_ angle: Radian) -> Self {
        let c = Scalar(angle.cos)
        let s = Scalar(angle.sin)
        return Self(linear: Linear<Scalar>.Matrix(a: c, b: -s, c: s, d: c), translation: .zero)
    }

    /// Create a rotation transform from degrees
    @inlinable
    public static func rotation(_ angle: Degree) -> Self {
        rotation(angle.radians)
    }
}

// MARK: - Fluent Modifiers

extension Affine.Transform where Scalar: FloatingPoint & ExpressibleByIntegerLiteral {
    /// Return a new transform with translation applied
    @inlinable
    public func translated(x: Scalar, y: Scalar) -> Self {
        concatenating(.translation(x: x, y: y))
    }

    /// Return a new transform with translation applied
    @inlinable
    public func translated(by vector: Linear<Scalar>.Vector<2>) -> Self {
        concatenating(.translation(vector))
    }

    /// Return a new transform with uniform scaling applied
    @inlinable
    public func scaled(by factor: Scalar) -> Self {
        concatenating(.scale(factor))
    }

    /// Return a new transform with non-uniform scaling applied
    @inlinable
    public func scaled(x: Scalar, y: Scalar) -> Self {
        concatenating(.scale(x: x, y: y))
    }
}

extension Affine.Transform where Scalar: Real & BinaryFloatingPoint {
    /// Return a new transform with rotation applied
    @inlinable
    public func rotated(by angle: Radian) -> Self {
        concatenating(.rotation(angle))
    }

    /// Return a new transform with rotation applied
    @inlinable
    public func rotated(by angle: Degree) -> Self {
        concatenating(.rotation(angle))
    }
}

// MARK: - Inversion

extension Affine.Transform where Scalar: FloatingPoint {
    /// The determinant of the linear part
    @inlinable
    public var determinant: Scalar {
        linear.determinant
    }

    /// Whether this transform is invertible
    @inlinable
    public var isInvertible: Bool {
        determinant != 0
    }

    /// The inverse transform, or nil if not invertible
    @inlinable
    public var inverted: Self? {
        guard let invLinear = linear.inverse else { return nil }

        // inv(T) = -inv(L) * t
        let tx = translation.x.value
        let ty = translation.y.value
        let newTx = -(invLinear.a * tx + invLinear.b * ty)
        let newTy = -(invLinear.c * tx + invLinear.d * ty)

        return Self(
            linear: invLinear,
            translation: Affine.Translation(x: newTx, y: newTy)
        )
    }
}

// MARK: - Apply Transform

extension Affine.Transform where Scalar: FloatingPoint {
    /// Apply transform to a point
    @inlinable
    public func apply(to point: Affine.Point<2>) -> Affine.Point<2> {
        let px = point.x.value
        let py = point.y.value
        let newX = linear.a * px + linear.b * py + translation.x.value
        let newY = linear.c * px + linear.d * py + translation.y.value
        return Affine.Point(x: Affine.X(newX), y: Affine.Y(newY))
    }

    /// Apply transform to a vector (ignores translation)
    @inlinable
    public func apply(to vector: Linear<Scalar>.Vector<2>) -> Linear<Scalar>.Vector<2> {
        let vx = vector.dx
        let vy = vector.dy
        let newDx = linear.a * vx + linear.b * vy
        let newDy = linear.c * vx + linear.d * vy
        return Linear<Scalar>.Vector(dx: newDx, dy: newDy)
    }
}

// MARK: - Monoid

extension Affine.Transform where Scalar: FloatingPoint & ExpressibleByIntegerLiteral {
    /// Compose multiple transforms into a single transform.
    ///
    /// Due to right-to-left matrix multiplication, transforms are applied
    /// in **reverse** order: the last transform in the array is applied first.
    ///
    /// For forward-order application, reverse the array before calling.
    @inlinable
    public static func composed(_ transforms: [Self]) -> Self {
        transforms.reduce(.identity) { $0.concatenating($1) }
    }

    /// Compose multiple transforms into a single transform
    @inlinable
    public static func composed(_ transforms: Self...) -> Self {
        composed(transforms)
    }
}
