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
    /// let transform = Geometry<Double>.AffineTransform.identity
    ///     .translated(x: 100, y: 50)
    ///     .rotated(cos: 0.707, sin: 0.707)
    ///     .scaled(by: 2.0)
    ///
    /// let point = Geometry<Double>.Point<2>(x: 10, y: 20)
    /// let transformed = transform.apply(to: point)
    /// ```
    public struct AffineTransform: ~Copyable {
        /// Scale/rotation component (row 1, col 1)
        public var a: Unit

        /// Scale/rotation component (row 1, col 2)
        public var b: Unit

        /// Scale/rotation component (row 2, col 1)
        public var c: Unit

        /// Scale/rotation component (row 2, col 2)
        public var d: Unit

        /// Translation x
        public var tx: Geometry.X

        /// Translation y
        public var ty: Geometry.Y

        /// Create a transform with explicit matrix components
        @inlinable
        public init(
            a: consuming Unit,
            b: consuming Unit,
            c: consuming Unit,
            d: consuming Unit,
            tx: consuming Geometry.X,
            ty: consuming Geometry.Y
        ) {
            self.a = a
            self.b = b
            self.c = c
            self.d = d
            self.tx = tx
            self.ty = ty
        }
    }
}

extension Geometry.AffineTransform: Copyable where Unit: Copyable {}
extension Geometry.AffineTransform: Sendable where Unit: Sendable {}
extension Geometry.AffineTransform: Equatable where Unit: Equatable & Copyable {}
extension Geometry.AffineTransform: Hashable where Unit: Hashable & Copyable {}

// MARK: - Typealiases

extension Geometry {
    /// A 2D affine transform (alias for AffineTransform)
    public typealias AffineTransform2 = AffineTransform
}

// MARK: - Codable

extension Geometry.AffineTransform: Codable where Unit: Codable & Copyable {}

// MARK: - Identity

extension Geometry.AffineTransform where Unit: FloatingPoint {
    /// The identity transform (no transformation)
    @inlinable
    public static var identity: Self {
        Self(a: 1, b: 0, c: 0, d: 1, tx: .zero, ty: .zero)
    }
}

// MARK: - Factory Methods

extension Geometry.AffineTransform where Unit: FloatingPoint {
    /// Create a translation transform
    @inlinable
    public static func translation(x: Geometry.X, y: Geometry.Y) -> Self {
        Self(a: 1, b: 0, c: 0, d: 1, tx: x, ty: y)
    }

    /// Create a uniform scaling transform
    @inlinable
    public static func scale(_ factor: Unit) -> Self {
        Self(a: factor, b: 0, c: 0, d: factor, tx: .zero, ty: .zero)
    }

    /// Create a non-uniform scaling transform
    @inlinable
    public static func scale(x: Unit, y: Unit) -> Self {
        Self(a: x, b: 0, c: 0, d: y, tx: .zero, ty: .zero)
    }

    /// Create a rotation transform (counter-clockwise)
    ///
    /// - Parameters:
    ///   - cos: Cosine of the rotation angle
    ///   - sin: Sine of the rotation angle
    @inlinable
    public static func rotation(cos: Unit, sin: Unit) -> Self {
        Self(a: cos, b: -sin, c: sin, d: cos, tx: .zero, ty: .zero)
    }

    /// Create a shear transform
    @inlinable
    public static func shear(x: Unit, y: Unit) -> Self {
        Self(a: 1, b: y, c: x, d: 1, tx: .zero, ty: .zero)
    }
}

// MARK: - Composition

extension Geometry.AffineTransform where Unit: FloatingPoint {
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
    public func translated(x: Unit, y: Unit) -> Self {
        concatenating(.translation(x: .init(x), y: .init(y)))
    }

    /// Return a new transform with translation applied
    @inlinable
    public func translated(by vector: Geometry.Vector<2>) -> Self {
        translated(x: vector.dx, y: vector.dy)
    }

    /// Return a new transform with uniform scaling applied
    @inlinable
    public func scaled(by factor: Unit) -> Self {
        concatenating(.scale(factor))
    }

    /// Return a new transform with non-uniform scaling applied
    @inlinable
    public func scaled(x: Unit, y: Unit) -> Self {
        concatenating(.scale(x: x, y: y))
    }

    /// Return a new transform with rotation applied
    ///
    /// - Parameters:
    ///   - cos: Cosine of the rotation angle
    ///   - sin: Sine of the rotation angle
    @inlinable
    public func rotated(cos: Unit, sin: Unit) -> Self {
        concatenating(.rotation(cos: cos, sin: sin))
    }
}

// MARK: - Inversion

extension Geometry.AffineTransform where Unit: FloatingPoint {
    /// The determinant of the linear part
    @inlinable
    public var determinant: Unit {
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
        let invDet: Unit = 1 / det
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

// MARK: - Apply Transform

extension Geometry.AffineTransform where Unit: FloatingPoint {
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

extension Geometry.AffineTransform where Unit: FloatingPoint {
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

// MARK: - Functorial Map

extension Geometry.AffineTransform {
    /// Create a transform by transforming the components of another transform
    @inlinable
    public init<U>(_ other: borrowing Geometry<U>.AffineTransform, _ transform: (U) -> Unit) {
        self.init(
            a: transform(other.a),
            b: transform(other.b),
            c: transform(other.c),
            d: transform(other.d),
            tx: Geometry.X(other.tx, transform),
            ty: Geometry.Y(other.ty, transform)
        )
    }

    /// Transform components using the given closure
    @inlinable
    public func map<E: Error, Result: ~Copyable>(
        _ transform: (Unit) throws(E) -> Result
    ) throws(E) -> Geometry<Result>.AffineTransform {
        Geometry<Result>.AffineTransform(
            a: try transform(a),
            b: try transform(b),
            c: try transform(c),
            d: try transform(d),
            tx: try tx.map(transform),
            ty: try ty.map(transform)
        )
    }
}
