// Vector.swift
// A fixed-size displacement vector with compile-time known dimensions.

extension Geometry {
    /// A fixed-size displacement vector with compile-time known dimensions.
    ///
    /// `Vector` represents a displacement or direction, as opposed to `Point`
    /// which represents a position. This distinction enables clearer semantics:
    /// - Points can be translated by vectors
    /// - Vectors can be added to each other
    /// - The difference of two points is a vector
    ///
    /// Uses Swift 6.2 integer generic parameters (SE-0452) for type-safe
    /// dimension checking at compile time.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let velocity: Geometry.Vector<2> = .init(dx: 10, dy: 5)
    /// let velocity3D: Geometry.Vector<3, Double> = .init(dx: 1, dy: 2, dz: 3)
    /// ```
    public struct Vector<let N: Int> {
        /// The vector components stored inline
        public var components: InlineArray<N, Unit>

        /// Create a vector from an inline array of components
        @inlinable
        public init(_ components: consuming InlineArray<N, Unit>) {
            self.components = components
        }
    }
}

extension Geometry.Vector: Sendable where Unit: Sendable {}

// MARK: - Equatable

extension Geometry.Vector: Equatable where Unit: Equatable {
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

extension Geometry.Vector: Hashable where Unit: Hashable {
    @inlinable
    public func hash(into hasher: inout Hasher) {
        for i in 0..<N {
            hasher.combine(components[i])
        }
    }
}

// MARK: - Typealiases

extension Geometry {
    /// A 2D vector
    public typealias Vector2 = Vector<2>

    /// A 3D vector
    public typealias Vector3 = Vector<3>

    /// A 4D vector
    public typealias Vector4 = Vector<4>
}

// MARK: - Codable

extension Geometry.Vector: Codable where Unit: Codable {
    public init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var components = InlineArray<N, Unit>(repeating: try container.decode(Unit.self))
        for i in 1..<N {
            components[i] = try container.decode(Unit.self)
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

extension Geometry.Vector {
    /// Access component by index
    @inlinable
    public subscript(index: Int) -> Unit {
        get { components[index] }
        set { components[index] = newValue }
    }
}

// MARK: - Functorial Map

extension Geometry.Vector {
    /// Create a vector by transforming each component of another vector
    @inlinable
    public init<U>(_ other: borrowing Geometry<U>.Vector<N>, _ transform: (U) -> Unit) {
        var comps = InlineArray<N, Unit>(repeating: transform(other.components[0]))
        for i in 1..<N {
            comps[i] = transform(other.components[i])
        }
        self.init(comps)
    }

    /// Transform each component using the given closure
    @inlinable
    public func map<E: Error, Result>(
        _ transform: (Unit) throws(E) -> Result
    ) throws(E) -> Geometry<Result>.Vector<N> {
        var result = InlineArray<N, Result>(repeating: try transform(components[0]))
        for i in 1..<N {
            result[i] = try transform(components[i])
        }
        return Geometry<Result>.Vector<N>(result)
    }
}

// MARK: - Zero

extension Geometry.Vector where Unit: AdditiveArithmetic {
    /// The zero vector
    @inlinable
    public static var zero: Self {
        Self(InlineArray(repeating: .zero))
    }
}

// MARK: - AdditiveArithmetic

extension Geometry.Vector: AdditiveArithmetic where Unit: AdditiveArithmetic {
    /// Add two vectors
    @inlinable
    public static func + (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        var result = lhs.components
        for i in 0..<N {
            result[i] = lhs.components[i] + rhs.components[i]
        }
        return Self(result)
    }

    /// Subtract two vectors
    @inlinable
    public static func - (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        var result = lhs.components
        for i in 0..<N {
            result[i] = lhs.components[i] - rhs.components[i]
        }
        return Self(result)
    }
}

// MARK: - Negation (SignedNumeric)

extension Geometry.Vector where Unit: SignedNumeric {
    /// Negate vector
    @inlinable
    public static prefix func - (value: borrowing Self) -> Self {
        var result = value.components
        for i in 0..<N {
            result[i] = -value.components[i]
        }
        return Self(result)
    }
}

// MARK: - Scalar Operations (FloatingPoint)

extension Geometry.Vector where Unit: FloatingPoint {
    /// Scale vector by a scalar
    @inlinable
    public static func * (lhs: borrowing Self, rhs: Unit) -> Self {
        var result = lhs.components
        for i in 0..<N {
            result[i] = lhs.components[i] * rhs
        }
        return Self(result)
    }

    /// Scale vector by a scalar
    @inlinable
    public static func * (lhs: Unit, rhs: borrowing Self) -> Self {
        var result = rhs.components
        for i in 0..<N {
            result[i] = lhs * rhs.components[i]
        }
        return Self(result)
    }

    /// Divide vector by a scalar
    @inlinable
    public static func / (lhs: borrowing Self, rhs: Unit) -> Self {
        var result = lhs.components
        for i in 0..<N {
            result[i] = lhs.components[i] / rhs
        }
        return Self(result)
    }
}

// MARK: - Properties (FloatingPoint)

extension Geometry.Vector where Unit: FloatingPoint {
    /// The squared length of the vector
    ///
    /// Use this when comparing magnitudes to avoid the sqrt computation.
    @inlinable
    public var lengthSquared: Unit {
        var sum = Unit.zero
        for i in 0..<N {
            sum += components[i] * components[i]
        }
        return sum
    }

    /// The length (magnitude) of the vector
    @inlinable
    public var length: Unit {
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

extension Geometry.Vector where Unit: FloatingPoint {
    /// Dot product of two vectors
    @inlinable
    public func dot(_ other: borrowing Self) -> Unit {
        var sum = Unit.zero
        for i in 0..<N {
            sum += components[i] * other.components[i]
        }
        return sum
    }
}

// MARK: - 2D Convenience

extension Geometry.Vector where N == 2 {
    /// The x component (horizontal displacement)
    @inlinable
    public var dx: Unit {
        get { components[0] }
        set { components[0] = newValue }
    }

    /// The y component (vertical displacement)
    @inlinable
    public var dy: Unit {
        get { components[1] }
        set { components[1] = newValue }
    }

    /// Create a 2D vector with the given components
    @inlinable
    public init(dx: Unit, dy: Unit) {
        self.init([dx, dy])
    }
}

// MARK: - 2D Cross Product (SignedNumeric)

extension Geometry.Vector where N == 2, Unit: SignedNumeric {
    /// 2D cross product (returns scalar z-component)
    ///
    /// This is the signed area of the parallelogram formed by the two vectors.
    /// Positive if `other` is counter-clockwise from `self`.
    @inlinable
    public func cross(_ other: borrowing Self) -> Unit {
        dx * other.dy - dy * other.dx
    }
}

// MARK: - 3D Convenience

extension Geometry.Vector where N == 3 {
    /// The x component
    @inlinable
    public var dx: Unit {
        get { components[0] }
        set { components[0] = newValue }
    }

    /// The y component
    @inlinable
    public var dy: Unit {
        get { components[1] }
        set { components[1] = newValue }
    }

    /// The z component
    @inlinable
    public var dz: Unit {
        get { components[2] }
        set { components[2] = newValue }
    }

    /// Create a 3D vector with the given components
    @inlinable
    public init(dx: Unit, dy: Unit, dz: Unit) {
        self.init([dx, dy, dz])
    }

    /// Create a 3D vector from a 2D vector with z component
    @inlinable
    public init(_ vector2: Geometry.Vector<2>, dz: Unit) {
        self.init(dx: vector2.dx, dy: vector2.dy, dz: dz)
    }
}

// MARK: - 3D Cross Product (SignedNumeric)

extension Geometry.Vector where N == 3, Unit: SignedNumeric {
    /// 3D cross product
    @inlinable
    public func cross(_ other: borrowing Self) -> Self {
        Self(
            dx: dy * other.dz - dz * other.dy,
            dy: dz * other.dx - dx * other.dz,
            dz: dx * other.dy - dy * other.dx
        )
    }
}

// MARK: - 4D Convenience

extension Geometry.Vector where N == 4 {
    /// The x component
    @inlinable
    public var dx: Unit {
        get { components[0] }
        set { components[0] = newValue }
    }

    /// The y component
    @inlinable
    public var dy: Unit {
        get { components[1] }
        set { components[1] = newValue }
    }

    /// The z component
    @inlinable
    public var dz: Unit {
        get { components[2] }
        set { components[2] = newValue }
    }

    /// The w component
    @inlinable
    public var dw: Unit {
        get { components[3] }
        set { components[3] = newValue }
    }

    /// Create a 4D vector with the given components
    @inlinable
    public init(dx: Unit, dy: Unit, dz: Unit, dw: Unit) {
        self.init([dx, dy, dz, dw])
    }

    /// Create a 4D vector from a 3D vector with w component
    @inlinable
    public init(_ vector3: Geometry.Vector<3>, dw: Unit) {
        self.init(dx: vector3.dx, dy: vector3.dy, dz: vector3.dz, dw: dw)
    }
}

// MARK: - Zip

extension Geometry.Vector {
    /// Combine two vectors component-wise
    @inlinable
    public static func zip(_ a: Self, _ b: Self, _ combine: (Unit, Unit) -> Unit) -> Self {
        var result = a.components
        for i in 0..<N {
            result[i] = combine(a.components[i], b.components[i])
        }
        return Self(result)
    }
}
