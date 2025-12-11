// Affine.Point.swift
// A fixed-size coordinate with compile-time known dimensions.

public import Algebra
public import Algebra_Linear
public import Dimension

extension Affine {
    /// Position in N-dimensional affine space with compile-time dimension checking.
    ///
    /// Represents absolute position rather than displacement, contrasting with `Linear.Vector`.
    /// Points support affine operations: translate by vectors, compute displacement between points.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let origin: Affine<Double>.Point<2> = .zero
    /// let p = Affine<Double>.Point(x: 72.0, y: 144.0)
    /// let displacement = p - origin  // Returns Linear<Double>.Vector<2>
    /// ```
    public struct Point<let N: Int> {
        /// Coordinate values stored as inline array for performance.
        public var coordinates: InlineArray<N, Scalar>

        /// Creates a point from coordinate array.
        @inlinable
        public init(_ coordinates: consuming InlineArray<N, Scalar>) {
            self.coordinates = coordinates
        }
    }
}

extension Affine.Point: Sendable where Scalar: Sendable {}

// MARK: - Equatable

extension Affine.Point: Equatable where Scalar: Equatable {
    @inlinable
    public static func == (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        for i in 0..<N {
            if lhs.coordinates[i] != rhs.coordinates[i] {
                return false
            }
        }
        return true
    }
}

// MARK: - Hashable

extension Affine.Point: Hashable where Scalar: Hashable {
    @inlinable
    public func hash(into hasher: inout Hasher) {
        for i in 0..<N {
            hasher.combine(coordinates[i])
        }
    }
}

// MARK: - Typealiases

extension Affine {
    /// A 2D point
    public typealias Point2 = Point<2>

    /// A 3D point
    public typealias Point3 = Point<3>

    /// A 4D point
    public typealias Point4 = Point<4>
}

// MARK: - Codable

#if Codable
    extension Affine.Point: Codable where Scalar: Codable {
        public init(from decoder: any Decoder) throws {
            var container = try decoder.unkeyedContainer()
            var coordinates = InlineArray<N, Scalar>(repeating: try container.decode(Scalar.self))
            for i in 1..<N {
                coordinates[i] = try container.decode(Scalar.self)
            }
            self.coordinates = coordinates
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.unkeyedContainer()
            for i in 0..<N {
                try container.encode(coordinates[i])
            }
        }
    }
#endif

// MARK: - Subscript

extension Affine.Point {
    /// Accesses coordinate at specified dimension index.
    @inlinable
    public subscript(index: Int) -> Scalar {
        get { coordinates[index] }
        set { coordinates[index] = newValue }
    }
}

// MARK: - Functorial Map

extension Affine.Point {
    /// Creates a point by transforming each coordinate of another point.
    @inlinable
    public init<U, E: Error>(
        _ other: borrowing Affine<U>.Point<N>,
        _ transform: (U) throws(E) -> Scalar
    ) throws(E) {
        var coords = InlineArray<N, Scalar>(repeating: try transform(other.coordinates[0]))
        for i in 1..<N {
            coords[i] = try transform(other.coordinates[i])
        }
        self.init(coords)
    }

    /// Transforms each coordinate using the given closure.
    @inlinable
    public func map<Result, E: Error>(
        _ transform: (Scalar) throws(E) -> Result
    ) throws(E) -> Affine<Result>.Point<N> {
        var result = InlineArray<N, Result>(repeating: try transform(coordinates[0]))
        for i in 1..<N {
            result[i] = try transform(coordinates[i])
        }
        return Affine<Result>.Point<N>(result)
    }
}

// MARK: - Zero

extension Affine.Point where Scalar: AdditiveArithmetic {
    /// Origin point with all coordinates set to zero.
    @inlinable
    public static var zero: Self {
        Self(InlineArray(repeating: .zero))
    }
}

// MARK: - Affine Arithmetic

extension Affine.Point where Scalar: AdditiveArithmetic {
    /// Computes displacement vector from `rhs` to `lhs`.
    ///
    /// Returns the vector representing the displacement needed to move from point `rhs` to point `lhs`.
    /// This fundamental affine operation converts position difference into directional displacement.
    ///
    /// ## Note
    ///
    /// Adding two points (`Point + Point`) is intentionally unsupported as it lacks geometric meaning.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let p = Affine<Double>.Point(x: 10, y: 20)
    /// let q = Affine<Double>.Point(x: 4, y: 8)
    /// let v = p - q  // Vector(dx: 6, dy: 12) — displacement from q to p
    /// ```
    @inlinable
    @_disfavoredOverload
    public static func - (lhs: borrowing Self, rhs: borrowing Self) -> Linear<Scalar>.Vector<N> {
        var result = InlineArray<N, Scalar>(repeating: lhs.coordinates[0] - rhs.coordinates[0])
        for i in 1..<N {
            result[i] = lhs.coordinates[i] - rhs.coordinates[i]
        }
        return Linear<Scalar>.Vector(result)
    }

    /// Translates point by adding displacement vector.
    ///
    /// Fundamental affine operation moving a position by a directional displacement.
    @inlinable
    @_disfavoredOverload
    public static func + (lhs: borrowing Self, rhs: borrowing Linear<Scalar>.Vector<N>) -> Self {
        var result = lhs.coordinates
        for i in 0..<N {
            result[i] = lhs.coordinates[i] + rhs.components[i]
        }
        return Self(result)
    }

    /// Translates point by subtracting displacement vector.
    @inlinable
    @_disfavoredOverload
    public static func - (lhs: borrowing Self, rhs: borrowing Linear<Scalar>.Vector<N>) -> Self {
        var result = lhs.coordinates
        for i in 0..<N {
            result[i] = lhs.coordinates[i] - rhs.components[i]
        }
        return Self(result)
    }
}

// MARK: - 2D Convenience

extension Affine.Point where N == 2 {
    /// Horizontal coordinate position.
    @inlinable
    public var x: Affine.X {
        get { Affine.X(coordinates[0]) }
        set { coordinates[0] = newValue.value }
    }

    /// Vertical coordinate position.
    @inlinable
    public var y: Affine.Y {
        get { Affine.Y(coordinates[1]) }
        set { coordinates[1] = newValue.value }
    }

    /// Creates 2D point from type-safe coordinate components.
    @inlinable
    public init(x: Affine.X, y: Affine.Y) {
        self.init([x.value, y.value])
    }
}

// MARK: - 3D Convenience

extension Affine.Point where N == 3 {
    /// Horizontal coordinate position.
    @inlinable
    public var x: Affine.X {
        get { .init(coordinates[0]) }
        set { coordinates[0] = newValue.value }
    }

    /// Vertical coordinate position.
    @inlinable
    public var y: Affine.Y {
        get { .init(coordinates[1]) }
        set { coordinates[1] = newValue.value }
    }

    /// Depth coordinate position.
    @inlinable
    public var z: Affine.Z {
        get { .init(coordinates[2]) }
        set { coordinates[2] = newValue.value }
    }

    /// Creates 3D point from type-safe coordinate components.
    @inlinable
    public init(x: Affine.X, y: Affine.Y, z: Affine.Z) {
        self.init([x.value, y.value, z.value])
    }

    /// Creates 3D point by extending 2D point with depth coordinate.
    @inlinable
    public init(_ point2: Affine.Point<2>, z: Affine.Z) {
        self.init(x: point2.x, y: point2.y, z: z)
    }
}

// MARK: - 4D Convenience

extension Affine.Point where N == 4 {
    /// Horizontal coordinate position.
    @inlinable
    public var x: Affine.X {
        get { .init(coordinates[0]) }
        set { coordinates[0] = newValue.value }
    }

    /// Vertical coordinate position.
    @inlinable
    public var y: Affine.Y {
        get { .init(coordinates[1]) }
        set { coordinates[1] = newValue.value }
    }

    /// Depth coordinate position.
    @inlinable
    public var z: Affine.Z {
        get { .init(coordinates[2]) }
        set { coordinates[2] = newValue.value }
    }

    /// Homogeneous coordinate for projective transformations.
    @inlinable
    public var w: Affine.W {
        get { .init(coordinates[3]) }
        set { coordinates[3] = newValue.value }
    }

    /// Creates 4D point from type-safe coordinate components.
    @inlinable
    public init(x: Affine.X, y: Affine.Y, z: Affine.Z, w: Affine.W) {
        self.init([x.value, y.value, z.value, w.value])
    }

    /// Creates 4D point by extending 3D point with homogeneous coordinate.
    @inlinable
    public init(_ point3: Affine.Point<3>, w: Affine.W) {
        self.init(x: point3.x, y: point3.y, z: point3.z, w: w)
    }
}

// MARK: - Zip

extension Affine.Point {
    /// Combines two points component-wise using custom function.
    @inlinable
    public static func zip(_ a: Self, _ b: Self, _ combine: (Scalar, Scalar) -> Scalar) -> Self {
        var result = a.coordinates
        for i in 0..<N {
            result[i] = combine(a.coordinates[i], b.coordinates[i])
        }
        return Self(result)
    }
}

// MARK: - 2D Point Translation (AdditiveArithmetic)

extension Affine.Point where N == 2, Scalar: AdditiveArithmetic {
    /// Returns point translated by displacement components.
    @inlinable
    public func translated(dx: Scalar, dy: Scalar) -> Self {
        Self(x: x + dx, y: y + dy)
    }

    /// Returns point translated by displacement vector.
    @inlinable
    public func translated(by vector: Linear<Scalar>.Vector<2>) -> Self {
        Self(x: x + vector.dx, y: y + vector.dy)
    }

    /// Computes displacement vector from this point to another.
    @inlinable
    public func vector(to other: Self) -> Linear<Scalar>.Vector<2> {
        Linear<Scalar>.Vector(dx: other.x - x, dy: other.y - y)
    }
}

// MARK: - 2D Point Distance (FloatingPoint)

extension Affine.Point where N == 2, Scalar: FloatingPoint {
    /// Computes squared Euclidean distance to another point.
    ///
    /// More efficient than `distance(to:)` when comparing distances.
    @inlinable
    public func distanceSquared(to other: Self) -> Scalar {
        let dx = other.x.value - x.value
        let dy = other.y.value - y.value
        return dx * dx + dy * dy
    }

    /// Computes Euclidean distance to another point.
    @inlinable
    public func distance(to other: Self) -> Scalar {
        distanceSquared(to: other).squareRoot()
    }

    /// Linearly interpolates between this point and another.
    ///
    /// - Parameters:
    ///   - other: Target point
    ///   - t: Interpolation parameter where `0` returns `self` and `1` returns `other`
    @inlinable
    public func lerp(to other: Self, t: Scalar) -> Self {
        Self(
            x: Affine.X(x.value + t * (other.x.value - x.value)),
            y: Affine.Y(y.value + t * (other.y.value - y.value))
        )
    }

    /// Computes midpoint between this point and another.
    @inlinable
    public func midpoint(to other: Self) -> Self {
        Self(
            x: Affine.X((x.value + other.x.value) / 2),
            y: Affine.Y((y.value + other.y.value) / 2)
        )
    }
}

// MARK: - 3D Point Translation (AdditiveArithmetic)

extension Affine.Point where N == 3, Scalar: AdditiveArithmetic {
    /// Returns point translated by displacement components.
    @inlinable
    public func translated(dx: Affine.X, dy: Affine.Y, dz: Affine.Z) -> Self {
        Self(x: x + dx, y: y + dy, z: z + dz)
    }

    /// Returns point translated by displacement vector.
    @inlinable
    public func translated(by vector: Linear<Scalar>.Vector<3>) -> Self {
        Self(x: x + vector.dx, y: y + vector.dy, z: z + vector.dz)
    }

    /// Computes displacement vector from this point to another.
    @inlinable
    public func vector(to other: Self) -> Linear<Scalar>.Vector<3> {
        Linear<Scalar>.Vector(dx: other.x - x, dy: other.y - y, dz: other.z - z)
    }
}

// MARK: - 3D Point Distance (FloatingPoint)

extension Affine.Point where N == 3, Scalar: FloatingPoint {
    /// Computes squared Euclidean distance to another point.
    ///
    /// More efficient than `distance(to:)` when comparing distances.
    @inlinable
    public func distanceSquared(to other: Self) -> Scalar {
        let dx = other.x - x
        let dy = other.y - y
        let dz = other.z - z
        return dx * dx + dy * dy + dz * dz
    }

    /// Computes Euclidean distance to another point.
    @inlinable
    public func distance(to other: Self) -> Scalar {
        distanceSquared(to: other).squareRoot()
    }
}
