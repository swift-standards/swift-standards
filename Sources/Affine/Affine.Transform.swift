// Affine.Transform.swift
// A 2D affine transformation: linear transformation + translation.

public import Algebra
public import Algebra_Linear
public import Angle
public import Dimension
public import RealModule

extension Affine {
    /// Two-dimensional affine transformation combining linear transformation and translation.
    ///
    /// Represents composition of dimensionless linear operations (rotation, scale, shear) with
    /// coordinate-space translation, enabling complete 2D geometric transformations.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let transform = Affine<Double>.Transform
    ///     .rotation(.degrees(45))
    ///     .scaled(by: 2.0)
    ///     .translated(x: 100, y: 50)
    /// let transformed = transform.apply(to: point)
    /// ```
    public struct Transform {
        /// Linear transformation matrix for rotation, scale, and shear operations.
        public var linear: Linear<Scalar, Space>.Matrix<2, 2>

        /// Translation displacement applied after linear transformation.
        public var translation: Translation

        /// Creates affine transform from linear and translation components.
        @inlinable
        public init(linear: Linear<Scalar, Space>.Matrix<2, 2>, translation: Translation) {
            self.linear = linear
            self.translation = translation
        }
    }
}

extension Affine.Transform: Sendable where Scalar: Sendable {}
extension Affine.Transform: Equatable where Scalar: Equatable {}
extension Affine.Transform: Hashable where Scalar: Hashable {}

// MARK: - Codable

#if Codable
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
#endif

// MARK: - Identity

extension Affine.Transform where Scalar: AdditiveArithmetic & ExpressibleByIntegerLiteral {
    /// Identity transform that leaves points unchanged.
    @inlinable
    public static var identity: Self {
        Self(linear: .identity, translation: .zero)
    }
}

// MARK: - Convenience Initializers

extension Affine.Transform where Scalar: AdditiveArithmetic {
    /// Creates transform with linear transformation and zero translation.
    @inlinable
    public init(linear: Linear<Scalar, Space>.Matrix<2, 2>) {
        self.init(linear: linear, translation: .zero)
    }
}

extension Affine.Transform where Scalar: AdditiveArithmetic & ExpressibleByIntegerLiteral {
    /// Creates transform with translation and identity linear transformation.
    @inlinable
    public init(translation: Affine.Translation) {
        self.init(linear: .identity, translation: translation)
    }
}

// MARK: - Component Access (Standard Notation)

extension Affine.Transform {
    /// Matrix element at row 0, column 0.
    @inlinable
    public var a: Scalar {
        get { linear.a }
        set { linear.a = newValue }
    }

    /// Matrix element at row 0, column 1.
    @inlinable
    public var b: Scalar {
        get { linear.b }
        set { linear.b = newValue }
    }

    /// Matrix element at row 1, column 0.
    @inlinable
    public var c: Scalar {
        get { linear.c }
        set { linear.c = newValue }
    }

    /// Matrix element at row 1, column 1.
    @inlinable
    public var d: Scalar {
        get { linear.d }
        set { linear.d = newValue }
    }

    /// Horizontal translation displacement component.
    @inlinable
    public var tx: Linear<Scalar, Space>.Dx {
        get { translation.dx }
        set { translation.dx = newValue }
    }

    /// Vertical translation displacement component.
    @inlinable
    public var ty: Linear<Scalar, Space>.Dy {
        get { translation.dy }
        set { translation.dy = newValue }
    }
}

// MARK: - Raw Component Initializer

extension Affine.Transform {
    /// Creates transform from raw matrix components.
    ///
    /// - Parameters:
    ///   - a, b, c, d: Linear transformation coefficients
    ///   - tx, ty: Translation displacement components
    @inlinable
    public init(a: Scalar, b: Scalar, c: Scalar, d: Scalar, tx: Scalar, ty: Scalar) {
        self.linear = Linear<Scalar, Space>.Matrix(a: a, b: b, c: c, d: d)
        self.translation = Affine.Translation(dx: tx, dy: ty)
    }

    /// Creates transform from matrix components with type-safe translation.
    ///
    /// - Parameters:
    ///   - a, b, c, d: Linear transformation coefficients
    ///   - tx, ty: Type-safe translation displacement components
    @inlinable
    public init(
        a: Scalar,
        b: Scalar,
        c: Scalar,
        d: Scalar,
        tx: Linear<Scalar, Space>.Dx,
        ty: Linear<Scalar, Space>.Dy
    ) {
        self.linear = Linear<Scalar, Space>.Matrix(a: a, b: b, c: c, d: d)
        self.translation = Affine.Translation(dx: tx, dy: ty)
    }
}

// MARK: - Composition

extension Affine.Transform where Scalar: FloatingPoint {
    /// Composes this transform with another, applying `other` first then `self`.
    ///
    /// Matrix composition follows right-to-left application order.
    @inlinable
    public func concatenating(_ other: Self) -> Self {
        // Linear part: matrix multiplication
        let newLinear = linear.multiplied(by: other.linear)

        // Translation part: apply self's linear to other's translation, then add self's translation
        let otherTx = other.translation.dx.value
        let otherTy = other.translation.dy.value
        let newTx = linear.a * otherTx + linear.b * otherTy + translation.dx.value
        let newTy = linear.c * otherTx + linear.d * otherTy + translation.dy.value

        return Self(
            linear: newLinear,
            translation: Affine.Translation(dx: newTx, dy: newTy)
        )
    }
}

// MARK: - Factory Methods

extension Affine.Transform where Scalar: FloatingPoint & ExpressibleByIntegerLiteral {
    /// Creates pure translation transform from typed displacements.
    @inlinable
    public static func translation(dx: Affine.Dx, dy: Affine.Dy) -> Self {
        Self(linear: .identity, translation: Affine.Translation(dx: dx, dy: dy))
    }

    /// Creates translation transform from displacement vector.
    @inlinable
    public static func translation(_ vector: Linear<Scalar, Space>.Vector<2>) -> Self {
        Self(translation: Affine.Translation(vector))
    }

    /// Creates translation transform from a Translation value.
    @inlinable
    public static func translation(_ translation: Affine.Translation) -> Self {
        Self(linear: .identity, translation: translation)
    }

    /// Creates uniform scaling transform.
    ///
    /// Scale factors are dimensionless ratios.
    @inlinable
    public static func scale(_ factor: Scalar) -> Self {
        Self(linear: Linear<Scalar, Space>.Matrix(a: factor, b: 0, c: 0, d: factor))
    }

    /// Creates non-uniform scaling transform with independent x and y factors.
    ///
    /// Scale factors are dimensionless ratios.
    @inlinable
    public static func scale(x: Scalar, y: Scalar) -> Self {
        Self(linear: Linear<Scalar, Space>.Matrix(a: x, b: 0, c: 0, d: y))
    }

    /// Creates shear transform with horizontal and vertical shear factors.
    ///
    /// Shear factors are dimensionless ratios.
    @inlinable
    public static func shear(x: Scalar, y: Scalar) -> Self {
        Self(linear: Linear<Scalar, Space>.Matrix(a: 1, b: x, c: y, d: 1))
    }
}

// MARK: - Rotation Factory (Real & BinaryFloatingPoint)

extension Affine.Transform where Scalar: Real & BinaryFloatingPoint {
    /// Creates counterclockwise rotation transform around origin.
    @inlinable
    public static func rotation(_ angle: Radian) -> Self {
        let c = Scalar(angle.cos)
        let s = Scalar(angle.sin)
        return Self(
            linear: Linear<Scalar, Space>.Matrix(a: c, b: -s, c: s, d: c),
            translation: .zero
        )
    }

    /// Creates counterclockwise rotation transform from degrees.
    @inlinable
    public static func rotation(_ angle: Degree) -> Self {
        rotation(angle.radians)
    }
}

// MARK: - Fluent Modifiers

extension Affine.Transform where Scalar: FloatingPoint & ExpressibleByIntegerLiteral {
    /// Returns new transform with additional translation applied.
    @inlinable
    public func translated(dx: Affine.Dx, dy: Affine.Dy) -> Self {
        concatenating(.translation(dx: dx, dy: dy))
    }

    /// Returns new transform with additional vector translation applied.
    @inlinable
    public func translated(by vector: Linear<Scalar, Space>.Vector<2>) -> Self {
        concatenating(.translation(vector))
    }

    /// Returns new transform with additional translation applied.
    @inlinable
    public func translated(by translation: Affine.Translation) -> Self {
        concatenating(.translation(translation))
    }

    /// Returns new transform with additional uniform scaling applied.
    @inlinable
    public func scaled(by factor: Scalar) -> Self {
        concatenating(.scale(factor))
    }

    /// Returns new transform with additional non-uniform scaling applied.
    @inlinable
    public func scaled(x: Scalar, y: Scalar) -> Self {
        concatenating(.scale(x: x, y: y))
    }
}

extension Affine.Transform where Scalar: Real & BinaryFloatingPoint {
    /// Returns new transform with additional rotation applied.
    @inlinable
    public func rotated(by angle: Radian) -> Self {
        concatenating(.rotation(angle))
    }

    /// Returns new transform with additional rotation in degrees applied.
    @inlinable
    public func rotated(by angle: Degree) -> Self {
        concatenating(.rotation(angle))
    }
}

// MARK: - Inversion

extension Affine.Transform where Scalar: FloatingPoint {
    /// Determinant of the linear transformation matrix.
    @inlinable
    public var determinant: Scalar {
        linear.determinant
    }

    /// Whether transform can be inverted.
    @inlinable
    public var isInvertible: Bool {
        determinant != 0
    }

    /// Inverse transform that reverses this transformation, or `nil` if singular.
    @inlinable
    public var inverted: Self? {
        guard let invLinear = linear.inverse else { return nil }

        // inv(T) = -inv(L) * t
        let tx = translation.dx.value
        let ty = translation.dy.value
        let newTx = -(invLinear.a * tx + invLinear.b * ty)
        let newTy = -(invLinear.c * tx + invLinear.d * ty)

        return Self(
            linear: invLinear,
            translation: Affine.Translation(dx: newTx, dy: newTy)
        )
    }
}

// MARK: - Apply Transform

extension Affine.Transform where Scalar: FloatingPoint {
    /// Applies transformation to a point, returning transformed position.
    @inlinable
    public func apply(to point: Affine.Point<2>) -> Affine.Point<2> {
        // Matrix multiplication mixes X and Y components: new_x = a*x + b*y + tx
        let px = point.x.value
        let py = point.y.value
        let newX = linear.a * px + linear.b * py + translation.dx.value
        let newY = linear.c * px + linear.d * py + translation.dy.value
        return Affine.Point(x: Affine.X(newX), y: Affine.Y(newY))
    }

    /// Applies linear transformation to vector, ignoring translation component.
    @inlinable
    public func apply(to vector: Linear<Scalar, Space>.Vector<2>) -> Linear<Scalar, Space>.Vector<2>
    {
        // Matrix multiplication mixes X and Y components: new_x = a*x + b*y
        let vx = vector.dx.value
        let vy = vector.dy.value
        let newDx = linear.a * vx + linear.b * vy
        let newDy = linear.c * vx + linear.d * vy
        return Linear<Scalar, Space>.Vector(
            dx: Linear<Scalar, Space>.Dx(newDx),
            dy: Linear<Scalar, Space>.Dy(newDy)
        )
    }
}

// MARK: - Monoid

extension Affine.Transform where Scalar: FloatingPoint & ExpressibleByIntegerLiteral {
    /// Composes multiple transforms into single transform via reduction.
    ///
    /// Transforms apply in array order: first transform applies first, last applies last.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let combined = Transform.composed([
    ///     .rotation(.degrees(45)),
    ///     .scale(2.0),
    ///     .translation(x: 100, y: 50)
    /// ])
    /// // Applies: rotate, then scale, then translate
    /// ```
    @inlinable
    public static func composed(_ transforms: [Self]) -> Self {
        transforms.reduce(.identity) { $0.concatenating($1) }
    }

    /// Composes variadic transforms into single transform.
    @inlinable
    public static func composed(_ transforms: Self...) -> Self {
        composed(transforms)
    }
}
