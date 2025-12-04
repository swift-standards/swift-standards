// AffineTransform.swift
// A 2D affine transformation matrix.

extension Geometry {
    /// A 2D affine transformation matrix.
    ///
    /// Represents transformations that preserve parallel lines:
    /// translation, rotation, scaling, shearing, and combinations thereof.
    ///
    /// The matrix is represented as:
    /// ```
    /// | a  b  0 |
    /// | c  d  0 |
    /// | tx ty 1 |
    /// ```
    ///
    /// Where `(a, b, c, d)` is the linear transformation and `(tx, ty)` is translation.
    ///
    /// The `Unit` type parameter provides compile-time type safety to prevent
    /// accidentally mixing transforms from different coordinate systems.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let transform = Geometry.AffineTransform<Double>.identity
    ///     .translated(x: 100, y: 50)
    ///     .rotated(cos: 0.707, sin: 0.707)
    ///     .scaled(by: 2.0)
    ///
    /// let point = Geometry.Point<2>(x: 10, y: 20)
    /// let transformed = transform.apply(to: point)
    /// ```
    public struct AffineTransform {
        /// Scale/rotation component (row 1, col 1)
        public var a: Double

        /// Scale/rotation component (row 1, col 2)
        public var b: Double

        /// Scale/rotation component (row 2, col 1)
        public var c: Double

        /// Scale/rotation component (row 2, col 2)
        public var d: Double

        /// Translation x
        public var tx: Geometry.X

        /// Translation y
        public var ty: Geometry.Y

        /// Create a transform with explicit matrix components
        @inlinable
        public init(a: Double, b: Double, c: Double, d: Double, tx: consuming Geometry.X, ty: consuming Geometry.Y) {
            self.a = a
            self.b = b
            self.c = c
            self.d = d
            self.tx = tx
            self.ty = ty
        }
    }
}

extension Geometry.AffineTransform: Sendable where Unit: Sendable {}
extension Geometry.AffineTransform: Equatable where Unit: Equatable {}
extension Geometry.AffineTransform: Hashable where Unit: Hashable {}

// MARK: - Typealiases

extension Geometry {
    /// A 2D affine transform (alias for AffineTransform)
    public typealias AffineTransform2 = AffineTransform
}

// MARK: - Codable

extension Geometry.AffineTransform: Codable where Unit: Codable {}

// MARK: - Identity

extension Geometry.AffineTransform where Unit: AdditiveArithmetic {
    /// The identity transform (no transformation)
    public static var identity: Self {
        Self(a: 1, b: 0, c: 0, d: 1, tx: .zero, ty: .zero)
    }
}

// MARK: - Factory Methods

extension Geometry.AffineTransform where Unit: AdditiveArithmetic {
    /// Create a translation transform
    @inlinable
    public static func translation(x: Geometry.X, y: Geometry.Y) -> Self {
        Self(a: 1, b: 0, c: 0, d: 1, tx: x, ty: y)
    }

    /// Create a uniform scaling transform
    @inlinable
    public static func scale(_ factor: Double) -> Self {
        Self(a: factor, b: 0, c: 0, d: factor, tx: .zero, ty: .zero)
    }

    /// Create a non-uniform scaling transform
    @inlinable
    public static func scale(x: Double, y: Double) -> Self {
        Self(a: x, b: 0, c: 0, d: y, tx: .zero, ty: .zero)
    }

    /// Create a rotation transform (counter-clockwise)
    ///
    /// - Parameters:
    ///   - cos: Cosine of the rotation angle
    ///   - sin: Sine of the rotation angle
    @inlinable
    public static func rotation(cos: Double, sin: Double) -> Self {
        Self(a: cos, b: -sin, c: sin, d: cos, tx: .zero, ty: .zero)
    }

    /// Create a shear transform
    @inlinable
    public static func shear(x: Double, y: Double) -> Self {
        Self(a: 1, b: y, c: x, d: 1, tx: .zero, ty: .zero)
    }
}

// MARK: - Composition (Double Unit)

extension Geometry.AffineTransform where Unit == Double {
    /// Create a translation transform from a vector
    @inlinable
    public static func translation(_ vector: Geometry.Vector<2>) -> Self {
        translation(x: .init(vector.dx), y: .init(vector.dy))
    }

    /// Concatenate with another transform (self * other)
    ///
    /// The resulting transform applies `other` first, then `self`.
    @inlinable
    public func concatenating(_ other: Self) -> Self {
        Self(
            a: a * other.a + b * other.c,
            b: a * other.b + b * other.d,
            c: c * other.a + d * other.c,
            d: c * other.b + d * other.d,
            tx: .init(tx.value + a * other.tx.value + b * other.ty.value),
            ty: .init(ty.value + c * other.tx.value + d * other.ty.value)
        )
    }

    /// Return a new transform with translation applied
    @inlinable
    public func translated(x: Double, y: Double) -> Self {
        concatenating(.translation(x: .init(x), y: .init(y)))
    }

    /// Return a new transform with translation applied
    @inlinable
    public func translated(by vector: Geometry.Vector<2>) -> Self {
        translated(x: vector.dx, y: vector.dy)
    }

    /// Return a new transform with uniform scaling applied
    @inlinable
    public func scaled(by factor: Double) -> Self {
        concatenating(.scale(factor))
    }

    /// Return a new transform with non-uniform scaling applied
    @inlinable
    public func scaled(x: Double, y: Double) -> Self {
        concatenating(.scale(x: x, y: y))
    }

    /// Return a new transform with rotation applied
    ///
    /// - Parameters:
    ///   - cos: Cosine of the rotation angle
    ///   - sin: Sine of the rotation angle
    @inlinable
    public func rotated(cos: Double, sin: Double) -> Self {
        concatenating(.rotation(cos: cos, sin: sin))
    }
}

// MARK: - Inversion (Double Unit)

extension Geometry.AffineTransform where Unit == Double {
    /// The determinant of the linear part
    @inlinable
    public var determinant: Double {
        a * d - b * c
    }

    /// Whether this transform is invertible
    @inlinable
    public var isInvertible: Bool {
        determinant != 0
    }

    /// The inverse transform, or nil if not invertible
    @inlinable
    public var inverted: Self? {
        let det = determinant
        guard det != 0 else { return nil }
        let invDet = 1.0 / det
        return Self(
            a: d * invDet,
            b: -b * invDet,
            c: -c * invDet,
            d: a * invDet,
            tx: .init((c * ty.value - d * tx.value) * invDet),
            ty: .init((b * tx.value - a * ty.value) * invDet)
        )
    }
}

// MARK: - Apply Transform (Double Unit)

extension Geometry.AffineTransform where Unit == Double {
    /// Apply transform to a point
    @inlinable
    public func apply(to point: Geometry.Point<2>) -> Geometry.Point<2> {
        let x = a * point.x + b * point.y + tx.value
        let y = c * point.x + d * point.y + ty.value
        return Geometry.Point(x: x, y: y)
    }

    /// Apply transform to a vector (ignores translation)
    @inlinable
    public func apply(to vector: Geometry.Vector<2>) -> Geometry.Vector<2> {
        let dx = a * vector.dx + b * vector.dy
        let dy = c * vector.dx + d * vector.dy
        return Geometry.Vector(dx: dx, dy: dy)
    }

    /// Apply transform to a size (uses absolute values of scale factors)
    @inlinable
    public func apply(to size: Geometry.Size<2>) -> Geometry.Size<2> {
        let width = abs(a * size.width + b * size.height)
        let height = abs(c * size.width + d * size.height)
        return Geometry.Size(width: width, height: height)
    }
}

// MARK: - Monoid

extension Geometry.AffineTransform where Unit == Double {
    /// Compose multiple transforms into a single transform
    ///
    /// The transforms are applied in order, so the first transform in the array
    /// is applied first, then the second, etc.
    @inlinable
    public static func composed(_ transforms: [Self]) -> Self {
        transforms.reduce(.identity) { $0.concatenating($1) }
    }

    /// Compose multiple transforms into a single transform
    ///
    /// The transforms are applied in order, so the first transform in the variadic list
    /// is applied first, then the second, etc.
    @inlinable
    public static func composed(_ transforms: Self...) -> Self {
        composed(transforms)
    }
}
