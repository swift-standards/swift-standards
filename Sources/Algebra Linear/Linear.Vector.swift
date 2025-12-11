// Linear.Vector.swift
// A fixed-size displacement vector with compile-time known dimensions.

public import Algebra

extension Linear {
    /// A fixed-size displacement vector with compile-time known dimensions.
    ///
    /// `Vector` represents a displacement or direction in a vector space.
    /// This is a linear algebra primitive - the underlying element of Vect.
    ///
    /// Uses Swift 6.2 integer generic parameters (SE-0452) for type-safe
    /// dimension checking at compile time.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let velocity: Linear<Double>.Vector<2> = .init(dx: 10, dy: 5)
    /// let velocity3D: Linear<Double>.Vector<3> = .init(dx: 1, dy: 2, dz: 3)
    /// ```
    public struct Vector<let N: Int> {
        /// The vector components stored inline
        public var components: InlineArray<N, Scalar>

        /// Create a vector from an inline array of components
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
    /// A 2D vector
    public typealias Vector2 = Vector<2>

    /// A 3D vector
    public typealias Vector3 = Vector<3>

    /// A 4D vector
    public typealias Vector4 = Vector<4>
}

// MARK: - Codable

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

// MARK: - Subscript

extension Linear.Vector {
    /// Access component by index
    @inlinable
    public subscript(index: Int) -> Scalar {
        get { components[index] }
        set { components[index] = newValue }
    }
}

// MARK: - Functorial Map

extension Linear.Vector {
    /// Create a vector by transforming each component of another vector
    @inlinable
    public init<U, E: Error>(
        _ other: borrowing Linear<U>.Vector<N>,
        _ transform: (U) throws(E) -> Scalar
    ) throws(E) {
        var comps = InlineArray<N, Scalar>(repeating: try transform(other.components[0]))
        for i in 1..<N {
            comps[i] = try transform(other.components[i])
        }
        self.init(comps)
    }

    /// Transform each component using the given closure
    @inlinable
    public func map<Result, E: Error>(
        _ transform: (Scalar) throws(E) -> Result
    ) throws(E) -> Linear<Result>.Vector<N> {
        var result = InlineArray<N, Result>(repeating: try transform(components[0]))
        for i in 1..<N {
            result[i] = try transform(components[i])
        }
        return Linear<Result>.Vector<N>(result)
    }
}

// MARK: - Zero

extension Linear.Vector where Scalar: AdditiveArithmetic {
    /// The zero vector
    @inlinable
    public static var zero: Self {
        Self(InlineArray(repeating: .zero))
    }
}

// MARK: - AdditiveArithmetic

extension Linear.Vector: AdditiveArithmetic where Scalar: AdditiveArithmetic {
    /// Add two vectors
    @inlinable
    @_disfavoredOverload
    public static func + (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        var result = lhs.components
        for i in 0..<N {
            result[i] = lhs.components[i] + rhs.components[i]
        }
        return Self(result)
    }

    /// Subtract two vectors
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
    /// Negate vector
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

// MARK: - Scalar Operations (FloatingPoint)

extension Linear.Vector where Scalar: FloatingPoint {
    /// Scale vector by a scalar
    @inlinable
    @_disfavoredOverload
    public static func * (lhs: borrowing Self, rhs: Scalar) -> Self {
        var result = lhs.components
        for i in 0..<N {
            result[i] = lhs.components[i] * rhs
        }
        return Self(result)
    }

    /// Scale vector by a scalar
    @inlinable
    @_disfavoredOverload
    public static func * (lhs: Scalar, rhs: borrowing Self) -> Self {
        var result = rhs.components
        for i in 0..<N {
            result[i] = lhs * rhs.components[i]
        }
        return Self(result)
    }

    /// Divide vector by a scalar
    @inlinable
    @_disfavoredOverload
    public static func / (lhs: borrowing Self, rhs: Scalar) -> Self {
        var result = lhs.components
        for i in 0..<N {
            result[i] = lhs.components[i] / rhs
        }
        return Self(result)
    }
}

// MARK: - Properties (FloatingPoint)

extension Linear.Vector where Scalar: FloatingPoint {
    /// The squared length of the vector
    ///
    /// Use this when comparing magnitudes to avoid the sqrt computation.
    @inlinable
    public var lengthSquared: Scalar {
        var sum = Scalar.zero
        for i in 0..<N {
            sum += components[i] * components[i]
        }
        return sum
    }

    /// The length (magnitude) of the vector
    @inlinable
    public var length: Scalar {
        lengthSquared.squareRoot()
    }

    /// A unit vector in the same direction
    ///
    /// Returns zero vector if this vector has zero length.
    @inlinable
    public var normalized: Self {
        let len = length
        guard len > 0 else { return .zero }
        return self / len
    }
}

// MARK: - Operations (FloatingPoint)

extension Linear.Vector where Scalar: FloatingPoint {
    /// Dot product of two vectors
    @inlinable
    public func dot(_ other: borrowing Self) -> Scalar {
        var sum = Scalar.zero
        for i in 0..<N {
            sum += components[i] * other.components[i]
        }
        return sum
    }

    /// Project this vector onto another vector.
    ///
    /// Returns the component of `self` that lies in the direction of `other`.
    ///
    /// - Parameter other: The vector to project onto
    /// - Returns: The projection of `self` onto `other`, or zero if `other` has zero length
    @inlinable
    public func projection(onto other: borrowing Self) -> Self {
        let otherLenSq = other.lengthSquared
        guard otherLenSq > 0 else { return .zero }
        let scale = dot(other) / otherLenSq
        return other * scale
    }

    /// The rejection (orthogonal component) of this vector from another vector.
    ///
    /// Returns the component of `self` that is perpendicular to `other`.
    /// `self = projection(onto: other) + rejection(from: other)`
    ///
    /// - Parameter other: The vector to reject from
    /// - Returns: The component of `self` perpendicular to `other`
    @inlinable
    public func rejection(from other: borrowing Self) -> Self {
        self - projection(onto: other)
    }

    /// The distance between the tips of two vectors (when both start at origin).
    ///
    /// - Parameter other: Another vector
    /// - Returns: The distance between the endpoints
    @inlinable
    public func distance(to other: borrowing Self) -> Scalar {
        (self - other).length
    }
}

// MARK: - 2D Convenience

extension Linear.Vector where N == 2 {
    /// The x component (horizontal displacement) - type-safe
    @inlinable
    public var dx: Linear.X {
        get { Linear.X(components[0]) }
        set { components[0] = newValue.value }
    }

    /// The y component (vertical displacement) - type-safe
    @inlinable
    public var dy: Linear.Y {
        get { Linear.Y(components[1]) }
        set { components[1] = newValue.value }
    }

    /// Create a 2D vector from typed components
    @inlinable
    public init(dx: Linear.X, dy: Linear.Y) {
        self.init([dx.value, dy.value])
    }
}

// MARK: - 2D Cross Product (SignedNumeric)

extension Linear.Vector where N == 2, Scalar: SignedNumeric {
    /// 2D cross product (returns scalar z-component)
    ///
    /// This is the signed area of the parallelogram formed by the two vectors.
    /// Positive if `other` is counter-clockwise from `self`.
    @inlinable
    public func cross(_ other: borrowing Self) -> Scalar {
        dx * other.dy - dy * other.dx
    }
}

// Note: The cross product uses Tagged's cross-axis multiplication:
// dx: Tagged<Algebra.X, Scalar> * other.dy: Tagged<Algebra.Y, Scalar> -> Scalar

// MARK: - 3D Convenience

extension Linear.Vector where N == 3 {
    /// The x component - type-safe
    @inlinable
    public var dx: Linear.X {
        get { Linear.X(components[0]) }
        set { components[0] = newValue.value }
    }

    /// The y component - type-safe
    @inlinable
    public var dy: Linear.Y {
        get { Linear.Y(components[1]) }
        set { components[1] = newValue.value }
    }

    /// The z component - type-safe
    @inlinable
    public var dz: Linear.Z {
        get { Linear.Z(components[2]) }
        set { components[2] = newValue.value }
    }

    /// Create a 3D vector with typed components
    @inlinable
    public init(dx: Linear.X, dy: Linear.Y, dz: Linear.Z) {
        self.init([dx.value, dy.value, dz.value])
    }

    /// Create a 3D vector from a 2D vector with z component
    @inlinable
    public init(_ vector2: Linear.Vector<2>, dz: Linear.Z) {
        self.init([vector2.dx.value, vector2.dy.value, dz.value])
    }
}

// MARK: - 3D Cross Product (SignedNumeric)

extension Linear.Vector where N == 3, Scalar: SignedNumeric {
    /// 3D cross product
    @inlinable
    public func cross(_ other: borrowing Self) -> Self {
        Self(
            dx: Linear.X(dy * other.dz - dz * other.dy),
            dy: Linear.Y(dz * other.dx - dx * other.dz),
            dz: Linear.Z(dx * other.dy - dy * other.dx)
        )
    }
}

// MARK: - 4D Convenience

extension Linear.Vector where N == 4 {
    /// The x component - type-safe
    @inlinable
    public var dx: Linear.X {
        get { Linear.X(components[0]) }
        set { components[0] = newValue.value }
    }

    /// The y component - type-safe
    @inlinable
    public var dy: Linear.Y {
        get { Linear.Y(components[1]) }
        set { components[1] = newValue.value }
    }

    /// The z component - type-safe
    @inlinable
    public var dz: Linear.Z {
        get { Linear.Z(components[2]) }
        set { components[2] = newValue.value }
    }

    /// The w component - type-safe
    @inlinable
    public var dw: Linear.W {
        get { Linear.W(components[3]) }
        set { components[3] = newValue.value }
    }

    /// Create a 4D vector with typed components
    @inlinable
    public init(dx: Linear.X, dy: Linear.Y, dz: Linear.Z, dw: Linear.W) {
        self.init([dx.value, dy.value, dz.value, dw.value])
    }

    /// Create a 4D vector from a 3D vector with w component
    @inlinable
    public init(_ vector3: Linear.Vector<3>, dw: Linear.W) {
        self.init([vector3.dx.value, vector3.dy.value, vector3.dz.value, dw.value])
    }
}

// MARK: - Zip

extension Linear.Vector {
    /// Combine two vectors component-wise
    @inlinable
    public static func zip(_ a: Self, _ b: Self, _ combine: (Scalar, Scalar) -> Scalar) -> Self {
        var result = a.components
        for i in 0..<N {
            result[i] = combine(a.components[i], b.components[i])
        }
        return Self(result)
    }
}
