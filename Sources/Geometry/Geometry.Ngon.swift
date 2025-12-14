// Ngon.swift
// An N-sided polygon with exactly N vertices (compile-time enforced).

public import Affine
public import Algebra
public import Algebra_Linear
public import Dimension
public import RealModule

extension Geometry {
    /// An N-sided polygon in 2D space with exactly N vertices.
    ///
    /// Uses Swift integer generic parameters (SE-0452) for compile-time
    /// enforcement of vertex count. For arbitrary vertex counts, use `Polygon`.
    ///
    /// Vertices are ordered consecutively around the polygon.
    /// For positive signed area, vertices should be ordered counter-clockwise.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // A quadrilateral (4 vertices)
    /// let quad: Geometry<Double, Void>.Ngon<4, Void> = .init(vertices: [
    ///     .init(x: 0, y: 0),
    ///     .init(x: 1, y: 0),
    ///     .init(x: 1, y: 1),
    ///     .init(x: 0, y: 1)
    /// ])
    /// print(quad.area)       // 1.0
    /// print(quad.perimeter)  // 4.0
    /// ```
    public struct Ngon<let N: Int> {
        /// The vertices stored inline with compile-time known count
        public var vertices: InlineArray<N, Point<2>>

        /// Create an N-gon from an inline array of vertices
        @inlinable
        public init(_ vertices: consuming InlineArray<N, Point<2>>) {
            self.vertices = vertices
        }
    }
}

extension Geometry.Ngon: Sendable where Scalar: Sendable {}

// MARK: - Equatable

extension Geometry.Ngon: Equatable where Scalar: Equatable {
    @inlinable
    public static func == (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        for i in 0..<N {
            if lhs.vertices[i] != rhs.vertices[i] {
                return false
            }
        }
        return true
    }
}

// MARK: - Hashable

extension Geometry.Ngon: Hashable where Scalar: Hashable {
    @inlinable
    public func hash(into hasher: inout Hasher) {
        for i in 0..<N {
            hasher.combine(vertices[i])
        }
    }
}

// MARK: - Codable

#if Codable
    extension Geometry.Ngon: Codable where Scalar: Codable {
        public init(from decoder: any Decoder) throws {
            var container = try decoder.unkeyedContainer()
            let first = try container.decode(Geometry.Point<2>.self)
            var verts = InlineArray<N, Geometry.Point<2>>(repeating: first)
            for i in 1..<N {
                verts[i] = try container.decode(Geometry.Point<2>.self)
            }
            self.vertices = verts
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.unkeyedContainer()
            for i in 0..<N {
                try container.encode(vertices[i])
            }
        }
    }
#endif

// MARK: - Typealiases

extension Geometry {
    /// A quadrilateral (4-sided polygon)
    public typealias Quadrilateral = Ngon<4>

    /// A pentagon (5-sided polygon)
    public typealias Pentagon = Ngon<5>

    /// A hexagon (6-sided polygon)
    public typealias Hexagon = Ngon<6>
}

// MARK: - Subscript

extension Geometry.Ngon {
    /// Access vertex by index
    @inlinable
    public subscript(index: Int) -> Geometry.Point<2> {
        get { vertices[index] }
        set { vertices[index] = newValue }
    }
}

// MARK: - Array Initializer

extension Geometry.Ngon {
    /// Create an N-gon from an array of exactly N vertices.
    ///
    /// - Parameter vertices: Array of N points
    /// - Returns: An N-gon, or `nil` if the array doesn't have exactly N points
    @inlinable
    public init?(vertices array: [Geometry.Point<2>]) {
        guard array.count == N, let first = array.first else { return nil }
        var verts = InlineArray<N, Geometry.Point<2>>(repeating: first)
        for i in 1..<N {
            verts[i] = array[i]
        }
        self.init(verts)
    }
}

// MARK: - Vertices as Array

extension Geometry.Ngon {
    /// The vertices as a Swift array
    @inlinable
    public var vertexArray: [Geometry.Point<2>] {
        var result: [Geometry.Point<2>] = []
        result.reserveCapacity(N)
        for i in 0..<N {
            result.append(vertices[i])
        }
        return result
    }
}

// MARK: - Edges Type

extension Geometry {
    /// A fixed-size collection of edge segments for an N-gon.
    public struct Edges<let N: Int> {
        /// The edge segments stored inline.
        public var segments: InlineArray<N, Line.Segment>

        /// Create edges from an inline array of segments.
        @inlinable
        public init(_ segments: InlineArray<N, Line.Segment>) {
            self.segments = segments
        }

        /// Access edge by index.
        @inlinable
        public subscript(index: Int) -> Line.Segment {
            get { segments[index] }
            set { segments[index] = newValue }
        }
    }
}

extension Geometry.Edges: Sendable where Scalar: Sendable {}

extension Geometry.Edges: Equatable where Scalar: Equatable {
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        for i in 0..<N {
            if lhs.segments[i] != rhs.segments[i] {
                return false
            }
        }
        return true
    }
}

extension Geometry.Edges: Hashable where Scalar: Hashable {
    @inlinable
    public func hash(into hasher: inout Hasher) {
        for i in 0..<N {
            hasher.combine(segments[i])
        }
    }
}

// MARK: - Edges (N == 3) Named Accessors

extension Geometry.Edges where N == 3 {
    /// Edge from vertex A to vertex B.
    @inlinable
    public var ab: Geometry.Line.Segment {
        get { segments[0] }
        set { segments[0] = newValue }
    }

    /// Edge from vertex B to vertex C.
    @inlinable
    public var bc: Geometry.Line.Segment {
        get { segments[1] }
        set { segments[1] = newValue }
    }

    /// Edge from vertex C to vertex A.
    @inlinable
    public var ca: Geometry.Line.Segment {
        get { segments[2] }
        set { segments[2] = newValue }
    }
}

// MARK: - Edges (N == 4) Named Accessors

extension Geometry.Edges where N == 4 {
    /// Edge from vertex A to vertex B.
    @inlinable
    public var ab: Geometry.Line.Segment {
        get { segments[0] }
        set { segments[0] = newValue }
    }

    /// Edge from vertex B to vertex C.
    @inlinable
    public var bc: Geometry.Line.Segment {
        get { segments[1] }
        set { segments[1] = newValue }
    }

    /// Edge from vertex C to vertex D.
    @inlinable
    public var cd: Geometry.Line.Segment {
        get { segments[2] }
        set { segments[2] = newValue }
    }

    /// Edge from vertex D to vertex A.
    @inlinable
    public var da: Geometry.Line.Segment {
        get { segments[3] }
        set { segments[3] = newValue }
    }
}

// MARK: - Ngon Edges

extension Geometry.Ngon where Scalar: AdditiveArithmetic {
    /// The edges as line segments (connecting consecutive vertices).
    @inlinable
    public var edges: Geometry.Edges<N> {
        let first = Geometry.Line.Segment(start: vertices[0], end: vertices[1 % N])
        var result = InlineArray<N, Geometry.Line.Segment>(repeating: first)
        for i in 0..<N {
            let next = (i + 1) % N
            result[i] = Geometry.Line.Segment(start: vertices[i], end: vertices[next])
        }
        return Geometry.Edges(result)
    }
}

// MARK: - Area (SignedNumeric)

extension Geometry.Ngon where Scalar: SignedNumeric {
    /// The signed double area using the shoelace formula.
    ///
    /// Positive if vertices are counter-clockwise, negative if clockwise.
    @inlinable
    public var signedDoubleArea: Linear<Scalar, Space>.Area {
        // Shoelace formula: Σ(xᵢyⱼ - xⱼyᵢ)
        // Treating coordinates as displacements from origin
        let zeroX = Geometry.X.zero
        let zeroY = Geometry.Y.zero
        var sum: Linear<Scalar, Space>.Area = Tagged(.zero)
        for i in 0..<N {
            let j = (i + 1) % N
            // Coordinate - Coordinate.zero = Displacement
            let xi = vertices[i].x - zeroX
            let yi = vertices[i].y - zeroY
            let xj = vertices[j].x - zeroX
            let yj = vertices[j].y - zeroY
            // Dx × Dy = Area
            sum = sum + xi * yj - xj * yi
        }
        return sum
    }
}

extension Geometry.Ngon where Scalar: FloatingPoint {
    /// The signed area of the polygon
    @inlinable
    public var signedArea: Linear<Scalar, Space>.Area {
        signedDoubleArea / Scale(2)
    }

    /// The area of the polygon (always positive)
    @inlinable
    public var area: Geometry.Area { Geometry.area(of: self) }

    /// The perimeter of the polygon
    @inlinable
    public var perimeter: Geometry.Perimeter { Geometry.perimeter(of: self) }
}

// MARK: - Centroid (FloatingPoint)

extension Geometry.Ngon where Scalar: FloatingPoint & SignedNumeric {
    /// The centroid (center of mass) of the polygon.
    ///
    /// Returns `nil` if the polygon has zero area.
    @inlinable
    public var centroid: Geometry.Point<2>? { Geometry.centroid(of: self) }
}

// MARK: - Bounding Box (FloatingPoint)

extension Geometry.Ngon where Scalar: FloatingPoint {
    /// The axis-aligned bounding box of the polygon.
    @inlinable
    public var boundingBox: Geometry.Rectangle {
        var minX = vertices[0].x
        var maxX = vertices[0].x
        var minY = vertices[0].y
        var maxY = vertices[0].y

        for i in 1..<N {
            minX = min(minX, vertices[i].x)
            maxX = max(maxX, vertices[i].x)
            minY = min(minY, vertices[i].y)
            maxY = max(maxY, vertices[i].y)
        }

        return Geometry.Rectangle(
            llx: minX,
            lly: minY,
            urx: maxX,
            ury: maxY
        )
    }
}

// MARK: - Convexity (SignedNumeric & Comparable)

extension Geometry.Ngon where Scalar: SignedNumeric & Comparable {
    /// Whether the polygon is convex.
    ///
    /// A polygon is convex if all interior angles are less than 180 degrees,
    /// which is equivalent to all cross products of consecutive edges having
    /// the same sign.
    @inlinable
    public var isConvex: Bool {
        // Cross product of edge vectors: Dx × Dy - Dy × Dx = Area
        var sign: Linear<Scalar, Space>.Area?
        let zero: Linear<Scalar, Space>.Area = Tagged(.zero)

        for i in 0..<N {
            let j = (i + 1) % N
            let k = (i + 2) % N

            let v1x = vertices[j].x - vertices[i].x
            let v1y = vertices[j].y - vertices[i].y
            let v2x = vertices[k].x - vertices[j].x
            let v2y = vertices[k].y - vertices[j].y

            let cross = v1x * v2y - v1y * v2x

            if let existingSign = sign {
                if cross > zero && existingSign < zero { return false }
                if cross < zero && existingSign > zero { return false }
            } else if cross != zero {
                sign = cross
            }
        }

        return true
    }
}

// MARK: - Winding and Orientation

extension Geometry.Ngon where Scalar: SignedNumeric & Comparable {
    /// Whether the vertices are ordered counter-clockwise.
    @inlinable
    public var isCounterClockwise: Bool {
        signedDoubleArea > Tagged(.zero)
    }

    /// Whether the vertices are ordered clockwise.
    @inlinable
    public var isClockwise: Bool {
        signedDoubleArea < Tagged(.zero)
    }

    /// Return a polygon with reversed vertex order.
    @inlinable
    public var reversed: Self {
        var newVerts = vertices
        for i in 0..<(N / 2) {
            let j = N - 1 - i
            let temp = newVerts[i]
            newVerts[i] = newVerts[j]
            newVerts[j] = temp
        }
        return Self(newVerts)
    }
}

// MARK: - Containment (FloatingPoint)

extension Geometry.Ngon where Scalar: FloatingPoint {
    /// Check if a point is inside the polygon using the ray casting algorithm.
    ///
    /// - Parameter point: The point to test
    /// - Returns: `true` if the point is inside the polygon
    @inlinable
    public func contains(_ point: Geometry.Point<2>) -> Bool {
        // Ray casting algorithm - uses raw values for slope calculation
        // Slope (Dx/Dy) is dimensionless, then multiplied by Dy to get Dx
        var inside = false
        var j = N - 1

        for i in 0..<N {
            let vi = vertices[i]
            let vj = vertices[j]

            if (vi.y > point.y) != (vj.y > point.y) {
                // Compute x-intercept using raw values
                let dx = (vj.x - vi.x)._rawValue
                let dy = (vj.y - vi.y)._rawValue
                let py = (point.y - vi.y)._rawValue
                let xIntersect = vi.x._rawValue + dx / dy * py
                if point.x._rawValue < xIntersect {
                    inside.toggle()
                }
            }
            j = i
        }

        return inside
    }
}

// MARK: - Transformation (FloatingPoint)

extension Geometry.Ngon where Scalar: FloatingPoint {
    /// Return a polygon translated by the given vector.
    @inlinable
    public func translated(by vector: Geometry.Vector<2>) -> Self {
        var newVerts = vertices
        for i in 0..<N {
            newVerts[i] = vertices[i] + vector
        }
        return Self(newVerts)
    }

    /// Return a polygon scaled uniformly about its centroid.
    @inlinable
    public func scaled(by factor: Scale<1, Scalar>) -> Self? {
        guard let center = centroid else { return nil }
        return scaled(by: factor, about: center)
    }

    /// Return a polygon scaled uniformly about a given point.
    @inlinable
    public func scaled(by factor: Scale<1, Scalar>, about point: Geometry.Point<2>) -> Self {
        var newVerts = vertices
        for i in 0..<N {
            let v = vertices[i]
            // Scale × Displacement = Displacement, then Coordinate + Displacement = Coordinate
            let dx = factor * (v.x - point.x)
            let dy = factor * (v.y - point.y)
            newVerts[i] = Geometry.Point(x: point.x + dx, y: point.y + dy)
        }
        return Self(newVerts)
    }
}

// MARK: - Regular Polygon Factory

extension Geometry.Ngon where Scalar: Real & BinaryFloatingPoint {
    /// Create a regular N-gon with the given side length.
    ///
    /// A regular polygon has all sides equal length and all interior angles equal.
    /// Vertices are placed counter-clockwise starting from the rightmost point.
    ///
    /// - Parameters:
    ///   - sideLength: The length of each side
    ///   - center: The center of the polygon (default: origin)
    /// - Returns: A regular N-gon
    ///
    /// ## Example
    ///
    /// ```swift
    /// let hexagon = Geometry<Double, Void>.Hexagon.regular(sideLength: 10)
    /// let pentagon = Geometry<Double, Void>.Pentagon.regular(sideLength: 5, at: .init(x: 10, y: 10))
    /// ```
    @inlinable
    public static func regular(
        sideLength: Scalar,
        at center: Geometry.Point<2> = .zero
    ) -> Self {
        // Circumradius R = s / (2 × sin(π/N))
        let piOverN = Radian<Scalar>(Scalar.pi / Scalar(N))
        let circumradius = sideLength / (Scalar(2) * piOverN.sin.value)

        // Generate vertices at angles 2πi/N
        var verts = InlineArray<N, Geometry.Point<2>>(repeating: center)
        for i in 0..<N {
            let angle = Radian<Scalar>(Scalar(2) * Scalar.pi * Scalar(i) / Scalar(N))
            let dx = Linear<Scalar, Space>.Dx(circumradius * angle.cos.value)
            let dy = Linear<Scalar, Space>.Dy(circumradius * angle.sin.value)
            verts[i] = Geometry.Point(x: center.x + dx, y: center.y + dy)
        }

        return Self(verts)
    }

    /// Create a regular N-gon with the given circumradius.
    ///
    /// The circumradius is the distance from the center to each vertex.
    ///
    /// - Parameters:
    ///   - circumradius: The radius of the circumscribed circle
    ///   - center: The center of the polygon (default: origin)
    /// - Returns: A regular N-gon
    @inlinable
    public static func regular(
        circumradius: Scalar,
        at center: Geometry.Point<2> = .zero
    ) -> Self {
        // Generate vertices at angles 2πi/N
        var verts = InlineArray<N, Geometry.Point<2>>(repeating: center)
        for i in 0..<N {
            let angle = Radian<Scalar>(Scalar(2) * Scalar.pi * Scalar(i) / Scalar(N))
            let dx = Linear<Scalar, Space>.Dx(circumradius * angle.cos.value)
            let dy = Linear<Scalar, Space>.Dy(circumradius * angle.sin.value)
            verts[i] = Geometry.Point(x: center.x + dx, y: center.y + dy)
        }
        return Self(verts)
    }

    /// Create a regular N-gon with the given inradius (apothem).
    ///
    /// The inradius is the distance from the center to the midpoint of each side.
    ///
    /// - Parameters:
    ///   - inradius: The radius of the inscribed circle (apothem)
    ///   - center: The center of the polygon (default: origin)
    /// - Returns: A regular N-gon
    @inlinable
    public static func regular(
        inradius: Scalar,
        at center: Geometry.Point<2> = .zero
    ) -> Self {
        // Circumradius R = r / cos(π/N) where r is inradius
        let piOverN = Radian<Scalar>(Scalar.pi / Scalar(N))
        let circumradius = inradius / piOverN.cos.value
        return regular(circumradius: circumradius, at: center)
    }
}

// MARK: - Ngon Static Implementations

extension Geometry where Scalar: FloatingPoint {
    /// Calculate the area of an N-gon (always positive).
    @inlinable
    public static func area<let N: Int>(of ngon: Ngon<N>) -> Area {
        // Use the instance method's typed result
        let signedArea = ngon.signedArea
        // abs of typed area, then wrap in Geometry.Area
        let absArea = signedArea._rawValue < 0 ? -signedArea._rawValue : signedArea._rawValue
        return Area(Tagged(absArea))
    }

    /// Calculate the signed double area of an N-gon using the shoelace formula.
    @inlinable
    public static func signedDoubleArea<let N: Int>(of ngon: Ngon<N>) -> Linear<Scalar, Space>.Area where Scalar: SignedNumeric {
        ngon.signedDoubleArea
    }

    /// Calculate the perimeter of an N-gon.
    @inlinable
    public static func perimeter<let N: Int>(of ngon: Ngon<N>) -> Perimeter {
        var sum: Distance = .zero
        for i in 0..<N {
            let j = (i + 1) % N
            sum += ngon.vertices[i].distance(to: ngon.vertices[j])
        }
        return sum
    }

    /// Calculate the centroid (center of mass) of an N-gon.
    @inlinable
    public static func centroid<let N: Int>(of ngon: Ngon<N>) -> Point<2>? where Scalar: SignedNumeric {
        // Centroid formula uses raw values because it inherently mixes
        // coordinate components in ways that don't fit dimensional analysis
        let a = signedDoubleArea(of: ngon)._rawValue
        guard abs(a) > .ulpOfOne else { return nil }

        var cx: Scalar = .zero
        var cy: Scalar = .zero

        for i in 0..<N {
            let j = (i + 1) % N
            let xi = ngon.vertices[i].x._rawValue
            let yi = ngon.vertices[i].y._rawValue
            let xj = ngon.vertices[j].x._rawValue
            let yj = ngon.vertices[j].y._rawValue
            let cross = xi * yj - xj * yi
            cx += (xi + xj) * cross
            cy += (yi + yj) * cross
        }

        let factor = Scalar(1) / (Scalar(3) * a)
        return Point(x: X(cx * factor), y: Y(cy * factor))
    }
}

// MARK: - Polygon Conversion

extension Geometry.Ngon {
    /// Convert to a dynamic-size polygon
    @inlinable
    public var polygon: Geometry.Polygon {
        Geometry.Polygon(vertices: vertexArray)
    }
}

// MARK: - Functorial Map

extension Geometry.Ngon {
    /// Create an N-gon by transforming the coordinates of another N-gon
    @inlinable
    public init<U, E: Error>(
        _ other: borrowing Geometry<U, Space>.Ngon<N>,
        _ transform: (U) throws(E) -> Scalar
    ) throws(E) {
        let first = try Geometry.Point<2>(other.vertices[0], transform)
        var result = InlineArray<N, Geometry.Point<2>>(repeating: first)
        for i in 1..<N {
            result[i] = try Geometry.Point<2>(other.vertices[i], transform)
        }
        self.init(result)
    }

    /// Transform coordinates using the given closure
    @inlinable
    public func map<Result, E: Error>(
        _ transform: (Scalar) throws(E) -> Result
    ) throws(E) -> Geometry<Result, Space>.Ngon<N> {
        let first = try vertices[0].map(transform)
        var result = InlineArray<N, Geometry<Result, Space>.Point<2>>(repeating: first)
        for i in 1..<N {
            result[i] = try vertices[i].map(transform)
        }
        return Geometry<Result, Space>.Ngon<N>(result)
    }
}

// MARK: - Quadrilateral (N == 4) Named Vertices

extension Geometry.Ngon where N == 4 {
    /// First vertex
    @inlinable
    public var a: Geometry.Point<2> {
        get { vertices[0] }
        set { vertices[0] = newValue }
    }

    /// Second vertex
    @inlinable
    public var b: Geometry.Point<2> {
        get { vertices[1] }
        set { vertices[1] = newValue }
    }

    /// Third vertex
    @inlinable
    public var c: Geometry.Point<2> {
        get { vertices[2] }
        set { vertices[2] = newValue }
    }

    /// Fourth vertex
    @inlinable
    public var d: Geometry.Point<2> {
        get { vertices[3] }
        set { vertices[3] = newValue }
    }

    /// Create a quadrilateral with four named vertices
    @inlinable
    public init(
        a: Geometry.Point<2>,
        b: Geometry.Point<2>,
        c: Geometry.Point<2>,
        d: Geometry.Point<2>
    ) {
        self.init([a, b, c, d])
    }
}

// MARK: - Quadrilateral Diagonals

extension Geometry.Ngon where N == 4, Scalar: AdditiveArithmetic {
    /// The two diagonals of the quadrilateral
    @inlinable
    public var diagonals: (ac: Geometry.Line.Segment, bd: Geometry.Line.Segment) {
        (
            Geometry.Line.Segment(start: vertices[0], end: vertices[2]),
            Geometry.Line.Segment(start: vertices[1], end: vertices[3])
        )
    }
}

// MARK: - Quadrilateral Triangulation

extension Geometry.Ngon where N == 4 {
    /// Decompose the quadrilateral into two triangles.
    ///
    /// Returns triangles (a, b, c) and (a, c, d).
    @inlinable
    public var triangles: (Geometry.Ngon<3>, Geometry.Ngon<3>) {
        (
            Geometry.Ngon<3>(a: vertices[0], b: vertices[1], c: vertices[2]),
            Geometry.Ngon<3>(a: vertices[0], b: vertices[2], c: vertices[3])
        )
    }
}

// MARK: - Triangle (N == 3) Named Vertices

extension Geometry.Ngon where N == 3 {
    /// First vertex
    @inlinable
    public var a: Geometry.Point<2> {
        get { vertices[0] }
        set { vertices[0] = newValue }
    }

    /// Second vertex
    @inlinable
    public var b: Geometry.Point<2> {
        get { vertices[1] }
        set { vertices[1] = newValue }
    }

    /// Third vertex
    @inlinable
    public var c: Geometry.Point<2> {
        get { vertices[2] }
        set { vertices[2] = newValue }
    }

    /// Create a triangle with three named vertices
    @inlinable
    public init(
        a: consuming Geometry.Point<2>,
        b: consuming Geometry.Point<2>,
        c: consuming Geometry.Point<2>
    ) {
        self.init([a, b, c])
    }
}

// MARK: - Triangle Side Lengths

extension Geometry.Ngon where N == 3, Scalar: FloatingPoint {
    /// The lengths of the three sides
    @inlinable
    public var sideLengths: (ab: Geometry.Distance, bc: Geometry.Distance, ca: Geometry.Distance) {
        (
            vertices[0].distance(to: vertices[1]),
            vertices[1].distance(to: vertices[2]),
            vertices[2].distance(to: vertices[0])
        )
    }
}

// MARK: - Triangle Incircle

extension Geometry.Ngon where N == 3, Scalar: FloatingPoint {
    /// The incircle (largest inscribed circle) of the triangle.
    ///
    /// The incircle's center is equidistant from all three sides.
    /// Returns `nil` if the triangle is degenerate.
    @inlinable
    public var incircle: Geometry.Circle? {
        // Incircle calculation uses raw values due to complex coordinate mixing
        let sides = sideLengths
        let ab = sides.ab._rawValue
        let bc = sides.bc._rawValue
        let ca = sides.ca._rawValue

        let perimeter = ab + bc + ca
        guard perimeter > 0 else { return nil }

        // Incenter is weighted centroid: I = (a*A + b*B + c*C) / (a+b+c)
        // where a,b,c are opposite side lengths
        let ax = vertices[0].x._rawValue, ay = vertices[0].y._rawValue
        let bx = vertices[1].x._rawValue, by = vertices[1].y._rawValue
        let cx = vertices[2].x._rawValue, cy = vertices[2].y._rawValue

        let centerX = (bc * ax + ca * bx + ab * cx) / perimeter
        let centerY = (bc * ay + ca * by + ab * cy) / perimeter

        // Inradius = Area / semi-perimeter
        let semiPerimeter = perimeter / 2
        let inradius = area.rawValue / semiPerimeter

        return Geometry.Circle(
            center: Geometry.Point(x: Geometry.X(centerX), y: Geometry.Y(centerY)),
            radius: Geometry.Radius(inradius)
        )
    }
}

// MARK: - Triangle Circumcircle

extension Geometry.Ngon where N == 3, Scalar: FloatingPoint {
    /// The circumcircle (smallest enclosing circle passing through all vertices).
    ///
    /// Returns `nil` if the triangle is degenerate (collinear vertices).
    @inlinable
    public var circumcircle: Geometry.Circle? {
        // Circumcircle calculation uses raw values due to complex coordinate mixing
        let ax = vertices[0].x._rawValue
        let ay = vertices[0].y._rawValue
        let bx = vertices[1].x._rawValue
        let by = vertices[1].y._rawValue
        let cx = vertices[2].x._rawValue
        let cy = vertices[2].y._rawValue

        // Break up complex expressions for type checker
        let dTerm1 = ax * (by - cy)
        let dTerm2 = bx * (cy - ay)
        let dTerm3 = cx * (ay - by)
        let d = Scalar(2) * (dTerm1 + dTerm2 + dTerm3)
        guard abs(d) > Scalar.ulpOfOne else { return nil }

        let aSq = ax * ax + ay * ay
        let bSq = bx * bx + by * by
        let cSq = cx * cx + cy * cy

        let uxTerm1 = aSq * (by - cy)
        let uxTerm2 = bSq * (cy - ay)
        let uxTerm3 = cSq * (ay - by)
        let ux = (uxTerm1 + uxTerm2 + uxTerm3) / d

        let uyTerm1 = aSq * (cx - bx)
        let uyTerm2 = bSq * (ax - cx)
        let uyTerm3 = cSq * (bx - ax)
        let uy = (uyTerm1 + uyTerm2 + uyTerm3) / d

        let center = Geometry.Point(x: Geometry.X(ux), y: Geometry.Y(uy))
        let radius = center.distance(to: vertices[0])

        return Geometry.Circle(center: center, radius: radius)
    }
}

// MARK: - Triangle Orthocenter

extension Geometry.Ngon where N == 3, Scalar: FloatingPoint {
    /// The orthocenter (intersection of altitudes).
    ///
    /// Returns `nil` if the triangle is degenerate.
    @inlinable
    public var orthocenter: Geometry.Point<2>? {
        // Orthocenter uses raw values due to coordinate mixing
        guard let cc = circumcircle else { return nil }

        let ax = vertices[0].x._rawValue
        let ay = vertices[0].y._rawValue
        let bx = vertices[1].x._rawValue
        let by = vertices[1].y._rawValue
        let cx = vertices[2].x._rawValue
        let cy = vertices[2].y._rawValue
        let ccx = cc.center.x._rawValue
        let ccy = cc.center.y._rawValue

        let ox = ax + bx + cx - Scalar(2) * ccx
        let oy = ay + by + cy - Scalar(2) * ccy

        return Geometry.Point(x: Geometry.X(ox), y: Geometry.Y(oy))
    }
}

// MARK: - Triangle Angles

extension Geometry.Ngon where N == 3, Scalar: Real & BinaryFloatingPoint {
    /// The interior angles at each vertex.
    ///
    /// Angles are in radians and always sum to π.
    @inlinable
    public var angles: (atA: Radian<Scalar>, atB: Radian<Scalar>, atC: Radian<Scalar>) {
        // Law of cosines uses raw values for side lengths
        let sides = sideLengths
        let ab = sides.ab._rawValue
        let bc = sides.bc._rawValue
        let ca = sides.ca._rawValue

        // cos(A) = (b² + c² - a²) / (2bc) - break up for type checker
        let abSq = ab * ab
        let bcSq = bc * bc
        let caSq = ca * ca

        let cosANum = caSq + abSq - bcSq
        let cosADen = Scalar(2) * ca * ab
        let cosA = cosANum / cosADen

        let cosBNum = abSq + bcSq - caSq
        let cosBDen = Scalar(2) * ab * bc
        let cosB = cosBNum / cosBDen

        let cosCNum = bcSq + caSq - abSq
        let cosCDen = Scalar(2) * bc * ca
        let cosC = cosCNum / cosCDen

        return (
            Radian.acos(Scale<1, Scalar>(cosA)),
            Radian.acos(Scale<1, Scalar>(cosB)),
            Radian.acos(Scale<1, Scalar>(cosC))
        )
    }
}

// MARK: - Triangle Barycentric Coordinates

extension Geometry.Ngon where N == 3, Scalar: FloatingPoint {
    /// Compute the barycentric coordinates of a point with respect to this triangle.
    ///
    /// For a point inside the triangle, all coordinates are in [0, 1] and sum to 1.
    ///
    /// - Parameter point: The point to compute coordinates for
    /// - Returns: The barycentric coordinates (u, v, w) where P = u*A + v*B + w*C, or nil if degenerate
    @inlinable
    public func barycentric(_ point: Geometry.Point<2>) -> (u: Scalar, v: Scalar, w: Scalar)? {
        let v0: Geometry.Vector<2> = Geometry.Vector(
            dx: vertices[2].x - vertices[0].x,
            dy: vertices[2].y - vertices[0].y
        )
        let v1: Geometry.Vector<2> = Geometry.Vector(
            dx: vertices[1].x - vertices[0].x,
            dy: vertices[1].y - vertices[0].y
        )
        let v2: Geometry.Vector<2> = Geometry.Vector(
            dx: point.x - vertices[0].x,
            dy: point.y - vertices[0].y
        )

        let dot00: Scalar = v0.dot(v0)
        let dot01: Scalar = v0.dot(v1)
        let dot02: Scalar = v0.dot(v2)
        let dot11: Scalar = v1.dot(v1)
        let dot12: Scalar = v1.dot(v2)

        let denom: Scalar = dot00 * dot11 - dot01 * dot01
        guard abs(denom) > Scalar.ulpOfOne else { return nil }

        let one: Scalar = Scalar(1)
        let invDenom: Scalar = one / denom
        let v: Scalar = (dot11 * dot02 - dot01 * dot12) * invDenom
        let u: Scalar = (dot00 * dot12 - dot01 * dot02) * invDenom
        let w: Scalar = one - u - v

        return (w, u, v)
    }

    /// Convert barycentric coordinates to a Cartesian point.
    ///
    /// - Parameters:
    ///   - u: Weight for vertex A
    ///   - v: Weight for vertex B
    ///   - w: Weight for vertex C
    /// - Returns: The Cartesian point
    @inlinable
    public func point(u: Scalar, v: Scalar, w: Scalar) -> Geometry.Point<2> {
        // P = A + v × (B - A) + w × (C - A), using u + v + w = 1
        // Barycentric weights are dimensionless ratios (Scale)
        let vScale = Scale<1, Scalar>(v)
        let wScale = Scale<1, Scalar>(w)
        let ab_dx = vertices[1].x - vertices[0].x
        let ab_dy = vertices[1].y - vertices[0].y
        let ac_dx = vertices[2].x - vertices[0].x
        let ac_dy = vertices[2].y - vertices[0].y
        return Geometry.Point(
            x: vertices[0].x + vScale * ab_dx + wScale * ac_dx,
            y: vertices[0].y + vScale * ab_dy + wScale * ac_dy
        )
    }
}

// MARK: - Triangle Containment (Barycentric)

extension Geometry.Ngon where N == 3, Scalar: FloatingPoint {
    /// Check if a point is inside or on the triangle using barycentric coordinates.
    ///
    /// This is more robust than the generic ray casting algorithm for triangles.
    ///
    /// - Parameter point: The point to test
    /// - Returns: `true` if the point is inside or on the boundary
    @inlinable
    public func containsBarycentric(_ point: Geometry.Point<2>) -> Bool {
        guard let bary = barycentric(point) else { return false }
        let zero: Scalar = Scalar(0)
        return bary.u >= zero && bary.v >= zero && bary.w >= zero
    }
}

// MARK: - Triangle Factory Methods

extension Geometry.Ngon where N == 3, Scalar: FloatingPoint & AdditiveArithmetic {
    /// Create a right triangle with the right angle at vertex A (origin).
    ///
    /// - Parameters:
    ///   - base: The length of the base (along positive x-axis)
    ///   - height: The length of the height (along positive y-axis)
    ///   - origin: The position of the right-angle vertex (default: origin)
    /// - Returns: A right triangle
    @inlinable
    public static func right(
        base: Scalar,
        height: Scalar,
        at origin: Geometry.Point<2> = .zero
    ) -> Self {
        Self(
            a: origin,
            b: Geometry.Point(x: origin.x + Linear<Scalar, Space>.Dx(base), y: origin.y),
            c: Geometry.Point(x: origin.x, y: origin.y + Linear<Scalar, Space>.Dy(height))
        )
    }

    /// Create an equilateral triangle with given side length.
    ///
    /// The first vertex is at the origin (or specified point), with the base
    /// along the positive x-axis.
    ///
    /// - Parameters:
    ///   - sideLength: The length of each side
    ///   - origin: The position of the first vertex (default: origin)
    /// - Returns: An equilateral triangle
    @inlinable
    public static func equilateral(
        sideLength: Scalar,
        at origin: Geometry.Point<2> = .zero
    ) -> Self {
        let half = sideLength / Scalar(2)
        // Height of equilateral triangle: h = s × √3 / 2
        let h = sideLength * Scalar(3).squareRoot() / Scalar(2)
        return Self(
            a: origin,
            b: Geometry.Point(x: origin.x + Linear<Scalar, Space>.Dx(sideLength), y: origin.y),
            c: Geometry.Point(x: origin.x + Linear<Scalar, Space>.Dx(half), y: origin.y + Linear<Scalar, Space>.Dy(h))
        )
    }

    /// Create an isosceles triangle with given base and leg length.
    ///
    /// The base is along the positive x-axis starting from the origin.
    ///
    /// - Parameters:
    ///   - base: The length of the base
    ///   - leg: The length of the two equal sides
    ///   - origin: The position of the first vertex (default: origin)
    /// - Returns: An isosceles triangle, or `nil` if impossible (leg too short)
    @inlinable
    public static func isosceles(
        base: Scalar,
        leg: Scalar,
        at origin: Geometry.Point<2> = .zero
    ) -> Self? {
        // Height: h = √(leg² - (base/2)²)
        let half = base / Scalar(2)
        let hSquared = leg * leg - half * half
        guard hSquared >= Scalar(0) else { return nil }
        let h = hSquared.squareRoot()
        return Self(
            a: origin,
            b: Geometry.Point(x: origin.x + Linear<Scalar, Space>.Dx(base), y: origin.y),
            c: Geometry.Point(x: origin.x + Linear<Scalar, Space>.Dx(half), y: origin.y + Linear<Scalar, Space>.Dy(h))
        )
    }
}

// MARK: - Triangle API (Shadows Base Ngon)

extension Geometry.Ngon where N == 3, Scalar: FloatingPoint {
    /// The centroid (center of mass) of the triangle.
    ///
    /// For a triangle, this is simply the average of the three vertices.
    /// This shadows the optional `centroid` from the base Ngon type.
    @inlinable
    public var centroid: Geometry.Point<2> {
        // centroid = p₀ + (1/3) × ((p₁ - p₀) + (p₂ - p₀))
        let oneThird = Scale<1, Scalar>(1 / Scalar(3))
        let dx = (vertices[1].x - vertices[0].x) + (vertices[2].x - vertices[0].x)
        let dy = (vertices[1].y - vertices[0].y) + (vertices[2].y - vertices[0].y)
        return Geometry.Point(x: vertices[0].x + oneThird * dx, y: vertices[0].y + oneThird * dy)
    }

    /// Return a triangle scaled uniformly about its centroid.
    ///
    /// This shadows the optional `scaled(by:)` from the base Ngon type.
    @inlinable
    public func scaled(by factor: Scale<1, Scalar>) -> Self {
        scaled(by: factor, about: centroid)
    }
}

// MARK: - Triangle Typealias

extension Geometry {
    /// A triangle (3-sided polygon)
    public typealias Triangle = Ngon<3>
}
