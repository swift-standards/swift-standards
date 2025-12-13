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
    /// let origin: Affine<Double>.Point<2, MySpace> = .zero
    /// let p = Affine<Double>.Point<2, MySpace>(x: .init(72.0), y: .init(144.0))
    /// let displacement = p - origin  // Returns Linear<Double>.Vector<2, Space, MySpace>
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
        _ other: borrowing Affine<U, Space>.Point<N>,
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
    ) throws(E) -> Affine<Result, Space>.Point<N> {
        var result = InlineArray<N, Result>(repeating: try transform(coordinates[0]))
        for i in 1..<N {
            result[i] = try transform(coordinates[i])
        }
        return Affine<Result, Space>.Point<N>(result)
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
    public static func - (
        lhs: borrowing Self,
        rhs: borrowing Self
    ) -> Linear<Scalar, Space>.Vector<N> {
        var result = InlineArray<N, Scalar>(repeating: lhs.coordinates[0] - rhs.coordinates[0])
        for i in 1..<N {
            result[i] = lhs.coordinates[i] - rhs.coordinates[i]
        }
        return Linear<Scalar, Space>.Vector(result)
    }

    /// Translates point by adding displacement vector.
    ///
    /// Fundamental affine operation moving a position by a directional displacement.
    @inlinable
    @_disfavoredOverload
    public static func + (
        lhs: borrowing Self,
        rhs: borrowing Linear<Scalar, Space>.Vector<N>
    ) -> Self {
        var result = lhs.coordinates
        for i in 0..<N {
            result[i] = lhs.coordinates[i] + rhs.components[i]
        }
        return Self(result)
    }

    /// Translates point by subtracting displacement vector.
    @inlinable
    @_disfavoredOverload
    public static func - (
        lhs: borrowing Self,
        rhs: borrowing Linear<Scalar, Space>.Vector<N>
    ) -> Self {
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
        set { coordinates[0] = newValue._rawValue }
    }

    /// Vertical coordinate position.
    @inlinable
    public var y: Affine.Y {
        get { Affine.Y(coordinates[1]) }
        set { coordinates[1] = newValue._rawValue }
    }

    /// Creates 2D point from type-safe coordinate components.
    @inlinable
    public init(x: Affine.X, y: Affine.Y) {
        self.init([x._rawValue, y._rawValue])
    }
}

// MARK: - 3D Convenience

extension Affine.Point where N == 3 {
    /// Horizontal coordinate position.
    @inlinable
    public var x: Affine.X {
        get { .init(coordinates[0]) }
        set { coordinates[0] = newValue._rawValue }
    }

    /// Vertical coordinate position.
    @inlinable
    public var y: Affine.Y {
        get { .init(coordinates[1]) }
        set { coordinates[1] = newValue._rawValue }
    }

    /// Depth coordinate position.
    @inlinable
    public var z: Affine.Z {
        get { .init(coordinates[2]) }
        set { coordinates[2] = newValue._rawValue }
    }

    /// Creates 3D point from type-safe coordinate components.
    @inlinable
    public init(x: Affine.X, y: Affine.Y, z: Affine.Z) {
        self.init([x._rawValue, y._rawValue, z._rawValue])
    }

    /// Creates 3D point by extending 2D point with depth coordinate.
    @inlinable
    public init(_ point2: Affine.Point2, z: Affine.Z) {
        self.init(x: point2.x, y: point2.y, z: z)
    }
}

// MARK: - 4D Convenience

extension Affine.Point where N == 4 {
    /// Horizontal coordinate position.
    @inlinable
    public var x: Affine.X {
        get { .init(coordinates[0]) }
        set { coordinates[0] = newValue._rawValue }
    }

    /// Vertical coordinate position.
    @inlinable
    public var y: Affine.Y {
        get { .init(coordinates[1]) }
        set { coordinates[1] = newValue._rawValue }
    }

    /// Depth coordinate position.
    @inlinable
    public var z: Affine.Z {
        get { .init(coordinates[2]) }
        set { coordinates[2] = newValue._rawValue }
    }

    /// Homogeneous coordinate for projective transformations.
    @inlinable
    public var w: Affine.W {
        get { .init(coordinates[3]) }
        set { coordinates[3] = newValue._rawValue }
    }

    /// Creates 4D point from type-safe coordinate components.
    @inlinable
    public init(x: Affine.X, y: Affine.Y, z: Affine.Z, w: Affine.W) {
        self.init([x._rawValue, y._rawValue, z._rawValue, w._rawValue])
    }

    /// Creates 4D point by extending 3D point with homogeneous coordinate.
    @inlinable
    public init(_ point3: Affine.Point3, w: Affine.W) {
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
    public static func translated(_ point: Self, dx: Affine.Dx, dy: Affine.Dy) -> Self {
        Self(x: point.x + dx, y: point.y + dy)
    }

    /// Returns point translated by displacement components.
    @inlinable
    public func translated(dx: Affine.Dx, dy: Affine.Dy) -> Self {
        Self.translated(self, dx: dx, dy: dy)
    }

    /// Returns point translated by displacement vector.
    @inlinable
    public static func translated(_ point: Self, by vector: Linear<Scalar, Space>.Vector<2>) -> Self {
        Self(x: point.x + vector.dx, y: point.y + vector.dy)
    }

    /// Returns point translated by displacement vector.
    @inlinable
    public func translated(by vector: Linear<Scalar, Space>.Vector<2>) -> Self {
        Self.translated(self, by: vector)
    }

    /// Computes displacement vector from one point to another.
    @inlinable
    public static func vector(from point: Self, to other: Self) -> Linear<Scalar, Space>.Vector<2> {
        Linear<Scalar, Space>.Vector(dx: other.x - point.x, dy: other.y - point.y)
    }

    /// Computes displacement vector from this point to another.
    @inlinable
    public func vector(to other: Self) -> Linear<Scalar, Space>.Vector<2> {
        Self.vector(from: self, to: other)
    }
}

// MARK: - 2D Point Distance (FloatingPoint)

extension Affine.Point where N == 2, Scalar: FloatingPoint {
    

    /// Linearly interpolates between two points.
    ///
    /// - Parameters:
    ///   - from: Starting point
    ///   - to: Target point
    ///   - t: Interpolation parameter where `0` returns `from` and `1` returns `to`
    @inlinable
    public static func lerp(from point: Self, to other: Self, t: Scalar) -> Self {
        Self(
            x: point.x + t * (other.x - point.x),
            y: point.y + t * (other.y - point.y)
        )
    }

    /// Linearly interpolates between this point and another.
    ///
    /// - Parameters:
    ///   - other: Target point
    ///   - t: Interpolation parameter where `0` returns `self` and `1` returns `other`
    @inlinable
    public func lerp(to other: Self, t: Scalar) -> Self {
        Self.lerp(from: self, to: other, t: t)
    }

    /// Computes midpoint between two points.
    /// Uses affine formula: p1 + (p2 - p1) / 2
    @inlinable
    public static func midpoint(from point: Self, to other: Self) -> Self {
        // Displacement / 2 = scaled displacement, then add to coordinate
        Self(
            x: point.x + (other.x - point.x) / 2,
            y: point.y + (other.y - point.y) / 2
        )
    }

    /// Computes midpoint between this point and another.
    @inlinable
    public func midpoint(to other: Self) -> Self {
        Self.midpoint(from: self, to: other)
    }
}

extension Affine.Point where N == 2, Scalar: FloatingPoint {

    public static var distance: Affine.Point<2>.Distance2.Type {
        Affine.Point<2>.Distance2.self
    }

    public var distance: Affine.Point<2>.Distance2 {
        .init(point: self)
    }
    
    public struct Distance2 {
        var point: Affine.Point<2>
        
        public static func squared(from point: Affine.Point<2>, to other: Affine.Point<2>) -> Affine<Scalar, Space>.Area {
            let dx = other.x - point.x
            let dy = other.y - point.y
            return dx * dx + dy * dy
        }

        public func squared(to other: Affine.Point<2>) -> Affine<Scalar, Space>.Area {
            Self.squared(from: point, to: other)
        }
        
        public static func from(_ point: Affine.Point<2>, to other: Affine.Point<2>) -> Affine.Distance {
            // sqrt(Area) = Magnitude = Distance
            sqrt(squared(from: point, to: other))
        }

        public func callAsFunction(to other: Affine.Point<2>) -> Affine.Distance {
            Self.from(point, to: other)
        }
    }
}

// MARK: - 3D Point Translation (AdditiveArithmetic)

extension Affine.Point where N == 3, Scalar: AdditiveArithmetic {
    /// Returns point translated by displacement components.
    @inlinable
    public static func translated(
        _ point: Self,
        dx: Linear<Scalar, Space>.Dx,
        dy: Linear<Scalar, Space>.Dy,
        dz: Linear<Scalar, Space>.Dz
    ) -> Self {
        Self(x: point.x + dx, y: point.y + dy, z: point.z + dz)
    }

    /// Returns point translated by displacement components.
    @inlinable
    public func translated(
        dx: Linear<Scalar, Space>.Dx,
        dy: Linear<Scalar, Space>.Dy,
        dz: Linear<Scalar, Space>.Dz
    ) -> Self {
        Self.translated(self, dx: dx, dy: dy, dz: dz)
    }

    /// Returns point translated by displacement vector.
    @inlinable
    public static func translated(_ point: Self, by vector: Linear<Scalar, Space>.Vector<3>) -> Self {
        Self(x: point.x + vector.dx, y: point.y + vector.dy, z: point.z + vector.dz)
    }

    /// Returns point translated by displacement vector.
    @inlinable
    public func translated(by vector: Linear<Scalar, Space>.Vector<3>) -> Self {
        Self.translated(self, by: vector)
    }

    /// Computes displacement vector from one point to another.
    @inlinable
    public static func vector(from point: Self, to other: Self) -> Linear<Scalar, Space>.Vector<3> {
        Linear<Scalar, Space>.Vector(dx: other.x - point.x, dy: other.y - point.y, dz: other.z - point.z)
    }

    /// Computes displacement vector from this point to another.
    @inlinable
    public func vector(to other: Self) -> Linear<Scalar, Space>.Vector<3> {
        Self.vector(from: self, to: other)
    }
}

// MARK: - 3D Point Distance (FloatingPoint)

extension Affine.Point where N == 3, Scalar: FloatingPoint {
    
    public static var distance: Affine.Point<3>.Distance3.Type {
        Affine.Point<3>.Distance3.self
    }

    public var distance: Affine.Point<3>.Distance3 {
        .init(point: self)
    }
    
    public struct Distance3 {
        var point: Affine.Point<3>
        
        public static func squared(from point: Affine.Point<3>, to other: Affine.Point<3>) -> Affine<Scalar, Space>.Area {
            let dx = other.x - point.x
            let dy = other.y - point.y
            let dz = other.z - point.z
            return dx * dx + dy * dy + dz * dz
        }

        public func squared(to other: Affine.Point<3>) -> Affine<Scalar, Space>.Area {
            Self.squared(from: point, to: other)
        }
        
        public static func from(_ point: Affine.Point<3>, to other: Affine.Point<3>) -> Affine.Distance {
            // sqrt(Area) = Magnitude = Distance
            sqrt(squared(from: point, to: other))
        }

        public func callAsFunction(to other: Affine.Point<3>) -> Affine.Distance {
            Self.from(point, to: other)
        }
    }
}


