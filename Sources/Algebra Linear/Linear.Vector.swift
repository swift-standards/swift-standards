// Linear.Vector.swift
// A fixed-size displacement vector with compile-time known dimensions.

public import Algebra
public import Dimension

extension Linear {
    /// A fixed-size vector with compile-time dimension checking.
    ///
    /// Represents a displacement, direction, or point in N-dimensional vector space. Use it for physics quantities (velocity, force), geometry (positions, normals), or any linear algebra needs.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let velocity = Linear<Double>.Vector<2>(dx: .init(10), dy: .init(5))
    /// let speed = velocity.length  // 11.18...
    /// let normalized = velocity.normalized  // unit vector
    /// ```
    public struct Vector<let N: Int> {
        /// The vector components as an inline array.
        public var components: InlineArray<N, Scalar>

        /// Creates a vector from component values.
        @inlinable
        public init(_ components: consuming InlineArray<N, Scalar>) {
            self.components = components
        }
    }
}

extension Linear.Vector: Sendable where Scalar: Sendable {}

// MARK: - Equatable

extension Linear.Vector: Equatable where Scalar: Equatable {
    @inlinable
    public static func == (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        for i in 0..<N {
            if lhs.components[i] != rhs.components[i] {
                return false
            }
        }
        return true
    }
}

// MARK: - Hashable

extension Linear.Vector: Hashable where Scalar: Hashable {
    @inlinable
    public func hash(into hasher: inout Hasher) {
        for i in 0..<N {
            hasher.combine(components[i])
        }
    }
}

// MARK: - Typealiases

extension Linear {
    /// A 2-dimensional vector.
    public typealias Vector2 = Vector<2>

    /// A 3-dimensional vector.
    public typealias Vector3 = Vector<3>

    /// A 4-dimensional vector.
    public typealias Vector4 = Vector<4>
}

// MARK: - Codable

#if Codable
    extension Linear.Vector: Codable where Scalar: Codable {
        public init(from decoder: any Decoder) throws {
            var container = try decoder.unkeyedContainer()
            var components = InlineArray<N, Scalar>(repeating: try container.decode(Scalar.self))
            for i in 1..<N {
                components[i] = try container.decode(Scalar.self)
            }
            self.components = components
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.unkeyedContainer()
            for i in 0..<N {
                try container.encode(components[i])
            }
        }
    }
#endif

// MARK: - Subscript

extension Linear.Vector {
    /// Accesses the component at the given index.
    @inlinable
    public subscript(index: Int) -> Scalar {
        get { components[index] }
        set { components[index] = newValue }
    }
}

// MARK: - Functorial Map

extension Linear.Vector {
    /// Creates a vector by transforming components from another vector.
    @inlinable
    public init<U, E: Error>(
        _ other: borrowing Linear<U, Space>.Vector<N>,
        _ transform: (U) throws(E) -> Scalar
    ) throws(E) {
        var comps = InlineArray<N, Scalar>(repeating: try transform(other.components[0]))
        for i in 1..<N {
            comps[i] = try transform(other.components[i])
        }
        self.init(comps)
    }

    /// Transforms each component and returns a new vector.
    @inlinable
    public func map<Result, E: Error>(
        _ transform: (Scalar) throws(E) -> Result
    ) throws(E) -> Linear<Result, Space>.Vector<N> {
        var result = InlineArray<N, Result>(repeating: try transform(components[0]))
        for i in 1..<N {
            result[i] = try transform(components[i])
        }
        return Linear<Result, Space>.Vector<N>(result)
    }
}

// MARK: - Zero

extension Linear.Vector where Scalar: AdditiveArithmetic {
    /// The zero vector (all components are zero).
    @inlinable
    public static var zero: Self {
        Self(InlineArray(repeating: .zero))
    }
}

// MARK: - AdditiveArithmetic

extension Linear.Vector where Scalar: AdditiveArithmetic {
    /// Adds two vectors component-wise.
    @inlinable
    @_disfavoredOverload
    public static func + (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        var result = lhs.components
        for i in 0..<N {
            result[i] = lhs.components[i] + rhs.components[i]
        }
        return Self(result)
    }

    /// Subtracts two vectors component-wise.
    @inlinable
    @_disfavoredOverload
    public static func - (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        var result = lhs.components
        for i in 0..<N {
            result[i] = lhs.components[i] - rhs.components[i]
        }
        return Self(result)
    }
}

// MARK: - Negation (SignedNumeric)

extension Linear.Vector where Scalar: SignedNumeric {
    /// Negates the vector (flips direction).
    @inlinable
    @_disfavoredOverload
    public static prefix func - (value: borrowing Self) -> Self {
        var result = value.components
        for i in 0..<N {
            result[i] = -value.components[i]
        }
        return Self(result)
    }
}

// MARK: - Scalar Multiplication (internal for mathematical operations)

extension Linear.Vector where Scalar: FloatingPoint {
    /// Scales the vector by a scalar multiplier (internal).
    @inlinable
    internal static func * (lhs: borrowing Self, rhs: Scalar) -> Self {
        var result = lhs.components
        for i in 0..<N {
            result[i] = lhs.components[i] * rhs
        }
        return Self(result)
    }

    /// Divides the vector by a scalar divisor (internal).
    @inlinable
    internal static func / (lhs: borrowing Self, rhs: Scalar) -> Self {
        var result = lhs.components
        for i in 0..<N {
            result[i] = lhs.components[i] / rhs
        }
        return Self(result)
    }
}

// MARK: - Properties (FloatingPoint)

extension Linear.Vector where Scalar: FloatingPoint {
    /// The squared length of the vector.
    ///
    /// Use when comparing magnitudes to avoid the square root computation.
    @inlinable
    public static func lengthSquared(_ vector: Self) -> Scalar {
        var sum = Scalar.zero
        for i in 0..<N {
            sum += vector.components[i] * vector.components[i]
        }
        return sum
    }

    /// The squared length of the vector.
    ///
    /// Use when comparing magnitudes to avoid the square root computation.
    @inlinable
    public var lengthSquared: Scalar {
        Self.lengthSquared(self)
    }

    /// The length (magnitude) of the vector.
    @inlinable
    public static func length(_ vector: Self) -> Scalar {
        lengthSquared(vector).squareRoot()
    }

    /// The length (magnitude) of the vector.
    @inlinable
    public var length: Scalar {
        Self.length(self)
    }

    /// The magnitude (length) of the vector as a typed value.
    @inlinable
    public var magnitude: Linear.Magnitude {
        Linear.Magnitude(Self.length(self))
    }

    /// A unit vector in the same direction.
    ///
    /// Returns the zero vector if this vector has zero length.
    @inlinable
    public static func normalized(_ vector: Self) -> Self {
        let len = length(vector)
        guard len > 0 else { return .zero }
        return vector / len
    }

    /// A unit vector in the same direction.
    ///
    /// Returns the zero vector if this vector has zero length.
    @inlinable
    public var normalized: Self {
        Self.normalized(self)
    }
}

// MARK: - Operations (FloatingPoint)

extension Linear.Vector where Scalar: FloatingPoint {
    /// Computes the dot product with another vector.
    @inlinable
    public static func dot(_ lhs: Self, _ rhs: Self) -> Scalar {
        var sum = Scalar.zero
        for i in 0..<N {
            sum += lhs.components[i] * rhs.components[i]
        }
        return sum
    }

    /// Computes the dot product with another vector.
    @inlinable
    public func dot(_ other: borrowing Self) -> Scalar {
        Self.dot(self, other)
    }

    /// Projects this vector onto another vector.
    ///
    /// Returns the component of this vector in the direction of `other`, or zero if `other` has zero length.
    @inlinable
    public static func projection(_ vector: Self, onto other: Self) -> Self {
        let otherLenSq = lengthSquared(other)
        guard otherLenSq > 0 else { return .zero }
        let scale = dot(vector, other) / otherLenSq
        return other * scale
    }

    /// Projects this vector onto another vector.
    ///
    /// Returns the component of this vector in the direction of `other`, or zero if `other` has zero length.
    @inlinable
    public func projection(onto other: borrowing Self) -> Self {
        Self.projection(self, onto: other)
    }

    /// Computes the rejection (orthogonal component) from another vector.
    ///
    /// Returns the component of this vector perpendicular to `other`. Satisfies: `self = projection(onto: other) + rejection(from: other)`.
    @inlinable
    public static func rejection(_ vector: Self, from other: Self) -> Self {
        vector - projection(vector, onto: other)
    }

    /// Computes the rejection (orthogonal component) from another vector.
    ///
    /// Returns the component of this vector perpendicular to `other`. Satisfies: `self = projection(onto: other) + rejection(from: other)`.
    @inlinable
    public func rejection(from other: borrowing Self) -> Self {
        Self.rejection(self, from: other)
    }

    /// Computes the distance between vector endpoints.
    @inlinable
    public static func distance(_ lhs: Self, to rhs: Self) -> Linear.Distance {
        Linear.Distance(length(lhs - rhs))
    }

    /// Computes the distance between vector endpoints.
    @inlinable
    public func distance(to other: borrowing Self) -> Linear.Distance {
        Self.distance(self, to: other)
    }
}

// MARK: - 2D Convenience

extension Linear.Vector where N == 2 {
    /// The X-component (horizontal displacement).
    @inlinable
    public var dx: Linear.Dx {
        get { Linear.Dx(components[0]) }
        set { components[0] = newValue._rawValue }
    }

    /// The Y-component (vertical displacement).
    @inlinable
    public var dy: Linear.Dy {
        get { Linear.Dy(components[1]) }
        set { components[1] = newValue._rawValue }
    }

    /// Creates a 2D vector from typed displacement components.
    @inlinable
    public init(dx: Linear.Dx, dy: Linear.Dy) {
        self.init([dx._rawValue, dy._rawValue])
    }
}

// MARK: - 2D Cross Product (SignedNumeric)

extension Linear.Vector where N == 2, Scalar: SignedNumeric {
    /// Computes the 2D cross product (signed Z-component).
    ///
    /// Returns the signed area of the parallelogram formed by the vectors.
    /// Positive if `other` is counter-clockwise from `self`.
    @inlinable
    public static func cross(_ lhs: Self, _ rhs: Self) -> Linear.Area {
        lhs.dx * rhs.dy - lhs.dy * rhs.dx
    }

    /// Computes the 2D cross product (signed Z-component).
    ///
    /// Returns the signed area of the parallelogram formed by the vectors.
    /// Positive if `other` is counter-clockwise from `self`.
    @inlinable
    public func cross(_ other: borrowing Self) -> Linear.Area {
        Self.cross(self, other)
    }
}

// MARK: - 3D Convenience

extension Linear.Vector where N == 3 {
    /// The X-component.
    @inlinable
    public var dx: Linear.Dx {
        get { Linear.Dx(components[0]) }
        set { components[0] = newValue._rawValue }
    }

    /// The Y-component.
    @inlinable
    public var dy: Linear.Dy {
        get { Linear.Dy(components[1]) }
        set { components[1] = newValue._rawValue }
    }

    /// The Z-component.
    @inlinable
    public var dz: Linear.Dz {
        get { Linear.Dz(components[2]) }
        set { components[2] = newValue._rawValue }
    }

    /// Creates a 3D vector from typed displacement components.
    @inlinable
    public init(dx: Linear.Dx, dy: Linear.Dy, dz: Linear.Dz) {
        self.init([dx._rawValue, dy._rawValue, dz._rawValue])
    }

    /// Creates a 3D vector from a 2D vector by adding a Z-component.
    @inlinable
    public init(_ vector2: Linear.Vector<2>, dz: Linear.Dz) {
        self.init([vector2.dx._rawValue, vector2.dy._rawValue, dz._rawValue])
    }
}

// MARK: - 3D Cross Product (SignedNumeric)

extension Linear.Vector where N == 3, Scalar: SignedNumeric {
    /// Computes the 3D cross product with another vector.
    ///
    /// Note: Uses raw values internally. The cross product of two displacement vectors
    /// is conventionally treated as returning a displacement vector, though dimensionally
    /// it's Length² (a bivector in geometric algebra).
    @inlinable
    public static func cross(_ lhs: Self, _ rhs: Self) -> Self {
        let lx = lhs.dx._rawValue, ly = lhs.dy._rawValue, lz = lhs.dz._rawValue
        let rx = rhs.dx._rawValue, ry = rhs.dy._rawValue, rz = rhs.dz._rawValue
        return Self(
            dx: Linear.Dx(ly * rz - lz * ry),
            dy: Linear.Dy(lz * rx - lx * rz),
            dz: Linear.Dz(lx * ry - ly * rx)
        )
    }

    /// Computes the 3D cross product with another vector.
    @inlinable
    public func cross(_ other: borrowing Self) -> Self {
        Self.cross(self, other)
    }
}

// MARK: - 4D Convenience

extension Linear.Vector where N == 4 {
    /// The X-component.
    @inlinable
    public var dx: Linear.Dx {
        get { Linear.Dx(components[0]) }
        set { components[0] = newValue._rawValue }
    }

    /// The Y-component.
    @inlinable
    public var dy: Linear.Dy {
        get { Linear.Dy(components[1]) }
        set { components[1] = newValue._rawValue }
    }

    /// The Z-component.
    @inlinable
    public var dz: Linear.Dz {
        get { Linear.Dz(components[2]) }
        set { components[2] = newValue._rawValue }
    }

    /// The W-component.
    @inlinable
    public var dw: Linear.Dw {
        get { Linear.Dw(components[3]) }
        set { components[3] = newValue._rawValue }
    }

    /// Creates a 4D vector from typed displacement components.
    @inlinable
    public init(dx: Linear.Dx, dy: Linear.Dy, dz: Linear.Dz, dw: Linear.Dw) {
        self.init([dx._rawValue, dy._rawValue, dz._rawValue, dw._rawValue])
    }

    /// Creates a 4D vector from a 3D vector by adding a W-component.
    @inlinable
    public init(_ vector3: Linear.Vector<3>, dw: Linear.Dw) {
        self.init([vector3.dx._rawValue, vector3.dy._rawValue, vector3.dz._rawValue, dw._rawValue])
    }
}

// MARK: - Zip

extension Linear.Vector {
    /// Combines two vectors component-wise using a closure.
    @inlinable
    public static func zip(_ a: Self, _ b: Self, _ combine: (Scalar, Scalar) -> Scalar) -> Self {
        var result = a.components
        for i in 0..<N {
            result[i] = combine(a.components[i], b.components[i])
        }
        return Self(result)
    }
}

// MARK: - Vector × Scale (Uniform Scaling)

/// Scales a vector uniformly by a dimensionless scale factor.
@inlinable
public func * <Scalar: FloatingPoint, Space, let N: Int>(
    lhs: Linear<Scalar, Space>.Vector<N>,
    rhs: Scale<1, Scalar>
) -> Linear<Scalar, Space>.Vector<N> {
    var result = lhs.components
    for i in 0..<N {
        result[i] = lhs.components[i] * rhs.value
    }
    return Linear<Scalar, Space>.Vector<N>(result)
}

/// Scales a vector uniformly by a dimensionless scale factor (commutative).
@inlinable
public func * <Scalar: FloatingPoint, Space, let N: Int>(
    lhs: Scale<1, Scalar>,
    rhs: Linear<Scalar, Space>.Vector<N>
) -> Linear<Scalar, Space>.Vector<N> {
    var result = rhs.components
    for i in 0..<N {
        result[i] = lhs.value * rhs.components[i]
    }
    return Linear<Scalar, Space>.Vector<N>(result)
}

/// Divides a vector uniformly by a dimensionless scale factor.
@inlinable
public func / <Scalar: FloatingPoint, Space, let N: Int>(
    lhs: Linear<Scalar, Space>.Vector<N>,
    rhs: Scale<1, Scalar>
) -> Linear<Scalar, Space>.Vector<N> {
    var result = lhs.components
    for i in 0..<N {
        result[i] = lhs.components[i] / rhs.value
    }
    return Linear<Scalar, Space>.Vector<N>(result)
}
